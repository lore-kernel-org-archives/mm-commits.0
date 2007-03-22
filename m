From: akpm@linux-foundation.org
Subject: + dm-call-clone_init-early.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:51:46 -0700
Message-ID: <200703222151.l2MLpkhd031221@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53419 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161120AbXCVVwM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christophe@saout.de, agk@redhat.com, olaf.kirch@oracle.com


The patch titled
     dm: call clone_init early
has been added to the -mm tree.  Its filename is
     dm-call-clone_init-early.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm: call clone_init early
From: Christophe Saout <christophe@saout.de>

We need to call clone_init as early as possible - at least before call
bio_put(clone) in any error path.  Otherwise, the destructor will try to
dereference bi_private, which may still be NULL.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-call-clone_init-early drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-call-clone_init-early
+++ a/drivers/md/dm-crypt.c
@@ -107,6 +107,8 @@ struct crypt_config {
 
 static struct kmem_cache *_crypt_io_pool;
 
+static void clone_init(struct crypt_io *, struct bio *);
+
 /*
  * Different IV generation algorithms:
  *
@@ -379,9 +381,10 @@ static int crypt_convert(struct crypt_co
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
@@ -396,7 +399,7 @@ crypt_alloc_buffer(struct crypt_config *
 	if (!clone)
 		return NULL;
 
-	clone->bi_destructor = dm_crypt_bio_destructor;
+	clone_init(io, clone);
 
 	/* if the last bio was not complete, continue where that one ended */
 	clone->bi_idx = *bio_vec_idx;
@@ -562,6 +565,7 @@ static void clone_init(struct crypt_io *
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
 static void process_read(struct crypt_io *io)
@@ -585,7 +589,6 @@ static void process_read(struct crypt_io
 	}
 
 	clone_init(io, clone);
-	clone->bi_destructor = dm_crypt_bio_destructor;
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
 	clone->bi_size = base_bio->bi_size;
@@ -615,7 +618,7 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(cc, base_bio->bi_size,
+		clone = crypt_alloc_buffer(io, base_bio->bi_size,
 					   io->first_clone, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
@@ -631,7 +634,6 @@ static void process_write(struct crypt_i
 			return;
 		}
 
-		clone_init(io, clone);
 		clone->bi_sector = cc->start + sector;
 
 		if (!io->first_clone) {
_

Patches currently in -mm which might be from christophe@saout.de are

dm-call-clone_init-early.patch
dm-do-not-access-the-bio-after-generic_make_request.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
