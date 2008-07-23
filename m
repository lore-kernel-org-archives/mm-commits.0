From: akpm@linux-foundation.org
Subject: - hugetlb-introduce-pud_huge-s390-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:05:03 -0700
Message-ID: <200807232317.m6NNHecm017162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058AbYGWXTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-introduce-pud_huge-s390-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-introduce-pud_huge-s390-fix.patch

This patch was dropped because it was folded into hugetlb-introduce-pud_huge.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-introduce-pud_huge-s390-fix
From: Nick Piggin <npiggin@suse.de>

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/hugetlbpage.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/s390/mm/hugetlbpage.c~hugetlb-introduce-pud_huge-s390-fix arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~hugetlb-introduce-pud_huge-s390-fix
+++ a/arch/s390/mm/hugetlbpage.c
@@ -120,6 +120,11 @@ int pmd_huge(pmd_t pmd)
 	return !!(pmd_val(pmd) & _SEGMENT_ENTRY_LARGE);
 }
 
+int pud_huge(pud_t pud)
+{
+	return 0;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmdp, int write)
 {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mspec-convert-nopfn-to-fault.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
hugetlb-introduce-pud_huge-s390-fix.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-override-default-huge-page-size-non-const-fix.patch
hugetlb-override-default-huge-page-size-non-const-fix-fix.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch

