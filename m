From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:52:05 -0700
Message-ID: <538fa315.bNDpXVV7pohMCiep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFDWwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:52:05 -0700


The patch titled
     Subject: mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes

WARNING: Missing a blank line after declarations
#73: FILE: mm/memory-failure.c:391:
+	struct task_struct *t;
+	rcu_read_lock();

WARNING: Missing a blank line after declarations
#118: FILE: mm/memory-failure.c:443:
+		struct task_struct *t = task_early_kill(tsk, force_early);
+		if (!t)

WARNING: Missing a blank line after declarations
#139: FILE: mm/memory-failure.c:473:
+		struct task_struct *t = task_early_kill(tsk, force_early);
+		if (!t)

total: 0 errors, 3 warnings, 103 lines checked

./patches/mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes
+++ a/mm/memory-failure.c
@@ -388,6 +388,7 @@ static void kill_procs(struct list_head
 static struct task_struct *find_early_kill_thread(struct task_struct *tsk)
 {
 	struct task_struct *t;
+
 	rcu_read_lock();
 	for_each_thread(tsk, t)
 		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
@@ -440,6 +441,7 @@ static void collect_procs_anon(struct pa
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
+
 		if (!t)
 			continue;
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
@@ -470,6 +472,7 @@ static void collect_procs_file(struct pa
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 		struct task_struct *t = task_early_kill(tsk, force_early);
+
 		if (!t)
 			continue;
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

