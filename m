From: akpm@linux-foundation.org
Subject: [merged]
 memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:02 -0700
Message-ID: <52336f3a./wQ01hJn6CWz+BDT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3IMUCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, glommer@gmail.com, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:02 -0700


The patch titled
     Subject: memcg, vmscan: integrate soft reclaim tighter with zone shrinking code
has been removed from the -mm tree.  Its filename was
     memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, vmscan: integrate soft reclaim tighter with zone shrinking code

This patchset is sitting out of tree for quite some time without any
objections.  I would be really happy if it made it into 3.12.  I do not
want to push it too hard but I think this work is basically ready and
waiting more doesn't help.

The basic idea is quite simple.  Pull soft reclaim into shrink_zone in the
first step and get rid of the previous soft reclaim infrastructure. 
shrink_zone is done in two passes now.  First it tries to do the soft
limit reclaim and it falls back to reclaim-all mode if no group is over
the limit or no pages have been scanned.  The second pass happens at the
same priority so the only time we waste is the memcg tree walk which has
been updated in the third step to have only negligible overhead.

As a bonus we will get rid of a _lot_ of code by this and soft reclaim
will not stand out like before when it wasn't integrated into the zone
shrinking code and it reclaimed at priority 0 (the testing results show
that some workloads suffers from such an aggressive reclaim).  The clean
up is in a separate patch because I felt it would be easier to review that
way.

The second step is soft limit reclaim integration into targeted reclaim. 
It should be rather straight forward.  Soft limit has been used only for
the global reclaim so far but it makes sense for any kind of pressure
coming from up-the-hierarchy, including targeted reclaim.

The third step (patches 4-8) addresses the tree walk overhead by enhancing
memcg iterators to enable skipping whole subtrees and tracking number of
over soft limit children at each level of the hierarchy.  This information
is updated same way the old soft limit tree was updated (from
memcg_check_events) so we shouldn't see an additional overhead.  In fact
mem_cgroup_update_soft_limit is much simpler than tree manipulation done
previously.

__shrink_zone uses mem_cgroup_soft_reclaim_eligible as a predicate for
mem_cgroup_iter so the decision whether a particular group should be
visited is done at the iterator level which allows us to decide to skip
the whole subtree as well (if there is no child in excess).  This reduces
the tree walk overhead considerably.

* TEST 1
========

My primary test case was a parallel kernel build with 2 groups (make is
running with -j8 with a distribution .config in a separate cgroup without
any hard limit) on a 32 CPU machine booted with 1GB memory and both builds
run taskset to Node 0 cpus.

I was mostly interested in 2 setups.  Default - no soft limit set and -
and 0 soft limit set to both groups.  The first one should tell us whether
the rework regresses the default behavior while the second one should show
us improvements in an extreme case where both workloads are always over
the soft limit.

/usr/bin/time -v has been used to collect the statistics and each
configuration had 3 runs after fresh boot without any other load on the
system.

base is mmotm-2013-07-18-16-40
rework all 8 patches applied on top of base

* No-limit
User
no-limit/base: min: 651.92 max: 672.65 avg: 664.33 std: 8.01 runs: 6
no-limit/rework: min: 657.34 [100.8%] max: 668.39 [99.4%] avg: 663.13 [99.8%] std: 3.61 runs: 6
System
no-limit/base: min: 69.33 max: 71.39 avg: 70.32 std: 0.79 runs: 6
no-limit/rework: min: 69.12 [99.7%] max: 71.05 [99.5%] avg: 70.04 [99.6%] std: 0.59 runs: 6
Elapsed
no-limit/base: min: 398.27 max: 422.36 avg: 408.85 std: 7.74 runs: 6
no-limit/rework: min: 386.36 [97.0%] max: 438.40 [103.8%] avg: 416.34 [101.8%] std: 18.85 runs: 6

The results are within noise. Elapsed time has a bigger variance but the
average looks good.

* 0-limit
User
0-limit/base: min: 573.76 max: 605.63 avg: 585.73 std: 12.21 runs: 6
0-limit/rework: min: 645.77 [112.6%] max: 666.25 [110.0%] avg: 656.97 [112.2%] std: 7.77 runs: 6
System
0-limit/base: min: 69.57 max: 71.13 avg: 70.29 std: 0.54 runs: 6
0-limit/rework: min: 68.68 [98.7%] max: 71.40 [100.4%] avg: 69.91 [99.5%] std: 0.87 runs: 6
Elapsed
0-limit/base: min: 1306.14 max: 1550.17 avg: 1430.35 std: 90.86 runs: 6
0-limit/rework: min: 404.06 [30.9%] max: 465.94 [30.1%] avg: 434.81 [30.4%] std: 22.68 runs: 6

The improvement is really huge here (even bigger than with my previous
testing and I suspect that this highly depends on the storage).  Page
fault statistics tell us at least part of the story:

Minor
0-limit/base: min: 37180461.00 max: 37319986.00 avg: 37247470.00 std: 54772.71 runs: 6
0-limit/rework: min: 36751685.00 [98.8%] max: 36805379.00 [98.6%] avg: 36774506.33 [98.7%] std: 17109.03 runs: 6
Major
0-limit/base: min: 170604.00 max: 221141.00 avg: 196081.83 std: 18217.01 runs: 6
0-limit/rework: min: 2864.00 [1.7%] max: 10029.00 [4.5%] avg: 5627.33 [2.9%] std: 2252.71 runs: 6

Same as with my previous testing Minor faults are more or less within
noise but Major fault count is way bellow the base kernel.

While this looks as a nice win it is fair to say that 0-limit
configuration is quite artificial. So I was playing with 0-no-limit
loads as well.

* TEST 2
========

The following results are from 2 groups configuration on a 16GB machine
(single NUMA node).

- A running stream IO (dd if=/dev/zero of=local.file bs=1024) with
  2*TotalMem with 0 soft limit.
- B running a mem_eater which consumes TotalMem-1G without any limit. The
  mem_eater consumes the memory in 100 chunks with 1s nap after each
  mmap+poppulate so that both loads have chance to fight for the memory.

The expected result is that B shouldn't be reclaimed and A shouldn't see
a big dropdown in elapsed time.

User
base: min: 2.68 max: 2.89 avg: 2.76 std: 0.09 runs: 3
rework: min: 3.27 [122.0%] max: 3.74 [129.4%] avg: 3.44 [124.6%] std: 0.21 runs: 3
System
base: min: 86.26 max: 88.29 avg: 87.28 std: 0.83 runs: 3
rework: min: 81.05 [94.0%] max: 84.96 [96.2%] avg: 83.14 [95.3%] std: 1.61 runs: 3
Elapsed
base: min: 317.28 max: 332.39 avg: 325.84 std: 6.33 runs: 3
rework: min: 281.53 [88.7%] max: 298.16 [89.7%] avg: 290.99 [89.3%] std: 6.98 runs: 3

System time improved slightly as well as Elapsed. My previous testing
has shown worse numbers but this again seem to depend on the storage
speed.

My theory is that the writeback doesn't catch up and prio-0 soft reclaim
falls into wait on writeback page too often in the base kernel. The
patched kernel doesn't do that because the soft reclaim is done from the
kswapd/direct reclaim context. This can be seen on the following graph
nicely. The A's group usage_in_bytes regurarly drops really low very often.

All 3 runs
http://labs.suse.cz/mhocko/soft_limit_rework/stream_io-vs-mem_eater/stream.png
resp. a detail of the single run
http://labs.suse.cz/mhocko/soft_limit_rework/stream_io-vs-mem_eater/stream-one-run.png

mem_eater seems to be doing better as well. It gets to the full
allocation size faster as can be seen on the following graph:
http://labs.suse.cz/mhocko/soft_limit_rework/stream_io-vs-mem_eater/mem_eater-one-run.png

/proc/meminfo collected during the test also shows that rework kernel
hasn't swapped that much (well almost not at all):
base: max: 123900 K avg: 56388.29 K
rework: max: 300 K avg: 128.68 K

kswapd and direct reclaim statistics are of no use unfortunatelly because
soft reclaim is not accounted properly as the counters are hidden by
global_reclaim() checks in the base kernel.

* TEST 3
========

Another test was the same configuration as TEST2 except the stream IO was
replaced by a single kbuild (16 parallel jobs bound to Node0 cpus same as
in TEST1) and mem_eater allocated TotalMem-200M so kbuild had only 200MB
left.

Kbuild did better with the rework kernel here as well:
User
base: min: 860.28 max: 872.86 avg: 868.03 std: 5.54 runs: 3
rework: min: 880.81 [102.4%] max: 887.45 [101.7%] avg: 883.56 [101.8%] std: 2.83 runs: 3
System
base: min: 84.35 max: 85.06 avg: 84.79 std: 0.31 runs: 3
rework: min: 85.62 [101.5%] max: 86.09 [101.2%] avg: 85.79 [101.2%] std: 0.21 runs: 3
Elapsed
base: min: 135.36 max: 243.30 avg: 182.47 std: 45.12 runs: 3
rework: min: 110.46 [81.6%] max: 116.20 [47.8%] avg: 114.15 [62.6%] std: 2.61 runs: 3
Minor
base: min: 36635476.00 max: 36673365.00 avg: 36654812.00 std: 15478.03 runs: 3
rework: min: 36639301.00 [100.0%] max: 36695541.00 [100.1%] avg: 36665511.00 [100.0%] std: 23118.23 runs: 3
Major
base: min: 14708.00 max: 53328.00 avg: 31379.00 std: 16202.24 runs: 3
rework: min: 302.00 [2.1%] max: 414.00 [0.8%] avg: 366.33 [1.2%] std: 47.22 runs: 3

Again we can see a significant improvement in Elapsed (it also seems to
be more stable), there is a huge dropdown for the Major page faults and
much more swapping:
base: max: 583736 K avg: 112547.43 K
rework: max: 4012 K avg: 124.36 K

Graphs from all three runs show the variability of the kbuild quite
nicely.  It even seems that it took longer after every run with the base
kernel which would be quite surprising as the source tree for the build is
removed and caches are dropped after each run so the build operates on a
freshly extracted sources everytime. 
http://labs.suse.cz/mhocko/soft_limit_rework/stream_io-vs-mem_eater/kbuild-mem_eater.png

My other testing shows that this is just a matter of timing and other runs
behave differently the std for Elapsed time is similar ~50.  Example of
other three runs:
http://labs.suse.cz/mhocko/soft_limit_rework/stream_io-vs-mem_eater/kbuild-mem_eater2.png

So to wrap this up.  The series is still doing good and improves the soft
limit.

The testing results for bunch of cgroups with both stream IO and kbuild
loads can be found in "memcg: track children in soft limit excess to
improve soft limit".



This patch:

Memcg soft reclaim has been traditionally triggered from the global
reclaim paths before calling shrink_zone.  mem_cgroup_soft_limit_reclaim
then picked up a group which exceeds the soft limit the most and reclaimed
it with 0 priority to reclaim at least SWAP_CLUSTER_MAX pages.

The infrastructure requires per-node-zone trees which hold over-limit
groups and keep them up-to-date (via memcg_check_events) which is not cost
free.  Although this overhead hasn't turned out to be a bottle neck the
implementation is suboptimal because mem_cgroup_update_tree has no idea
which zones consumed memory over the limit so we could easily end up
having a group on a node-zone tree having only few pages from that
node-zone.

This patch doesn't try to fix node-zone trees management because it seems
that integrating soft reclaim into zone shrinking sounds much easier and
more appropriate for several reasons.  First of all 0 priority reclaim was
a crude hack which might lead to big stalls if the group's LRUs are big
and hard to reclaim (e.g.  a lot of dirty/writeback pages).  Soft reclaim
should be applicable also to the targeted reclaim which is awkward right
now without additional hacks.  Last but not least the whole infrastructure
eats quite some code.

After this patch shrink_zone is done in 2 passes.  First it tries to do
the soft reclaim if appropriate (only for global reclaim for now to keep
compatible with the original state) and fall back to ignoring soft limit
if no group is eligible to soft reclaim or nothing has been scanned during
the first pass.  Only groups which are over their soft limit or any of
their parents up the hierarchy is over the limit are considered eligible
during the first pass.

Soft limit tree which is not necessary anymore will be removed in the
follow up patch to make this patch smaller and easier to review.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 --
 mm/memcontrol.c            |  161 ++++-------------------------------
 mm/vmscan.c                |   62 +++++++------
 3 files changed, 59 insertions(+), 174 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/include/linux/memcontrol.h
@@ -180,9 +180,7 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask,
-						unsigned long *total_scanned);
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
@@ -359,11 +357,9 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
 {
-	return 0;
+	return false;
 }
 
 static inline void mem_cgroup_split_huge_fixup(struct page *head)
diff -puN mm/memcontrol.c~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/mm/memcontrol.c
@@ -2004,57 +2004,28 @@ static bool mem_cgroup_reclaimable(struc
 }
 #endif
 
-static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
-				   struct zone *zone,
-				   gfp_t gfp_mask,
-				   unsigned long *total_scanned)
+/*
+ * A group is eligible for the soft limit reclaim if it is
+ * 	a) is over its soft limit
+ * 	b) any parent up the hierarchy is over its soft limit
+ */
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *victim = NULL;
-	int total = 0;
-	int loop = 0;
-	unsigned long excess;
-	unsigned long nr_scanned;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.zone = zone,
-		.priority = 0,
-	};
-
-	excess = res_counter_soft_limit_excess(&root_memcg->res) >> PAGE_SHIFT;
-
-	while (1) {
-		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
-		if (!victim) {
-			loop++;
-			if (loop >= 2) {
-				/*
-				 * If we have not been able to reclaim
-				 * anything, it might because there are
-				 * no reclaimable pages under this hierarchy
-				 */
-				if (!total)
-					break;
-				/*
-				 * We want to do more targeted reclaim.
-				 * excess >> 2 is not to excessive so as to
-				 * reclaim too much, nor too less that we keep
-				 * coming back to reclaim from this cgroup
-				 */
-				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
-					break;
-			}
-			continue;
-		}
-		if (!mem_cgroup_reclaimable(victim, false))
-			continue;
-		total += mem_cgroup_shrink_node_zone(victim, gfp_mask, false,
-						     zone, &nr_scanned);
-		*total_scanned += nr_scanned;
-		if (!res_counter_soft_limit_excess(&root_memcg->res))
-			break;
+	struct mem_cgroup *parent = memcg;
+
+	if (res_counter_soft_limit_excess(&memcg->res))
+		return true;
+
+	/*
+	 * If any parent up the hierarchy is over its soft limit then we
+	 * have to obey and reclaim from this group as well.
+	 */
+	while((parent = parent_mem_cgroup(parent))) {
+		if (res_counter_soft_limit_excess(&parent->res))
+			return true;
 	}
-	mem_cgroup_iter_break(root_memcg, victim);
-	return total;
+
+	return false;
 }
 
 /*
@@ -4727,98 +4698,6 @@ static int mem_cgroup_resize_memsw_limit
 	return ret;
 }
 
-unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
-{
-	unsigned long nr_reclaimed = 0;
-	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
-	unsigned long reclaimed;
-	int loop = 0;
-	struct mem_cgroup_tree_per_zone *mctz;
-	unsigned long long excess;
-	unsigned long nr_scanned;
-
-	if (order > 0)
-		return 0;
-
-	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
-	/*
-	 * This loop can run a while, specially if mem_cgroup's continuously
-	 * keep exceeding their soft limit and putting the system under
-	 * pressure
-	 */
-	do {
-		if (next_mz)
-			mz = next_mz;
-		else
-			mz = mem_cgroup_largest_soft_limit_node(mctz);
-		if (!mz)
-			break;
-
-		nr_scanned = 0;
-		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, zone,
-						    gfp_mask, &nr_scanned);
-		nr_reclaimed += reclaimed;
-		*total_scanned += nr_scanned;
-		spin_lock(&mctz->lock);
-
-		/*
-		 * If we failed to reclaim anything from this memory cgroup
-		 * it is time to move on to the next cgroup
-		 */
-		next_mz = NULL;
-		if (!reclaimed) {
-			do {
-				/*
-				 * Loop until we find yet another one.
-				 *
-				 * By the time we get the soft_limit lock
-				 * again, someone might have aded the
-				 * group back on the RB tree. Iterate to
-				 * make sure we get a different mem.
-				 * mem_cgroup_largest_soft_limit_node returns
-				 * NULL if no other cgroup is present on
-				 * the tree
-				 */
-				next_mz =
-				__mem_cgroup_largest_soft_limit_node(mctz);
-				if (next_mz == mz)
-					css_put(&next_mz->memcg->css);
-				else /* next_mz == NULL or other memcg */
-					break;
-			} while (1);
-		}
-		__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
-		excess = res_counter_soft_limit_excess(&mz->memcg->res);
-		/*
-		 * One school of thought says that we should not add
-		 * back the node to the tree if reclaim returns 0.
-		 * But our reclaim could return 0, simply because due
-		 * to priority we are exposing a smaller subset of
-		 * memory to reclaim from. Consider this as a longer
-		 * term TODO.
-		 */
-		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz->memcg, mz, mctz, excess);
-		spin_unlock(&mctz->lock);
-		css_put(&mz->memcg->css);
-		loop++;
-		/*
-		 * Could not reclaim anything and there are no more
-		 * mem cgroups to try or we seem to be looping without
-		 * reclaiming anything.
-		 */
-		if (!nr_reclaimed &&
-			(next_mz == NULL ||
-			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
-			break;
-	} while (!nr_reclaimed);
-	if (next_mz)
-		css_put(&next_mz->memcg->css);
-	return nr_reclaimed;
-}
-
 /**
  * mem_cgroup_force_empty_list - clears LRU of a group
  * @memcg: group to clear
diff -puN mm/vmscan.c~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code
+++ a/mm/vmscan.c
@@ -139,11 +139,21 @@ static bool global_reclaim(struct scan_c
 {
 	return !sc->target_mem_cgroup;
 }
+
+static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
+{
+	return !mem_cgroup_disabled() && global_reclaim(sc);
+}
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
+
+static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
+{
+	return false;
+}
 #endif
 
 unsigned long zone_reclaimable_pages(struct zone *zone)
@@ -2130,7 +2140,8 @@ static inline bool should_continue_recla
 	}
 }
 
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
+static void
+__shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
 {
 	unsigned long nr_reclaimed, nr_scanned;
 
@@ -2149,6 +2160,12 @@ static void shrink_zone(struct zone *zon
 		do {
 			struct lruvec *lruvec;
 
+			if (soft_reclaim &&
+			    !mem_cgroup_soft_reclaim_eligible(memcg)) {
+				memcg = mem_cgroup_iter(root, memcg, &reclaim);
+				continue;
+			}
+
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2179,6 +2196,24 @@ static void shrink_zone(struct zone *zon
 					 sc->nr_scanned - nr_scanned, sc));
 }
 
+
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
+{
+	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
+	unsigned long nr_scanned = sc->nr_scanned;
+
+	__shrink_zone(zone, sc, do_soft_reclaim);
+
+	/*
+	 * No group is over the soft limit or those that are do not have
+	 * pages in the zone we are reclaiming so we have to reclaim everybody
+	 */
+	if (do_soft_reclaim && (sc->nr_scanned == nr_scanned)) {
+		__shrink_zone(zone, sc, false);
+		return;
+	}
+}
+
 /* Returns true if compaction should go ahead for a high-order request */
 static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 {
@@ -2240,8 +2275,6 @@ static bool shrink_zones(struct zonelist
 {
 	struct zoneref *z;
 	struct zone *zone;
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
 
 	/*
@@ -2281,18 +2314,6 @@ static bool shrink_zones(struct zonelist
 					continue;
 				}
 			}
-			/*
-			 * This steals pages from memory cgroups over softlimit
-			 * and returns the number of reclaimed pages and
-			 * scanned pages. This works for global memory pressure
-			 * and balancing, not for a memcg's limit.
-			 */
-			nr_soft_scanned = 0;
-			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
-						sc->order, sc->gfp_mask,
-						&nr_soft_scanned);
-			sc->nr_reclaimed += nr_soft_reclaimed;
-			sc->nr_scanned += nr_soft_scanned;
 			/* need some check for avoid more shrink_zone() */
 		}
 
@@ -2880,8 +2901,6 @@ static unsigned long balance_pgdat(pg_da
 {
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
-	unsigned long nr_soft_reclaimed;
-	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
@@ -2996,15 +3015,6 @@ static unsigned long balance_pgdat(pg_da
 
 			sc.nr_scanned = 0;
 
-			nr_soft_scanned = 0;
-			/*
-			 * Call soft limit reclaim before calling shrink_zone.
-			 */
-			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
-							order, sc.gfp_mask,
-							&nr_soft_scanned);
-			sc.nr_reclaimed += nr_soft_reclaimed;
