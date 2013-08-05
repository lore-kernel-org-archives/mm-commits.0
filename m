From: akpm@linux-foundation.org
Subject: [merged] vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:06:04 -0700
Message-ID: <51fff79c.bTJwcqnv6w9V1oN0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3HETGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, anton.vorontsov@linaro.org, mhocko@suse.cz

Subject: [merged] vmpressure-change-vmpressure-sr_lock-to-spinlock.patch removed from -mm tree
To: mhocko@suse.cz,anton.vorontsov@linaro.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,lizefan@huawei.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:04 -0700


The patch titled
     Subject: vmpressure: change vmpressure::sr_lock to spinlock
has been removed from the -mm tree.  Its filename was
     vmpressure-change-vmpressure-sr_lock-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmpressure: change vmpressure::sr_lock to spinlock

There is nothing that can sleep inside critical sections protected by
this lock and those sections are really small so there doesn't make much
sense to use mutex for them. Change the log to a spinlock

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    2 +-
 mm/vmpressure.c            |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/vmpressure.h~vmpressure-change-vmpressure-sr_lock-to-spinlock include/linux/vmpressure.h
--- a/include/linux/vmpressure.h~vmpressure-change-vmpressure-sr_lock-to-spinlock
+++ a/include/linux/vmpressure.h
@@ -12,7 +12,7 @@ struct vmpressure {
 	unsigned long scanned;
 	unsigned long reclaimed;
 	/* The lock is used to keep the scanned/reclaimed above in sync. */
-	struct mutex sr_lock;
+	struct spinlock sr_lock;
 
 	/* The list of vmpressure_event structs. */
 	struct list_head events;
diff -puN mm/vmpressure.c~vmpressure-change-vmpressure-sr_lock-to-spinlock mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-change-vmpressure-sr_lock-to-spinlock
+++ a/mm/vmpressure.c
@@ -180,12 +180,12 @@ static void vmpressure_work_fn(struct wo
 	if (!vmpr->scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
 	vmpr->reclaimed = 0;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	do {
 		if (vmpressure_event(vmpr, scanned, reclaimed))
@@ -240,11 +240,11 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	if (!scanned)
 		return;
 
-	mutex_lock(&vmpr->sr_lock);
+	spin_lock(&vmpr->sr_lock);
 	vmpr->scanned += scanned;
 	vmpr->reclaimed += reclaimed;
 	scanned = vmpr->scanned;
-	mutex_unlock(&vmpr->sr_lock);
+	spin_unlock(&vmpr->sr_lock);
 
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
@@ -367,7 +367,7 @@ void vmpressure_unregister_event(struct
  */
 void vmpressure_init(struct vmpressure *vmpr)
 {
-	mutex_init(&vmpr->sr_lock);
+	spin_lock_init(&vmpr->sr_lock);
 	mutex_init(&vmpr->events_lock);
 	INIT_LIST_HEAD(&vmpr->events);
 	INIT_WORK(&vmpr->work, vmpressure_work_fn);
_

Patches currently in -mm which might be from mhocko@suse.cz are

include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

