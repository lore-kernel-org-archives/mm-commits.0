From: akpm@linux-foundation.org
Subject: + memcg-trivial-cleanups.patch added to -mm tree
Date: Tue, 30 Jul 2013 15:34:03 -0700
Message-ID: <51f83f5b.iHwVfMv3mnpFAr/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3G3WeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, akpm@linux-foundation.org

Subject: + memcg-trivial-cleanups.patch added to -mm tree
To: akpm@linux-foundation.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:34:03 -0700


The patch titled
     Subject: memcg: trivial cleanups
has been added to the -mm tree.  Its filename is
     memcg-trivial-cleanups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-trivial-cleanups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-trivial-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg: trivial cleanups

Clean up some mess made by the "Soft limit rework" series, and a few other
things.

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   32 ++++++++++++++++----------------
 mm/vmscan.c     |   12 ++++++------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-trivial-cleanups mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-trivial-cleanups
+++ a/mm/memcontrol.c
@@ -279,7 +279,7 @@ struct mem_cgroup {
 	 * Should we move charges of a task when a task is moved into this
 	 * mem_cgroup ? And what type of charges should we move ?
 	 */
-	unsigned long 	move_charge_at_immigrate;
+	unsigned long move_charge_at_immigrate;
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
@@ -324,7 +324,7 @@ struct mem_cgroup {
 
 	/*
 	 * If true then this group has increased parents' children_in_excess
-         * when it got over the soft limit.
+	 * when it got over the soft limit.
 	 * When a group falls bellow the soft limit, parents' children_in_excess
 	 * is decreased and soft_contributed changed to false.
 	 */
@@ -836,12 +836,12 @@ static bool mem_cgroup_event_ratelimit(s
 }
 
 /*
- * Called from rate-limitted memcg_check_events when enough
+ * Called from rate-limited memcg_check_events when enough
  * MEM_CGROUP_TARGET_SOFTLIMIT events are accumulated and it makes sure
- * that all the parents up the hierarchy will be noticed that this group
+ * that all the parents up the hierarchy will be notified that this group
  * is in excess or that it is not in excess anymore. mmecg->soft_contributed
  * makes the transition a single action whenever the state flips from one to
- * other.
+ * the other.
  */
 static void mem_cgroup_update_soft_limit(struct mem_cgroup *memcg)
 {
@@ -974,7 +974,7 @@ static struct mem_cgroup *__mem_cgroup_i
 	 * explicit visit.
 	 */
 	if (!last_visited) {
-		switch(mem_cgroup_filter(root, root, cond)) {
+		switch (mem_cgroup_filter(root, root, cond)) {
 		case VISIT:
 			return root;
 		case SKIP:
@@ -1905,8 +1905,8 @@ int mem_cgroup_select_victim_node(struct
 /*
  * A group is eligible for the soft limit reclaim under the given root
  * hierarchy if
- * 	a) it is over its soft limit
- * 	b) any parent up the hierarchy is over its soft limit
+ *	a) it is over its soft limit
+ *	b) any parent up the hierarchy is over its soft limit
  *
  * If the given group doesn't have any children over the limit then it
  * doesn't make any sense to iterate its subtree.
@@ -1928,7 +1928,7 @@ mem_cgroup_soft_reclaim_eligible(struct
 	 * If any parent up to the root in the hierarchy is over its soft limit
 	 * then we have to obey and reclaim from this group as well.
 	 */
-	while((parent = parent_mem_cgroup(parent))) {
+	while ((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
 			return VISIT;
 		if (parent == root)
@@ -2333,7 +2333,7 @@ static void drain_all_stock(struct mem_c
 			flush_work(&stock->work);
 	}
 out:
- 	put_online_cpus();
+	put_online_cpus();
 }
 
 /*
@@ -2765,7 +2765,7 @@ static void __mem_cgroup_commit_charge(s
 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
 	 * before USED bit, we need memory barrier here.
 	 * See mem_cgroup_add_lru_list(), etc.
- 	 */
+	 */
 	smp_wmb();
 	SetPageCgroupUsed(pc);
 
@@ -3504,9 +3504,9 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	 * the page allocator. Therefore, the following sequence when backed by
 	 * the SLUB allocator:
 	 *
-	 * 	memcg_stop_kmem_account();
-	 * 	kmalloc(<large_number>)
-	 * 	memcg_resume_kmem_account();
+	 *	memcg_stop_kmem_account();
+	 *	kmalloc(<large_number>)
+	 *	memcg_resume_kmem_account();
 	 *
 	 * would effectively ignore the fact that we should skip accounting,
 	 * since it will drive us directly to this function without passing
@@ -4535,7 +4535,7 @@ static int mem_cgroup_resize_limit(struc
 				   MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
-  		if (curusage >= oldusage)
+ 		if (curusage >= oldusage)
 			retry_count--;
 		else
 			oldusage = curusage;
@@ -4556,7 +4556,7 @@ static int mem_cgroup_resize_memsw_limit
 	int enlarge = 0;
 
 	/* see mem_cgroup_resize_res_limit */
- 	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
+	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
 	oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 	while (retry_count) {
 		if (signal_pending(current)) {
diff -puN mm/vmscan.c~memcg-trivial-cleanups mm/vmscan.c
--- a/mm/vmscan.c~memcg-trivial-cleanups
+++ a/mm/vmscan.c
@@ -2186,12 +2186,12 @@ static void shrink_zone(struct zone *zon
 
 	scanned_groups = __shrink_zone(zone, sc, do_soft_reclaim);
 	/*
-         * memcg iterator might race with other reclaimer or start from
-         * a incomplete tree walk so the tree walk in __shrink_zone
-         * might have missed groups that are above the soft limit. Try
-         * another loop to catch up with others. Do it just once to
-         * prevent from reclaim latencies when other reclaimers always
-         * preempt this one.
+	 * memcg iterator might race with other reclaimer or start from
+	 * a incomplete tree walk so the tree walk in __shrink_zone
+	 * might have missed groups that are above the soft limit. Try
+	 * another loop to catch up with others. Do it just once to
+	 * prevent from reclaim latencies when other reclaimers always
+	 * preempt this one.
 	 */
 	if (do_soft_reclaim && !scanned_groups)
 		__shrink_zone(zone, sc, do_soft_reclaim);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

