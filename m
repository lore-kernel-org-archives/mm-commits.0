From: akpm@linux-foundation.org
Subject: [merged] fs-mpagec-consolidate-code.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:43 -0800
Message-ID: <201101142247.p0EMlXdR005012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haishan.bai@gmail.com, shan.hai@windriver.com, mm-commits@vger.kernel.org


The patch titled
     fs/mpage.c: consolidate code
has been removed from the -mm tree.  Its filename was
     fs-mpagec-consolidate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/mpage.c: consolidate code
From: Hai Shan <haishan.bai@gmail.com>

Merge mpage_end_io_read() and mpage_end_io_write() into mpage_end_io() to
eliminate code duplication.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hai Shan <shan.hai@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   49 +++++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff -puN fs/mpage.c~fs-mpagec-consolidate-code fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-consolidate-code
+++ a/fs/mpage.c
@@ -40,7 +40,7 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io_read(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -50,44 +50,29 @@ static void mpage_end_io_read(struct bio
 
 		if (--bvec >= bio->bi_io_vec)
 			prefetchw(&bvec->bv_page->flags);
-
-		if (uptodate) {
-			SetPageUptodate(page);
-		} else {
-			ClearPageUptodate(page);
-			SetPageError(page);
-		}
-		unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
-	bio_put(bio);
-}
-
-static void mpage_end_io_write(struct bio *bio, int err)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-
-	do {
-		struct page *page = bvec->bv_page;
-
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (!uptodate){
-			SetPageError(page);
-			if (page->mapping)
-				set_bit(AS_EIO, &page->mapping->flags);
+		if (bio_data_dir(bio) == READ) {
+			if (uptodate) {
+				SetPageUptodate(page);
+			} else {
+				ClearPageUptodate(page);
+				SetPageError(page);
+			}
+			unlock_page(page);
+		} else { /* bio_data_dir(bio) == WRITE */
+			if (!uptodate) {
+				SetPageError(page);
+				if (page->mapping)
+					set_bit(AS_EIO, &page->mapping->flags);
+			}
+			end_page_writeback(page);
 		}
-		end_page_writeback(page);
 	} while (bvec >= bio->bi_io_vec);
 	bio_put(bio);
 }
 
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
-	bio->bi_end_io = mpage_end_io_read;
-	if (rw == WRITE)
-		bio->bi_end_io = mpage_end_io_write;
+	bio->bi_end_io = mpage_end_io;
 	submit_bio(rw, bio);
 	return NULL;
 }
_

Patches currently in -mm which might be from haishan.bai@gmail.com are

origin.patch

