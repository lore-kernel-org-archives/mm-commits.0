From: akpm@osdl.org
Subject: + nfs-fix-nr_file_dirty-underflow.patch added to -mm tree
Date: Wed, 13 Dec 2006 17:42:49 -0800
Message-ID: <200612140142.kBE1gnwo028186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbWLNBnA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 20:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix NR_FILE_DIRTY underflow
has been added to the -mm tree.  Its filename is
     nfs-fix-nr_file_dirty-underflow.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: fix NR_FILE_DIRTY underflow
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Delay clearing the dirty page state till after we've invalidated the
page in invalidate_complete_page2(). This gives try_to_release_pages() a
chance to flush dirty data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfs/file.c |    2 --
 mm/truncate.c |   14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN fs/nfs/file.c~nfs-fix-nr_file_dirty-underflow fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-fix-nr_file_dirty-underflow
+++ a/fs/nfs/file.c
@@ -320,8 +320,6 @@ static int nfs_release_page(struct page 
 	 */
 	if (!(gfp & __GFP_FS))
 		return 0;
-	/* Hack... Force nfs_wb_page() to write out the page */
-	SetPageDirty(page);
 	return !nfs_wb_page(page->mapping->host, page);
 }
 
diff -puN mm/truncate.c~nfs-fix-nr_file_dirty-underflow mm/truncate.c
--- a/mm/truncate.c~nfs-fix-nr_file_dirty-underflow
+++ a/mm/truncate.c
@@ -306,19 +306,14 @@ invalidate_complete_page2(struct address
 	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
+	test_clear_page_dirty(page);
 	write_lock_irq(&mapping->tree_lock);
-	if (PageDirty(page))
-		goto failed;
-
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
 	write_unlock_irq(&mapping->tree_lock);
 	ClearPageUptodate(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
-failed:
-	write_unlock_irq(&mapping->tree_lock);
-	return 0;
 }
 
 /**
@@ -350,7 +345,6 @@ int invalidate_inode_pages2_range(struct
 		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index;
-			int was_dirty;
 
 			lock_page(page);
 			if (page->mapping != mapping) {
@@ -386,12 +380,8 @@ int invalidate_inode_pages2_range(struct
 					  PAGE_CACHE_SIZE, 0);
 				}
 			}
-			was_dirty = test_clear_page_dirty(page);
-			if (!invalidate_complete_page2(mapping, page)) {
-				if (was_dirty)
-					set_page_dirty(page);
+			if (!invalidate_complete_page2(mapping, page))
 				ret = -EIO;
-			}
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-export-get_current_tty.patch
uml-fix-net_kern-workqueue-abuse.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-nr_file_dirty-underflow.patch

