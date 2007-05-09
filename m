From: akpm@linux-foundation.org
Subject: + dm-crypt-use-smaller-bvecs-in-clones.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:42 -0700
Message-ID: <200705090054.l490sgl1006367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966826AbXEIAyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf.kirch@oracle.com, agk@redhat.com, jens.axboe@oracle.com


The patch titled
     dm crypt: use smaller bvecs in clones
has been added to the -mm tree.  Its filename is
     dm-crypt-use-smaller-bvecs-in-clones.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm crypt: use smaller bvecs in clones
From: Olaf Kirch <olaf.kirch@oracle.com>

Allocate smaller clones

With the previous dm-crypt fixes, there is no need for the clone bios to have
the same bvec size as the original - we just need to make them big enough for
the remaining number of pages.  The only requirement is that we clear the
"out" index in convert_context, so that crypt_convert starts storing data at
the right position within the clone bio.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-use-smaller-bvecs-in-clones drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-use-smaller-bvecs-in-clones
+++ a/drivers/md/dm-crypt.c
@@ -379,8 +379,7 @@ static int crypt_convert(struct crypt_co
  * This should never violate the device limitations
  * May return a smaller bio when running out of pages
  */
-static struct bio *crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
-				      unsigned int *bio_vec_idx)
+static struct bio *crypt_alloc_buffer(struct crypt_io *io, unsigned int size)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -394,16 +393,7 @@ static struct bio *crypt_alloc_buffer(st
 
 	clone_init(io, clone);
 
-	/* if the last bio was not complete, continue where that one ended */
-	clone->bi_idx = *bio_vec_idx;
-	clone->bi_vcnt = *bio_vec_idx;
-	clone->bi_size = 0;
-	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
-
-	/* clone->bi_idx pages have already been allocated */
-	size -= clone->bi_idx * PAGE_SIZE;
-
-	for (i = clone->bi_idx; i < nr_iovecs; i++) {
+	for (i = 0; i < nr_iovecs; i++) {
 		struct bio_vec *bv = bio_iovec_idx(clone, i);
 
 		bv->bv_page = mempool_alloc(cc->page_pool, gfp_mask);
@@ -415,7 +405,7 @@ static struct bio *crypt_alloc_buffer(st
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if ((i - clone->bi_idx) == (MIN_BIO_PAGES - 1))
+		if (i == (MIN_BIO_PAGES - 1))
 			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		bv->bv_offset = 0;
@@ -434,12 +424,6 @@ static struct bio *crypt_alloc_buffer(st
 		return NULL;
 	}
 
-	/*
-	 * Remember the last bio_vec allocated to be able
-	 * to correctly continue after the splitting.
-	 */
-	*bio_vec_idx = clone->bi_vcnt;
-
 	return clone;
 }
 
@@ -597,7 +581,6 @@ static void process_write(struct crypt_i
 	struct convert_context ctx;
 	unsigned remaining = base_bio->bi_size;
 	sector_t sector = base_bio->bi_sector - io->target->begin;
-	unsigned bvec_idx = 0;
 
 	atomic_inc(&io->pending);
 
@@ -608,13 +591,14 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(io, base_bio->bi_size, &bvec_idx);
+		clone = crypt_alloc_buffer(io, remaining);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
 		}
 
 		ctx.bio_out = clone;
+		ctx.idx_out = 0;
 
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
 			crypt_free_buffer_pages(cc, clone, clone->bi_size);
@@ -623,6 +607,9 @@ static void process_write(struct crypt_i
 			return;
 		}
 
+		/* crypt_convert should have filled the clone bio */
+		BUG_ON(ctx.idx_out < clone->bi_vcnt);
+
 		clone->bi_sector = cc->start + sector;
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
_

Patches currently in -mm which might be from olaf.kirch@oracle.com are

origin.patch
dm-crypt-fix-call-to-clone_init.patch
dm-crypt-fix-avoid-cloned-bio-ref-after-free.patch
dm-crypt-fix-remove-first_clone.patch
dm-crypt-use-smaller-bvecs-in-clones.patch
