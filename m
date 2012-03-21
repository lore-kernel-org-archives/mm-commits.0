From: akpm@linux-foundation.org
Subject: [folded] thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:28:06 -0700
Message-ID: <20120321232806.6D052A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53896 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab2CUX2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:28:07 -0400
Received: by yenq2 with SMTP id q2so273701yen.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:28:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, nishimura@mxp.nes.nec.co.jp, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix
has been removed from the -mm tree.  Its filename was
     thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

This patch was dropped because it was folded into thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix

fix build in mm/pgtable-generic.c

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix include/linux/huge_mm.h
diff -puN mm/pgtable-generic.c~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix
+++ a/mm/pgtable-generic.c
@@ -70,10 +70,11 @@ int pmdp_clear_flush_young(struct vm_are
 			   unsigned long address, pmd_t *pmdp)
 {
 	int young;
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+#else
 	BUG();
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
 		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
hugetlbfs-return-error-code-when-initializing-module.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-use-new-logic-for-page-stat-accounting.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch

