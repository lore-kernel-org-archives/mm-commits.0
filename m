From: akpm@linux-foundation.org
Subject: [merged]
 bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch removed from -mm tree
Date: Wed, 02 Jul 2014 11:04:01 -0700
Message-ID: <53b44991.SIEQPxlz66POsX4n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44540 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbaGBSED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 14:04:03 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so1308891qcv.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 11:04:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mlombard@redhat.com, axboe@kernel.dk, dongsu.park@profitbricks.com, hch@lst.de, jet.chen@intel.com, kmo@daterainc.com, ming.lei@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: bio: modify __bio_add_page() to accept pages that don't start a new segment
has been removed from the -mm tree.  Its filename was
     bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maurizio Lombardi <mlombard@redhat.com>
Subject: bio: modify __bio_add_page() to accept pages that don't start a new segment

The original behaviour is to refuse to add a new page if the maximum
number of segments has been reached, regardless of the fact the page we
are going to add can be merged into the last segment or not.

Unfortunately, when the system runs under heavy memory fragmentation
conditions, a driver may try to add multiple pages to the last segment. 
The original code won't accept them and EBUSY will be reported to
userspace.

This patch modifies the function so it refuses to add a page only in case
the latter starts a new segment and the maximum number of segments has
already been reached.

The bug can be easily reproduced with the st driver:

1) set CONFIG_SCSI_MPT2SAS_MAX_SGE or CONFIG_SCSI_MPT3SAS_MAX_SGE  to 16
2) modprobe st buffer_kbs=1024
3) #dd if=/dev/zero of=/dev/st0 bs=1M count=10
   dd: error writing `/dev/st0': Device or resource busy

[ming.lei@canonical.com: update bi_iter.bi_size before recounting segments]
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c |   52 +++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff -puN block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment block/bio.c
--- a/block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment
+++ a/block/bio.c
@@ -745,6 +745,7 @@ static int __bio_add_page(struct request
 				}
 			}
 
+			bio->bi_iter.bi_size += len;
 			goto done;
 		}
 
@@ -761,29 +762,32 @@ static int __bio_add_page(struct request
 		return 0;
 
 	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
+	 * setup the new entry, we might clear it again later if we
+	 * cannot add the page
+	 */
+	bvec = &bio->bi_io_vec[bio->bi_vcnt];
+	bvec->bv_page = page;
+	bvec->bv_len = len;
+	bvec->bv_offset = offset;
+	bio->bi_vcnt++;
+	bio->bi_phys_segments++;
+	bio->bi_iter.bi_size += len;
+
+	/*
+	 * Perform a recount if the number of segments is greater
+	 * than queue_max_segments(q).
 	 */
 
-	while (bio->bi_phys_segments >= queue_max_segments(q)) {
+	while (bio->bi_phys_segments > queue_max_segments(q)) {
 
 		if (retried_segments)
-			return 0;
+			goto failed;
 
 		retried_segments = 1;
 		blk_recount_segments(q, bio);
 	}
 
 	/*
-	 * setup the new entry, we might clear it again later if we
-	 * cannot add the page
-	 */
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
-
-	/*
 	 * if queue has other restrictions (eg varying max sector size
 	 * depending on offset), it can specify a merge_bvec_fn in the
 	 * queue to get further control
@@ -800,23 +804,25 @@ static int __bio_add_page(struct request
 		 * merge_bvec_fn() returns number of bytes it can accept
 		 * at this offset
 		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
+		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len)
+			goto failed;
 	}
 
 	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
+	if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
-	bio->bi_vcnt++;
-	bio->bi_phys_segments++;
  done:
-	bio->bi_iter.bi_size += len;
 	return len;
+
+ failed:
+	bvec->bv_page = NULL;
+	bvec->bv_len = 0;
+	bvec->bv_offset = 0;
+	bio->bi_vcnt--;
+	bio->bi_iter.bi_size -= len;
+	blk_recount_segments(q, bio);
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from mlombard@redhat.com are

linux-next.patch

