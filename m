From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:29 -0700
Message-ID: <201103232045.p2NKj50M029160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933516Ab1CWUz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: strakh@ispras.ru, mchehab@infradead.org, shijie8@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/tlg2300/pd-video.c: fix double mutex_unlock in pd_vidioc_s_fmt()
has been removed from the -mm tree.  Its filename was
     drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/tlg2300/pd-video.c: fix double mutex_unlock in pd_vidioc_s_fmt()
From: Alexander Strakh <strakh@ispras.ru>

Cc: Huang Shijie <shijie8@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tlg2300/pd-video.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/media/video/tlg2300/pd-video.c~drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt drivers/media/video/tlg2300/pd-video.c
--- a/drivers/media/video/tlg2300/pd-video.c~drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt
+++ a/drivers/media/video/tlg2300/pd-video.c
@@ -764,10 +764,8 @@ static int pd_vidioc_s_fmt(struct poseid
 	}
 	ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
 				vid_resol, &cmd_status);
-	if (ret || cmd_status) {
-		mutex_unlock(&pd->lock);
+	if (ret || cmd_status)
 		return -EBUSY;
-	}
 
 	pix_def->pixelformat = pix->pixelformat; /* save it */
 	pix->height = (context->tvnormid & V4L2_STD_525_60) ?  480 : 576;
_

Patches currently in -mm which might be from strakh@ispras.ru are

linux-next.patch

