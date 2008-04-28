From: akpm@linux-foundation.org
Subject: - pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:49 -0700
Message-ID: <200804282157.m3SLvnh4018431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965305AbYD1V6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM/gxfb: add hook to PM console layer that allows disabling of suspend VT switch
has been removed from the -mm tree.  Its filename was
     pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM/gxfb: add hook to PM console layer that allows disabling of suspend VT switch
From: Andres Salomon <dilinger@queued.net>

Prior to suspend, we allocate and switch to a new VT; after suspend, we switch
back to the original VT.  This can be slow, and is completely unnecessary if
the framebuffer we're using can restore video properly.

This adds a hook that allows drivers to select whether or not to do this vt
switch, and changes the gxfb driver to call this hook.  It also adds a module
param to gxfb to allow controlling of the vt switch (defaulting to no switch).

(Note: I'm not convinced that console_sem is the best way to protect this, but
we should probably have some form of locking..)

[akpm@linux-foundation.org: build fix]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/gxfb.txt       |    3 ++-
 drivers/video/geode/gxfb_core.c |    7 +++++++
 include/linux/suspend.h         |   15 +++++++++++++--
 kernel/power/console.c          |   27 ++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 4 deletions(-)

diff -puN Documentation/fb/gxfb.txt~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch Documentation/fb/gxfb.txt
--- a/Documentation/fb/gxfb.txt~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch
+++ a/Documentation/fb/gxfb.txt
@@ -45,7 +45,8 @@ Accepted options:
 mode_option	- specify the video mode.  Of the form
 		  <x>x<y>[-<bpp>][@<refresh>]
 vram		- size of video ram (normally auto-detected)
-
+vt_switch	- enable vt switching during suspend/resume.  The vt
+		  switch is slow, but harmless.
 
 --
 Andres Salomon <dilinger@debian.org>
diff -puN drivers/video/geode/gxfb_core.c~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch
+++ a/drivers/video/geode/gxfb_core.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/console.h>
+#include <linux/suspend.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/geode.h>
@@ -37,6 +38,7 @@
 
 static char *mode_option;
 static int vram;
+static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
 static const struct fb_videomode gx_modedb[] __initdata = {
@@ -382,6 +384,8 @@ static int __init gxfb_probe(struct pci_
 	gxfb_check_var(&info->var, info);
 	gxfb_set_par(info);
 
+	pm_set_vt_switch(vt_switch);
+
 	if (register_framebuffer(info) < 0) {
 		ret = -EINVAL;
 		goto err;
@@ -502,5 +506,8 @@ MODULE_PARM_DESC(mode_option, "video mod
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram, "video memory size");
 
+module_param(vt_switch, int, 0);
+MODULE_PARM_DESC(vt_switch, "enable VT switch during suspend/resume");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
diff -puN include/linux/suspend.h~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch include/linux/suspend.h
--- a/include/linux/suspend.h~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch
+++ a/include/linux/suspend.h
@@ -12,11 +12,22 @@
 #include <asm/errno.h>
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
+extern void pm_set_vt_switch(int);
 extern int pm_prepare_console(void);
 extern void pm_restore_console(void);
 #else
-static inline int pm_prepare_console(void) { return 0; }
-static inline void pm_restore_console(void) {}
+static inline void pm_set_vt_switch(int do_switch)
+{
+}
+
+static inline int pm_prepare_console(void)
+{
+	return 0;
+}
+
+static inline void pm_restore_console(void)
+{
+}
 #endif
 
 typedef int __bitwise suspend_state_t;
diff -puN kernel/power/console.c~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch kernel/power/console.c
--- a/kernel/power/console.c~pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch
+++ a/kernel/power/console.c
@@ -7,17 +7,39 @@
 #include <linux/vt_kern.h>
 #include <linux/kbd_kern.h>
 #include <linux/console.h>
+#include <linux/module.h>
 #include "power.h"
 
 #if defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
+static int disable_vt_switch;
+
+/*
+ * Normally during a suspend, we allocate a new console and switch to it.
+ * When we resume, we switch back to the original console.  This switch
+ * can be slow, so on systems where the framebuffer can handle restoration
+ * of video registers anyways, there's little point in doing the console
+ * switch.  This function allows you to disable it by passing it '0'.
+ */
+void pm_set_vt_switch(int do_switch)
+{
+	acquire_console_sem();
+	disable_vt_switch = !do_switch;
+	release_console_sem();
+}
+EXPORT_SYMBOL(pm_set_vt_switch);
 
 int pm_prepare_console(void)
 {
 	acquire_console_sem();
 
+	if (disable_vt_switch) {
+		release_console_sem();
+		return 0;
+	}
+
 	orig_fgconsole = fg_console;
 
 	if (vc_allocate(SUSPEND_CONSOLE)) {
@@ -50,9 +72,12 @@ int pm_prepare_console(void)
 void pm_restore_console(void)
 {
 	acquire_console_sem();
+	if (disable_vt_switch) {
+		release_console_sem();
+		return;
+	}
 	set_console(orig_fgconsole);
 	release_console_sem();
 	kmsg_redirect = orig_kmsg;
-	return;
 }
 #endif
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

