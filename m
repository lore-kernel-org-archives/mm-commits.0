From: akpm@linux-foundation.org
Subject: [merged] z3fold-fix-header-size-related-issues.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:25:36 -0800
Message-ID: <58b48b40.uB5gvNONz7hkamgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752033AbdB0U5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:57:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: fix header size related issues
has been removed from the -mm tree.  Its filename was
     z3fold-fix-header-size-related-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Link: http://lkml.kernel.org/r/20170131214057.d98677032bc7b1c6c59a80c9@gmail.com
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |  114 ++++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 50 deletions(-)

diff -puN mm/z3fold.c~z3fold-fix-header-size-related-issues mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-header-size-related-issues
+++ a/mm/z3fold.c
@@ -34,29 +34,58 @@
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
+ * @first_chunks:	the size of the first buddy in chunks, 0 if free
+ * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
+ * @last_chunks:	the size of the last buddy in chunks, 0 if free
+ * @first_num:		the starting number (for the first handle)
+ */
+struct z3fold_header {
+	struct list_head buddy;
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
@@ -86,32 +115,6 @@ struct z3fold_pool {
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
- * @first_chunks:	the size of the first buddy in chunks, 0 if free
- * @middle_chunks:	the size of the middle buddy in chunks, 0 if free
- * @last_chunks:	the size of the last buddy in chunks, 0 if free
- * @first_num:		the starting number (for the first handle)
- */
-struct z3fold_header {
-	struct list_head buddy;
-	unsigned short first_chunks;
-	unsigned short middle_chunks;
-	unsigned short last_chunks;
-	unsigned short start_middle;
-	unsigned short first_num:2;
-};
-
 /*
  * Internal z3fold page flags
  */
@@ -121,6 +124,7 @@ enum z3fold_page_flags {
 	MIDDLE_CHUNK_MAPPED,
 };
 
+
 /*****************
  * Helpers
 *****************/
@@ -204,9 +208,10 @@ static int num_free_chunks(struct z3fold
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
@@ -254,26 +259,35 @@ static void z3fold_destroy_pool(struct z
 	kfree(pool);
 }
 
+static inline void *mchunk_memmove(struct z3fold_header *zhdr,
+				unsigned short dst_chunk)
+{
+	void *beg = zhdr;
+	return memmove(beg + (dst_chunk << CHUNK_SHIFT),
+		       beg + (zhdr->start_middle << CHUNK_SHIFT),
+		       zhdr->middle_chunks << CHUNK_SHIFT);
+}
+
 /* Has to be called with lock held */
 static int z3fold_compact_page(struct z3fold_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
-	void *beg = zhdr;
 
+	if (test_bit(MIDDLE_CHUNK_MAPPED, &page->private))
+		return 0; /* can't move middle chunk, it's used */
 
-	if (!test_bit(MIDDLE_CHUNK_MAPPED, &page->private) &&
-	    zhdr->middle_chunks != 0 &&
-	    zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-		memmove(beg + ZHDR_SIZE_ALIGNED,
-			beg + (zhdr->start_middle << CHUNK_SHIFT),
-			zhdr->middle_chunks << CHUNK_SHIFT);
+	if (zhdr->middle_chunks == 0)
+		return 0; /* nothing to compact */
+
+	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
+		/* move to the beginning */
+		mchunk_memmove(zhdr, ZHDR_CHUNKS);
 		zhdr->first_chunks = zhdr->middle_chunks;
 		zhdr->middle_chunks = 0;
 		zhdr->start_middle = 0;
 		zhdr->first_num++;
-		return 1;
 	}
-	return 0;
+	return 1;
 }
 
 /**
@@ -365,7 +379,7 @@ found:
 		zhdr->last_chunks = chunks;
 	else {
 		zhdr->middle_chunks = chunks;
-		zhdr->start_middle = zhdr->first_chunks + 1;
+		zhdr->start_middle = zhdr->first_chunks + ZHDR_CHUNKS;
 	}
 
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0 ||
@@ -778,8 +792,8 @@ MODULE_ALIAS("zpool-z3fold");
 
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


