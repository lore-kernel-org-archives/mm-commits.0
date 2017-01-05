From: akpm@linux-foundation.org
Subject: [to-be-updated] z3fold-fix-header-size-related-issues.patch
 removed from -mm tree
Date: Wed, 04 Jan 2017 17:27:38 -0800
Message-ID: <586da10a.9mtjViq4sD8gRIFd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967686AbdAECWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 21:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, arnd@arndb.de, dan.carpenter@oracle.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: fix header size related issues
has been removed from the -mm tree.  Its filename was
     z3fold-fix-header-size-related-issues.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix header size related issues

Currently the whole kernel build will be stopped if the size of struct
z3fold_header is greater than the size of one chunk, which is 64 bytes by
default.  This patch instead defines the offset for z3fold objects as the
size of the z3fold header in chunks.

Fixed also are the calculation of num_free_chunks() and the address to
move the middle chunk to in case of in-page compaction in
z3fold_compact_page().

This patch is to be applied on top of commit 570931c ("z3fold: use
per-page spinlock"), substituting commit 50a50d2 ("z3fold: don't fail
kernel build is z3fold_header is too big").

Link: http://lkml.kernel.org/r/20161126201735.d0577eedf81c64498a22d998@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  161 +++++++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 74 deletions(-)

diff -puN mm/z3fold.c~z3fold-fix-header-size-related-issues mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-header-size-related-issues
+++ a/mm/z3fold.c
@@ -34,29 +34,60 @@
 /*****************
  * Structures
 *****************/
+struct z3fold_pool;
+struct z3fold_ops {
+	int (*evict)(struct z3fold_pool *pool, unsigned long handle);
+};
+
+enum buddy {
+	HEADLESS = 0,
+	FIRST,
+	MIDDLE,
+	LAST,
+	BUDDIES_MAX
+};
+
+/*
+ * struct z3fold_header - z3fold page metadata occupying the first chunk of each
+ *			z3fold page, except for HEADLESS pages
+ * @buddy:	links the z3fold page into the relevant list in the pool
+ * @page_lock:		per-page lock
+ * @first_chunks:	the size of the first buddy in chunks, 0 if free
+ * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
+ * @last_chunks:	the size of the last buddy in chunks, 0 if free
+ * @first_num:		the starting number (for the first handle)
+ */
+struct z3fold_header {
+	struct list_head buddy;
+	raw_spinlock_t page_lock;
+	unsigned short first_chunks;
+	unsigned short middle_chunks;
+	unsigned short last_chunks;
+	unsigned short start_middle;
+	unsigned short first_num:2;
+};
+
 /*
  * NCHUNKS_ORDER determines the internal allocation granularity, effectively
  * adjusting internal fragmentation.  It also determines the number of
  * freelists maintained in each pool. NCHUNKS_ORDER of 6 means that the
- * allocation granularity will be in chunks of size PAGE_SIZE/64. As one chunk
- * in allocated page is occupied by z3fold header, NCHUNKS will be calculated
- * to 63 which shows the max number of free chunks in z3fold page, also there
- * will be 63 freelists per pool.
+ * allocation granularity will be in chunks of size PAGE_SIZE/64. Some chunks
+ * in the beginning of an allocated page are occupied by z3fold header, so
+ * NCHUNKS will be calculated to 63 (or 62 in case CONFIG_DEBUG_SPINLOCK=y),
+ * which shows the max number of free chunks in z3fold page, also there will
+ * be 63, or 62, respectively, freelists per pool.
  */
 #define NCHUNKS_ORDER	6
 
 #define CHUNK_SHIFT	(PAGE_SHIFT - NCHUNKS_ORDER)
 #define CHUNK_SIZE	(1 << CHUNK_SHIFT)
-#define ZHDR_SIZE_ALIGNED CHUNK_SIZE
+#define ZHDR_SIZE_ALIGNED round_up(sizeof(struct z3fold_header), CHUNK_SIZE)
+#define ZHDR_CHUNKS	(ZHDR_SIZE_ALIGNED >> CHUNK_SHIFT)
+#define TOTAL_CHUNKS	(PAGE_SIZE >> CHUNK_SHIFT)
 #define NCHUNKS		((PAGE_SIZE - ZHDR_SIZE_ALIGNED) >> CHUNK_SHIFT)
 
 #define BUDDY_MASK	(0x3)
 
-struct z3fold_pool;
-struct z3fold_ops {
-	int (*evict)(struct z3fold_pool *pool, unsigned long handle);
-};
-
 /**
  * struct z3fold_pool - stores metadata for each z3fold pool
  * @lock:	protects all pool fields and first|last_chunk fields of any
@@ -86,33 +117,6 @@ struct z3fold_pool {
 	const struct zpool_ops *zpool_ops;
 };
 
-enum buddy {
-	HEADLESS = 0,
-	FIRST,
-	MIDDLE,
-	LAST,
-	BUDDIES_MAX
-};
-
-/*
- * struct z3fold_header - z3fold page metadata occupying the first chunk of each
- *			z3fold page, except for HEADLESS pages
- * @buddy:	links the z3fold page into the relevant list in the pool
- * @page_lock:		per-page lock
- * @first_chunks:	the size of the first buddy in chunks, 0 if free
- * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
- * @last_chunks:	the size of the last buddy in chunks, 0 if free
- * @first_num:		the starting number (for the first handle)
- */
-struct z3fold_header {
-	struct list_head buddy;
-	raw_spinlock_t page_lock;
-	unsigned short first_chunks;
-	unsigned short middle_chunks;
-	unsigned short last_chunks;
-	unsigned short start_middle;
-	unsigned short first_num:2;
-};
 
 /*
  * Internal z3fold page flags
@@ -123,6 +127,7 @@ enum z3fold_page_flags {
 	MIDDLE_CHUNK_MAPPED,
 };
 
+
 /*****************
  * Helpers
 *****************/
@@ -220,9 +225,10 @@ static int num_free_chunks(struct z3fold
 	 */
 	if (zhdr->middle_chunks != 0) {
 		int nfree_before = zhdr->first_chunks ?
-			0 : zhdr->start_middle - 1;
+			0 : zhdr->start_middle - ZHDR_CHUNKS;
 		int nfree_after = zhdr->last_chunks ?
-			0 : NCHUNKS - zhdr->start_middle - zhdr->middle_chunks;
+			0 : TOTAL_CHUNKS -
+				(zhdr->start_middle + zhdr->middle_chunks);
 		nfree = max(nfree_before, nfree_after);
 	} else
 		nfree = NCHUNKS - zhdr->first_chunks - zhdr->last_chunks;
@@ -287,40 +293,47 @@ static int z3fold_compact_page(struct z3
 	int ret = 0;
 
 	if (test_bit(MIDDLE_CHUNK_MAPPED, &page->private))
-		goto out;
+		goto out; /* can't move middle chunk, it's used */
 
-	if (zhdr->middle_chunks != 0) {
-		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-			mchunk_memmove(zhdr, 1); /* move to the beginning */
-			zhdr->first_chunks = zhdr->middle_chunks;
-			zhdr->middle_chunks = 0;
-			zhdr->start_middle = 0;
-			zhdr->first_num++;
-			ret = 1;
-			goto out;
-		}
+	if (zhdr->middle_chunks == 0)
+		goto out; /* nothing to compact */
 
-		/*
-		 * moving data is expensive, so let's only do that if
-		 * there's substantial gain (at least BIG_CHUNK_GAP chunks)
-		 */
-		if (zhdr->first_chunks != 0 && zhdr->last_chunks == 0 &&
-		    zhdr->start_middle > zhdr->first_chunks + BIG_CHUNK_GAP) {
-			mchunk_memmove(zhdr, zhdr->first_chunks + 1);
-			zhdr->start_middle = zhdr->first_chunks + 1;
-			ret = 1;
-			goto out;
-		}
-		if (zhdr->last_chunks != 0 && zhdr->first_chunks == 0 &&
-		    zhdr->middle_chunks + zhdr->last_chunks <=
-		    NCHUNKS - zhdr->start_middle - BIG_CHUNK_GAP) {
-			unsigned short new_start = NCHUNKS - zhdr->last_chunks -
-				zhdr->middle_chunks;
-			mchunk_memmove(zhdr, new_start);
-			zhdr->start_middle = new_start;
-			ret = 1;
-			goto out;
-		}
+	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+		/* move to the beginning */
+		mchunk_memmove(zhdr, ZHDR_CHUNKS);
+		zhdr->first_chunks = zhdr->middle_chunks;
+		zhdr->middle_chunks = 0;
+		zhdr->start_middle = 0;
+		zhdr->first_num++;
+		ret = 1;
+		goto out;
+	}
+
+	/*
+	 * moving data is expensive, so let's only do that if
+	 * there's substantial gain (at least BIG_CHUNK_GAP chunks)
+	 */
+	if (zhdr->first_chunks != 0 && zhdr->last_chunks == 0 &&
+	    zhdr->start_middle - (zhdr->first_chunks + ZHDR_CHUNKS) >=
+	    BIG_CHUNK_GAP) {
+		/* new_start: right after 1st chunk */
+		unsigned short new_start = zhdr->first_chunks + ZHDR_CHUNKS;
+		mchunk_memmove(zhdr, new_start);
+		zhdr->start_middle = new_start;
+		ret = 1;
+		goto out;
+	}
+	if (zhdr->last_chunks != 0 && zhdr->first_chunks == 0 &&
+	    TOTAL_CHUNKS -
+	    (zhdr->last_chunks + zhdr->start_middle + zhdr->middle_chunks) >=
+	    BIG_CHUNK_GAP) {
+		/* new_start: right before last chunk */
+		unsigned short new_start = TOTAL_CHUNKS -
+			(zhdr->last_chunks + zhdr->middle_chunks);
+		mchunk_memmove(zhdr, new_start);
+		zhdr->start_middle = new_start;
+		ret = 1;
+		goto out;
 	}
 out:
 	return ret;
@@ -425,7 +438,7 @@ found:
 		zhdr->last_chunks = chunks;
 	else {
 		zhdr->middle_chunks = chunks;
-		zhdr->start_middle = zhdr->first_chunks + 1;
+		zhdr->start_middle = zhdr->first_chunks + ZHDR_CHUNKS;
 	}
 
 	spin_lock(&pool->lock);
@@ -882,8 +895,8 @@ MODULE_ALIAS("zpool-z3fold");
 
 static int __init init_z3fold(void)
 {
-	/* Make sure the z3fold header will fit in one chunk */
-	BUILD_BUG_ON(sizeof(struct z3fold_header) > ZHDR_SIZE_ALIGNED);
+	/* Make sure the z3fold header is not larger than the page size */
+	BUILD_BUG_ON(ZHDR_SIZE_ALIGNED > PAGE_SIZE);
 	zpool_register_driver(&z3fold_zpool_driver);
 
 	return 0;
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-fix-locking-issues.patch

