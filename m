From: akpm@linux-foundation.org
Subject: +
 vt-delete-unneeded-functions-register_con_drivertake_over_console.patch
 added to -mm tree
Date: Tue, 21 May 2013 15:27:36 -0700
Message-ID: <519bf4d8.Tnm4OMnnZROm6MIJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EUW1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 18:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, tiwai@suse.de, sedat.dilek@gmail.com, maarten.lankhorst@canonical.com, jslaby@suse.cz, huax.lu@intel.com, greg@kroah.com, daniel.vetter@ffwll.ch, airlied@linux.ie, FlorianSchandinat@gmx.de, udknight@gmail.com

Subject: + vt-delete-unneeded-functions-register_con_drivertake_over_console.patch added to -mm tree
To: udknight@gmail.com,FlorianSchandinat@gmx.de,airlied@linux.ie,daniel.vetter@ffwll.ch,greg@kroah.com,huax.lu@intel.com,jslaby@suse.cz,maarten.lankhorst@canonical.com,sedat.dilek@gmail.com,tiwai@suse.de,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 15:27:36 -0700


The patch titled
     Subject: vt: delete unneeded functions register_con_driver|take_over_console
has been added to the -mm tree.  Its filename is
     vt-delete-unneeded-functions-register_con_drivertake_over_console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang YanQing <udknight@gmail.com>
Subject: vt: delete unneeded functions register_con_driver|take_over_console

Now there is no place use register_con_driver|take_over_console, and we
can achieve their function with do_register_con_driver|
do_take_over_console easily, so just delete them to reduce code
duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Lu Hua <huax.lu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt.c     |   45 --------------------------------------
 include/linux/console.h |    2 -
 2 files changed, 47 deletions(-)

diff -puN drivers/tty/vt/vt.c~vt-delete-unneeded-functions-register_con_drivertake_over_console drivers/tty/vt/vt.c
--- a/drivers/tty/vt/vt.c~vt-delete-unneeded-functions-register_con_drivertake_over_console
+++ a/drivers/tty/vt/vt.c
@@ -3574,26 +3574,6 @@ err:
 	return retval;
 }
 
-/**
- * register_con_driver - register console driver to console layer
- * @csw: console driver
- * @first: the first console to take over, minimum value is 0
- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
- *
- * DESCRIPTION: This function registers a console driver which can later
- * bind to a range of consoles specified by @first and @last. It will
- * also initialize the console driver by calling con_startup().
- */
-int register_con_driver(const struct consw *csw, int first, int last)
-{
-	int retval;
-
-	console_lock();
-	retval = do_register_con_driver(csw, first, last);
-	console_unlock();
-	return retval;
-}
-EXPORT_SYMBOL(register_con_driver);
 
 /**
  * unregister_con_driver - unregister console driver from console layer
@@ -3675,30 +3655,6 @@ int do_take_over_console(const struct co
 }
 EXPORT_SYMBOL_GPL(do_take_over_console);
 
-/*
- *	If we support more console drivers, this function is used
- *	when a driver wants to take over some existing consoles
- *	and become default driver for newly opened ones.
- *
- *	take_over_console is basically a register followed by unbind
- */
-int take_over_console(const struct consw *csw, int first, int last, int deflt)
-{
-	int err;
-
-	err = register_con_driver(csw, first, last);
-	/*
-	 * If we get an busy error we still want to bind the console driver
-	 * and return success, as we may have unbound the console driver
-	 * but not unregistered it.
-	 */
-	if (err == -EBUSY)
-		err = 0;
-	if (!err)
-		bind_con_driver(csw, first, last, deflt);
-
-	return err;
-}
 
 /*
  * give_up_console is a wrapper to unregister_con_driver. It will only
@@ -4262,6 +4218,5 @@ EXPORT_SYMBOL(console_blanked);
 EXPORT_SYMBOL(vc_cons);
 EXPORT_SYMBOL(global_cursor_default);
 #ifndef VT_SINGLE_DRIVER
-EXPORT_SYMBOL(take_over_console);
 EXPORT_SYMBOL(give_up_console);
 #endif
diff -puN include/linux/console.h~vt-delete-unneeded-functions-register_con_drivertake_over_console include/linux/console.h
--- a/include/linux/console.h~vt-delete-unneeded-functions-register_con_drivertake_over_console
+++ a/include/linux/console.h
@@ -75,10 +75,8 @@ extern const struct consw newport_con;	/
 extern const struct consw prom_con;	/* SPARC PROM console */
 
 int con_is_bound(const struct consw *csw);
-int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int do_unregister_con_driver(const struct consw *csw);
-int take_over_console(const struct consw *sw, int first, int last, int deflt);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
_

Patches currently in -mm which might be from udknight@gmail.com are

linux-next.patch
fbcon-convert-last-fbcon_takeover-call-to-do_fbcon_takeover.patch
fbcon-delete-unneeded-function-fbcon_takeover.patch
vt-delete-unneeded-functions-register_con_drivertake_over_console.patch
vt-convert-last-unbind_con_driver-call-to-do_unbind_con_driver.patch
vt-delete-unneeded-function-unbind_con_driver.patch
vt-convert-last-bind_con_driver-call-to-do_bind_con_driver.patch
vt-delete-unneeded-function-bind_con_driver.patch
fbcon-convert-last-two-unregister_con_driver-call-to-do_unregister_con_driver.patch
vt-delete-unneeded-function-unregister_con_driver.patch

