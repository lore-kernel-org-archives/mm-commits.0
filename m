From: akpm@google.com
Subject: [merged] vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch removed from -mm tree
Date: Thu, 22 Sep 2011 14:01:00 -0700
Message-ID: <201109222101.p8ML10xp004588@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:35476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1IVVCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, arnd@arnd.de, art@ified.ca, gregkh@suse.de, hsweeten@visionengravers.com, jslaby@suse.cz, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger


The patch titled
     Subject: vt/suspend: cleanup #if defined uglyness and fix compile error
has been removed from the -mm tree.  Its filename was
     vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: vt/suspend: cleanup #if defined uglyness and fix compile error

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
Acked-by: Arnd Bergmann <arnd@arnd.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Arthur Taylor <art@ified.ca>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@google.com>
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

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

