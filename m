From: akpm@linux-foundation.org
Subject: + lxfb-disable-suspend-vt-switch-by-default.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:26:22 -0700
Message-ID: <200803312126.m2VLQMdc026809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475AbYCaV1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:27:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     lxfb: disable suspend VT switch by default
has been added to the -mm tree.  Its filename is
     lxfb-disable-suspend-vt-switch-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: disable suspend VT switch by default
From: Andres Salomon <dilinger@queued.net>

By default disable VT switch, but allow it to be overridden via the
'vt_switch' module arg.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/lxfb.txt       |    2 ++
 drivers/video/geode/lxfb_core.c |    7 +++++++
 2 files changed, 9 insertions(+)

diff -puN Documentation/fb/lxfb.txt~lxfb-disable-suspend-vt-switch-by-default Documentation/fb/lxfb.txt
--- a/Documentation/fb/lxfb.txt~lxfb-disable-suspend-vt-switch-by-default
+++ a/Documentation/fb/lxfb.txt
@@ -45,6 +45,8 @@ Accepted options:
 mode_option	- specify the video mode.  Of the form
 		  <x>x<y>[-<bpp>][@<refresh>]
 vram		- size of video ram (normally auto-detected)
+vt_switch	- enable vt switching during suspend/resume.  The vt
+		  switch is slow, but harmless.
 
 --
 Andres Salomon <dilinger@debian.org>
diff -puN drivers/video/geode/lxfb_core.c~lxfb-disable-suspend-vt-switch-by-default drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-disable-suspend-vt-switch-by-default
+++ a/drivers/video/geode/lxfb_core.c
@@ -17,6 +17,7 @@
 #include <linux/console.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -28,6 +29,7 @@
 static char *mode_option;
 static int noclear, nopanel, nocrt;
 static int vram;
+static int vt_switch;
 
 /* Most of these modes are sorted in ascending order, but
  * since the first entry in this table is the "default" mode,
@@ -526,6 +528,8 @@ static int __init lxfb_probe(struct pci_
 	lxfb_check_var(&info->var, info);
 	lxfb_set_par(info);
 
+	pm_set_vt_switch(vt_switch);
+
 	if (register_framebuffer(info) < 0) {
 		ret = -EINVAL;
 		goto err;
@@ -653,5 +657,8 @@ MODULE_PARM_DESC(mode_option, "video mod
 module_param(vram, int, 0);
 MODULE_PARM_DESC(vram, "video memory size");
 
+module_param(vt_switch, int, 0);
+MODULE_PARM_DESC(vt_switch, "enable VT switch during suspend/resume");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode LX");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-geode-msr-cleanup.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch

