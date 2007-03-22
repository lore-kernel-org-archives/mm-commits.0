From: akpm@linux-foundation.org
Subject: + dm-allocate-smaller-clones.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:51:52 -0700
Message-ID: <200703222151.l2MLpvIW031234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53422 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161120AbXCVVwS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe@saout.de, agk@redhat.com, olaf.kirch@oracle.com


The patch titled
     dm: allocate smaller clones
has been added to the -mm tree.  Its filename is
     dm-allocate-smaller-clones.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: allocate smaller clones
From: Christophe Saout <christophe@saout.de>

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
 1 files changed, 8 insertions(+), 20 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-allocate-smaller-clones drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-allocate-smaller-clones
+++ a/drivers/md/dm-crypt.c
@@ -380,7 +380,7 @@ static int crypt_convert(struct crypt_co
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_io *io, unsigned int size, unsigned int *bio_vec_idx)
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -394,16 +394,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 
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
@@ -415,7 +406,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if ((i - clone->bi_idx) == (MIN_BIO_PAGES - 1))
+		if (i == (MIN_BIO_PAGES - 1))
 			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		bv->bv_offset = 0;
@@ -434,12 +425,6 @@ crypt_alloc_buffer(struct crypt_io *io, 
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
 
@@ -597,7 +582,6 @@ static void process_write(struct crypt_i
 	struct convert_context ctx;
 	unsigned remaining = base_bio->bi_size;
 	sector_t sector = base_bio->bi_sector - io->target->begin;
-	unsigned bvec_idx = 0;
 
 	atomic_inc(&io->pending);
 
@@ -608,13 +592,14 @@ static void process_write(struct crypt_i
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
@@ -623,6 +608,9 @@ static void process_write(struct crypt_i
 			return;
 		}
 
+		/* crypt_convert should have filled the clone bio */
+		BUG_ON(ctx.idx_out < clone->bi_vcnt);
+
 		clone->bi_sector = cc->start + sector;
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
_

Patches currently in -mm which might be from christophe@saout.de are

dm-call-clone_init-early.patch
dm-do-not-access-the-bio-after-generic_make_request.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
