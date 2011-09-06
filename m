From: akpm@linux-foundation.org
Subject: + vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:59:44 -0700
Message-ID: <201109062159.p86Lxip8004493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab1IFWAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, arnd@arnd.de, art@ified.ca, gregkh@suse.de, hsweeten@visionengravers.com, jslaby@suse.cz, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     vt/suspend: cleanup #if defined uglyness and fix compile error
has been added to the -mm tree.  Its filename is
     vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt/suspend: cleanup #if defined uglyness and fix compile error
From: H Hartley Sweeten <hartleys@visionengravers.com>

Introduce the config option CONFIG_VT_CONSOLE_SLEEP in order to cleanup
the #if defined ugliness for the vt suspend support functions.  Note that
CONFIG_VT_CONSOLE is already dependant on CONFIG_VT.

The function pm_set_vt_switch is actually dependant on CONFIG_VT and not
CONFIG_PM_SLEEP.  This fixes a compile error when CONFIG_PM_SLEEP is not
set:

drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here

Also, remove the incorrect path from the comment in console.c.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arnd.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Arthur Taylor <art@ified.ca>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/Kconfig     |    4 ++++
 include/linux/suspend.h |    9 ++++++---
 kernel/power/Makefile   |    2 +-
 kernel/power/console.c  |    4 +---
 4 files changed, 12 insertions(+), 7 deletions(-)

diff -puN drivers/tty/Kconfig~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error drivers/tty/Kconfig
--- a/drivers/tty/Kconfig~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error
+++ a/drivers/tty/Kconfig
@@ -60,6 +60,10 @@ config VT_CONSOLE
 
 	  If unsure, say Y.
 
+config VT_CONSOLE_SLEEP
+	def_bool y
+	depends on VT_CONSOLE && PM_SLEEP
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff -puN include/linux/suspend.h~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error include/linux/suspend.h
--- a/include/linux/suspend.h~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error
+++ a/include/linux/suspend.h
@@ -8,15 +8,18 @@
 #include <linux/mm.h>
 #include <asm/errno.h>
 
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+#if defined(CONFIG_VT)
 extern void pm_set_vt_switch(int);
-extern int pm_prepare_console(void);
-extern void pm_restore_console(void);
 #else
 static inline void pm_set_vt_switch(int do_switch)
 {
 }
+#endif
 
+#if defined(CONFIG_VT_CONSOLE_SLEEP)
+extern int pm_prepare_console(void);
+extern void pm_restore_console(void);
+#else
 static inline int pm_prepare_console(void)
 {
 	return 0;
diff -puN kernel/power/Makefile~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error kernel/power/Makefile
--- a/kernel/power/Makefile~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error
+++ a/kernel/power/Makefile
@@ -2,7 +2,7 @@
 ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_PM)		+= main.o qos.o
-obj-$(CONFIG_PM_SLEEP)		+= console.o
+obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
diff -puN kernel/power/console.c~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error kernel/power/console.c
--- a/kernel/power/console.c~vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error
+++ a/kernel/power/console.c
@@ -1,5 +1,5 @@
 /*
- * drivers/power/process.c - Functions for saving/restoring console.
+ * Functions for saving/restoring console.
  *
  * Originally from swsusp.
  */
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include "power.h"
 
-#if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
@@ -32,4 +31,3 @@ void pm_restore_console(void)
 		vt_kmsg_redirect(orig_kmsg);
 	}
 }
-#endif
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

lib-bitmapc-quiet-sparse-noise-about-address-space.patch
vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

