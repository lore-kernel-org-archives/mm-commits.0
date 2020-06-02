From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 082/128] mm/memcg: automatically penalize tasks
 with high swap use
Date: Mon, 01 Jun 2020 21:49:52 -0700
Message-ID: <20200602044952.g4tpmtOiL%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEty (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:49:54 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, hannes@cmpxchg.org, hughd@google.com, kuba@kernel.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org

From: Jakub Kicinski <kuba@kernel.org>
Subject: mm/memcg: automatically penalize tasks with high swap use

Add a memory.swap.high knob, which can be used to protect the system from
SWAP exhaustion.  The mechanism used for penalizing is similar to
memory.high penalty (sleep on return to user space).

That is not to say that the knob itself is equivalent to memory.high.  The
objective is more to protect the system from potentially buggy tasks
consuming a lot of swap and impacting other tasks, or even bringing the
whole system to stand still with complete SWAP exhaustion.  Hopefully
without the need to find per-task hard limits.

Slowing misbehaving tasks down gradually allows user space oom killers or
other protection mechanisms to react.  oomd and earlyoom already do
killing based on swap exhaustion, and memory.swap.high protection will
help implement such userspace oom policies more reliably.

We can use one counter for number of pages allocated under pressure to
save struct task space and avoid two separate hierarchy walks on the hot
path.  The exact overage is calculated on return to user space, anyway.

Take the new high limit into account when determining if swap is "full". 
Borrowing the explanation from Johannes:

  The idea behind "swap full" is that as long as the workload has plenty
  of swap space available and it's not changing its memory contents, it
  makes sense to generously hold on to copies of data in the swap device,
  even after the swapin.  A later reclaim cycle can drop the page without
  any IO.  Trading disk space for IO.

  But the only two ways to reclaim a swap slot is when they're faulted
  in and the references go away, or by scanning the virtual address space
  like swapoff does - which is very expensive (one could argue it's too
  expensive even for swapoff, it's often more practical to just reboot).

  So at some point in the fill level, we have to start freeing up swap
  slots on fault/swapin.  Otherwise we could eventually run out of swap
  slots while they're filled with copies of data that is also in RAM.

  We don't want to OOM a workload because its available swap space is
  filled with redundant cache.

Link: http://lkml.kernel.org/r/20200527195846.102707-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   20 +++++
 include/linux/memcontrol.h              |    1 
 mm/memcontrol.c                         |   88 ++++++++++++++++++++--
 3 files changed, 102 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-automatically-penalize-tasks-with-high-swap-use
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1374,6 +1374,22 @@ PAGE_SIZE multiple when read back.
 	The total amount of swap currently being used by the cgroup
 	and its descendants.
 
+  memory.swap.high
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
+
+	Swap usage throttle limit.  If a cgroup's swap usage exceeds
+	this limit, all its further allocations will be throttled to
+	allow userspace to implement custom out-of-memory procedures.
+
+	This limit marks a point of no return for the cgroup. It is NOT
+	designed to manage the amount of swapping a workload does
+	during regular operation. Compare to memory.swap.max, which
+	prohibits swapping past a set amount, but lets the cgroup
+	continue unimpeded as long as other memory can be reclaimed.
+
+	Healthy workloads are not expected to reach this limit.
+
   memory.swap.max
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
@@ -1387,6 +1403,10 @@ PAGE_SIZE multiple when read back.
 	otherwise, a value change in this file generates a file
 	modified event.
 
+	  high
+		The number of times the cgroup's swap usage was over
+		the high threshold.
+
 	  max
 		The number of times the cgroup's swap usage was about
 		to go over the max boundary and swap allocation
--- a/include/linux/memcontrol.h~mm-automatically-penalize-tasks-with-high-swap-use
+++ a/include/linux/memcontrol.h
@@ -45,6 +45,7 @@ enum memcg_memory_event {
 	MEMCG_MAX,
 	MEMCG_OOM,
 	MEMCG_OOM_KILL,
+	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
 	MEMCG_NR_MEMORY_EVENTS,
--- a/mm/memcontrol.c~mm-automatically-penalize-tasks-with-high-swap-use
+++ a/mm/memcontrol.c
@@ -2354,6 +2354,22 @@ static u64 mem_find_max_overage(struct m
 	return max_overage;
 }
 
+static u64 swap_find_max_overage(struct mem_cgroup *memcg)
+{
+	u64 overage, max_overage = 0;
+
+	do {
+		overage = calculate_overage(page_counter_read(&memcg->swap),
+					    READ_ONCE(memcg->swap.high));
+		if (overage)
+			memcg_memory_event(memcg, MEMCG_SWAP_HIGH);
+		max_overage = max(overage, max_overage);
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
+
+	return max_overage;
+}
+
 /*
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
@@ -2415,6 +2431,9 @@ void mem_cgroup_handle_over_high(void)
 	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
 					       mem_find_max_overage(memcg));
 
+	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+						swap_find_max_overage(memcg));
+
 	/*
 	 * Clamp the max delay per usermode return so as to still keep the
 	 * application moving forwards and also permit diagnostics, albeit
@@ -2605,13 +2624,32 @@ done_restock:
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) >
-		    READ_ONCE(memcg->memory.high)) {
-			/* Don't bother a random interrupted task */
-			if (in_interrupt()) {
+		bool mem_high, swap_high;
+
+		mem_high = page_counter_read(&memcg->memory) >
+			READ_ONCE(memcg->memory.high);
+		swap_high = page_counter_read(&memcg->swap) >
+			READ_ONCE(memcg->swap.high);
+
+		/* Don't bother a random interrupted task */
+		if (in_interrupt()) {
+			if (mem_high) {
 				schedule_work(&memcg->high_work);
 				break;
 			}
+			continue;
+		}
+
+		if (mem_high || swap_high) {
+			/*
+			 * The allocating tasks in this cgroup will need to do
+			 * reclaim or be throttled to prevent further growth
+			 * of the memory or swap footprints.
+			 *
+			 * Target some best-effort fairness between the tasks,
+			 * and distribute reclaim work and delay penalties
+			 * based on how much each task is actually allocating.
+			 */
 			current->memcg_nr_pages_over_high += batch;
 			set_notify_resume(current);
 			break;
@@ -5076,6 +5114,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
@@ -5229,6 +5268,7 @@ static void mem_cgroup_css_reset(struct
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
 
@@ -7142,10 +7182,13 @@ bool mem_cgroup_swap_full(struct page *p
 	if (!memcg)
 		return false;
 
-	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
-		if (page_counter_read(&memcg->swap) * 2 >=
-		    READ_ONCE(memcg->swap.max))
+	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
+		unsigned long usage = page_counter_read(&memcg->swap);
+
+		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
+		    usage * 2 >= READ_ONCE(memcg->swap.max))
 			return true;
+	}
 
 	return false;
 }
@@ -7175,6 +7218,29 @@ static u64 swap_current_read(struct cgro
 	return (u64)page_counter_read(&memcg->swap) * PAGE_SIZE;
 }
 
+static int swap_high_show(struct seq_file *m, void *v)
+{
+	return seq_puts_memcg_tunable(m,
+		READ_ONCE(mem_cgroup_from_seq(m)->swap.high));
+}
+
+static ssize_t swap_high_write(struct kernfs_open_file *of,
+			       char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long high;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "max", &high);
+	if (err)
+		return err;
+
+	page_counter_set_high(&memcg->swap, high);
+
+	return nbytes;
+}
+
 static int swap_max_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -7202,6 +7268,8 @@ static int swap_events_show(struct seq_f
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
+	seq_printf(m, "high %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]));
 	seq_printf(m, "max %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
 	seq_printf(m, "fail %lu\n",
@@ -7217,6 +7285,12 @@ static struct cftype swap_files[] = {
 		.read_u64 = swap_current_read,
 	},
 	{
+		.name = "swap.high",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_high_show,
+		.write = swap_high_write,
+	},
+	{
 		.name = "swap.max",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = swap_max_show,
_
