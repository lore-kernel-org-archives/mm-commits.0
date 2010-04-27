From: akpm@linux-foundation.org
Subject: [merged] mmap-check-vm_ops-before-dereferencing.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:01:35 -0400
Message-ID: <201004271803.o3RI39Gf010951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0D0SEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mmap: check ->vm_ops before dereferencing
has been removed from the -mm tree.  Its filename was
     mmap-check-vm_ops-before-dereferencing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap: check ->vm_ops before dereferencing
From: Rik van Riel <riel@redhat.com>

Check whether the VMA has a vm_ops before calling close, just like we
check vm_ops before calling open a few dozen lines higher up in the
function.

akpm: lots of vm_operations_structs have a NULL ->close.  If vma_adjust()
fails, we oops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mmap-check-vm_ops-before-dereferencing mm/mmap.c
--- a/mm/mmap.c~mmap-check-vm_ops-before-dereferencing
+++ a/mm/mmap.c
@@ -1977,7 +1977,8 @@ static int __split_vma(struct mm_struct 
 		return 0;
 
 	/* Clean everything up if vma_adjust failed. */
-	new->vm_ops->close(new);
+	if (new->vm_ops && new->vm_ops->close)
+		new->vm_ops->close(new);
 	if (new->vm_file) {
 		if (vma->vm_flags & VM_EXECUTABLE)
 			removed_exe_file_vma(mm);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
powerpc-add-rcu_read_lock-to-gup_fast-implementation.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mmmigration-take-a-reference-to-the-anon_vma-before-migrating.patch
mmmigration-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mmmigration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mmmigration-allow-the-migration-of-pageswapcache-pages.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mm-export-fragmentation-index-via-debugfs.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mmcompaction-memory-compaction-core.patch
mmcompaction-add-proc-trigger-for-memory-compaction.patch
mmcompaction-add-sys-trigger-for-per-node-memory-compaction.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mmcompaction-defer-compaction-using-an-exponential-backoff-when-compaction-fails.patch
mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch
mm-document-follow_page.patch

