From: akpm@linux-foundation.org
Subject: + mm-cleanup-__get_user_pages.patch added to -mm tree
Date: Fri, 18 Apr 2014 15:16:02 -0700
Message-ID: <5351a422.PhjJq7mBdXNtzW81%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaDRWQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-cleanup-__get_user_pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:16:02 -0700


The patch titled
     Subject: mm: cleanup __get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-cleanup-__get_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-__get_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-__get_user_pages.patch

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
Subject: mm: cleanup __get_user_pages()

Get rid of two nested loops over nr_pages and other random cleanups.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  150 +++++++++++++++++++++++++----------------------------
 1 file changed, 73 insertions(+), 77 deletions(-)

diff -puN mm/gup.c~mm-cleanup-__get_user_pages mm/gup.c
--- a/mm/gup.c~mm-cleanup-__get_user_pages
+++ a/mm/gup.c
@@ -370,9 +370,10 @@ long __get_user_pages(struct task_struct
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *nonblocking)
 {
-	long i;
+	long i = 0;
 	unsigned long vm_flags;
 	unsigned int page_mask;
+	struct vm_area_struct *vma = NULL;
 
 	if (!nr_pages)
 		return 0;
@@ -396,88 +397,83 @@ long __get_user_pages(struct task_struct
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
-				return i ? : ret;
-			page_mask = 0;
-			goto next_page;
-		}
-
-		if (!vma ||
-		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
-			return i ? : -EFAULT;
-
-		if (is_vm_hugetlb_page(vma)) {
-			i = follow_hugetlb_page(mm, vma, pages, vmas,
-					&start, &nr_pages, i, gup_flags);
-			continue;
-		}
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
+		struct page *page;
+		unsigned int foll_flags = gup_flags;
+		unsigned int page_increm;
+
+		/* first iteration or cross vma bound */
+		if (!vma || start >= vma->vm_end) {
+			vma = find_extend_vma(mm, start);
+			if (!vma && in_gate_area(mm, start)) {
 				int ret;
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
-					BUILD_BUG();
-				}
-				cond_resched();
+				ret = get_gate_page(mm, start & PAGE_MASK,
+						gup_flags, &vma,
+						pages ? &pages[i] : NULL);
+				if (ret)
+					return i ? : ret;
+				page_mask = 0;
+				goto next_page;
 			}
-			if (IS_ERR(page))
-				return i ? i : PTR_ERR(page);
-			if (pages) {
-				pages[i] = page;
 
-				flush_anon_page(vma, page, start);
-				flush_dcache_page(page);
-				page_mask = 0;
+			if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
+					!(vm_flags & vma->vm_flags))
+				return i ? : -EFAULT;
+
+			if (is_vm_hugetlb_page(vma)) {
+				i = follow_hugetlb_page(mm, vma, pages, vmas,
+						&start, &nr_pages, i,
+						gup_flags);
+				continue;
 			}
-next_page:
-			if (vmas) {
-				vmas[i] = vma;
-				page_mask = 0;
+		}
+
+		/*
+		 * If we have a pending SIGKILL, don't keep faulting pages and
+		 * potentially allocating memory.
+		 */
+		if (unlikely(fatal_signal_pending(current)))
+			return i ? i : -ERESTARTSYS;
+retry:
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
-			page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
-			if (page_increm > nr_pages)
-				page_increm = nr_pages;
-			i += page_increm;
-			start += page_increm * PAGE_SIZE;
-			nr_pages -= page_increm;
-		} while (nr_pages && start < vma->vm_end);
+			BUILD_BUG();
+		}
+		if (IS_ERR(page))
+			return i ? i : PTR_ERR(page);
+		if (pages) {
+			pages[i] = page;
+			flush_anon_page(vma, page, start);
+			flush_dcache_page(page);
+			page_mask = 0;
+		}
+next_page:
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
 }
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-close-race-between-split-and-zap-huge-pages.patch
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
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

