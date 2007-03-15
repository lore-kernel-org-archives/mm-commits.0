From: akpm@linux-foundation.org
Subject: + software-suspend-fix-suspend-when-console-is-in.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:26 -0800
Message-ID: <200703151848.l2FImSH5023246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35400 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXCOStO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajohnson@intrinsyc.com, adaplas@pol.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     Software Suspend: Fix suspend when console is in VT_AUTO+KD_GRAPHICS mode
has been added to the -mm tree.  Its filename is
     software-suspend-fix-suspend-when-console-is-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Software Suspend: Fix suspend when console is in VT_AUTO+KD_GRAPHICS mode
From: Andrew Johnson <ajohnson@intrinsyc.com>

When the console is in VT_AUTO+KD_GRAPHICS mode, switching to the
SUSPEND_CONSOLE fails, resulting in vt_waitactive() waiting indefinitely or
until the task is interrupted.  This patch tests if a console switch can
occur in set_console() and returns early if a console switch is not
possible.

Signed-off-by: Andrew Johnson <ajohnson@intrinsyc.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c        |   22 +++++++++++++++++++++-
 drivers/char/vt_ioctl.c  |    2 +-
 include/linux/kbd_kern.h |    2 +-
 kernel/power/console.c   |   10 +++++++++-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff -puN drivers/char/vt.c~software-suspend-fix-suspend-when-console-is-in drivers/char/vt.c
--- a/drivers/char/vt.c~software-suspend-fix-suspend-when-console-is-in
+++ a/drivers/char/vt.c
@@ -2185,10 +2185,30 @@ static void console_callback(struct work
 	release_console_sem();
 }
 
-void set_console(int nr)
+extern char vt_dont_switch;
+
+int set_console(int nr)
 {
+	struct vc_data *vc = vc_cons[fg_console].d;
+
+	if (!vc_cons_allocated(nr) || vt_dont_switch ||
+		(vc->vt_mode.mode == VT_AUTO && vc->vc_mode == KD_GRAPHICS)) {
+
+		/*
+		 * Console switch will fail in console_callback() or
+		 * change_console() so there is no point scheduling
+		 * the callback
+		 *
+		 * Existing set_console() users don't check the return
+		 * value so this shouldn't break anything
+		 */
+		return -EINVAL;
+	}
+
 	want_console = nr;
 	schedule_console_callback();
+
+	return 0;
 }
 
 struct tty_driver *console_driver;
diff -puN drivers/char/vt_ioctl.c~software-suspend-fix-suspend-when-console-is-in drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~software-suspend-fix-suspend-when-console-is-in
+++ a/drivers/char/vt_ioctl.c
@@ -34,7 +34,7 @@
 #include <linux/kbd_diacr.h>
 #include <linux/selection.h>
 
-static char vt_dont_switch;
+char vt_dont_switch;
 extern struct tty_driver *console_driver;
 
 #define VT_IS_IN_USE(i)	(console_driver->ttys[i] && console_driver->ttys[i]->count)
diff -puN include/linux/kbd_kern.h~software-suspend-fix-suspend-when-console-is-in include/linux/kbd_kern.h
--- a/include/linux/kbd_kern.h~software-suspend-fix-suspend-when-console-is-in
+++ a/include/linux/kbd_kern.h
@@ -75,7 +75,7 @@ extern int do_poke_blanked_console;
 
 extern void (*kbd_ledfunc)(unsigned int led);
 
-extern void set_console(int nr);
+extern int set_console(int nr);
 extern void schedule_console_callback(void);
 
 static inline void set_leds(void)
diff -puN kernel/power/console.c~software-suspend-fix-suspend-when-console-is-in kernel/power/console.c
--- a/kernel/power/console.c~software-suspend-fix-suspend-when-console-is-in
+++ a/kernel/power/console.c
@@ -27,7 +27,15 @@ int pm_prepare_console(void)
 		return 1;
 	}
 
-	set_console(SUSPEND_CONSOLE);
+	if (set_console(SUSPEND_CONSOLE)) {
+		/*
+		 * We're unable to switch to the SUSPEND_CONSOLE.
+		 * Let the calling function know so it can decide
+		 * what to do.
+		 */
+		release_console_sem();
+		return 1;
+	}
 	release_console_sem();
 
 	if (vt_waitactive(SUSPEND_CONSOLE)) {
_

Patches currently in -mm which might be from ajohnson@intrinsyc.com are

software-suspend-fix-suspend-when-console-is-in.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch
