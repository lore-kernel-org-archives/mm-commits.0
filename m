From: akpm@linux-foundation.org
Subject: - dm-call-clone_init-early.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:17:05 -0700
Message-ID: <200704170517.l3H5H501020991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36150 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbXDQFRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, agk@redhat.com, christophe@saout.de, mm-commits@vger.kernel.org


The patch titled
     dm: call clone_init early
has been removed from the -mm tree.  Its filename was
     dm-call-clone_init-early.patch

This patch was dropped because changes in the dm tree broke it

------------------------------------------------------
Subject: dm: call clone_init early
From: Olaf Kirch <olaf.kirch@oracle.com>

We need to call clone_init as early as possible - at least before call
bio_put(clone) in any error path.  Otherwise, the destructor will try to
dereference bi_private, which may still be NULL.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-call-clone_init-early drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-call-clone_init-early
+++ a/drivers/md/dm-crypt.c
@@ -138,6 +138,8 @@ struct crypt_config {
 
 static struct kmem_cache *_crypt_io_pool;
 
+static void clone_init(struct crypt_io *, struct bio *);
+
 /*
  * Different IV generation algorithms:
  *
@@ -492,9 +494,10 @@ static int crypt_convert(struct crypt_co
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_config *cc, unsigned int size,
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
                    struct bio *base_bio, unsigned int *bio_vec_idx)
 {
+	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
@@ -509,7 +512,7 @@ crypt_alloc_buffer(struct crypt_config *
 	if (!clone)
 		return NULL;
 
-	clone->bi_destructor = dm_crypt_bio_destructor;
+	clone_init(io, clone);
 
 	/* if the last bio was not complete, continue where that one ended */
 	clone->bi_idx = *bio_vec_idx;
@@ -692,6 +695,7 @@ static void clone_init(struct crypt_io *
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
 static void process_read(struct crypt_io *io)
@@ -715,7 +719,6 @@ static void process_read(struct crypt_io
 	}
 
 	clone_init(io, clone);
-	clone->bi_destructor = dm_crypt_bio_destructor;
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
 	clone->bi_size = base_bio->bi_size;
@@ -738,7 +741,7 @@ static void crypt_write_loop(struct cryp
 	do {
 		struct bio *clone;
 
-		clone = crypt_alloc_buffer(cc, base_bio->bi_size,
+		clone = crypt_alloc_buffer(io, base_bio->bi_size,
 					   io->first_clone, &io->bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
@@ -788,7 +791,6 @@ static void crypt_write_done(struct conv
 		return;
 	}
 
-	clone_init(io, clone);
 	clone->bi_sector = cc->start + io->sector;
 
 	if (!io->first_clone) {
_

Patches currently in -mm which might be from olaf.kirch@oracle.com are

origin.patch
dm-call-clone_init-early.patch
dm-do-not-access-the-bio-after-generic_make_request.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
