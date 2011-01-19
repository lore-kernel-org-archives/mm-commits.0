From: akpm@linux-foundation.org
Subject: + fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch added to -mm tree
Date: Tue, 18 Jan 2011 16:54:06 -0800
Message-ID: <201101190054.p0J0s64S016857__36469.5752658465$1295398486$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab1ASAyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 19:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dillowda@ornl.gov, jmoyer@redhat.com, stable@kernel.org


The patch titled
     fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a bio
has been added to the -mm tree.  Its filename is
     fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a bio
From: David Dillow <dillowda@ornl.gov>

When using devices that support max_segments > BIO_MAX_PAGES (256), direct
IO tries to allocate a bio with more pages than allowed, which leads to an
oops in dio_bio_alloc().  Clamp the request to the supported maximum, and
change dio_bio_alloc() to reflect that bio_alloc() will always return a
bio when called with __GFP_WAIT and a valid number of vectors.

Signed-off-by: David Dillow <dillowda@ornl.gov>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/direct-io.c~fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio
+++ a/fs/direct-io.c
@@ -325,13 +325,18 @@ void dio_end_io(struct bio *bio, int err
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static int
+static void
 dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 		sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
 
+	/*
+	 * bio_alloc() is guaranteed to return a bio when called with
+	 * __GFP_WAIT and we request a valid number of vectors.
+	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	BUG_ON(!bio);
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
@@ -342,7 +347,6 @@ dio_bio_alloc(struct dio *dio, struct bl
 
 	dio->bio = bio;
 	dio->logical_offset_in_bio = dio->cur_page_fs_offset;
-	return 0;
 }
 
 /*
@@ -583,8 +587,9 @@ static int dio_new_bio(struct dio *dio, 
 		goto out;
 	sector = start_sector << (dio->blkbits - 9);
 	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
-	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
+	dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
 	dio->boundary = 0;
 out:
 	return ret;
_

Patches currently in -mm which might be from dillowda@ornl.gov are

origin.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio.patch

