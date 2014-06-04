From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:31:08 -0700
Message-ID: <538f9e2c.KTiXMvPV6g1bk2VJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaFDWbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nasa4836@gmail.com, hughd@google.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,hughd@google.com,nasa4836@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:31:08 -0700


The patch titled
     Subject: mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-comment-for-__mod_zone_page_stat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes

also fix spellos

WARNING: line over 80 characters
#54: FILE: mm/rmap.c:988:
+		 * pte lock(a spinlock) is held, which implies preemtion disabled.

total: 0 errors, 1 warnings, 45 lines checked

./patches/mm-add-comment-for-__mod_zone_page_stat.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 +++---
 mm/rmap.c     |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/internal.h~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes mm/internal.h
--- a/mm/internal.h~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
+++ a/mm/internal.h
@@ -202,9 +202,9 @@ static inline int mlocked_vma_newpage(st
 
 	if (!TestSetPageMlocked(page)) {
 		/*
-		 * We use the irq-unsafe __mod_zone_page_stat because
-		 * this counter is not modified from interrupt context, and the
-		 * pte lock is held(spinlock), which implies preemtion disabled.
+		 * We use the irq-unsafe __mod_zone_page_stat because this
+		 * counter is not modified from interrupt context, and the pte
+		 * lock is held(spinlock), which implies preemption disabled.
 		 */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
diff -puN mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes mm/rmap.c
--- a/mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
+++ a/mm/rmap.c
@@ -985,7 +985,8 @@ void do_page_add_anon_rmap(struct page *
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 		 * these counters are not modified in interrupt context, and
-		 * pte lock(a spinlock) is held, which implies preemtion disabled.
+		 * pte lock(a spinlock) is held, which implies preemption
+		 * disabled.
 		 */
 		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
@@ -1082,7 +1083,7 @@ void page_remove_rmap(struct page *page)
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
 	 * these counters are not modified in interrupt context, and
-	 * pte lock(a spinlock) is held, which implies preemtion disabled.
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
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
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

