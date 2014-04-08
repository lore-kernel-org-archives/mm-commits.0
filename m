From: akpm@linux-foundation.org
Subject: [merged]
 mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:42:19 -0700
Message-ID: <53445f2b.fEv/YEZvZjjyN7r5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDHUmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, riel@redhat.com, quning@gmail.com, mgorman@suse.de, matthew.r.wilcox@intel.com, david@fromorbit.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,david@fromorbit.com,matthew.r.wilcox@intel.com,mgorman@suse.de,quning@gmail.com,riel@redhat.com,torvalds@linux-foundation.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:42:19 -0700


The patch titled
     Subject: mm: cleanup size checks in filemap_fault() and filemap_map_pages()
has been removed from the -mm tree.  Its filename was
     mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: cleanup size checks in filemap_fault() and filemap_map_pages()

Minor cleanups:
 - 'size' variable is now in bytes, not pages;
 - use round_up(): it should be easier to read.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ning Qu <quning@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/filemap.c~mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages mm/filemap.c
--- a/mm/filemap.c~mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages
+++ a/mm/filemap.c
@@ -1953,11 +1953,11 @@ int filemap_fault(struct vm_area_struct
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
 	struct page *page;
-	pgoff_t size;
+	loff_t size;
 	int ret = 0;
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (offset >= size)
+	size = round_up(i_size_read(inode), PAGE_CACHE_SIZE);
+	if (offset >= size >> PAGE_CACHE_SHIFT)
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -2006,8 +2006,8 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 * We must recheck i_size under page lock.
 	 */
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (unlikely(offset >= size)) {
+	size = round_up(i_size_read(inode), PAGE_CACHE_SIZE);
+	if (unlikely(offset >= size >> PAGE_CACHE_SHIFT)) {
 		unlock_page(page);
 		page_cache_release(page);
 		return VM_FAULT_SIGBUS;
@@ -2111,8 +2111,8 @@ repeat:
 		if (page->mapping != mapping || !PageUptodate(page))
 			goto unlock;
 
-		size = i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1;
-		if (page->index >= size	>> PAGE_CACHE_SHIFT)
+		size = round_up(i_size_read(mapping->host), PAGE_CACHE_SIZE);
+		if (page->index >= size >> PAGE_CACHE_SHIFT)
 			goto unlock;
 
 		pte = vmf->pte + page->index - vmf->pgoff;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

