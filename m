From: akpm@linux-foundation.org
Subject: + fs-fix-nobh-data-leak.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:46:38 -0800
Message-ID: <200702150546.l1F5kcMR021194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXBOFqm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: fix nobh data leak
has been added to the -mm tree.  Its filename is
     fs-fix-nobh-data-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2241,7 +2241,6 @@ int nobh_prepare_write(struct page *page
 	int i;
 	int ret = 0;
 	int is_mapped_to_disk = 1;
-	int dirtied_it = 0;
 
 	if (PageMappedToDisk(page))
 		return 0;
@@ -2278,14 +2277,10 @@ int nobh_prepare_write(struct page *page
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
@@ -2340,17 +2335,6 @@ int nobh_prepare_write(struct page *page
 
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
 
@@ -2380,6 +2364,7 @@ int nobh_commit_write(struct file *file,
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (pos > inode->i_size) {
 		i_size_write(inode, pos);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mincore-config_swap=n-fix.patch
mincore-fill-in-results-properly.patch
mincore-vma-crossing-fix.patch
git-block.patch
mm-remove-gcc-workaround.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
fs-fix-libfs-data-leak.patch
fs-fix-nobh-data-leak.patch
