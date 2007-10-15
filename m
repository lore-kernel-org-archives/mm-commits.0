From: akpm@linux-foundation.org
Subject: + reiser4-drop-size-argument-from-bio_endio-and-bi_end_io.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:49:42 -0700
Message-ID: <200710152249.l9FMngEO029318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXJOWuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laurent.riffard@free.fr, edward@namesys.com, jens.axboe@oracle.com


The patch titled
     Reiser4: Drop 'size' argument from bio_endio and bi_end_io
has been added to the -mm tree.  Its filename is
     reiser4-drop-size-argument-from-bio_endio-and-bi_end_io.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Reiser4: Drop 'size' argument from bio_endio and bi_end_io
From: Laurent Riffard <laurent.riffard@free.fr>

Reiser4: Drop 'size' argument from bio_endio and bi_end_io

This patch pushes into Reiser4 the changes introduced by
commit 6712ecf8f648118c3363c142196418f89a510b90:

	As bi_end_io is only called once when the request is complete,
	the 'size' argument is now redundant.  Remove it.

	Now there is no need for bio_endio to subtract the size completed
	from bi_size.  So don't do that either.

	While we are at it, change bi_end_io to return void.

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/flush_queue.c  |   10 ++--------
 fs/reiser4/page_cache.c   |   24 ++++--------------------
 fs/reiser4/status_flags.c |    7 +------
 3 files changed, 7 insertions(+), 34 deletions(-)

diff -puN fs/reiser4/flush_queue.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io
+++ a/fs/reiser4/flush_queue.c
@@ -391,9 +391,8 @@ int atom_fq_parts_are_clean(txn_atom * a
 }
 #endif
 /* Bio i/o completion routine for reiser4 write operations. */
-static int
-end_io_handler(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-	       int err)
+static void
+end_io_handler(struct bio *bio, int err)
 {
 	int i;
 	int nr_errors = 0;
@@ -401,10 +400,6 @@ end_io_handler(struct bio *bio, unsigned
 
 	assert("zam-958", bio->bi_rw & WRITE);
 
-	/* i/o op. is not fully completed */
-	if (bio->bi_size != 0)
-		return 1;
-
 	if (err == -EOPNOTSUPP)
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 
@@ -447,7 +442,6 @@ end_io_handler(struct bio *bio, unsigned
 	}
 
 	bio_put(bio);
-	return 0;
 }
 
 /* Count I/O requests which will be submitted by @bio in given flush queues
diff -puN fs/reiser4/page_cache.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io
+++ a/fs/reiser4/page_cache.c
@@ -320,18 +320,11 @@ reiser4_tree *reiser4_tree_by_page(const
    mpage_end_io_read() would also do. But it's static.
 
 */
-static int
-end_bio_single_page_read(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-			 int err UNUSED_ARG)
+static void
+end_bio_single_page_read(struct bio *bio, int err UNUSED_ARG)
 {
 	struct page *page;
 
-	if (bio->bi_size != 0) {
-		warning("nikita-3332", "Truncated single page read: %i",
-			bio->bi_size);
-		return 1;
-	}
-
 	page = bio->bi_io_vec[0].bv_page;
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
@@ -342,7 +335,6 @@ end_bio_single_page_read(struct bio *bio
 	}
 	unlock_page(page);
 	bio_put(bio);
-	return 0;
 }
 
 /* completion handler for single page bio-based write.
@@ -350,25 +342,17 @@ end_bio_single_page_read(struct bio *bio
    mpage_end_io_write() would also do. But it's static.
 
 */
-static int
-end_bio_single_page_write(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-			  int err UNUSED_ARG)
+static void
+end_bio_single_page_write(struct bio *bio, int err UNUSED_ARG)
 {
 	struct page *page;
 
-	if (bio->bi_size != 0) {
-		warning("nikita-3333", "Truncated single page write: %i",
-			bio->bi_size);
-		return 1;
-	}
-
 	page = bio->bi_io_vec[0].bv_page;
 
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		SetPageError(page);
 	end_page_writeback(page);
 	bio_put(bio);
-	return 0;
 }
 
 /* ->readpage() method for formatted nodes */
diff -puN fs/reiser4/status_flags.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io fs/reiser4/status_flags.c
--- a/fs/reiser4/status_flags.c~reiser4-drop-size-argument-from-bio_endio-and-bi_end_io
+++ a/fs/reiser4/status_flags.c
@@ -15,12 +15,8 @@
 /* This is our end I/O handler that marks page uptodate if IO was successful. It also
    unconditionally unlocks the page, so we can see that io was done.
    We do not free bio, because we hope to reuse that. */
-static int reiser4_status_endio(struct bio *bio, unsigned int bytes_done,
-				int err)
+static void reiser4_status_endio(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		SetPageUptodate(bio->bi_io_vec->bv_page);
 	} else {
@@ -28,7 +24,6 @@ static int reiser4_status_endio(struct b
 		SetPageError(bio->bi_io_vec->bv_page);
 	}
 	unlock_page(bio->bi_io_vec->bv_page);
-	return 0;
 }
 
 /* Initialise status code. This is expected to be called from the disk format
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

git-block.patch
r-o-bind-mounts-elevate-write-count-opend-files-reiserfs-fix.patch
reiser4-drop-size-argument-from-bio_endio-and-bi_end_io.patch
