From: akpm@linux-foundation.org
Subject: + drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch added to -mm tree
Date: Fri, 21 Jan 2011 15:23:41 -0800
Message-ID: <201101212323.p0LNNfdn007108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361Ab1AUXY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 18:24:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: strakh@ispras.ru, mchehab@infradead.org, shijie8@gmail.com


The patch titled
     drivers/media/video/tlg2300/pd-video.c: fix double mutex_unlock in pd_vidioc_s_fmt()
has been added to the -mm tree.  Its filename is
     drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch

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

drivers-media-video-tlg2300-pd-videoc-fix-double-mutex_unlock-in-pd_vidioc_s_fmt.patch

