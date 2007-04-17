From: akpm@linux-foundation.org
Subject: - dm-get-rid-of-first_clone-in-dm-crypt.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:17:20 -0700
Message-ID: <200704170517.l3H5HKV4020997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbXDQFRu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf.kirch@oracle.com, agk@redhat.com, christophe@saout.de, mm-commits@vger.kernel.org


The patch titled
     dm: get rid of first_clone in dm-crypt
has been removed from the -mm tree.  Its filename was
     dm-get-rid-of-first_clone-in-dm-crypt.patch

This patch was dropped because changes in the dm tree broke it

------------------------------------------------------
Subject: dm: get rid of first_clone in dm-crypt
From: Olaf Kirch <olaf.kirch@oracle.com>

This gets rid of first_clone, which is not really needed.  Apparently, cloned
bios used to share their bvec some time way in the past - this is no longer
the case.  Contrarily, this even hurts us if we try to create a clone off
first_clone after it has completed, and crypt_endio has destroyed its bvec.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Acked-by: Christophe Saout <christophe@saout.de>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff -puN drivers/md/dm-crypt.c~dm-get-rid-of-first_clone-in-dm-crypt drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-get-rid-of-first_clone-in-dm-crypt
+++ a/drivers/md/dm-crypt.c
@@ -33,7 +33,6 @@
 struct crypt_io {
 	struct dm_target *target;
 	struct bio *base_bio;
-	struct bio *first_clone;
 	struct work_struct work;
 	atomic_t pending;
 	int error;
@@ -395,8 +394,7 @@ static int crypt_convert(struct crypt_co
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
-                   struct bio *base_bio, unsigned int *bio_vec_idx)
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size, unsigned int *bio_vec_idx)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -404,12 +402,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
 	unsigned int i;
 
-	if (base_bio) {
-		clone = bio_alloc_bioset(GFP_NOIO, base_bio->bi_max_vecs, cc->bs);
-		__bio_clone(clone, base_bio);
-	} else
-		clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
-
+	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
 		return NULL;
 
@@ -512,9 +505,6 @@ static void dec_pending(struct crypt_io 
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	if (io->first_clone)
-		bio_put(io->first_clone);
-
 	bio_endio(io->base_bio, io->base_bio->bi_size, io->error);
 
 	mempool_free(io, cc->io_pool);
@@ -632,8 +622,7 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(io, base_bio->bi_size,
-					   io->first_clone, &bvec_idx);
+		clone = crypt_alloc_buffer(io, base_bio->bi_size, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
@@ -649,21 +638,11 @@ static void process_write(struct crypt_i
 		}
 
 		clone->bi_sector = cc->start + sector;
-
-		if (!io->first_clone) {
-			/*
-			 * hold a reference to the first clone, because it
-			 * holds the bio_vec array and that can't be freed
-			 * before all other clones are released
-			 */
-			bio_get(clone);
-			io->first_clone = clone;
-		}
-
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
 
-		/* prevent bio_put of first_clone */
+		/* Grab another reference to the io struct
+		 * before we kick off the request */
 		if (remaining)
 			atomic_inc(&io->pending);
 
@@ -981,7 +960,6 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->first_clone = NULL;
 	io->error = io->post_process = 0;
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);
_

Patches currently in -mm which might be from olaf.kirch@oracle.com are

origin.patch
dm-get-rid-of-first_clone-in-dm-crypt.patch
dm-allocate-smaller-clones.patch
