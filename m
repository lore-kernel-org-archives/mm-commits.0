From: akpm@linux-foundation.org
Subject: - ps3fb-make-frame-buffer-offsets-unsigned-int.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:06 -0800
Message-ID: <200802070028.m170SlcN007206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764527AbYBGAn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: make frame buffer offsets unsigned int
has been removed from the -mm tree.  Its filename was
     ps3fb-make-frame-buffer-offsets-unsigned-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ps3fb: make frame buffer offsets unsigned int
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Frame buffer offsets don't have to be `unsigned long', `unsigned int' is
sufficient

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-make-frame-buffer-offsets-unsigned-int drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-make-frame-buffer-offsets-unsigned-int
+++ a/drivers/video/ps3fb.c
@@ -140,9 +140,9 @@ struct ps3fb_par {
 	unsigned int ddr_line_length;
 	unsigned int ddr_frame_size;
 	unsigned int xdr_frame_size;
-	unsigned long full_offset;	/* start of fullscreen DDR fb */
-	unsigned long fb_offset;	/* start of actual DDR fb */
-	unsigned long pan_offset;
+	unsigned int full_offset;	/* start of fullscreen DDR fb */
+	unsigned int fb_offset;		/* start of actual DDR fb */
+	unsigned int pan_offset;
 };
 
 
@@ -512,8 +512,7 @@ static int ps3fb_set_par(struct fb_info 
 {
 	struct ps3fb_par *par = info->par;
 	unsigned int mode, ddr_line_length, xdr_line_length, lines, maxlines;
-	unsigned int ddr_xoff, ddr_yoff;
-	unsigned long offset;
+	unsigned int ddr_xoff, ddr_yoff, offset;
 	const struct fb_videomode *vmode;
 	u64 dst;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
git-scsi-misc.patch
