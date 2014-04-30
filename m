From: akpm@linux-foundation.org
Subject: +
 bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch added to -mm tree
Date: Wed, 30 Apr 2014 13:10:48 -0700
Message-ID: <536158c8.+R1LJ0DeMK6+EDD1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbaD3UKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 16:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kmo@daterainc.com, hch@lst.de, axboe@kernel.dk, mlombard@redhat.com

Subject: + bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch added to -mm tree
To: mlombard@redhat.com,axboe@kernel.dk,hch@lst.de,kmo@daterainc.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:10:48 -0700


The patch titled
     Subject: bio: modify __bio_add_page() to accept pages that don't start a new segment
has been added to the -mm tree.  Its filename is
     bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |   51 +++++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff -puN fs/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment fs/bio.c
--- a/fs/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment
+++ a/fs/bio.c
@@ -699,6 +699,7 @@ static int __bio_add_page(struct request
 			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
+	unsigned int bi_phys_segments_orig;
 	struct bio_vec *bvec;
 
 	/*
@@ -750,29 +751,32 @@ static int __bio_add_page(struct request
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
+	bi_phys_segments_orig = bio->bi_phys_segments;
+	bio->bi_phys_segments++;
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
@@ -789,23 +793,26 @@ static int __bio_add_page(struct request
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
 	bio->bi_iter.bi_size += len;
 	return len;
+
+ failed:
+	bvec->bv_page = NULL;
+	bvec->bv_len = 0;
+	bvec->bv_offset = 0;
+	bio->bi_vcnt--;
+	bio->bi_phys_segments = bi_phys_segments_orig;
+
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from mlombard@redhat.com are

bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch

