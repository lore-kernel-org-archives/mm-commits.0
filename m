From: akpm@linux-foundation.org
Subject: [folded] mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:21:26 -0700
Message-ID: <20120321232126.75CA9A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63857 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CUXV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:21:28 -0400
Received: by bkcjm19 with SMTP id jm19so82593bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:21:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-fix-move-migrate_pages-race-on-task-struct.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes

WARNING: line over 80 characters
#97: FILE: mm/mempolicy.c:1365:
+			capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);

WARNING: line over 80 characters
#184: FILE: mm/migrate.c:1395:
+			err = do_pages_move(mm, task_nodes, nr_pages, pages, nodes,

total: 0 errors, 2 warnings, 150 lines checked

./patches/mm-fix-move-migrate_pages-race-on-task-struct.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes mm/migrate.c
--- a/mm/migrate.c~mm-fix-move-migrate_pages-race-on-task-struct-checkpatch-fixes
+++ a/mm/migrate.c
@@ -1390,8 +1390,8 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 
 	if (mm) {
 		if (nodes)
-			err = do_pages_move(mm, task_nodes, nr_pages, pages, nodes,
-				status, flags);
+			err = do_pages_move(mm, task_nodes, nr_pages, pages,
+					    nodes, status, flags);
 		else
 			err = do_pages_stat(mm, nr_pages, pages, status);
 	} else
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

