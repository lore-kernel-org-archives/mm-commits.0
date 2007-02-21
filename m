From: akpm@linux-foundation.org
Subject: - fs-fix-nobh-data-leak.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:09 -0800
Message-ID: <200702211046.l1LAk94E006445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46951 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXBUKqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix nobh data leak
has been removed from the -mm tree.  Its filename was
     fs-fix-nobh-data-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix nobh data leak
From: Nick Piggin <npiggin@suse.de>

nobh_prepare_write leaks data similarly to how simple_prepare_write did. Fix
by not marking the page uptodate until nobh_commit_write time. Again, this
could break weird use-cases, but none appear to exist in the tree.

We can safely remove the set_page_dirty, because as the comment says,
nobh_commit_write does set_page_dirty. If a filesystem wants to allocate
backing store for a page dirtied via mmap, page_mkwrite is the suggested
approach.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~fs-fix-nobh-data-leak fs/buffer.c
--- a/fs/buffer.c~fs-fix-nobh-data-leak
+++ a/fs/buffer.c
@@ -2248,7 +2248,6 @@ int nobh_prepare_write(struct page *page
 	int i;
 	int ret = 0;
 	int is_mapped_to_disk = 1;
-	int dirtied_it = 0;
 
 	if (PageMappedToDisk(page))
 		return 0;
@@ -2285,14 +2284,10 @@ int nobh_prepare_write(struct page *page
 			continue;
 		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
 			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_start < from) {
+			if (block_start < from)
 				memset(kaddr+block_start, 0, from-block_start);
-				dirtied_it = 1;
-			}
-			if (block_end > to) {
+			if (block_end > to)
 				memset(kaddr + to, 0, block_end - to);
-				dirtied_it = 1;
-			}
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 			continue;
@@ -2347,17 +2342,6 @@ int nobh_prepare_write(struct page *page
 
 	if (is_mapped_to_disk)
 		SetPageMappedToDisk(page);
-	SetPageUptodate(page);
-
-	/*
-	 * Setting the page dirty here isn't necessary for the prepare_write
-	 * function - commit_write will do that.  But if/when this function is
-	 * used within the pagefault handler to ensure that all mmapped pages
-	 * have backing space in the filesystem, we will need to dirty the page
-	 * if its contents were altered.
-	 */
-	if (dirtied_it)
-		set_page_dirty(page);
 
 	return 0;
 
@@ -2387,6 +2371,7 @@ int nobh_commit_write(struct file *file,
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
