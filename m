From: akpm@linux-foundation.org
Subject: + mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
 added to -mm tree
Date: Fri, 02 May 2014 13:47:18 -0700
Message-ID: <53640456.gI7NuvCaXdjySWIx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaEBUrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 16:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 13:47:18 -0700


The patch titled
     Subject: mm: extract code to fault in a page from __get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch

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
Subject: mm: extract code to fault in a page from __get_user_pages()

Nesting level in __get_user_pages() is just insane. Let's try to fix it
a bit.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  138 +++++++++++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 67 deletions(-)

diff -puN mm/gup.c~mm-extract-code-to-fault-in-a-page-from-__get_user_pages mm/gup.c
--- a/mm/gup.c~mm-extract-code-to-fault-in-a-page-from-__get_user_pages
+++ a/mm/gup.c
@@ -214,12 +214,6 @@ struct page *follow_page_mask(struct vm_
 	return follow_page_pte(vma, address, pmd, flags);
 }
 
-static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
-{
-	return stack_guard_page_start(vma, addr) ||
-	       stack_guard_page_end(vma, addr+PAGE_SIZE);
-}
-
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
 		unsigned int gup_flags, struct vm_area_struct **vma,
 		struct page **page)
@@ -264,6 +258,63 @@ unmap:
 	return ret;
 }
 
+static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
+		unsigned long address, unsigned int *flags, int *nonblocking)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned int fault_flags = 0;
+	int ret;
+
+	/* For mlock, just skip the stack guard page. */
+	if ((*flags & FOLL_MLOCK) &&
+			(stack_guard_page_start(vma, address) ||
+			 stack_guard_page_end(vma, address + PAGE_SIZE)))
+		return -ENOENT;
+	if (*flags & FOLL_WRITE)
+		fault_flags |= FAULT_FLAG_WRITE;
+	if (nonblocking)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+	if (*flags & FOLL_NOWAIT)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
+
+	ret = handle_mm_fault(mm, vma, address, fault_flags);
+	if (ret & VM_FAULT_ERROR) {
+		if (ret & VM_FAULT_OOM)
+			return -ENOMEM;
+		if (ret & (VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE))
+			return *flags & FOLL_HWPOISON ? -EHWPOISON : -EFAULT;
+		if (ret & VM_FAULT_SIGBUS)
+			return -EFAULT;
+		BUG();
+	}
+
+	if (tsk) {
+		if (ret & VM_FAULT_MAJOR)
+			tsk->maj_flt++;
+		else
+			tsk->min_flt++;
+	}
+
+	if (ret & VM_FAULT_RETRY) {
+		if (nonblocking)
+			*nonblocking = 0;
+		return -EBUSY;
+	}
+
+	/*
+	 * The VM_FAULT_WRITE bit tells us that do_wp_page has broken COW when
+	 * necessary, even if maybe_mkwrite decided not to set pte_write. We
+	 * can thus safely do subsequent page lookups as if they were reads.
+	 * But only do so when looping for pte_write is futile: in some cases
+	 * userspace may also be wanting to write to the gotten user page,
+	 * which a read fault here might prevent (a readonly page might get
+	 * reCOWed by userspace write).
+	 */
+	if ((ret & VM_FAULT_WRITE) && !(vma->vm_flags & VM_WRITE))
+		*flags &= ~FOLL_WRITE;
+	return 0;
+}
+
 /**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
@@ -410,69 +461,22 @@ long __get_user_pages(struct task_struct
 			while (!(page = follow_page_mask(vma, start,
 						foll_flags, &page_mask))) {
 				int ret;
-				unsigned int fault_flags = 0;
-
-				/* For mlock, just skip the stack guard page. */
-				if (foll_flags & FOLL_MLOCK) {
-					if (stack_guard_page(vma, start))
-						goto next_page;
-				}
-				if (foll_flags & FOLL_WRITE)
-					fault_flags |= FAULT_FLAG_WRITE;
-				if (nonblocking)
-					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
-				if (foll_flags & FOLL_NOWAIT)
-					fault_flags |= (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT);
-
-				ret = handle_mm_fault(mm, vma, start,
-							fault_flags);
-
-				if (ret & VM_FAULT_ERROR) {
-					if (ret & VM_FAULT_OOM)
-						return i ? i : -ENOMEM;
-					if (ret & (VM_FAULT_HWPOISON |
-						   VM_FAULT_HWPOISON_LARGE)) {
-						if (i)
-							return i;
-						else if (gup_flags & FOLL_HWPOISON)
-							return -EHWPOISON;
-						else
-							return -EFAULT;
-					}
-					if (ret & VM_FAULT_SIGBUS)
-						goto efault;
-					BUG();
-				}
-
-				if (tsk) {
-					if (ret & VM_FAULT_MAJOR)
-						tsk->maj_flt++;
-					else
-						tsk->min_flt++;
-				}
-
-				if (ret & VM_FAULT_RETRY) {
-					if (nonblocking)
-						*nonblocking = 0;
+				ret = faultin_page(tsk, vma, start, &foll_flags,
+						nonblocking);
+				switch (ret) {
+				case 0:
+					break;
+				case -EFAULT:
+				case -ENOMEM:
+				case -EHWPOISON:
+					return i ? i : ret;
+				case -EBUSY:
 					return i;
+				case -ENOENT:
+					goto next_page;
+				default:
+					BUG();
 				}
-
-				/*
-				 * The VM_FAULT_WRITE bit tells us that
-				 * do_wp_page has broken COW when necessary,
-				 * even if maybe_mkwrite decided not to set
-				 * pte_write. We can thus safely do subsequent
-				 * page lookups as if they were reads. But only
-				 * do so when looping for pte_write is futile:
-				 * in some cases userspace may also be wanting
-				 * to write to the gotten user page, which a
-				 * read fault here might prevent (a readonly
-				 * page might get reCOWed by userspace write).
-				 */
-				if ((ret & VM_FAULT_WRITE) &&
-				    !(vma->vm_flags & VM_WRITE))
-					foll_flags &= ~FOLL_WRITE;
-
 				cond_resched();
 			}
 			if (IS_ERR(page))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

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
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

