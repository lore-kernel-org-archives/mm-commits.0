From: akpm@linux-foundation.org
Subject: [patch 041/117] include/linux/nodemask.h: create next_node_in()
 helper
Date: Thu, 19 May 2016 17:10:58 -0700
Message-ID: <573e5612.iHb9uoOz2/AivuE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbcETALA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, lauraa@codeaurora.org, mhocko@kernel.org, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/nodemask.h: create next_node_in() helper

Lots of code does

	node = next_node(node, XXX);
	if (node == MAX_NUMNODES)
		node = first_node(XXX);

so create next_node_in() to do this and use it in various places.

[mhocko@suse.com: use next_node_in() helper]
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/setup.c |    4 +---
 arch/x86/mm/numa.c       |    4 +---
 include/linux/nodemask.h |   11 ++++++++++-
 kernel/cpuset.c          |    8 +-------
 lib/Makefile             |    2 +-
 lib/nodemask.c           |   30 ++++++++++++++++++++++++++++++
 mm/hugetlb.c             |    4 +---
 mm/memcontrol.c          |    4 +---
 mm/mempolicy.c           |   24 ++----------------------
 mm/page_isolation.c      |    9 +++------
 mm/slab.c                |   13 +++----------
 11 files changed, 54 insertions(+), 59 deletions(-)

diff -puN include/linux/nodemask.h~include-linux-nodemaskh-create-next_node_in-helper include/linux/nodemask.h
--- a/include/linux/nodemask.h~include-linux-nodemaskh-create-next_node_in-helper
+++ a/include/linux/nodemask.h
@@ -43,8 +43,10 @@
  *
  * int first_node(mask)			Number lowest set bit, or MAX_NUMNODES
  * int next_node(node, mask)		Next node past 'node', or MAX_NUMNODES
+ * int next_node_in(node, mask)		Next node past 'node', or wrap to first,
+ *					or MAX_NUMNODES
  * int first_unset_node(mask)		First node not set in mask, or 
- *					MAX_NUMNODES.
+ *					MAX_NUMNODES
  *
  * nodemask_t nodemask_of_node(node)	Return nodemask with bit 'node' set
  * NODE_MASK_ALL			Initializer - all bits set
@@ -259,6 +261,13 @@ static inline int __next_node(int n, con
 	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
+/*
+ * Find the next present node in src, starting after node n, wrapping around to
+ * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
+ */
+#define next_node_in(n, src) __next_node_in((n), &(src))
+int __next_node_in(int node, const nodemask_t *srcp);
+
 static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 {
 	nodes_clear(*mask);
diff -puN kernel/cpuset.c~include-linux-nodemaskh-create-next_node_in-helper kernel/cpuset.c
--- a/kernel/cpuset.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/kernel/cpuset.c
@@ -2591,13 +2591,7 @@ int __cpuset_node_allowed(int node, gfp_
 
 static int cpuset_spread_node(int *rotor)
 {
-	int node;
-
-	node = next_node(*rotor, current->mems_allowed);
-	if (node == MAX_NUMNODES)
-		node = first_node(current->mems_allowed);
-	*rotor = node;
-	return node;
+	return *rotor = next_node_in(*rotor, current->mems_allowed);
 }
 
 int cpuset_mem_spread_node(void)
diff -puN mm/hugetlb.c~include-linux-nodemaskh-create-next_node_in-helper mm/hugetlb.c
--- a/mm/hugetlb.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/mm/hugetlb.c
@@ -937,9 +937,7 @@ err:
  */
 static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
 {
-	nid = next_node(nid, *nodes_allowed);
-	if (nid == MAX_NUMNODES)
-		nid = first_node(*nodes_allowed);
+	nid = next_node_in(nid, *nodes_allowed);
 	VM_BUG_ON(nid >= MAX_NUMNODES);
 
 	return nid;
diff -puN mm/memcontrol.c~include-linux-nodemaskh-create-next_node_in-helper mm/memcontrol.c
--- a/mm/memcontrol.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/mm/memcontrol.c
@@ -1389,9 +1389,7 @@ int mem_cgroup_select_victim_node(struct
 	mem_cgroup_may_update_nodemask(memcg);
 	node = memcg->last_scanned_node;
 
-	node = next_node(node, memcg->scan_nodes);
-	if (node == MAX_NUMNODES)
-		node = first_node(memcg->scan_nodes);
+	node = next_node_in(node, memcg->scan_nodes);
 	/*
 	 * We call this when we hit limit, not when pages are added to LRU.
 	 * No LRU may hold pages because all pages are UNEVICTABLE or
diff -puN mm/mempolicy.c~include-linux-nodemaskh-create-next_node_in-helper mm/mempolicy.c
--- a/mm/mempolicy.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/mm/mempolicy.c
@@ -97,7 +97,6 @@
 
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
-#include <linux/random.h>
 
 #include "internal.h"
 
@@ -347,9 +346,7 @@ static void mpol_rebind_nodemask(struct
 		BUG();
 
 	if (!node_isset(current->il_next, tmp)) {
-		current->il_next = next_node(current->il_next, tmp);
-		if (current->il_next >= MAX_NUMNODES)
-			current->il_next = first_node(tmp);
+		current->il_next = next_node_in(current->il_next, tmp);
 		if (current->il_next >= MAX_NUMNODES)
 			current->il_next = numa_node_id();
 	}
@@ -1709,9 +1706,7 @@ static unsigned interleave_nodes(struct
 	struct task_struct *me = current;
 
 	nid = me->il_next;
-	next = next_node(nid, policy->v.nodes);
-	if (next >= MAX_NUMNODES)
-		next = first_node(policy->v.nodes);
+	next = next_node_in(nid, policy->v.nodes);
 	if (next < MAX_NUMNODES)
 		me->il_next = next;
 	return nid;
@@ -1805,21 +1800,6 @@ static inline unsigned interleave_nid(st
 		return interleave_nodes(pol);
 }
 
-/*
- * Return the bit number of a random bit set in the nodemask.
- * (returns NUMA_NO_NODE if nodemask is empty)
- */
-int node_random(const nodemask_t *maskp)
-{
-	int w, bit = NUMA_NO_NODE;
-
-	w = nodes_weight(*maskp);
-	if (w)
-		bit = bitmap_ord_to_pos(maskp->bits,
-			get_random_int() % w, MAX_NUMNODES);
-	return bit;
-}
-
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
diff -puN mm/page_isolation.c~include-linux-nodemaskh-create-next_node_in-helper mm/page_isolation.c
--- a/mm/page_isolation.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/mm/page_isolation.c
@@ -288,13 +288,10 @@ struct page *alloc_migrate_target(struct
 	 * accordance with memory policy of the user process if possible. For
 	 * now as a simple work-around, we use the next node for destination.
 	 */
-	if (PageHuge(page)) {
-		int node = next_online_node(page_to_nid(page));
-		if (node == MAX_NUMNODES)
-			node = first_online_node;
+	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
-					    node);
-	}
+					    next_node_in(page_to_nid(page),
+							 node_online_map));
 
 	if (PageHighMem(page))
 		gfp_mask |= __GFP_HIGHMEM;
diff -puN mm/slab.c~include-linux-nodemaskh-create-next_node_in-helper mm/slab.c
--- a/mm/slab.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/mm/slab.c
@@ -522,22 +522,15 @@ static DEFINE_PER_CPU(unsigned long, sla
 
 static void init_reap_node(int cpu)
 {
-	int node;
-
-	node = next_node(cpu_to_mem(cpu), node_online_map);
-	if (node == MAX_NUMNODES)
-		node = first_node(node_online_map);
-
-	per_cpu(slab_reap_node, cpu) = node;
+	per_cpu(slab_reap_node, cpu) = next_node_in(cpu_to_mem(cpu),
+						    node_online_map);
 }
 
 static void next_reap_node(void)
 {
 	int node = __this_cpu_read(slab_reap_node);
 
-	node = next_node(node, node_online_map);
-	if (unlikely(node >= MAX_NUMNODES))
-		node = first_node(node_online_map);
+	node = next_node_in(node, node_online_map);
 	__this_cpu_write(slab_reap_node, node);
 }
 
diff -puN arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/arch/tile/kernel/setup.c
@@ -962,9 +962,7 @@ static void __init setup_numa_mapping(vo
 		cpumask_set_cpu(best_cpu, &node_2_cpu_mask[node]);
 		cpu_2_node[best_cpu] = node;
 		cpumask_clear_cpu(best_cpu, &unbound_cpus);
-		node = next_node(node, default_nodes);
-		if (node == MAX_NUMNODES)
-			node = first_node(default_nodes);
+		node = next_node_in(node, default_nodes);
 	}
 
 	/* Print out node assignments and set defaults for disabled cpus */
diff -puN arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~include-linux-nodemaskh-create-next_node_in-helper
+++ a/arch/x86/mm/numa.c
@@ -617,9 +617,7 @@ static void __init numa_init_array(void)
 		if (early_cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
 		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
+		rr = next_node_in(rr, node_online_map);
 	}
 }
 
diff -puN lib/Makefile~include-linux-nodemaskh-create-next_node_in-helper lib/Makefile
--- a/lib/Makefile~include-linux-nodemaskh-create-next_node_in-helper
+++ a/lib/Makefile
@@ -25,7 +25,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 sha1.o md5.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o seq_buf.o nmi_backtrace.o
+	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff -puN /dev/null lib/nodemask.c
--- /dev/null
+++ a/lib/nodemask.c
@@ -0,0 +1,30 @@
+#include <linux/nodemask.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+int __next_node_in(int node, const nodemask_t *srcp)
+{
+	int ret = __next_node(node, srcp);
+
+	if (ret == MAX_NUMNODES)
+		ret = __first_node(srcp);
+	return ret;
+}
+EXPORT_SYMBOL(__next_node_in);
+
+#ifdef CONFIG_NUMA
+/*
+ * Return the bit number of a random bit set in the nodemask.
+ * (returns NUMA_NO_NODE if nodemask is empty)
+ */
+int node_random(const nodemask_t *maskp)
+{
+	int w, bit = NUMA_NO_NODE;
+
+	w = nodes_weight(*maskp);
+	if (w)
+		bit = bitmap_ord_to_pos(maskp->bits,
+			get_random_int() % w, MAX_NUMNODES);
+	return bit;
+}
+#endif
_
