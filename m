From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-make-compact_control-order-signed-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:17:35 -0700
Message-ID: <20120321231736.008AEA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:40392 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab2CUXRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:17:38 -0400
Received: by faaa19 with SMTP id a19so92267faa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:17:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dan.carpenter@oracle.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-make-compact_control-order-signed-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-compact_control-order-signed-fix.patch

This patch was dropped because it was folded into mm-compaction-make-compact_control-order-signed.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-make-compact_control-order-signed-fix

make __compact_pgdat()'s comparison match other code sites

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-make-compact_control-order-signed-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-compact_control-order-signed-fix
+++ a/mm/compaction.c
@@ -692,7 +692,7 @@ static int __compact_pgdat(pg_data_t *pg
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
-		if (cc->order < 0 || !compaction_deferred(zone, cc->order))
+		if (cc->order == -1 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
 		if (cc->order > 0) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
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

