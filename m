From: akpm@linux-foundation.org
Subject: +
 mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch added
 to -mm tree
Date: Fri, 02 May 2014 15:49:54 -0700
Message-ID: <53642112.spAqwCewKXHoAPE9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaEBWty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:49:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:49:54 -0700


The patch titled
     Subject: mm/rmap.c: make page_referenced_one() and try_to_unmap_one() static
has been added to the -mm tree.  Its filename is
     mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch

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
@@ -665,7 +665,7 @@ struct page_referenced_arg {
 /*
  * arg: page_referenced_arg will be passed
  */
-int page_referenced_one(struct page *page, struct vm_area_struct *vma,
+static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -1108,7 +1108,7 @@ out:
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
mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

