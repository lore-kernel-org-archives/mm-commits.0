From: akpm@linux-foundation.org
Subject: - drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:01 -0700
Message-ID: <200803172100.m2HL01Nv030782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbYCQVAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/tvp5150.c: logical-bitwise and confusion
has been removed from the -mm tree.  Its filename was
     drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/tvp5150.c: logical-bitwise and confusion
From: Roel Kluin <12o3l@tiscali.nl>

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tvp5150.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/tvp5150.c~drivers-media-video-tvp5150c-logical-bitwise-and-confusion drivers/media/video/tvp5150.c
--- a/drivers/media/video/tvp5150.c~drivers-media-video-tvp5150c-logical-bitwise-and-confusion
+++ a/drivers/media/video/tvp5150.c
@@ -672,7 +672,7 @@ static int tvp5150_set_vbi(struct i2c_cl
 	if (std == V4L2_STD_ALL) {
 		tvp5150_err("VBI can't be configured without knowing number of lines\n");
 		return 0;
-	} else if (std && V4L2_STD_625_50) {
+	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
 		line += 3;
 	}
@@ -719,7 +719,7 @@ static int tvp5150_get_vbi(struct i2c_cl
 	if (std == V4L2_STD_ALL) {
 		tvp5150_err("VBI can't be configured without knowing number of lines\n");
 		return 0;
-	} else if (std && V4L2_STD_625_50) {
+	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
 		line += 3;
 	}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

