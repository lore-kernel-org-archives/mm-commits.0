From: akpm@linux-foundation.org
Subject: - drivers-media-video-use-div_round_up.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:18 -0700
Message-ID: <200809022041.m82KfIVE011628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbYIBUl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-media-video-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c       |    4 ++--
 drivers/media/video/uvc/uvc_video.c |    2 +-
 drivers/media/video/zoran_device.c  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/media/video/bw-qcam.c~drivers-media-video-use-div_round_up drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~drivers-media-video-use-div_round_up
+++ a/drivers/media/video/bw-qcam.c
@@ -495,7 +495,7 @@ static void qc_set(struct qcam_device *q
 		val2 = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
 		    q->transfer_scale;
 	}
-	val = (val + val2 - 1) / val2;
+	val = DIV_ROUND_UP(val, val2);
 	qc_command(q, 0x13);
 	qc_command(q, val);
 
@@ -651,7 +651,7 @@ static long qc_capture(struct qcam_devic
 	transperline = q->width * q->bpp;
 	divisor = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
 	    q->transfer_scale;
-	transperline = (transperline + divisor - 1) / divisor;
+	transperline = DIV_ROUND_UP(transperline, divisor);
 
 	for (i = 0, yield = yieldlines; i < linestotrans; i++)
 	{
diff -puN drivers/media/video/uvc/uvc_video.c~drivers-media-video-use-div_round_up drivers/media/video/uvc/uvc_video.c
--- a/drivers/media/video/uvc/uvc_video.c~drivers-media-video-use-div_round_up
+++ a/drivers/media/video/uvc/uvc_video.c
@@ -655,7 +655,7 @@ static int uvc_init_video_isoc(struct uv
 	if (size > UVC_MAX_FRAME_SIZE)
 		return -EINVAL;
 
-	npackets = (size + psize - 1) / psize;
+	npackets = DIV_ROUND_UP(size, psize);
 	if (npackets > UVC_MAX_ISO_PACKETS)
 		npackets = UVC_MAX_ISO_PACKETS;
 
diff -puN drivers/media/video/zoran_device.c~drivers-media-video-use-div_round_up drivers/media/video/zoran_device.c
--- a/drivers/media/video/zoran_device.c~drivers-media-video-use-div_round_up
+++ a/drivers/media/video/zoran_device.c
@@ -377,7 +377,7 @@ zr36057_set_vfe (struct zoran           
 
 	/* horizontal */
 	VidWinWid = video_width;
-	X = (VidWinWid * 64 + tvn->Wa - 1) / tvn->Wa;
+	X = DIV_ROUND_UP(VidWinWid * 64, tvn->Wa);
 	We = (VidWinWid * 64) / X;
 	HorDcm = 64 - X;
 	hcrop1 = 2 * ((tvn->Wa - We) / 4);
@@ -403,7 +403,7 @@ zr36057_set_vfe (struct zoran           
 	/* Vertical */
 	DispMode = !(video_height > BUZ_MAX_HEIGHT / 2);
 	VidWinHt = DispMode ? video_height : video_height / 2;
-	Y = (VidWinHt * 64 * 2 + tvn->Ha - 1) / tvn->Ha;
+	Y = DIV_ROUND_UP(VidWinHt * 64 * 2, tvn->Ha);
 	He = (VidWinHt * 64) / Y;
 	VerDcm = 64 - Y;
 	vcrop1 = (tvn->Ha / 2 - He) / 2;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-atm-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

