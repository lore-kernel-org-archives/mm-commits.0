From: akpm@linux-foundation.org
Subject: + lxfb-rename-kernel-arg-fbsize-to-vram.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:26:20 -0700
Message-ID: <200803312126.m2VLQKGp026806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbYCaV07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     lxfb: rename kernel arg fbsize to vram
has been added to the -mm tree.  Its filename is
     lxfb-rename-kernel-arg-fbsize-to-vram.patch

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
Subject: lxfb: rename kernel arg fbsize to vram
From: Andres Salomon <dilinger@queued.net>

Match other fb drivers (including gxfb).  Also, document the current boot
arguments in Documentation/fb/lxfb.txt.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/lxfb.txt       |   50 ++++++++++++++++++++++++++++++
 drivers/video/geode/lxfb_core.c |   12 +++----
 2 files changed, 55 insertions(+), 7 deletions(-)

diff -puN /dev/null Documentation/fb/lxfb.txt
--- /dev/null
+++ a/Documentation/fb/lxfb.txt
@@ -0,0 +1,50 @@
+[This file is cloned from VesaFB/aty128fb]
+
+What is lxfb?
+=================
+
+This is a graphics framebuffer driver for AMD Geode LX based processors.
+
+Advantages:
+
+ * No need to use AMD's VSA code (or other VESA emulation layer) in the
+   BIOS.
+ * It provides a nice large console (128 cols + 48 lines with 1024x768)
+   without using tiny, unreadable fonts.
+ * You can run XF68_FBDev on top of /dev/fb0
+ * Most important: boot logo :-)
+
+Disadvantages:
+
+ * graphic mode is slower than text mode...
+
+
+How to use it?
+==============
+
+Switching modes is done using  lxfb.mode_option=<resolution>... boot
+parameter or using `fbset' program.
+
+See Documentation/fb/modedb.txt for more information on modedb
+resolutions.
+
+
+X11
+===
+
+XF68_FBDev should generally work fine, but it is non-accelerated.
+
+
+Configuration
+=============
+
+You can pass kernel command line options to lxfb with lxfb.<option>.
+For example, lxfb.mode_option=800x600@75.
+Accepted options:
+
+mode_option	- specify the video mode.  Of the form
+		  <x>x<y>[-<bpp>][@<refresh>]
+vram		- size of video ram (normally auto-detected)
+
+--
+Andres Salomon <dilinger@debian.org>
diff -puN drivers/video/geode/lxfb_core.c~lxfb-rename-kernel-arg-fbsize-to-vram drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-rename-kernel-arg-fbsize-to-vram
+++ a/drivers/video/geode/lxfb_core.c
@@ -27,7 +27,7 @@
 
 static char *mode_option;
 static int noclear, nopanel, nocrt;
-static int fbsize;
+static int vram;
 
 /* Most of these modes are sorted in ascending order, but
  * since the first entry in this table is the "default" mode,
@@ -339,7 +339,7 @@ static int __init lxfb_map_video_memory(
 		return ret;
 
 	info->fix.smem_start = pci_resource_start(dev, 0);
-	info->fix.smem_len = fbsize ? fbsize : lx_framebuffer_size();
+	info->fix.smem_len = vram ? vram : lx_framebuffer_size();
 
 	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 
@@ -613,9 +613,7 @@ static int __init lxfb_setup(char *optio
 		if (!*opt)
 			continue;
 
-		if (!strncmp(opt, "fbsize:", 7))
-			fbsize = simple_strtoul(opt+7, NULL, 0);
-		else if (!strcmp(opt, "noclear"))
+		if (!strcmp(opt, "noclear"))
 			noclear = 1;
 		else if (!strcmp(opt, "nopanel"))
 			nopanel = 1;
@@ -652,8 +650,8 @@ module_exit(lxfb_cleanup);
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
-module_param(fbsize, int, 0);
-MODULE_PARM_DESC(fbsize, "video memory size");
+module_param(vram, int, 0);
+MODULE_PARM_DESC(vram, "video memory size");
 
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

