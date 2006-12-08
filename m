From: akpm@osdl.org
Subject: - dm-io-fix-bi_max_vecs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:02 -0800
Message-ID: <200612082015.kB8KF2kE003261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946990AbWLHUPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjm@redhat.com, agk@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm io: fix bi_max_vecs
has been removed from the -mm tree.  Its filename was
     dm-io-fix-bi_max_vecs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm io: fix bi_max_vecs
From: Heinz Mauelshagen <hjm@redhat.com>

The existing code allocates an extra slot in bi_io_vec[] and uses it to store
the region number.

This patch hides the extra slot from bio_add_page() so the region number can't
get overwritten.

Also remove a hard-coded SECTOR_SHIFT and fix a typo in a comment.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-io.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/md/dm-io.c~dm-io-fix-bi_max_vecs drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~dm-io-fix-bi_max_vecs
+++ a/drivers/md/dm-io.c
@@ -92,12 +92,12 @@ void dm_io_put(unsigned int num_pages)
  *---------------------------------------------------------------*/
 static inline void bio_set_region(struct bio *bio, unsigned region)
 {
-	bio->bi_io_vec[bio->bi_max_vecs - 1].bv_len = region;
+	bio->bi_io_vec[bio->bi_max_vecs].bv_len = region;
 }
 
 static inline unsigned bio_get_region(struct bio *bio)
 {
-	return bio->bi_io_vec[bio->bi_max_vecs - 1].bv_len;
+	return bio->bi_io_vec[bio->bi_max_vecs].bv_len;
 }
 
 /*-----------------------------------------------------------------
@@ -136,6 +136,7 @@ static int endio(struct bio *bio, unsign
 		zero_fill_bio(bio);
 
 	dec_count(io, bio_get_region(bio), error);
+	bio->bi_max_vecs++;
 	bio_put(bio);
 
 	return 0;
@@ -250,16 +251,18 @@ static void do_region(int rw, unsigned i
 
 	while (remaining) {
 		/*
-		 * Allocate a suitably sized bio, we add an extra
-		 * bvec for bio_get/set_region().
+		 * Allocate a suitably sized-bio: we add an extra
+		 * bvec for bio_get/set_region() and decrement bi_max_vecs
+		 * to hide it from bio_add_page().
 		 */
-		num_bvecs = (remaining / (PAGE_SIZE >> 9)) + 2;
+		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, _bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
 		bio->bi_private = io;
 		bio->bi_destructor = dm_bio_destructor;
+		bio->bi_max_vecs--;
 		bio_set_region(bio, region);
 
 		/*
@@ -302,7 +305,7 @@ static void dispatch_io(int rw, unsigned
 	}
 
 	/*
-	 * Drop the extra refence that we were holding to avoid
+	 * Drop the extra reference that we were holding to avoid
 	 * the io being completed too early.
 	 */
 	dec_count(io, 0, 0);
_

Patches currently in -mm which might be from hjm@redhat.com are

dm-io-fix-bi_max_vecs.patch

