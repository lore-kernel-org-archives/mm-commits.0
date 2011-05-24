From: akpm@linux-foundation.org
Subject: [folded] oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch removed from -mm tree
Date: Tue, 24 May 2011 16:53:28 -0700
Message-ID: <201105242353.p4ONrS3M023725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab1EXXxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 19:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hughd@google.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
has been removed from the -mm tree.  Its filename was
     oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch

This patch was dropped because it was folded into oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
From: David Rientjes <rientjes@google.com>

 v3: add comment for test_set_oom_score_adj()
     disable irqs when taking siglock, thanks to Matt Fleming

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update mm/oom_kill.c
--- a/mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
+++ a/mm/oom_kill.c
@@ -38,12 +38,20 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+/**
+ * test_set_oom_score_adj() - set current's oom_score_adj and return old value
+ * @new_val: new oom_score_adj value
+ *
+ * Sets the oom_score_adj value for current to @new_val with proper
+ * synchronization and returns the old value.  Usually used to temporarily
+ * set a value, save the old value in the caller, and then reinstate it later.
+ */
 int test_set_oom_score_adj(int new_val)
 {
 	struct sighand_struct *sighand = current->sighand;
 	int old_val;
 
-	spin_lock(&sighand->siglock);
+	spin_lock_irq(&sighand->siglock);
 	old_val = current->signal->oom_score_adj;
 	if (new_val != old_val) {
 		if (new_val == OOM_SCORE_ADJ_MIN)
@@ -52,7 +60,7 @@ int test_set_oom_score_adj(int new_val)
 			atomic_dec(&current->mm->oom_disable_count);
 		current->signal->oom_score_adj = new_val;
 	}
-	spin_unlock(&sighand->siglock);
+	spin_unlock_irq(&sighand->siglock);
 
 	return old_val;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
alpha-mm-set-all-online-nodes-in-n_normal_memory.patch
m32r-mm-set-all-online-nodes-in-n_normal_memory.patch
mm-remove-dependency-on-config_flatmem-from-online_page.patch
mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
mm-add-section_align_up-and-section_align_down-macro.patch

