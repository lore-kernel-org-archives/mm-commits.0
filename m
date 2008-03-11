From: akpm@linux-foundation.org
Subject: + block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:38:18 -0700
Message-ID: <200803110538.m2B5cIPB024602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbYCKFiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:38:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl


The patch titled
     block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
has been added to the -mm tree.  Its filename is
     block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch

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
Subject: block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
From: Roel Kluin <12o3l@tiscali.nl>

In my likely profile it appears this one is inverted.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-merge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-merge.c~block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn block/blk-merge.c
--- a/block/blk-merge.c~block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn
+++ a/block/blk-merge.c
@@ -305,7 +305,7 @@ int ll_back_merge_fn(struct request_queu
 	}
 	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
+	if (likely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-alsa.patch
git-dvb.patch
drivers-media-video-tvp5150c-logical-bitwise-and-confusion.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

