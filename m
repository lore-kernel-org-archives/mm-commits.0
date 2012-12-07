From: akpm@linux-foundation.org
Subject: + fb-rework-locking-to-fix-lock-ordering-on-takeover.patch added to -mm tree
Date: Fri, 07 Dec 2012 12:13:34 -0800
Message-ID: <20121207201339.3AA98200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:48804 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2LGUNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 15:13:42 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so56149bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 12:13:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, FlorianSchandinat@gmx.de


The patch titled
     Subject: fb: rework locking to fix lock ordering on takeover
has been added to the -mm tree.  Its filename is
     fb-rework-locking-to-fix-lock-ordering-on-takeover.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alan Cox <alan@linux.intel.com>
Subject: fb: rework locking to fix lock ordering on takeover

Adjust the console layer to allow a take over call where the caller
already holds the locks.  Make the fb layer lock in order.

This is partly a band aid, the fb layer is terminally confused about th=
e
locking rules it uses for its notifiers it seems.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c           |   81 ++++++++++++++++++++++++--------
 drivers/video/console/fbcon.c |   30 +++++++++++
 drivers/video/fbmem.c         |    5 -
 drivers/video/fbsysfs.c       |    3 +
 include/linux/console.h       |    1=20
 5 files changed, 97 insertions(+), 23 deletions(-)

diff -puN drivers/tty/vt/vt.c~fb-rework-locking-to-fix-lock-ordering-on=
-takeover drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~fb-rework-locking-to-fix-lock-ordering-on-tak=
eover
+++ a/drivers/tty/vt/vt.c
@@ -2987,7 +2987,7 @@ int __init vty_init(const struct file_op
=20
 static struct class *vtconsole_class;
=20
-static int bind_con_driver(const struct consw *csw, int first, int las=
t,
+static int do_bind_con_driver(const struct consw *csw, int first, int =
last,
 			   int deflt)
 {
 	struct module *owner =3D csw->owner;
@@ -2998,7 +2998,7 @@ static int bind_con_driver(const struct=20
 	if (!try_module_get(owner))
 		return -ENODEV;
=20
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
=20
 	/* check if driver is registered */
 	for (i =3D 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3083,11 +3083,22 @@ static int bind_con_driver(const struct=20
=20
 	retval =3D 0;
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 };
=20
+
+static int bind_con_driver(const struct consw *csw, int first, int las=
t,
+			   int deflt)
+{
+	int ret;
+
+	console_lock();
+	ret =3D do_bind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return ret;
+}
+
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int las=
t)
 {
@@ -3199,9 +3210,9 @@ int unbind_con_driver(const struct consw
 	if (!con_is_bound(csw))
 		con_driver->flag &=3D ~CON_DRIVER_FLAG_INIT;
=20
-	console_unlock();
 	/* ignore return value, binding should not fail */
-	bind_con_driver(defcsw, first, last, deflt);
+	do_bind_con_driver(defcsw, first, last, deflt);
+	console_unlock();
 err:
 	module_put(owner);
 	return retval;
@@ -3492,28 +3503,18 @@ int con_debug_leave(void)
 }
 EXPORT_SYMBOL_GPL(con_debug_leave);
=20
-/**
- * register_con_driver - register console driver to console layer
- * @csw: console driver
- * @first: the first console to take over, minimum value is 0
- * @last: the last console to take over, maximum value is MAX_NR_CONSO=
LES -1
- *
- * DESCRIPTION: This function registers a console driver which can lat=
er
- * bind to a range of consoles specified by @first and @last. It will
- * also initialize the console driver by calling con_startup().
- */
-int register_con_driver(const struct consw *csw, int first, int last)
+static int do_register_con_driver(const struct consw *csw, int first, =
int last)
 {
 	struct module *owner =3D csw->owner;
 	struct con_driver *con_driver;
 	const char *desc;
 	int i, retval =3D 0;
=20
+	WARN_CONSOLE_UNLOCKED();
+
 	if (!try_module_get(owner))
 		return -ENODEV;
=20
-	console_lock();
-
 	for (i =3D 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver =3D &registered_con_driver[i];
=20
@@ -3566,10 +3567,29 @@ int register_con_driver(const struct con
 	}
=20
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 }
+
+/**
+ * register_con_driver - register console driver to console layer
+ * @csw: console driver
+ * @first: the first console to take over, minimum value is 0
+ * @last: the last console to take over, maximum value is MAX_NR_CONSO=
LES -1
+ *
+ * DESCRIPTION: This function registers a console driver which can lat=
er
+ * bind to a range of consoles specified by @first and @last. It will
+ * also initialize the console driver by calling con_startup().
+ */
+int register_con_driver(const struct consw *csw, int first, int last)
+{
+	int retval;
+
+	console_lock();
+	retval =3D do_register_con_driver(csw, first, last);
+	console_unlock();
+	return retval;
+}
 EXPORT_SYMBOL(register_con_driver);
=20
 /**
@@ -3625,6 +3645,29 @@ EXPORT_SYMBOL(unregister_con_driver);
  *
  *      take_over_console is basically a register followed by unbind
  */
+int do_take_over_console(const struct consw *csw, int first, int last,=
 int deflt)
+{
+	int err;
+
+	err =3D do_register_con_driver(csw, first, last);
+	/* if we get an busy error we still want to bind the console driver
+	 * and return success, as we may have unbound the console driver
+	=C2=A0* but not unregistered it.
+	*/
+	if (err =3D=3D -EBUSY)
+		err =3D 0;
+	if (!err)
+		do_bind_con_driver(csw, first, last, deflt);
+
+	return err;
+}
+/*
+ *	If we support more console drivers, this function is used
+ *	when a driver wants to take over some existing consoles
+ *	and become default driver for newly opened ones.
+ *
+ *      take_over_console is basically a register followed by unbind
+ */
 int take_over_console(const struct consw *csw, int first, int last, in=
t deflt)
 {
 	int err;
diff -puN drivers/video/console/fbcon.c~fb-rework-locking-to-fix-lock-o=
rdering-on-takeover drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fb-rework-locking-to-fix-lock-order=
ing-on-takeover
+++ a/drivers/video/console/fbcon.c
@@ -529,6 +529,34 @@ static int search_for_mapped_con(void)
 	return retval;
 }
=20
+static int do_fbcon_takeover(int show_logo)
+{
+	int err, i;
+
+	if (!num_registered_fb)
+		return -ENODEV;
+
+	if (!show_logo)
+		logo_shown =3D FBCON_LOGO_DONTSHOW;
+
+	for (i =3D first_fb_vc; i <=3D last_fb_vc; i++)
+		con2fb_map[i] =3D info_idx;
+
+	err =3D do_take_over_console(&fb_con, first_fb_vc, last_fb_vc,
+				fbcon_is_default);
+
+	if (err) {
+		for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
+			con2fb_map[i] =3D -1;
+		}
+		info_idx =3D -1;
+	} else {
+		fbcon_has_console_bind =3D 1;
+	}
+
+	return err;
+}
+
 static int fbcon_takeover(int show_logo)
 {
 	int err, i;
@@ -3115,7 +3143,7 @@ static int fbcon_fb_registered(struct fb
 		}
=20
 		if (info_idx !=3D -1)
-			ret =3D fbcon_takeover(1);
+			ret =3D do_fbcon_takeover(1);
 	} else {
 		for (i =3D first_fb_vc; i <=3D last_fb_vc; i++) {
 			if (con2fb_map_boot[i] =3D=3D idx)
diff -puN drivers/video/fbmem.c~fb-rework-locking-to-fix-lock-ordering-=
on-takeover drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-rework-locking-to-fix-lock-ordering-on-t=
akeover
+++ a/drivers/video/fbmem.c
@@ -1650,7 +1650,9 @@ static int do_register_framebuffer(struc
 	event.info =3D fb_info;
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+        console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+        console_unlock();
 	unlock_fb_info(fb_info);
 	return 0;
 }
@@ -1853,11 +1855,8 @@ int fb_new_modelist(struct fb_info *info
 	err =3D 1;
=20
 	if (!list_empty(&info->modelist)) {
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info =3D info;
 		err =3D fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
-		unlock_fb_info(info);
 	}
=20
 	return err;
diff -puN drivers/video/fbsysfs.c~fb-rework-locking-to-fix-lock-orderin=
g-on-takeover drivers/video/fbsysfs.c
--- a/drivers/video/fbsysfs.c~fb-rework-locking-to-fix-lock-ordering-on=
-takeover
+++ a/drivers/video/fbsysfs.c
@@ -177,6 +177,8 @@ static ssize_t store_modes(struct device
 	if (i * sizeof(struct fb_videomode) !=3D count)
 		return -EINVAL;
=20
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	console_lock();
 	list_splice(&fb_info->modelist, &old_list);
 	fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
@@ -188,6 +190,7 @@ static ssize_t store_modes(struct device
 		fb_destroy_modelist(&old_list);
=20
 	console_unlock();
+	unlock_fb_info(fb_info);
=20
 	return 0;
 }
diff -puN include/linux/console.h~fb-rework-locking-to-fix-lock-orderin=
g-on-takeover include/linux/console.h
--- a/include/linux/console.h~fb-rework-locking-to-fix-lock-ordering-on=
-takeover
+++ a/include/linux/console.h
@@ -78,6 +78,7 @@ int con_is_bound(const struct consw *csw
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int=
 deflt);
+int do_take_over_console(const struct consw *sw, int first, int last, =
int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
 int con_debug_enter(struct vc_data *vc);
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
irq-tsk-comm-is-an-array.patch
drivers-message-fusion-mptscsihc-missing-break.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes=
=2Epatch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
fork-unshare-remove-dead-code.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
