From: akpm@linux-foundation.org
Subject: + gxfb-fix-incorrect-__init-annotation.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:48:30 -0700
Message-ID: <201006042248.o54MmUbi022857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0FDWsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, jordan.crouse@amd.com


The patch titled
     gxfb: fix incorrect __init annotation
has been added to the -mm tree.  Its filename is
     gxfb-fix-incorrect-__init-annotation.patch

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
Subject: gxfb: fix incorrect __init annotation
From: Andres Salomon <dilinger@queued.net>

WARNING: vmlinux.o(.data+0x195d8): Section mismatch in reference from the
variable gxfb_driver to the function .init.text:gxfb_probe() The variable
gxfb_driver references the function __init gxfb_probe()

This changes gxfb_probe and friends to use __devinit, and also adds
__devexit to gxfb_remove.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/gxfb_core.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~gxfb-fix-incorrect-__init-annotation drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-fix-incorrect-__init-annotation
+++ a/drivers/video/geode/gxfb_core.c
@@ -40,7 +40,7 @@ static int vram;
 static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static struct fb_videomode gx_modedb[] __initdata = {
+static struct fb_videomode gx_modedb[] __devinitdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -110,14 +110,15 @@ static struct fb_videomode gx_modedb[] _
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static struct fb_videomode gx_dcon_modedb[] __initdata = {
+static struct fb_videomode gx_dcon_modedb[] __devinitdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) gx_dcon_modedb;
@@ -129,7 +130,8 @@ static void __init get_modedb(struct fb_
 }
 
 #else
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) gx_modedb;
 	*size = ARRAY_SIZE(gx_modedb);
@@ -226,7 +228,8 @@ static int gxfb_blank(int blank_mode, st
 	return gx_blank_display(info, blank_mode);
 }
 
-static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
+static int __devinit gxfb_map_video_memory(struct fb_info *info,
+		struct pci_dev *dev)
 {
 	struct gxfb_par *par = info->par;
 	int ret;
@@ -290,7 +293,7 @@ static struct fb_ops gxfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static struct fb_info * __init gxfb_init_fbinfo(struct device *dev)
+static struct fb_info *__devinit gxfb_init_fbinfo(struct device *dev)
 {
 	struct gxfb_par *par;
 	struct fb_info *info;
@@ -371,7 +374,8 @@ static int gxfb_resume(struct pci_dev *p
 }
 #endif
 
-static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit gxfb_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
 	struct gxfb_par *par;
 	struct fb_info *info;
@@ -451,7 +455,7 @@ static int __init gxfb_probe(struct pci_
 	return ret;
 }
 
-static void gxfb_remove(struct pci_dev *pdev)
+static void __devexit gxfb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct gxfb_par *par = info->par;
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-mm-create-symbolic-index-into-address_markers-array.patch
x86-olpc-add-support-for-calling-into-openfirmware.patch
gxfb-fix-incorrect-__init-annotation.patch
lxfb-fix-incorrect-__init-annotation.patch

