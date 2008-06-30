From: akpm@linux-foundation.org
Subject: + block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:13:27 -0700
Message-ID: <200806302113.m5ULDRas025640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbYF3VOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, jens.axboe@oracle.com


The patch titled
     block: fix bio_add_page for non trivial merge_bvec_fn case
has been added to the -mm tree.  Its filename is
     block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch

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
Subject: block: fix bio_add_page for non trivial merge_bvec_fn case
From: Dmitri Monakhov <dmonakhov@openvz.org>

We have to properly decrease all related bio's counters, especially
bi_size in order to merge_bvec_fn return right result.  Usually this
result in false merge rejects for two absolutely valid bio_vecs.  This may
cause significant performance penalty for example Itanium: page_size ==
16k, fs_block_size == 1k and block device is raid with small chunk_size.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/bio.c~block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case fs/bio.c
--- a/fs/bio.c~block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case
+++ a/fs/bio.c
@@ -332,14 +332,21 @@ static int __bio_add_page(struct request
 
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
+			/* Temprory detacth last bio_vec. */
+			bio->bi_size -= prev->bv_len;
+			bio->bi_vcnt--;
+			bio->bi_phys_segments--;
+			bio->bi_hw_segments--;
+
 			prev->bv_len += len;
 			if (q->merge_bvec_fn &&
 			    q->merge_bvec_fn(q, bio, prev) < len) {
 				prev->bv_len -= len;
-				return 0;
+				len = 0;
 			}
 
-			goto done;
+			bio->bi_size += prev->bv_len;
+			goto out_add_bvec;
 		}
 	}
 
@@ -394,11 +401,11 @@ static int __bio_add_page(struct request
 	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	bio->bi_size += len;
+out_add_bvec:
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
 	bio->bi_hw_segments++;
- done:
-	bio->bi_size += len;
 	return len;
 }
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch
block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case-fix.patch

