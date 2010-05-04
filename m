From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch removed from -mm tree
Date: Tue, 04 May 2010 11:28:23 -0400
Message-ID: <201005041829.o44ITsKG011411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932941Ab0EDSad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 14:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, laurent.pinchart@ideasonboard.com, luca.risolia@studio.unibo.it, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/sn9c102/sn9c102_core.c: improve error handling
has been removed from the -mm tree.  Its filename was
     drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/sn9c102/sn9c102_core.c: improve error handling
From: Dan Carpenter <error27@gmail.com>

Return an error if the controller is not found.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/sn9c102/sn9c102_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling drivers/media/video/sn9c102/sn9c102_core.c
--- a/drivers/media/video/sn9c102/sn9c102_core.c~drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling
+++ a/drivers/media/video/sn9c102/sn9c102_core.c
@@ -2295,7 +2295,7 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_dev
 	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
 		return -EFAULT;
 
-	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++)
+	for (i = 0; i < ARRAY_SIZE(s->qctrl); i++) {
 		if (ctrl.id == s->qctrl[i].id) {
 			if (s->qctrl[i].flags & V4L2_CTRL_FLAG_DISABLED)
 				return -EINVAL;
@@ -2305,7 +2305,9 @@ sn9c102_vidioc_s_ctrl(struct sn9c102_dev
 			ctrl.value -= ctrl.value % s->qctrl[i].step;
 			break;
 		}
