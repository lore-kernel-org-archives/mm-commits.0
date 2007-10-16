From: akpm@linux-foundation.org
Subject: - ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:26 -0700
Message-ID: <200710162045.l9GKjQhe016264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935214AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: do not print warnings on invalid frame numbers
has been removed from the -mm tree.  Its filename was
     ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: do not print warnings on invalid frame numbers
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Do not print warnings on invalid frame numbers, as this can be triggered from
user space.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-do-not-print-warnings-on-invalid-frame-numbers drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-do-not-print-warnings-on-invalid-frame-numbers
+++ a/drivers/video/ps3fb.c
@@ -389,8 +389,8 @@ static int ps3fb_sync(struct fb_info *in
 	yres = ps3fb_res[i].yres;
 
 	if (frame > ps3fb.num_frames - 1) {
-		dev_warn(info->device, "%s: invalid frame number (%u)\n",
-			 __func__, frame);
+		dev_dbg(info->device, "%s: invalid frame number (%u)\n",
+			__func__, frame);
 		return -EINVAL;
 	}
 	offset = xres * yres * BPP * frame;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
