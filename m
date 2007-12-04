From: akpm@linux-foundation.org
Subject: + rewrite-rd-fix.patch added to -mm tree
Date: Mon, 03 Dec 2007 23:58:34 -0800
Message-ID: <200712040758.lB47wY11007597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXLDH7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:59:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     rewrite rd (fix)
has been added to the -mm tree.  Its filename is
     rewrite-rd-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rewrite rd (fix)
From: Nick Piggin <npiggin@suse.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/block/brd.c~rewrite-rd-fix drivers/block/brd.c
--- a/drivers/block/brd.c~rewrite-rd-fix
+++ a/drivers/block/brd.c
@@ -56,7 +56,7 @@ struct brd_device {
  */
 static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 {
-	unsigned long idx;
+	pgoff_t idx;
 	struct page *page;
 
 	/*
@@ -87,13 +87,17 @@ static struct page *brd_lookup_page(stru
  */
 static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 {
-	unsigned long idx;
+	pgoff_t idx;
 	struct page *page;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
 		return page;
 
+	/*
+	 * Must use NOIO because we don't want to recurse back into the
+	 * block or filesystem layers from page reclaim.
+	 */
 	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
 	if (!page)
 		return NULL;
@@ -148,6 +152,11 @@ static void brd_free_pages(struct brd_de
 
 		pos++;
 
+		/*
+		 * This assumes radix_tree_gang_lookup always returns as
+		 * many pages as possible. If the radix-tree code changes,
+		 * so will this have to.
+		 */
 	} while (nr_pages == FREE_BATCH);
 }
 
@@ -159,7 +168,7 @@ static int copy_to_brd_setup(struct brd_
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	if (!brd_insert_page(brd, sector))
 		return -ENOMEM;
 	if (copy < n) {
@@ -181,7 +190,7 @@ static void copy_to_brd(struct brd_devic
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
 
@@ -213,7 +222,7 @@ static void copy_from_brd(void *dst, str
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
-	copy = min((unsigned long)n, PAGE_SIZE - offset);
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
 		src = kmap_atomic(page, KM_USER1);
@@ -318,6 +327,9 @@ static int brd_ioctl(struct inode *inode
 		/*
 		 * Invalidate the cache first, so it isn't written
 		 * back to the device.
+		 *
+		 * Another thread might instantiate more buffercache here,
+		 * but there is not much we can do to close that race.
 		 */
 		invalidate_bh_lrus();
 		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
_

Patches currently in -mm which might be from npiggin@suse.de are

git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
reiser4.patch
