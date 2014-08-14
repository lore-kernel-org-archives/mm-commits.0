From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch removed from -mm tree
Date: Thu, 14 Aug 2014 14:31:59 -0700
Message-ID: <53ed2acf.epep0fM+PhkuYkMg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:45169 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbaHNVcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:32:00 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so414044obc.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:32:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd-fix.patch

This patch was dropped because it was folded into mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch

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

origin.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

