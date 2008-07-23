From: akpm@linux-foundation.org
Subject: - hugetlb-override-default-huge-page-size-non-const-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:05:37 -0700
Message-ID: <200807232318.m6NNIEqi017179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYGWXSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     hugetlb: override default huge page size non-const fix
has been removed from the -mm tree.  Its filename was
     hugetlb-override-default-huge-page-size-non-const-fix.patch

This patch was dropped because it was folded into hugetlb-override-default-huge-page-size.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: override default huge page size non-const fix
From: Nick Piggin <npiggin@suse.de>

If HPAGE_SIZE is not constant (eg.  on ia64), then the initialiser does
not work.  Fix this by making default_hstate_size == 0, then if it isn't
set from the cmdline, hugetlb_init will still do the right thing and set
up the default hstate as (the now initialized) HPAGE_SIZE.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-override-default-huge-page-size-non-const-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-override-default-huge-page-size-non-const-fix
+++ a/mm/hugetlb.c
@@ -34,7 +34,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
-static unsigned long __initdata default_hstate_size = HPAGE_SIZE;
+static unsigned long __initdata default_hstate_size = 0;
 
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
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

