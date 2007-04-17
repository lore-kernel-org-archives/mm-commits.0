From: akpm@linux-foundation.org
Subject: - dm-allocate-smaller-clones.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:17:45 -0700
Message-ID: <200704170517.l3H5HjaO021000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbXDQFSJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, agk@redhat.com, christophe@saout.de, mm-commits@vger.kernel.org


The patch titled
     dm: allocate smaller clones
has been removed from the -mm tree.  Its filename was
     dm-allocate-smaller-clones.patch

This patch was dropped because changes in the dm tree broke it

------------------------------------------------------
Subject: dm: allocate smaller clones
From: Olaf Kirch <olaf.kirch@oracle.com>

With the previous dm-crypt fixes, there is no need for the clone bios to have
the same bvec size as the original - we just need to make them big enough for
the remaining number of pages.  The only requirement is that we clear the
"out" index in convert_context, so that crypt_convert starts storing data at
the right position within the clone bio.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-allocate-smaller-clones drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-allocate-smaller-clones
+++ a/drivers/md/dm-crypt.c
@@ -394,7 +394,7 @@ static int crypt_convert(struct crypt_co
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_io *io, unsigned int size, unsigned int *bio_vec_idx)
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -408,16 +408,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 
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
@@ -429,7 +420,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if ((i - clone->bi_idx) == (MIN_BIO_PAGES - 1))
+		if (i == (MIN_BIO_PAGES - 1))
 			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		bv->bv_offset = 0;
@@ -448,12 +439,6 @@ crypt_alloc_buffer(struct crypt_io *io, 
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
 
@@ -611,7 +596,6 @@ static void process_write(struct crypt_i
 	struct convert_context ctx;
 	unsigned remaining = base_bio->bi_size;
 	sector_t sector = base_bio->bi_sector - io->target->begin;
-	unsigned bvec_idx = 0;
 
 	atomic_inc(&io->pending);
 
@@ -622,13 +606,14 @@ static void process_write(struct crypt_i
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
@@ -637,6 +622,9 @@ static void process_write(struct crypt_i
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
dm-allocate-smaller-clones.patch
