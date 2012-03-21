From: akpm@linux-foundation.org
Subject: [folded] procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:20:57 -0700
Message-ID: <20120321232057.8EA5BA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47287 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CUXU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:20:59 -0400
Received: by vbnl22 with SMTP id l22so128692vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:20:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, siddhesh.poyarekar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch

This patch was dropped because it was folded into procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes

ERROR: spaces required around that '!=' (ctx:WxV)
#144: FILE: fs/proc/task_mmu.c:279:
+		if (tid !=0) {
 		        ^

ERROR: spaces required around that '!=' (ctx:WxV)
#175: FILE: fs/proc/task_mmu.c:1151:
+		if (tid !=0) {
 		        ^

total: 3 errors, 0 warnings, 281 lines checked

./patches/procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -276,7 +276,7 @@ show_map_vma(struct seq_file *m, struct 
 
 		tid = vm_is_stack(task, vma, is_pid);
 
-		if (tid !=0) {
+		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
 			 * the main process stack.
@@ -1161,7 +1161,7 @@ static int show_numa_map(struct seq_file
 		seq_printf(m, " heap");
 	} else {
 		pid_t tid = vm_is_stack(proc_priv->task, vma, is_pid);
-		if (tid !=0) {
+		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
 			 * the main process stack.
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

