From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-__get_user_pages.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:20 -0700
Message-ID: <5390ca38.XnI3s0QNlHHe5HyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaFETvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-cleanup-__get_user_pages.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:20 -0700


The patch titled
     Subject: mm: cleanup __get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-cleanup-__get_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: cleanup __get_user_pages()

Get rid of two nested loops over nr_pages, extract vma flags checking to
separate function and other random cleanups.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  218 ++++++++++++++++++++++++++---------------------------
 1 file changed, 107 insertions(+), 111 deletions(-)

diff -puN mm/gup.c~mm-cleanup-__get_user_pages mm/gup.c
--- a/mm/gup.c~mm-cleanup-__get_user_pages
+++ a/mm/gup.c
@@ -315,6 +315,44 @@ static int faultin_page(struct task_stru
 	return 0;
 }
 
+static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
+{
+	vm_flags_t vm_flags = vma->vm_flags;
+
+	if (vm_flags & (VM_IO | VM_PFNMAP))
+		return -EFAULT;
+
+	if (gup_flags & FOLL_WRITE) {
+		if (!(vm_flags & VM_WRITE)) {
+			if (!(gup_flags & FOLL_FORCE))
+				return -EFAULT;
+			/*
+			 * We used to let the write,force case do COW in a
+			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
+			 * set a breakpoint in a read-only mapping of an
+			 * executable, without corrupting the file (yet only
+			 * when that file had been opened for writing!).
+			 * Anon pages in shared mappings are surprising: now
+			 * just reject it.
+			 */
+			if (!is_cow_mapping(vm_flags)) {
+				WARN_ON_ONCE(vm_flags & VM_MAYWRITE);
+				return -EFAULT;
+			}
+		}
+	} else if (!(vm_flags & VM_READ)) {
+		if (!(gup_flags & FOLL_FORCE))
+			return -EFAULT;
+		/*
+		 * Is there actually any vma we can reach here which does not
+		 * have VM_MAYREAD set?
+		 */
+		if (!(vm_flags & VM_MAYREAD))
+			return -EFAULT;
+	}
+	return 0;
+}
+
 /**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
@@ -369,9 +407,9 @@ long __get_user_pages(struct task_struct
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *nonblocking)
 {
-	long i;
-	unsigned long vm_flags;
+	long i = 0;
 	unsigned int page_mask;
+	struct vm_area_struct *vma = NULL;
 
 	if (!nr_pages)
 		return 0;
@@ -386,124 +424,82 @@ long __get_user_pages(struct task_struct
 	if (!(gup_flags & FOLL_FORCE))
 		gup_flags |= FOLL_NUMA;
 
-	i = 0;
-
 	do {
-		struct vm_area_struct *vma;
-
-		vma = find_extend_vma(mm, start);
-		if (!vma && in_gate_area(mm, start)) {
-			int ret;
-			ret = get_gate_page(mm, start & PAGE_MASK, gup_flags,
-					&vma, pages ? &pages[i] : NULL);
-			if (ret)
-				goto efault;
-			page_mask = 0;
-			goto next_page;
-		}
+		struct page *page;
+		unsigned int foll_flags = gup_flags;
+		unsigned int page_increm;
+
+		/* first iteration or cross vma bound */
+		if (!vma || start >= vma->vm_end) {
+			vma = find_extend_vma(mm, start);
+			if (!vma && in_gate_area(mm, start)) {
+				int ret;
+				ret = get_gate_page(mm, start & PAGE_MASK,
+						gup_flags, &vma,
+						pages ? &pages[i] : NULL);
+				if (ret)
+					return i ? : ret;
+				page_mask = 0;
+				goto next_page;
+			}
 
-		if (!vma)
-			goto efault;
-		vm_flags = vma->vm_flags;
-		if (vm_flags & (VM_IO | VM_PFNMAP))
-			goto efault;
-
-		if (gup_flags & FOLL_WRITE) {
-			if (!(vm_flags & VM_WRITE)) {
-				if (!(gup_flags & FOLL_FORCE))
-					goto efault;
-				/*
-				 * We used to let the write,force case do COW
-				 * in a VM_MAYWRITE VM_SHARED !VM_WRITE vma, so
-				 * ptrace could set a breakpoint in a read-only
-				 * mapping of an executable, without corrupting
-				 * the file (yet only when that file had been
-				 * opened for writing!).  Anon pages in shared
-				 * mappings are surprising: now just reject it.
-				 */
-				if (!is_cow_mapping(vm_flags)) {
-					WARN_ON_ONCE(vm_flags & VM_MAYWRITE);
-					goto efault;
-				}
+			if (!vma || check_vma_flags(vma, gup_flags))
+				return i ? : -EFAULT;
+			if (is_vm_hugetlb_page(vma)) {
+				i = follow_hugetlb_page(mm, vma, pages, vmas,
+						&start, &nr_pages, i,
+						gup_flags);
+				continue;
 			}
-		} else {
-			if (!(vm_flags & VM_READ)) {
-				if (!(gup_flags & FOLL_FORCE))
-					goto efault;
-				/*
-				 * Is there actually any vma we can reach here
-				 * which does not have VM_MAYREAD set?
-				 */
-				if (!(vm_flags & VM_MAYREAD))
-					goto efault;
+		}
+retry:
+		/*
+		 * If we have a pending SIGKILL, don't keep faulting pages and
+		 * potentially allocating memory.
+		 */
+		if (unlikely(fatal_signal_pending(current)))
+			return i ? i : -ERESTARTSYS;
+		cond_resched();
+		page = follow_page_mask(vma, start, foll_flags, &page_mask);
+		if (!page) {
+			int ret;
+			ret = faultin_page(tsk, vma, start, &foll_flags,
+					nonblocking);
+			switch (ret) {
+			case 0:
+				goto retry;
+			case -EFAULT:
+			case -ENOMEM:
+			case -EHWPOISON:
+				return i ? i : ret;
+			case -EBUSY:
+				return i;
+			case -ENOENT:
+				goto next_page;
 			}
+			BUG();
 		}
-
-		if (is_vm_hugetlb_page(vma)) {
-			i = follow_hugetlb_page(mm, vma, pages, vmas,
-					&start, &nr_pages, i, gup_flags);
-			continue;
+		if (IS_ERR(page))
+			return i ? i : PTR_ERR(page);
+		if (pages) {
+			pages[i] = page;
+			flush_anon_page(vma, page, start);
+			flush_dcache_page(page);
+			page_mask = 0;
 		}
-
-		do {
-			struct page *page;
-			unsigned int foll_flags = gup_flags;
-			unsigned int page_increm;
-
-			/*
-			 * If we have a pending SIGKILL, don't keep faulting
-			 * pages and potentially allocating memory.
-			 */
-			if (unlikely(fatal_signal_pending(current)))
-				return i ? i : -ERESTARTSYS;
-
-			cond_resched();
-			while (!(page = follow_page_mask(vma, start,
-						foll_flags, &page_mask))) {
-				int ret;
-				ret = faultin_page(tsk, vma, start, &foll_flags,
-						nonblocking);
-				switch (ret) {
-				case 0:
-					break;
-				case -EFAULT:
-				case -ENOMEM:
-				case -EHWPOISON:
-					return i ? i : ret;
-				case -EBUSY:
-					return i;
-				case -ENOENT:
-					goto next_page;
-				default:
-					BUG();
-				}
-				cond_resched();
-			}
-			if (IS_ERR(page))
-				return i ? i : PTR_ERR(page);
-			if (pages) {
-				pages[i] = page;
-
-				flush_anon_page(vma, page, start);
-				flush_dcache_page(page);
-				page_mask = 0;
-			}
 next_page:
-			if (vmas) {
-				vmas[i] = vma;
-				page_mask = 0;
-			}
-			page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
-			if (page_increm > nr_pages)
-				page_increm = nr_pages;
-			i += page_increm;
-			start += page_increm * PAGE_SIZE;
-			nr_pages -= page_increm;
-		} while (nr_pages && start < vma->vm_end);
+		if (vmas) {
+			vmas[i] = vma;
+			page_mask = 0;
+		}
+		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+		if (page_increm > nr_pages)
+			page_increm = nr_pages;
+		i += page_increm;
+		start += page_increm * PAGE_SIZE;
+		nr_pages -= page_increm;
 	} while (nr_pages);
 	return i;
-efault:
-	return i ? : -EFAULT;
 }
 EXPORT_SYMBOL(__get_user_pages);
 
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

