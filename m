From: akpm@linux-foundation.org
Subject: - block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch removed from -mm tree
Date: Tue, 01 Jul 2008 23:21:19 -0700
Message-ID: <200807020621.m626LKUa002500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758330AbYGBGV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 02:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: fix bio_add_page for non trivial merge_bvec_fn case
has been removed from the -mm tree.  Its filename was
     block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch

This patch was dropped because it gets rejects, and seems to need an update

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

