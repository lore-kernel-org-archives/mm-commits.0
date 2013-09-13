From: akpm@linux-foundation.org
Subject: [merged] memcg-trivial-cleanups.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:18 -0700
Message-ID: <52336f4a.lBrAJSs4vhYcDpNx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, akpm@linux-foundation.org

Subject: [merged] memcg-trivial-cleanups.patch removed from -mm tree
To: akpm@linux-foundation.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:18 -0700


The patch titled
     Subject: memcg: trivial cleanups
has been removed from the -mm tree.  Its filename was
     memcg-trivial-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg: trivial cleanups

Clean up some mess made by the "Soft limit rework" series, and a few other
things.

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 +++++++++++++++---------------
 mm/vmscan.c     |   12 ++++++------
 2 files changed, 21 insertions(+), 21 deletions(-)

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
@@ -835,12 +835,12 @@ static bool mem_cgroup_event_ratelimit(s
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
@@ -1881,8 +1881,8 @@ int mem_cgroup_select_victim_node(struct
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
@@ -1904,7 +1904,7 @@ mem_cgroup_soft_reclaim_eligible(struct
 	 * If any parent up to the root in the hierarchy is over its soft limit
 	 * then we have to obey and reclaim from this group as well.
 	 */
-	while((parent = parent_mem_cgroup(parent))) {
+	while ((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
 			return VISIT;
 		if (parent == root)
@@ -2309,7 +2309,7 @@ static void drain_all_stock(struct mem_c
 			flush_work(&stock->work);
 	}
 out:
- 	put_online_cpus();
+	put_online_cpus();
 }
 
 /*
@@ -2741,7 +2741,7 @@ static void __mem_cgroup_commit_charge(s
 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
 	 * before USED bit, we need memory barrier here.
 	 * See mem_cgroup_add_lru_list(), etc.
- 	 */
+	 */
 	smp_wmb();
 	SetPageCgroupUsed(pc);
 
@@ -3483,9 +3483,9 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
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
@@ -4514,7 +4514,7 @@ static int mem_cgroup_resize_limit(struc
 				   MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
-  		if (curusage >= oldusage)
+		if (curusage >= oldusage)
 			retry_count--;
 		else
 			oldusage = curusage;
@@ -4535,7 +4535,7 @@ static int mem_cgroup_resize_memsw_limit
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
@@ -2205,12 +2205,12 @@ static void shrink_zone(struct zone *zon
 
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

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
mm.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

