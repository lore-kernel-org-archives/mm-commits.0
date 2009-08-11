From: akpm@linux-foundation.org
Subject: + memcg-improve-resource-counter-scalability.patch added to -mm tree
Date: Tue, 11 Aug 2009 16:24:41 -0700
Message-ID: <200908112324.n7BNOffw021539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbZHKXZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 19:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, prarit@redhat.com


The patch titled
     memcg: improve resource counter scalability
has been added to the -mm tree.  Its filename is
     memcg-improve-resource-counter-scalability.patch

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
Subject: memcg: improve resource counter scalability
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Reduce the resource counter overhead (mostly spinlock) associated with the
root cgroup.  This is a part of the several patches to reduce mem cgroup
overhead.  I had posted other approaches earlier (including using percpu
counters).  Those patches will be a natural addition and will be added
iteratively on top of these.

The patch stops resource counter accounting for the root cgroup.  The data
for display is derived from the statisitcs we maintain via
mem_cgroup_charge_statistics (which is more scalable).

The tests results I see on a 24 way show that

1. The lock contention disappears from /proc/lock_stats
2. The results of the test are comparable to running with
   cgroup_disable=memory.

Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   89 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~memcg-improve-resource-counter-scalability mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-resource-counter-scalability
+++ a/mm/memcontrol.c
@@ -70,6 +70,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
+	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -478,6 +479,19 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+static void mem_cgroup_swap_statistics(struct mem_cgroup *mem,
+					 bool charge)
+{
+	int val = (charge)? 1 : -1;
+	struct mem_cgroup_stat *stat = &mem->stat;
+	struct mem_cgroup_stat_cpu *cpustat;
+	int cpu = get_cpu();
+
+	cpustat = &stat->cpustat[cpu];
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SWAPOUT, val);
+	put_cpu();
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
@@ -1281,9 +1295,11 @@ static int __mem_cgroup_try_charge(struc
 	VM_BUG_ON(css_is_removed(&mem->css));
 
 	while (1) {
-		int ret;
+		int ret = 0;
 		unsigned long flags = 0;
 
+		if (mem_cgroup_is_root(mem))
+			goto done;
 		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
 						&soft_fail_res);
 		if (likely(!ret)) {
@@ -1343,6 +1359,7 @@ static int __mem_cgroup_try_charge(struc
 		if (mem_cgroup_soft_limit_check(mem_over_soft_limit))
 			mem_cgroup_update_tree(mem_over_soft_limit, page);
 	}
+done:
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -1415,9 +1432,12 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+		if (!mem_cgroup_is_root(mem)) {
+			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+			if (do_swap_account)
+				res_counter_uncharge(&mem->memsw, PAGE_SIZE,
+							NULL);
+		}
 		css_put(&mem->css);
 		return;
 	}
@@ -1494,7 +1514,8 @@ static int mem_cgroup_move_account(struc
 	if (pc->mem_cgroup != from)
 		goto out;
 
-	res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(from))
+		res_counter_uncharge(&from->res, PAGE_SIZE, NULL);
 	mem_cgroup_charge_statistics(from, pc, false);
 
 	page = pc->page;
@@ -1513,7 +1534,7 @@ static int mem_cgroup_move_account(struc
 						1);
 	}
 
-	if (do_swap_account)
+	if (do_swap_account && !mem_cgroup_is_root(from))
 		res_counter_uncharge(&from->memsw, PAGE_SIZE, NULL);
 	css_put(&from->css);
 
@@ -1584,9 +1605,11 @@ uncharge:
 	/* drop extra refcnt by try_charge() */
 	css_put(&parent->css);
 	/* uncharge if move fails */
-	res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
-	if (do_swap_account)
-		res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(parent)) {
+		res_counter_uncharge(&parent->res, PAGE_SIZE, NULL);
+		if (do_swap_account)
+			res_counter_uncharge(&parent->memsw, PAGE_SIZE, NULL);
+	}
 	return ret;
 }
 
@@ -1775,7 +1798,10 @@ __mem_cgroup_commit_charge_swapin(struct
 			 * This recorded memcg can be obsolete one. So, avoid
 			 * calling css_tryget
 			 */
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+			if (!mem_cgroup_is_root(memcg))
+				res_counter_uncharge(&memcg->memsw, PAGE_SIZE,
+							NULL);
+			mem_cgroup_swap_statistics(memcg, false);
 			mem_cgroup_put(memcg);
 		}
 		rcu_read_unlock();
@@ -1800,9 +1826,11 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-	if (do_swap_account)
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(mem)) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
+		if (do_swap_account)
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	}
 	css_put(&mem->css);
 }
 
@@ -1855,9 +1883,14 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
-	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	if (!mem_cgroup_is_root(mem)) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
+		if (do_swap_account &&
+				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
+	}
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT && mem_cgroup_is_root(mem))
+		mem_cgroup_swap_statistics(mem, true);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
 	ClearPageCgroupUsed(pc);
@@ -1948,7 +1981,9 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * We uncharge this because swap is freed.
 		 * This memcg can be obsolete one. We avoid calling css_tryget
 		 */
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+		if (!mem_cgroup_is_root(memcg))
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE, NULL);
+		mem_cgroup_swap_statistics(memcg, false);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -2461,10 +2496,26 @@ static u64 mem_cgroup_read(struct cgroup
 	name = MEMFILE_ATTR(cft->private);
 	switch (type) {
 	case _MEM:
-		val = res_counter_read_u64(&mem->res, name);
+		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
+			val = mem_cgroup_read_stat(&mem->stat,
+					MEM_CGROUP_STAT_CACHE);
+			val += mem_cgroup_read_stat(&mem->stat,
+					MEM_CGROUP_STAT_RSS);
+			val <<= PAGE_SHIFT;
+		} else
+			val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
-		val = res_counter_read_u64(&mem->memsw, name);
+		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
+			val = mem_cgroup_read_stat(&mem->stat,
+					MEM_CGROUP_STAT_CACHE);
+			val += mem_cgroup_read_stat(&mem->stat,
+					MEM_CGROUP_STAT_RSS);
+			val += mem_cgroup_read_stat(&mem->stat,
+					MEM_CGROUP_STAT_SWAPOUT);
+			val <<= PAGE_SHIFT;
+		} else
+			val = res_counter_read_u64(&mem->memsw, name);
 		break;
 	default:
 		BUG();
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch

