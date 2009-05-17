From: akpm@linux-foundation.org
Subject: [merged] block-fix-the-bio_vec-array-index-out-of-bounds-test.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:29 -0700
Message-ID: <200905171654.n4HGsThe017174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbZEQQzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ki@epsilou.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: fix the bio_vec array index out-of-bounds test
has been removed from the -mm tree.  Its filename was
     block-fix-the-bio_vec-array-index-out-of-bounds-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix the bio_vec array index out-of-bounds test
From: Kazuhisa Ichikawa <ki@epsilou.com>

Current bio_vec array index out-of-bounds test within
__end_that_request_first() does not seem correct.

It checks bio->bi_idx against bio->bi_vcnt, but the subsequent code uses
idx (which is, bio->bi_idx + next_idx) as the array index into bio_vec
array.  This means that the test really make sense only at the first
iteration of !(nr_bytes >=bio->bi_size) case (when next_idx == zero).  Fix
this by replacing bio->bi_idx with idx.

Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN block/blk-core.c~block-fix-the-bio_vec-array-index-out-of-bounds-test block/blk-core.c
--- a/block/blk-core.c~block-fix-the-bio_vec-array-index-out-of-bounds-test
+++ a/block/blk-core.c
@@ -1863,10 +1863,10 @@ bool blk_update_request(struct request *
 		} else {
 			int idx = bio->bi_idx + next_idx;
 
-			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			if (unlikely(idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-				       __func__, bio->bi_idx, bio->bi_vcnt);
+				       __func__, idx, bio->bi_vcnt);
 				break;
 			}
 
_

Patches currently in -mm which might be from ki@epsilou.com are


