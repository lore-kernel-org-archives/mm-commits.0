From: akpm@linux-foundation.org
Subject: + memcg-update-threshold-and-softlimit-at-commit-v2.patch added to -mm tree
Date: Fri, 12 Feb 2010 12:02:27 -0800
Message-ID: <201002122002.o1CK2SiG023767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136Ab0BLUCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kirill@shutemov.name, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: update threshold and softlimit at commit
has been added to the -mm tree.  Its filename is
     memcg-update-threshold-and-softlimit-at-commit-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update threshold and softlimit at commit
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, move_task does "batched" precharge.  Because res_counter or
css's refcnt are not-scalable jobs for memcg, try_charge_()..  tend to be
done in batched manner if allowed.

Now, softlimit and threshold check their event counter in try_charge, but
the charge is not a per-page event.  And event counter is not updated at
charge().  Moreover, precharge doesn't pass "page" to try_charge() and
softlimit tree will be never updated until uncharge() causes an event."

So the best place to check the event counter is commit_charge().  This is
per-page event by its nature.  This patch move checks to there.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN mm/memcontrol.c~memcg-update-threshold-and-softlimit-at-commit-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-update-threshold-and-softlimit-at-commit-v2
+++ a/mm/memcontrol.c
@@ -1424,8 +1424,7 @@ static int __cpuinit memcg_stock_cpu_cal
  * oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **memcg,
-			bool oom, struct page *page)
+			gfp_t gfp_mask, struct mem_cgroup **memcg, bool oom)
 {
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
@@ -1463,7 +1462,7 @@ static int __mem_cgroup_try_charge(struc
 		unsigned long flags = 0;
 
 		if (consume_stock(mem))
-			goto charged;
+			goto done;
 
 		ret = res_counter_charge(&mem->res, csize, &fail_res);
 		if (likely(!ret)) {
@@ -1558,16 +1557,7 @@ static int __mem_cgroup_try_charge(struc
 	}
 	if (csize > PAGE_SIZE)
 		refill_stock(mem, csize - PAGE_SIZE);
-charged:
-	/*
-	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
-	 * if they exceeds softlimit.
-	 */
-	if (page && mem_cgroup_soft_limit_check(mem))
-		mem_cgroup_update_tree(mem, page);
 done:
-	if (mem_cgroup_threshold_check(mem))
-		mem_cgroup_threshold(mem);
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -1691,6 +1681,16 @@ static void __mem_cgroup_commit_charge(s
 	mem_cgroup_charge_statistics(mem, pc, true);
 
 	unlock_page_cgroup(pc);
+	/*
+	 * "charge_statistics" updated event counter. Then, check it.
+	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
+	 * if they exceeds softlimit.
+	 */
+	if (mem_cgroup_soft_limit_check(mem))
+		mem_cgroup_update_tree(mem, pc->page);
+	if (mem_cgroup_threshold_check(mem))
+		mem_cgroup_threshold(mem);
+
 }
 
 /**
@@ -1788,7 +1788,7 @@ static int mem_cgroup_move_parent(struct
 		goto put;
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, page);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false);
 	if (ret || !parent)
 		goto put_back;
 
@@ -1824,7 +1824,7 @@ static int mem_cgroup_charge_common(stru
 	prefetchw(pc);
 
 	mem = memcg;
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true, page);
+	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
 	if (ret || !mem)
 		return ret;
 
@@ -1944,14 +1944,14 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
-	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true, page);
+	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
 	/* drop extra refcnt from tryget */
 	css_put(&mem->css);
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, ptr, true, page);
+	return __mem_cgroup_try_charge(mm, mask, ptr, true);
 }
 
 static void
@@ -2340,8 +2340,7 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false,
-						page);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
@@ -3863,8 +3862,7 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem,
-								false, NULL);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
 		if (ret || !mem)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return -ENOMEM;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-oom-killing-a-child-process-in-an-other-cgroup.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
devmem-dont-allow-seek-to-last-page.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-implement-memory-thresholds-check-if-first-threshold-crossed.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch

