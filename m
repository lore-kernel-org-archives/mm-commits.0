From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:25 -0700
Message-ID: <5390ca3d.mPGv+LXLIAbdaDSo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaFETvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:25 -0700


The patch titled
     Subject: mm/rmap.c: make page_referenced_one() and try_to_unmap_one() static
has been removed from the -mm tree.  Its filename was
     mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/rmap.c: make page_referenced_one() and try_to_unmap_one() static

KSM was converted to use rmap_walk() and now nobody uses these functions
outside mm/rmap.c.

Let's covert them back to static.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ----
 mm/rmap.c            |    4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN include/linux/rmap.h~mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static
+++ a/include/linux/rmap.h
@@ -183,14 +183,10 @@ static inline void page_dup_rmap(struct
  */
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
-int page_referenced_one(struct page *, struct vm_area_struct *,
-	unsigned long address, void *arg);
 
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
 int try_to_unmap(struct page *, enum ttu_flags flags);
-int try_to_unmap_one(struct page *, struct vm_area_struct *,
-			unsigned long address, void *arg);
 
 /*
  * Called from mm/filemap_xip.c to unmap empty zero page
diff -puN mm/rmap.c~mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static mm/rmap.c
--- a/mm/rmap.c~mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static
+++ a/mm/rmap.c
@@ -671,7 +671,7 @@ struct page_referenced_arg {
 /*
  * arg: page_referenced_arg will be passed
  */
-int page_referenced_one(struct page *page, struct vm_area_struct *vma,
+static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -1114,7 +1114,7 @@ out:
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
-int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
+static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		     unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
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
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

