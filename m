From: akpm@linux-foundation.org
Subject: [merged] rmap-fix-anon_vma_fork-memory-leak.patch removed from -mm tree
Date: Tue, 06 Apr 2010 11:30:24 -0400
Message-ID: <201004061831.o36IVm9k000447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756748Ab0DFScD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 14:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, minchan.kim@gmail.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     rmap: fix anon_vma_fork() memory leak
has been removed from the -mm tree.  Its filename was
     rmap-fix-anon_vma_fork-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rmap: fix anon_vma_fork() memory leak
From: Rik van Riel <riel@redhat.com>

Fix a memory leak in anon_vma_fork(), where we fail to tear down the
anon_vmas attached to the new VMA in case setting up the new anon_vma
fails.

This bug also has the potential to leave behind anon_vma_chain structs
with pointers to invalid memory.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/rmap.c~rmap-fix-anon_vma_fork-memory-leak mm/rmap.c
--- a/mm/rmap.c~rmap-fix-anon_vma_fork-memory-leak
+++ a/mm/rmap.c
@@ -232,6 +232,7 @@ int anon_vma_fork(struct vm_area_struct 
  out_error_free_anon_vma:
 	anon_vma_free(anon_vma);
  out_error:
+	unlink_anon_vmas(vma);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
exit-fix-oops-in-sync_mm_rss.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
mm-revert-vmscan-get_scan_ratio-cleanup.patch
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

