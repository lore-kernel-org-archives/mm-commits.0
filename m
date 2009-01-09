From: akpm@linux-foundation.org
Subject: - bio-zero-inlined-bio_vec.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:51:07 -0800
Message-ID: <200901092051.n09Kp70I011733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbZAIUvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     bio: zero inlined bio_vec
has been removed from the -mm tree.  Its filename was
     bio-zero-inlined-bio_vec.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bio: zero inlined bio_vec
From: Hugh Dickins <hugh@veritas.com>

bvec_alloc_bs() zeroes its bio_vec, and at least __blk_queue_bounce()
relies upon that: therefore bio_alloc_bioset() must zero the inlined
bio_vec - without that, lots of nastiness occurs in bounce_end_io and
blk_rq_map_sg and other places when booting up my PAE box.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/bio.c~bio-zero-inlined-bio_vec fs/bio.c
--- a/fs/bio.c~bio-zero-inlined-bio_vec
+++ a/fs/bio.c
@@ -321,6 +321,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 			if (nr_iovecs <= BIO_INLINE_VECS) {
 				idx = 0;
 				bvl = bio->bi_inline_vecs;
+				memset(bvl, 0, BIO_INLINE_VECS *
+							sizeof(struct bio_vec));
 				nr_iovecs = BIO_INLINE_VECS;
 			} else {
 				bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

