From: akpm@linux-foundation.org
Subject: + olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch added to -mm tree
Date: Thu, 17 Apr 2008 21:22:10 -0700
Message-ID: <200804180422.m3I4MA3t010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbYDREWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 00:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     lxfb/gxfb: fix up __init and __initdata fields for modedb-related stuff
has been added to the -mm tree.  Its filename is
     olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch

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
Subject: lxfb/gxfb: fix up __init and __initdata fields for modedb-related stuff
From: Andres Salomon <dilinger@queued.net>

A couple things were wrong here:
 - a struct in lxfb should've been static.
 - 'const' and '__initdata' don't mix, so the consts have been dropped
 - get_modedb() in both drivers should've been marked w/ __init

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gxfb_core.c |    8 ++++----
 drivers/video/geode/lxfb_core.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix
+++ a/drivers/video/geode/gxfb_core.c
@@ -41,7 +41,7 @@ static int vram;
 static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static const struct fb_videomode gx_modedb[] __initdata = {
+static struct fb_videomode gx_modedb[] __initdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -111,14 +111,14 @@ static const struct fb_videomode gx_mode
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static const struct fb_videomode gx_dcon_modedb[] __initdata = {
+static struct fb_videomode gx_dcon_modedb[] __initdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) gx_dcon_modedb;
@@ -130,7 +130,7 @@ static void get_modedb(struct fb_videomo
 }
 
 #else
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) gx_modedb;
 	*size = ARRAY_SIZE(gx_modedb);
diff -puN drivers/video/geode/lxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix
+++ a/drivers/video/geode/lxfb_core.c
@@ -36,7 +36,7 @@ static int vt_switch;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-static const struct fb_videomode geode_modedb[] __initdata = {
+static struct fb_videomode geode_modedb[] __initdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
@@ -220,14 +220,14 @@ static const struct fb_videomode geode_m
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-const struct fb_videomode olpc_dcon_modedb[] __initdata = {
+static struct fb_videomode olpc_dcon_modedb[] __initdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
@@ -239,7 +239,7 @@ static void get_modedb(struct fb_videomo
 }
 
 #else
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) geode_modedb;
 	*size = ARRAY_SIZE(geode_modedb);
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

