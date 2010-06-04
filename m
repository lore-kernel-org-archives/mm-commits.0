From: akpm@linux-foundation.org
Subject: + lxfb-fix-incorrect-__init-annotation.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:48:32 -0700
Message-ID: <201006042248.o54MmWqm022860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0FDWsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, jordan.crouse@amd.com


The patch titled
     lxfb: fix incorrect __init annotation
has been added to the -mm tree.  Its filename is
     lxfb-fix-incorrect-__init-annotation.patch

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
Subject: lxfb: fix incorrect __init annotation
From: Andres Salomon <dilinger@queued.net>

WARNING: vmlinux.o(.data+0x196e8): Section mismatch in reference from the
variable lxfb_driver to the function .init.text:lxfb_probe() The variable
lxfb_driver references the function __init lxfb_probe()

This changes lxfb_probe and friends to use __devinit, and also adds
__devexit to lxfb_remove.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~lxfb-fix-incorrect-__init-annotation drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-fix-incorrect-__init-annotation
+++ a/drivers/video/geode/lxfb_core.c
@@ -35,7 +35,7 @@ static int vt_switch;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-static struct fb_videomode geode_modedb[] __initdata = {
+static struct fb_videomode geode_modedb[] __devinitdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
@@ -219,14 +219,15 @@ static struct fb_videomode geode_modedb[
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static struct fb_videomode olpc_dcon_modedb[] __initdata = {
+static struct fb_videomode olpc_dcon_modedb[] __devinitdata = {
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
 		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
@@ -238,7 +239,8 @@ static void __init get_modedb(struct fb_
 }
 
 #else
-static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __devinit get_modedb(struct fb_videomode **modedb,
+		unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) geode_modedb;
 	*size = ARRAY_SIZE(geode_modedb);
@@ -334,7 +336,7 @@ static int lxfb_blank(int blank_mode, st
 }
 
 
-static int __init lxfb_map_video_memory(struct fb_info *info,
+static int __devinit lxfb_map_video_memory(struct fb_info *info,
 					struct pci_dev *dev)
 {
 	struct lxfb_par *par = info->par;
@@ -412,7 +414,7 @@ static struct fb_ops lxfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static struct fb_info * __init lxfb_init_fbinfo(struct device *dev)
+static struct fb_info * __devinit lxfb_init_fbinfo(struct device *dev)
 {
 	struct lxfb_par *par;
 	struct fb_info *info;
@@ -496,7 +498,7 @@ static int lxfb_resume(struct pci_dev *p
 #define lxfb_resume NULL
 #endif
 
-static int __init lxfb_probe(struct pci_dev *pdev,
+static int __devinit lxfb_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
 	struct lxfb_par *par;
@@ -588,7 +590,7 @@ err:
 	return ret;
 }
 
-static void lxfb_remove(struct pci_dev *pdev)
+static void __devexit lxfb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct lxfb_par *par = info->par;
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-mm-create-symbolic-index-into-address_markers-array.patch
x86-olpc-add-support-for-calling-into-openfirmware.patch
gxfb-fix-incorrect-__init-annotation.patch
lxfb-fix-incorrect-__init-annotation.patch

