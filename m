From: akpm@linux-foundation.org
Subject: + thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch added to -mm tree
Date: Wed, 21 Mar 2012 15:01:36 -0700
Message-ID: <20120321224529.D92A1200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57711 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2CUWpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 18:45:33 -0400
Received: by wibhj13 with SMTP id hj13so1046wib.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 15:45:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, nishimura@mxp.nes.nec.co.jp, paul.gortmaker@windriver.com, rientjes@google.com


The patch titled
     Subject: thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix
has been added to the -mm tree.  Its filename is
     thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
thp-optimize-away-unnecessary-page-table-locking-fix-checkpatch-fixes.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch
mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch
hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

