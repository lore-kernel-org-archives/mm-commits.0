From: akpm@linux-foundation.org
Subject: + mm-thp-close-race-between-mremap-and-split_huge_page.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:52:06 -0700
Message-ID: <536aab06.rEHUMng+UDXHSN1Z%akpm__35420.7008764662$1399499537$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaEGVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:52:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, riel@redhat.com, hannes@cmpxchg.org, davem@davemloft.net, davej@redhat.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + mm-thp-close-race-between-mremap-and-split_huge_page.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,davej@redhat.com,davem@davemloft.net,hannes@cmpxchg.org,riel@redhat.com,stable@vger.kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:52:06 -0700


The patch titled
     Subject: mm, thp: close race between mremap() and split_huge_page()
has been added to the -mm tree.  Its filename is
     mm-thp-close-race-between-mremap-and-split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-close-race-between-mremap-and-split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-close-race-between-mremap-and-split_huge_page.patch

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
Subject: mm, thp: close race between mremap() and split_huge_page()

It's critical for split_huge_page() (and migration) to catch and freeze
all PMDs on rmap walk.  It gets tricky if there's concurrent fork() or
mremap() since usually we copy/move page table entries on dup_mm() or
move_page_tables() without rmap lock taken.  To get it work we rely on
rmap walk order to not miss any entry.  We expect to see destination VMA
after source one to work correctly.

But after switching rmap implementation to interval tree it's not always
possible to preserve expected walk order.

It works fine for dup_mm() since new VMA has the same vma_start_pgoff() /
vma_last_pgoff() and explicitly insert dst VMA after src one with
vma_interval_tree_insert_after().

But on move_vma() destination VMA can be merged into adjacent one and as
result shifted left in interval tree.  Fortunately, we can detect the
situation and prevent race with rmap walk by moving page table entries
under rmap lock.  See commit 38a76013ad80.

Problem is that we miss the lock when we move transhuge PMD.  Most likely
this bug caused the crash[1].

[1] http://thread.gmane.org/gmane.linux.kernel.mm/96473

Fixes: 108d6642ad81 ("mm anon rmap: remove anon_vma_moveto_tail")

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Miller <davem@davemloft.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>        [3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~mm-thp-close-race-between-mremap-and-split_huge_page mm/mremap.c
--- a/mm/mremap.c~mm-thp-close-race-between-mremap-and-split_huge_page
+++ a/mm/mremap.c
@@ -194,10 +194,17 @@ unsigned long move_page_tables(struct vm
 			break;
 		if (pmd_trans_huge(*old_pmd)) {
 			int err = 0;
-			if (extent == HPAGE_PMD_SIZE)
+			if (extent == HPAGE_PMD_SIZE) {
+				VM_BUG_ON(vma->vm_file || !vma->anon_vma);
+				/* See comment in move_ptes() */
+				if (need_rmap_locks)
+					anon_vma_lock_write(vma->anon_vma);
 				err = move_huge_pmd(vma, new_vma, old_addr,
 						    new_addr, old_end,
 						    old_pmd, new_pmd);
+				if (need_rmap_locks)
+					anon_vma_unlock_write(vma->anon_vma);
+			}
 			if (err > 0) {
 				need_flush = true;
 				continue;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-thp-close-race-between-mremap-and-split_huge_page.patch
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
mm-update-comment-for-default_max_map_count.patch
mm-update-comment-for-default_max_map_count-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

