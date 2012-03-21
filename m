From: akpm@linux-foundation.org
Subject: [folded] bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:21:45 -0700
Message-ID: <20120321232145.D103DA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54103 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CUXVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:21:46 -0400
Received: by ggnd2 with SMTP id d2so273854ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:21:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nacc@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix
has been removed from the -mm tree.  Its filename was
     bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix.patch

This patch was dropped because it was folded into bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix

code simplification

Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/bootmem.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix mm/bootmem.c
--- a/mm/bootmem.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section-fix
+++ a/mm/bootmem.c
@@ -766,14 +766,13 @@ void * __init alloc_bootmem_section(unsi
 				    unsigned long section_nr)
 {
 	bootmem_data_t *bdata;
-	unsigned long pfn, goal, limit;
+	unsigned long pfn, goal;
 
 	pfn = section_nr_to_pfn(section_nr);
 	goal = pfn << PAGE_SHIFT;
-	limit = 0;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
+	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, 0);
 }
 #endif
 
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
hugetlbfs-fix-alignment-of-huge-page-requests-fix.patch
hugetlbfs-return-error-code-when-initializing-module-fix.patch
mmapc-fix-comment-for-__insert_vm_struct-fix.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

