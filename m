From: akpm@linux-foundation.org
Subject: - memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:11:53 -0800
Message-ID: <200901072311.n07NBrIk029720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbZAGXMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: make resize limit hold mutex
has been removed from the -mm tree.  Its filename was
     memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch

This patch was dropped because it was folded into memcg-memswap-controller-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: make resize limit hold mutex
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mem_cgroup_resize_memsw_limit() try to hold memsw.lock while holding
res.lock, so below message is showed when trying to write
memory.memsw.limit_in_bytes file.

    [ INFO: possible recursive locking detected ]
    2.6.28-rc4-mm1-mmotm-2008-11-14-20-50-ef4e17ef #1

    bash/4406 is trying to acquire lock:
     (&counter->lock){....}, at: [<c0498408>] mem_cgroup_resize_memsw_limit+0x8d/0x113

    but task is already holding lock:
     (&counter->lock){....}, at: [<c04983d6>] mem_cgroup_resize_memsw_limit+0x5b/0x113

    other info that might help us debug this:
    1 lock held by bash/4406:
     #0:  (&counter->lock){....}, at: [<c04983d6>] mem_cgroup_resize_memsw_limit+0x5b/0x113

    stack backtrace:
    Pid: 4406, comm: bash Not tainted 2.6.28-rc4-mm1-mmotm-2008-11-14-20-50-ef4e17ef #1
    Call Trace:
     [<c066e60f>] ? printk+0xf/0x18
     [<c044d0c0>] __lock_acquire+0xc67/0x1353
     [<c044d793>] ? __lock_acquire+0x133a/0x1353
     [<c044d81c>] lock_acquire+0x70/0x97
     [<c0498408>] ? mem_cgroup_resize_memsw_limit+0x8d/0x113
     [<c0671519>] _spin_lock_irqsave+0x3a/0x6d
     [<c0498408>] ? mem_cgroup_resize_memsw_limit+0x8d/0x113
     [<c0498408>] mem_cgroup_resize_memsw_limit+0x8d/0x113
     [<c0518a6c>] ? memparse+0x14/0x66
     [<c0498594>] mem_cgroup_write+0x4a/0x50
     [<c045e063>] cgroup_file_write+0x181/0x1c6
     [<c0449e43>] ? lock_release_holdtime+0x1a/0x168
     [<c04ec725>] ? security_file_permission+0xf/0x11
     [<c049b5f0>] ? rw_verify_area+0x76/0x97
     [<c045dee2>] ? cgroup_file_write+0x0/0x1c6
     [<c049bce6>] vfs_write+0x8a/0x12e
     [<c049be23>] sys_write+0x3b/0x60
     [<c0403867>] sysenter_do_call+0x12/0x3f

This patch define a new mutex and make both mem_cgroup_resize_limit and
mem_cgroup_memsw_resize_limit hold it to remove spin_lock_irqsave.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-memswap-controller-core-make-resize-limit-hold-mutex mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memswap-controller-core-make-resize-limit-hold-mutex
+++ a/mm/memcontrol.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
@@ -1189,32 +1190,43 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
+static DEFINE_MUTEX(set_limit_mutex);
+
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
-				   unsigned long long val)
+				unsigned long long val)
 {
 
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
 	int progress;
+	u64 memswlimit;
 	int ret = 0;
 
-	if (do_swap_account) {
-		if (val > memcg->memsw.limit)
-			return -EINVAL;
-	}
-
-	while (res_counter_set_limit(&memcg->res, val)) {
+	while (retry_count) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
-		if (!retry_count) {
-			ret = -EBUSY;
+		/*
+		 * Rather than hide all in some function, I do this in
+		 * open coded manner. You see what this really does.
+		 * We have to guarantee mem->res.limit < mem->memsw.limit.
+		 */
+		mutex_lock(&set_limit_mutex);
+		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		if (memswlimit < val) {
+			ret = -EINVAL;
+			mutex_unlock(&set_limit_mutex);
 			break;
 		}
+		ret = res_counter_set_limit(&memcg->res, val);
+		mutex_unlock(&set_limit_mutex);
+
+		if (!ret)
+			break;
+
 		progress = try_to_free_mem_cgroup_pages(memcg,
 				GFP_HIGHUSER_MOVABLE, false);
-		if (!progress)
-			retry_count--;
+  		if (!progress)			retry_count--;
 	}
 	return ret;
 }
@@ -1223,7 +1235,6 @@ int mem_cgroup_resize_memsw_limit(struct
 				unsigned long long val)
 {
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
-	unsigned long flags;
 	u64 memlimit, oldusage, curusage;
 	int ret;
 
@@ -1240,19 +1251,20 @@ int mem_cgroup_resize_memsw_limit(struct
 		 * open coded manner. You see what this really does.
 		 * We have to guarantee mem->res.limit < mem->memsw.limit.
 		 */
-		spin_lock_irqsave(&memcg->res.lock, flags);
-		memlimit = memcg->res.limit;
+		mutex_lock(&set_limit_mutex);
+		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
 		if (memlimit > val) {
-			spin_unlock_irqrestore(&memcg->res.lock, flags);
 			ret = -EINVAL;
+			mutex_unlock(&set_limit_mutex);
 			break;
 		}
 		ret = res_counter_set_limit(&memcg->memsw, val);
-		oldusage = memcg->memsw.usage;
-		spin_unlock_irqrestore(&memcg->res.lock, flags);
+		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
 			break;
+
+		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch

