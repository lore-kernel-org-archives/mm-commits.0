From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch added to -mm tree
Date: Mon, 04 Aug 2014 15:34:53 -0700
Message-ID: <53e00a8d.0zTMiogVZ+iPLpNn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:41436 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaHDWey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 18:34:54 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so16592ykb.1
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 15:34:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix
+++ a/mm/hugetlb.c
@@ -3690,6 +3690,14 @@ follow_huge_pud(struct mm_struct *mm, un
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
+/*
+ * This function calls the architecture dependent variant follow_huge_pmd()
+ * with holding page table lock depending on FOLL_GET.
+ * Whether hugepage migration is supported or not, follow() can be called
+ * with FOLL_GET from do_move_page_to_node_array(), so we need do this in
+ * common code.
+ * Should be called under read mmap_sem.
+ */
 struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmd, int flags)
 {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
mm-softdirty-respect-vm_softdirty-in-pte-holes.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

