From: akpm@osdl.org
Subject: + fix-namespace-conflict-between-w9968cfc-on-mips.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:17:14 -0800
Message-ID: <200612102017.kBAKHEae002050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762489AbWLJUR3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, mchehab@infradead.org


The patch titled
     Fix namespace conflict between w9968cf.c on MIPS
has been added to the -mm tree.  Its filename is
     fix-namespace-conflict-between-w9968cfc-on-mips.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix namespace conflict between w9968cf.c on MIPS
From: Ralf Baechle <ralf@linux-mips.org>

Both use __SC.  Since __* is sort of private namespace I've choosen to fix
this in the driver.  For consistency I decieded to also change __UNSC to
UNSC.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/w9968cf.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/media/video/w9968cf.c~fix-namespace-conflict-between-w9968cfc-on-mips drivers/media/video/w9968cf.c
--- a/drivers/media/video/w9968cf.c~fix-namespace-conflict-between-w9968cfc-on-mips
+++ a/drivers/media/video/w9968cf.c
@@ -1827,8 +1827,8 @@ w9968cf_set_window(struct w9968cf_device
 	int err = 0;
 
 	/* Work around to avoid FP arithmetics */
-	#define __SC(x) ((x) << 10)
-	#define __UNSC(x) ((x) >> 10)
+	#define SC(x) ((x) << 10)
+	#define UNSC(x) ((x) >> 10)
 
 	/* Make sure we are using a supported resolution */
 	if ((err = w9968cf_adjust_window_size(cam, (u16*)&win.width,
@@ -1836,15 +1836,15 @@ w9968cf_set_window(struct w9968cf_device
 		goto error;
 
 	/* Scaling factors */
-	fw = __SC(win.width) / cam->maxwidth;
-	fh = __SC(win.height) / cam->maxheight;
+	fw = SC(win.width) / cam->maxwidth;
+	fh = SC(win.height) / cam->maxheight;
 
 	/* Set up the width and height values used by the chip */
 	if ((win.width > cam->maxwidth) || (win.height > cam->maxheight)) {
 		cam->vpp_flag |= VPP_UPSCALE;
 		/* Calculate largest w,h mantaining the same w/h ratio */
-		w = (fw >= fh) ? cam->maxwidth : __SC(win.width)/fh;
-		h = (fw >= fh) ? __SC(win.height)/fw : cam->maxheight;
+		w = (fw >= fh) ? cam->maxwidth : SC(win.width)/fh;
+		h = (fw >= fh) ? SC(win.height)/fw : cam->maxheight;
 		if (w < cam->minwidth) /* just in case */
 			w = cam->minwidth;
 		if (h < cam->minheight) /* just in case */
@@ -1861,8 +1861,8 @@ w9968cf_set_window(struct w9968cf_device
 
 	/* Calculate cropped area manteining the right w/h ratio */
 	if (cam->largeview && !(cam->vpp_flag & VPP_UPSCALE)) {
-		cw = (fw >= fh) ? cam->maxwidth : __SC(win.width)/fh;
-		ch = (fw >= fh) ? __SC(win.height)/fw : cam->maxheight;
+		cw = (fw >= fh) ? cam->maxwidth : SC(win.width)/fh;
+		ch = (fw >= fh) ? SC(win.height)/fw : cam->maxheight;
 	} else {
 		cw = w;
 		ch = h;
@@ -1901,8 +1901,8 @@ w9968cf_set_window(struct w9968cf_device
 	/* We have to scale win.x and win.y offsets */
 	if ( (cam->largeview && !(cam->vpp_flag & VPP_UPSCALE))
 	     || (cam->vpp_flag & VPP_UPSCALE) ) {
-		ax = __SC(win.x)/fw;
-		ay = __SC(win.y)/fh;
+		ax = SC(win.x)/fw;
+		ay = SC(win.y)/fh;
 	} else {
 		ax = win.x;
 		ay = win.y;
@@ -1917,8 +1917,8 @@ w9968cf_set_window(struct w9968cf_device
 	/* Adjust win.x, win.y */
 	if ( (cam->largeview && !(cam->vpp_flag & VPP_UPSCALE))
 	     || (cam->vpp_flag & VPP_UPSCALE) ) {
-		win.x = __UNSC(ax*fw);
-		win.y = __UNSC(ay*fh);
+		win.x = UNSC(ax*fw);
+		win.y = UNSC(ay*fh);
 	} else {
 		win.x = ax;
 		win.y = ay;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch
i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit.patch
fix-namespace-conflict-between-w9968cfc-on-mips.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

