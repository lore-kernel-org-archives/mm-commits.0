From: akpm@linux-foundation.org
Subject: + dvb-logical-bitwise-confusion-in-se401_init.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:00:59 -0700
Message-ID: <200803172200.m2HM0xU4000593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbYCQWBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, mchehab@infradead.org, riel@redhat.com


The patch titled
     dvb: logical-bitwise & confusion in se401_init()
has been added to the -mm tree.  Its filename is
     dvb-logical-bitwise-confusion-in-se401_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
kernel-schedc-remove-double-unlikely.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
dvb-logical-bitwise-confusion-in-se401_init.patch

