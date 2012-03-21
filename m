From: akpm@linux-foundation.org
Subject: [folded] make-swapin-readahead-skip-over-holes-fix.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:16:43 -0700
Message-ID: <20120321231643.2C714A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34082 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2CUXQp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:16:45 -0400
Received: by faaa19 with SMTP id a19so92257faa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:16:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, kosaki.motohiro@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, z@drze.net, mm-commits@vger.kernel.org


The patch titled
     Subject: make-swapin-readahead-skip-over-holes-fix
has been removed from the -mm tree.  Its filename was
     make-swapin-readahead-skip-over-holes-fix.patch

This patch was dropped because it was folded into make-swapin-readahead-skip-over-holes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: make-swapin-readahead-skip-over-holes-fix

fix it for page_cluster >= 32

Cc: Adrian Drzewiecki <z@drze.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~make-swapin-readahead-skip-over-holes-fix mm/swap_state.c
--- a/mm/swap_state.c~make-swapin-readahead-skip-over-holes-fix
+++ a/mm/swap_state.c
@@ -375,7 +375,7 @@ struct page *swapin_readahead(swp_entry_
 	struct page *page;
 	unsigned long offset = swp_offset(entry);
 	unsigned long start_offset, end_offset;
-	unsigned long mask = (1 << page_cluster) - 1;
+	unsigned long mask = (1UL << page_cluster) - 1;
 
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
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

