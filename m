From: akpm@linux-foundation.org
Subject: + memcg-improve-resource-counter-scalability-v5.patch added to -mm tree
Date: Thu, 13 Aug 2009 15:13:04 -0700
Message-ID: <200908132213.n7DMD4IJ021549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbZHMWNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 18:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, andi@firstfloor.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, prarit@redhat.com


The patch titled
     memcg-improve-resource-counter-scalability-v5
has been added to the -mm tree.  Its filename is
     memcg-improve-resource-counter-scalability-v5.patch

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
Subject: memcg-improve-resource-counter-scalability-v5
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcg-improve-resource-counter-scalability-v5 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-resource-counter-scalability-v5
+++ a/mm/memcontrol.c
@@ -496,7 +496,7 @@ static void mem_cgroup_charge_statistics
 					 struct page_cgroup *pc,
 					 bool charge)
 {
-	int val = (charge)? 1 : -1;
+	int val = (charge) ? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
 	struct mem_cgroup_stat_cpu *cpustat;
 	int cpu = get_cpu();
@@ -1889,7 +1889,7 @@ __mem_cgroup_uncharge_common(struct page
 				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
 			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
 	}
-	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT && mem_cgroup_is_root(mem))
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		mem_cgroup_swap_statistics(mem, true);
 	mem_cgroup_charge_statistics(mem, pc, false);
 
@@ -2486,10 +2486,34 @@ static int mem_cgroup_hierarchy_write(st
 	return retval;
 }
 
+struct mem_cgroup_idx_data {
+	s64 val;
+	enum mem_cgroup_stat_index idx;
+};
+
+static int
+mem_cgroup_get_idx_stat(struct mem_cgroup *mem, void *data)
+{
+	struct mem_cgroup_idx_data *d = data;
+	d->val += mem_cgroup_read_stat(&mem->stat, d->idx);
+	return 0;
+}
+
+static void
+mem_cgroup_get_recursive_idx_stat(struct mem_cgroup *mem,
+				enum mem_cgroup_stat_index idx, s64 *val)
+{
+	struct mem_cgroup_idx_data d;
+	d.idx = idx;
+	d.val = 0;
+	mem_cgroup_walk_tree(mem, &d, mem_cgroup_get_idx_stat);
+	*val = d.val;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	u64 val = 0;
+	u64 idx_val, val;
 	int type, name;
 
 	type = MEMFILE_TYPE(cft->private);
@@ -2497,22 +2521,26 @@ static u64 mem_cgroup_read(struct cgroup
 	switch (type) {
 	case _MEM:
 		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			val = mem_cgroup_read_stat(&mem->stat,
-					MEM_CGROUP_STAT_CACHE);
-			val += mem_cgroup_read_stat(&mem->stat,
-					MEM_CGROUP_STAT_RSS);
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_CACHE, &idx_val);
+			val = idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_RSS, &idx_val);
+			val += idx_val;
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
 		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			val = mem_cgroup_read_stat(&mem->stat,
-					MEM_CGROUP_STAT_CACHE);
-			val += mem_cgroup_read_stat(&mem->stat,
-					MEM_CGROUP_STAT_RSS);
-			val += mem_cgroup_read_stat(&mem->stat,
-					MEM_CGROUP_STAT_SWAPOUT);
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_CACHE, &idx_val);
+			val = idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_RSS, &idx_val);
+			val += idx_val;
+			mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
 			val <<= PAGE_SHIFT;
 		} else
 			val = res_counter_read_u64(&mem->memsw, name);
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
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
memcg-improve-resource-counter-scalability-v5.patch

