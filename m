From: akpm@linux-foundation.org
Subject: +
 mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch added
 to -mm tree
Date: Fri, 28 Feb 2014 15:58:59 -0800
Message-ID: <531122c3.GAMfxvyAxxFGrA0R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaB1X7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:59:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, riel@redhat.com, quning@gmail.com, mgorman@suse.de, matthew.r.wilcox@intel.com, david@fromorbit.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,david@fromorbit.com,matthew.r.wilcox@intel.com,mgorman@suse.de,quning@gmail.com,riel@redhat.com,torvalds@linux-foundation.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:58:59 -0800


The patch titled
     Subject: mm: cleanup size checks in filemap_fault() and filemap_map_pages()
has been added to the -mm tree.  Its filename is
     mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1950,11 +1950,11 @@ int filemap_fault(struct vm_area_struct
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
@@ -2003,8 +2003,8 @@ retry_find:
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
@@ -2106,8 +2106,8 @@ repeat:
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
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch

