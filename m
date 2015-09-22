From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_read_stat-unsigned.patch added to -mm
 tree
Date: Tue, 22 Sep 2015 15:23:19 -0700
Message-ID: <5601d4d7.7iizUnEXBi0Slw1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbbIVWXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 18:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make mem_cgroup_read_stat() unsigned
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_read_stat-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-make-mem_cgroup_read_stat-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-make-mem_cgroup_read_stat-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: memcg: make mem_cgroup_read_stat() unsigned

mem_cgroup_read_stat() returns a page count by summing per cpu page
counters.  The summing is racy wrt. updates, so a transient negative sum
is possible.  Callers don't want negative values:

- mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.

- oom reports and memory.stat shouldn't show confusing negative usage.

- tree_usage() already avoids negatives.

Avoid returning negative page counts from mem_cgroup_read_stat() and
convert it to unsigned.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_read_stat-unsigned mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_read_stat-unsigned
+++ a/mm/memcontrol.c
@@ -644,12 +644,14 @@ mem_cgroup_largest_soft_limit_node(struc
 }
 
 /*
+ * Return page count for single (non recursive) @memcg.
+ *
  * Implementation Note: reading percpu statistics for memcg.
  *
  * Both of vmstat[] and percpu_counter has threshold and do periodic
  * synchronization to implement "quick" read. There are trade-off between
  * reading cost and precision of value. Then, we may have a chance to implement
- * a periodic synchronizion of counter in memcg's counter.
+ * a periodic synchronization of counter in memcg's counter.
  *
  * But this _read() function is used for user interface now. The user accounts
  * memory usage by memory cgroup and he _always_ requires exact value because
@@ -659,17 +661,24 @@ mem_cgroup_largest_soft_limit_node(struc
  *
  * If there are kernel internal actions which can make use of some not-exact
  * value, and reading all cpu value can be performance bottleneck in some
- * common workload, threashold and synchonization as vmstat[] should be
+ * common workload, threashold and synchronization as vmstat[] should be
  * implemented.
  */
-static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
-				 enum mem_cgroup_stat_index idx)
+static unsigned long
+mem_cgroup_read_stat(struct mem_cgroup *memcg, enum mem_cgroup_stat_index idx)
 {
 	long val = 0;
 	int cpu;
 
+	/* Per-cpu values can be negative, use a signed accumulator */
 	for_each_possible_cpu(cpu)
 		val += per_cpu(memcg->stat->count[idx], cpu);
+	/*
+	 * Summing races with updates, so val may be negative.  Avoid exposing
+	 * transient negative values.
+	 */
+	if (val < 0)
+		val = 0;
 	return val;
 }
 
@@ -1254,7 +1263,7 @@ void mem_cgroup_print_oom_info(struct me
 		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 				continue;
-			pr_cont(" %s:%ldKB", mem_cgroup_stat_names[i],
+			pr_cont(" %s:%luKB", mem_cgroup_stat_names[i],
 				K(mem_cgroup_read_stat(iter, i)));
 		}
 
@@ -2819,14 +2828,11 @@ static unsigned long tree_stat(struct me
 			       enum mem_cgroup_stat_index idx)
 {
 	struct mem_cgroup *iter;
-	long val = 0;
+	unsigned long val = 0;
 
-	/* Per-cpu values can be negative, use a signed accumulator */
 	for_each_mem_cgroup_tree(iter, memcg)
 		val += mem_cgroup_read_stat(iter, idx);
 
-	if (val < 0) /* race ? */
-		val = 0;
 	return val;
 }
 
@@ -3169,7 +3175,7 @@ static int memcg_stat_show(struct seq_fi
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
-		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
+		seq_printf(m, "%s %lu\n", mem_cgroup_stat_names[i],
 			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
 	}
 
@@ -3194,13 +3200,13 @@ static int memcg_stat_show(struct seq_fi
 			   (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
-		long long val = 0;
+		unsigned long long val = 0;
 
 		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 		for_each_mem_cgroup_tree(mi, memcg)
 			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
-		seq_printf(m, "total_%s %lld\n", mem_cgroup_stat_names[i], val);
+		seq_printf(m, "total_%s %llu\n", mem_cgroup_stat_names[i], val);
 	}
 
 	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-fix-dirty-page-migration.patch
memcg-make-mem_cgroup_read_stat-unsigned.patch

