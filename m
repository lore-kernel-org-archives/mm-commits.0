From: akpm@linux-foundation.org
Subject: + memcg-simplify-the-way-memory-limits-are-checked.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:25:04 -0800
Message-ID: <201102032325.p13NP4Jp030977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab1BCXZv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:25:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: simplify the way memory limits are checked
has been added to the -mm tree.  Its filename is
     memcg-simplify-the-way-memory-limits-are-checked.patch

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
Subject: memcg: simplify the way memory limits are checked
From: Johannes Weiner <hannes@cmpxchg.org>

Since transparent huge pages, checking whether memory cgroups are below
their limits is no longer enough, but the actual amount of chargeable
space is important.

To not have more than one limit-checking interface, replace
memory_cgroup_check_under_limit() and memory_cgroup_check_margin() with a
single memory_cgroup_margin() that returns the chargeable space and leaves
the comparison to the callsite.

Soft limits are now checked the other way round, by using the already
existing function that returns the amount by which soft limits are
exceeded: res_counter_soft_limit_excess().

Also remove all the corresponding functions on the res_counter side that
are now no longer used.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   72 ++++++----------------------------
 mm/memcontrol.c             |   49 ++++++++---------------
 2 files changed, 31 insertions(+), 90 deletions(-)

diff -puN include/linux/res_counter.h~memcg-simplify-the-way-memory-limits-are-checked include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-simplify-the-way-memory-limits-are-checked
+++ a/include/linux/res_counter.h
@@ -129,20 +129,22 @@ int __must_check res_counter_charge(stru
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
-static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
-{
-	if (cnt->usage < cnt->limit)
-		return true;
-
-	return false;
-}
-
-static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
+/**
+ * res_counter_margin - calculate chargeable space of a counter
+ * @cnt: the counter
+ *
+ * Returns the difference between the hard limit and the current usage
+ * of resource counter @cnt.
+ */
+static inline unsigned long long res_counter_margin(struct res_counter *cnt)
 {
-	if (cnt->usage <= cnt->soft_limit)
-		return true;
+	unsigned long long margin;
+	unsigned long flags;
 
-	return false;
+	spin_lock_irqsave(&cnt->lock, flags);
+	margin = cnt->limit - cnt->usage;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return margin;
 }
 
 /**
@@ -167,52 +169,6 @@ res_counter_soft_limit_excess(struct res
 	return excess;
 }
 
-/*
- * Helper function to detect if the cgroup is within it's limit or
- * not. It's currently called from cgroup_rss_prepare()
- */
-static inline bool res_counter_check_under_limit(struct res_counter *cnt)
-{
-	bool ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cnt->lock, flags);
-	ret = res_counter_limit_check_locked(cnt);
-	spin_unlock_irqrestore(&cnt->lock, flags);
-	return ret;
-}
-
-/**
- * res_counter_check_margin - check if the counter allows charging
- * @cnt: the resource counter to check
- * @bytes: the number of bytes to check the remaining space against
- *
- * Returns a boolean value on whether the counter can be charged
- * @bytes or whether this would exceed the limit.
- */
-static inline bool res_counter_check_margin(struct res_counter *cnt,
-					    unsigned long bytes)
-{
-	bool ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cnt->lock, flags);
-	ret = cnt->limit - cnt->usage >= bytes;
-	spin_unlock_irqrestore(&cnt->lock, flags);
-	return ret;
-}
-
-static inline bool res_counter_check_within_soft_limit(struct res_counter *cnt)
-{
-	bool ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cnt->lock, flags);
-	ret = res_counter_soft_limit_check_locked(cnt);
-	spin_unlock_irqrestore(&cnt->lock, flags);
-	return ret;
-}
-
 static inline void res_counter_reset_max(struct res_counter *cnt)
 {
 	unsigned long flags;
diff -puN mm/memcontrol.c~memcg-simplify-the-way-memory-limits-are-checked mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-the-way-memory-limits-are-checked
+++ a/mm/memcontrol.c
@@ -504,11 +504,6 @@ static void mem_cgroup_remove_from_trees
 	}
 }
 
-static inline unsigned long mem_cgroup_get_excess(struct mem_cgroup *mem)
-{
-	return res_counter_soft_limit_excess(&mem->res) >> PAGE_SHIFT;
-}
-
 static struct mem_cgroup_per_zone *
 __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
 {
@@ -1101,33 +1096,21 @@ unsigned long mem_cgroup_isolate_pages(u
 #define mem_cgroup_from_res_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
-static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
-{
-	if (do_swap_account) {
-		if (res_counter_check_under_limit(&mem->res) &&
-			res_counter_check_under_limit(&mem->memsw))
-			return true;
-	} else
-		if (res_counter_check_under_limit(&mem->res))
-			return true;
-	return false;
-}
-
 /**
- * mem_cgroup_check_margin - check if the memory cgroup allows charging
- * @mem: memory cgroup to check
- * @bytes: the number of bytes the caller intends to charge
+ * mem_cgroup_margin - calculate chargeable space of a memory cgroup
+ * @mem: the memory cgroup
  *
- * Returns a boolean value on whether @mem can be charged @bytes or
- * whether this would exceed the limit.
+ * Returns the maximum amount of memory @mem can be charged with, in
+ * bytes.
  */
-static bool mem_cgroup_check_margin(struct mem_cgroup *mem, unsigned long bytes)
+static unsigned long long mem_cgroup_margin(struct mem_cgroup *mem)
 {
-	if (!res_counter_check_margin(&mem->res, bytes))
-		return false;
-	if (do_swap_account && !res_counter_check_margin(&mem->memsw, bytes))
-		return false;
-	return true;
+	unsigned long long margin;
+
+	margin = res_counter_margin(&mem->res);
+	if (do_swap_account)
+		margin = min(margin, res_counter_margin(&mem->memsw));
+	return margin;
 }
 
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
@@ -1394,7 +1377,9 @@ static int mem_cgroup_hierarchical_recla
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
-	unsigned long excess = mem_cgroup_get_excess(root_mem);
+	unsigned long excess;
+
+	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
 	if (root_mem->memsw_is_minimum)
@@ -1451,9 +1436,9 @@ static int mem_cgroup_hierarchical_recla
 			return ret;
 		total += ret;
 		if (check_soft) {
-			if (res_counter_check_within_soft_limit(&root_mem->res))
+			if (!res_counter_soft_limit_excess(&root_mem->res))
 				return total;
-		} else if (mem_cgroup_check_under_limit(root_mem))
+		} else if (mem_cgroup_margin(root_mem))
 			return 1 + total;
 	}
 	return total;
@@ -1872,7 +1857,7 @@ static int __mem_cgroup_do_charge(struct
 
 	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
 					      gfp_mask, flags);
-	if (mem_cgroup_check_margin(mem_over_limit, csize))
+	if (mem_cgroup_margin(mem_over_limit) >= csize)
 		return CHARGE_RETRY;
 	/*
 	 * Even though the limit is exceeded at this point, reclaim
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

