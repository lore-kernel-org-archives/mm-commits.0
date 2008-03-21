From: akpm@linux-foundation.org
Subject: - dvb-logical-bitwise-confusion-in-se401_init.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:48 -0700
Message-ID: <200803212030.m2LKUmb2009019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757634AbYCUUbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mchehab@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dvb: logical-bitwise & confusion in se401_init()
has been removed from the -mm tree.  Its filename was
     dvb-logical-bitwise-confusion-in-se401_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb: logical-bitwise & confusion in se401_init()
From: Roel Kluin <12o3l@tiscali.nl>

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/se401.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/se401.c~dvb-logical-bitwise-confusion-in-se401_init drivers/media/video/se401.c
--- a/drivers/media/video/se401.c~dvb-logical-bitwise-confusion-in-se401_init
+++ a/drivers/media/video/se401.c
@@ -1279,7 +1279,7 @@ static int se401_init(struct usb_se401 *
 	rc=se401_sndctrl(0, se401, SE401_REQ_GET_HEIGHT, 0, cp, sizeof(cp));
 	se401->cheight=cp[0]+cp[1]*256;
 
-	if (!cp[2] && SE401_FORMAT_BAYER) {
+	if (!(cp[2] & SE401_FORMAT_BAYER)) {
 		err("Bayer format not supported!");
 		return 1;
 	}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

