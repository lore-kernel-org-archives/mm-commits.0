From: akpm@linux-foundation.org
Subject: - mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:10:46 -0700
Message-ID: <200704270810.l3R8AkHs022941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbXD0IKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm-dnp-invp-race-fix2
has been removed from the -mm tree.  Its filename was
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch

This patch was dropped because it was folded into mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch

------------------------------------------------------
Subject: mm-dnp-invp-race-fix2
From: Nick Piggin <nickpiggin@yahoo.com.au>

The nopage vs invalidate race fix patch did not take care of truncating
private COW pages. Mind you, I'm pretty sure this was previously racy
even for regular truncate, not to mention vmtruncate_range.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN mm/memory.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix mm/memory.c
--- a/mm/memory.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix
+++ a/mm/memory.c
@@ -1999,7 +1999,18 @@ int vmtruncate(struct inode * inode, lof
 	if (IS_SWAPFILE(inode))
 		goto out_busy;
 	i_size_write(inode, offset);
+
+	/*
+	 * unmap_mapping_range is called twice, first simply for efficiency
+	 * so that truncate_inode_pages does fewer single-page unmaps. However
+	 * after this first call, and before truncate_inode_pages finishes,
+	 * it is possible for private pages to be COWed, which remain after
+	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
+	 * call must be made for correctness.
+	 */
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	truncate_inode_pages(mapping, offset);
+	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
 	goto out_truncate;
 
 do_expand:
@@ -2037,7 +2048,9 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	truncate_inode_pages_range(mapping, offset, end);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

ia64-race-flushing-icache-in-do_no_page-path.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch
mm-merge-nopfn-into-fault-fix.patch
convert-hugetlbfs-to-use-vm_ops-fault.patch
readahead-improve-heuristic-detecting-sequential-reads.patch
readahead-code-cleanup.patch
readahead-code-cleanup-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
madv_free-lazytlb-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
as-fix-antic_expire-check.patch
kblockd-use-flush_work.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched2-sched-domain-sysctl.patch
revoke-core-code-break-cow-fixes.patch
