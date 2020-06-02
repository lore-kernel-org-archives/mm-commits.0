From: akpm@linux-foundation.org
Subject: [merged]
 mm-prepare-for-swap-over-high-accounting-and-penalty-calculation.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:40:51 -0700
Message-ID: <20200602214051.yW8tkH6Qg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgFBVkx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com, kuba@kernel.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org


The patch titled
     Subject: mm/memcg: prepare for swap over-high accounting and penalty calculation
has been removed from the -mm tree.  Its filename was
     mm-prepare-for-swap-over-high-accounting-and-penalty-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jakub Kicinski <kuba@kernel.org>
Subject: mm/memcg: prepare for swap over-high accounting and penalty calculation

Patch series "memcg: Slow down swap allocation as the available space gets
depleted", v6.

Tejun describes the problem as follows:

When swap runs out, there's an abrupt change in system behavior - the
anonymous memory suddenly becomes unmanageable which readily breaks any
sort of memory isolation and can bring down the whole system.  To avoid
that, oomd [1] monitors free swap space and triggers kills when it drops
below the specific threshold (e.g.  15%).

While this works, it's far from ideal:
 - Depending on IO performance and total swap size, a given
   headroom might not be enough or too much.
 - oomd has to monitor swap depletion in addition to the usual
   pressure metrics and it currently doesn't consider memory.swap.max.

Solve this by adapting parts of the approach that memory.high uses - slow
down allocation as the resource gets depleted turning the depletion
behavior from abrupt cliff one to gradual degradation observable through
memory pressure metric.

[1] https://github.com/facebookincubator/oomd


This patch (of 4):

Slice the memory overage calculation logic a little bit so we can reuse it
to apply a similar penalty to the swap.  The logic which accesses the
memory-specific fields (use and high values) has to be taken out of
calculate_high_delay().

Link: http://lkml.kernel.org/r/20200527195846.102707-1-kuba@kernel.org
Link: http://lkml.kernel.org/r/20200527195846.102707-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   62 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

--- a/mm/memcontrol.c~mm-prepare-for-swap-over-high-accounting-and-penalty-calculation
+++ a/mm/memcontrol.c
@@ -2321,41 +2321,48 @@ static void high_work_func(struct work_s
  #define MEMCG_DELAY_PRECISION_SHIFT 20
  #define MEMCG_DELAY_SCALING_SHIFT 14
 
-/*
- * Get the number of jiffies that we should penalise a mischievous cgroup which
- * is exceeding its memory.high by checking both it and its ancestors.
- */
-static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
-					  unsigned int nr_pages)
+static u64 calculate_overage(unsigned long usage, unsigned long high)
 {
-	unsigned long penalty_jiffies;
-	u64 max_overage = 0;
+	u64 overage;
 
-	do {
-		unsigned long usage, high;
-		u64 overage;
+	if (usage <= high)
+		return 0;
 
-		usage = page_counter_read(&memcg->memory);
-		high = READ_ONCE(memcg->high);
+	/*
+	 * Prevent division by 0 in overage calculation by acting as if
+	 * it was a threshold of 1 page
+	 */
+	high = max(high, 1UL);
 
-		if (usage <= high)
-			continue;
+	overage = usage - high;
+	overage <<= MEMCG_DELAY_PRECISION_SHIFT;
+	return div64_u64(overage, high);
+}
 
-		/*
-		 * Prevent division by 0 in overage calculation by acting as if
-		 * it was a threshold of 1 page
-		 */
-		high = max(high, 1UL);
-
-		overage = usage - high;
-		overage <<= MEMCG_DELAY_PRECISION_SHIFT;
-		overage = div64_u64(overage, high);
+static u64 mem_find_max_overage(struct mem_cgroup *memcg)
+{
+	u64 overage, max_overage = 0;
 
-		if (overage > max_overage)
-			max_overage = overage;
+	do {
+		overage = calculate_overage(page_counter_read(&memcg->memory),
+					    READ_ONCE(memcg->high));
+		max_overage = max(overage, max_overage);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
 
+	return max_overage;
+}
+
+/*
+ * Get the number of jiffies that we should penalise a mischievous cgroup which
+ * is exceeding its memory.high by checking both it and its ancestors.
+ */
+static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
+					  unsigned int nr_pages,
+					  u64 max_overage)
+{
+	unsigned long penalty_jiffies;
+
 	if (!max_overage)
 		return 0;
 
@@ -2411,7 +2418,8 @@ void mem_cgroup_handle_over_high(void)
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages);
+	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+					       mem_find_max_overage(memcg));
 
 	/*
 	 * Don't sleep if the amount of jiffies this memcg owes us is so low
_

Patches currently in -mm which might be from kuba@kernel.org are
