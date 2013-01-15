From: akpm@linux-foundation.org
Subject: + fb-yet-another-band-aid-for-fixing-lockdep-mess.patch added to -mm tree
Date: Tue, 15 Jan 2013 12:29:30 -0800
Message-ID: <20130115202931.B3F125A41D4@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58227 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3AOU3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 15:29:35 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so67340vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 12:29:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, FlorianSchandinat@gmx.de, alan@linux.intel.com, jkosina@suse.cz, sedat.dilek@gmail.com


The patch titled
     Subject: [PATCH] fb: Yet another band-aid for fixing lockdep mess
has been added to the -mm tree.  Its filename is
     fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] fb: Yet another band-aid for fixing lockdep mess

I've still got lockdep warnings even after Alan's patch, and it seems that
yet more band aids are required to paper over similar paths for
unbind_con_driver() and unregister_con_driver().  After this hack, lockdep
warnings are finally gone.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c           |   43 ++++++++++++++++++++------------
 drivers/video/console/fbcon.c |    4 +-
 drivers/video/fbmem.c         |    4 ++
 include/linux/console.h       |    1 
 include/linux/vt_kern.h       |    2 +
 5 files changed, 37 insertions(+), 17 deletions(-)

diff -puN drivers/tty/vt/vt.c~fb-yet-another-band-aid-for-fixing-lockdep-mess drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~fb-yet-another-band-aid-for-fixing-lockdep-mess
+++ a/drivers/tty/vt/vt.c
@@ -3135,6 +3135,18 @@ static int con_is_graphics(const struct 
  */
 int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
+	int retval;
+
+	console_lock();
+	retval = do_unbind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(unbind_con_driver);
+
+/* unlocked version of unbind_con_driver() */
+int do_unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
+{
 	struct module *owner = csw->owner;
 	const struct consw *defcsw = NULL;
 	struct con_driver *con_driver = NULL, *con_back = NULL;
@@ -3143,7 +3155,7 @@ int unbind_con_driver(const struct consw
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
 
 	/* check if driver is registered and if it is unbindable */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3156,10 +3168,8 @@ int unbind_con_driver(const struct consw
 		}
 	}
 
-	if (retval) {
-		console_unlock();
+	if (retval)
 		goto err;
-	}
 
 	retval = -ENODEV;
 
@@ -3175,15 +3185,11 @@ int unbind_con_driver(const struct consw
 		}
 	}
 
-	if (retval) {
-		console_unlock();
+	if (retval)
 		goto err;
-	}
 
-	if (!con_is_bound(csw)) {
-		console_unlock();
+	if (!con_is_bound(csw))
 		goto err;
-	}
 
 	first = max(first, con_driver->first);
 	last = min(last, con_driver->last);
@@ -3212,13 +3218,12 @@ int unbind_con_driver(const struct consw
 
 	/* ignore return value, binding should not fail */
 	do_bind_con_driver(defcsw, first, last, deflt);
-	console_unlock();
 err:
 	module_put(owner);
 	return retval;
 
 }
-EXPORT_SYMBOL(unbind_con_driver);
+EXPORT_SYMBOL_GPL(do_unbind_con_driver);
 
 static int vt_bind(struct con_driver *con)
 {
@@ -3605,9 +3610,18 @@ EXPORT_SYMBOL(register_con_driver);
  */
 int unregister_con_driver(const struct consw *csw)
 {
-	int i, retval = -ENODEV;
+	int retval;
 
 	console_lock();
+	retval = do_unregister_con_driver(csw);
+	console_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(unregister_con_driver);
+
+int do_unregister_con_driver(const struct consw *csw)
+{
+	int i, retval = -ENODEV;
 
 	/* cannot unregister a bound driver */
 	if (con_is_bound(csw))
@@ -3633,10 +3647,9 @@ int unregister_con_driver(const struct c
 		}
 	}
 err:
-	console_unlock();
 	return retval;
 }
-EXPORT_SYMBOL(unregister_con_driver);
+EXPORT_SYMBOL_GPL(do_unregister_con_driver);
 
 /*
  *	If we support more console drivers, this function is used
diff -puN drivers/video/console/fbcon.c~fb-yet-another-band-aid-for-fixing-lockdep-mess drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fb-yet-another-band-aid-for-fixing-lockdep-mess
+++ a/drivers/video/console/fbcon.c
@@ -3004,7 +3004,7 @@ static int fbcon_unbind(void)
 {
 	int ret;
 
-	ret = unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
+	ret = do_unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
 				fbcon_is_default);
 
 	if (!ret)
@@ -3077,7 +3077,7 @@ static int fbcon_fb_unregistered(struct 
 		primary_device = -1;
 
 	if (!num_registered_fb)
-		unregister_con_driver(&fb_con);
+		do_unregister_con_driver(&fb_con);
 
 	return 0;
 }
diff -puN drivers/video/fbmem.c~fb-yet-another-band-aid-for-fixing-lockdep-mess drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-yet-another-band-aid-for-fixing-lockdep-mess
+++ a/drivers/video/fbmem.c
@@ -1668,8 +1668,10 @@ static int do_unregister_framebuffer(str
 
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+	console_lock();
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+	console_unlock();
 	unlock_fb_info(fb_info);
 
 	if (ret)
@@ -1684,7 +1686,9 @@ static int do_unregister_framebuffer(str
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
 	event.info = fb_info;
+	console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
+	console_unlock();
 
 	/* this may free fb info */
 	put_fb_info(fb_info);
diff -puN include/linux/console.h~fb-yet-another-band-aid-for-fixing-lockdep-mess include/linux/console.h
--- a/include/linux/console.h~fb-yet-another-band-aid-for-fixing-lockdep-mess
+++ a/include/linux/console.h
@@ -77,6 +77,7 @@ extern const struct consw prom_con;	/* S
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
+int do_unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
diff -puN include/linux/vt_kern.h~fb-yet-another-band-aid-for-fixing-lockdep-mess include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~fb-yet-another-band-aid-for-fixing-lockdep-mess
+++ a/include/linux/vt_kern.h
@@ -130,6 +130,8 @@ void vt_event_post(unsigned int event, u
 int vt_waitactive(int n);
 void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
+extern int do_unbind_con_driver(const struct consw *csw, int first, int last,
+			     int deflt);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

