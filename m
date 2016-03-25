From: akpm@linux-foundation.org
Subject: + include-linux-nodemaskh-create-next_node_in-helper.patch added
 to -mm tree
Date: Fri, 25 Mar 2016 12:23:12 -0700
Message-ID: <56f59020.QLPANo9jOaZ6N4ji%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbcCYTXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 15:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, lauraa@codeaurora.org, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, wangxq10@lzu.edu.cn, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/nodemask.h: create next_node_in() helper
has been added to the -mm tree.  Its filename is
     include-linux-nodemaskh-create-next_node_in-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-nodemaskh-create-next_node_in-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-create-next_node_in-helper.patch

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
Subject: include/linux/nodemask.h: create next_node_in() helper

Lots of code does

	node = next_node(node, XXX);
	if (node == MAX_NUMNODES)
		node = first_node(XXX);

so create next_node_in() to do this and use it in various places.

Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Laura Abbott" <lauraa@codeaurora.org>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   18 +++++++++++++++++-
 kernel/cpuset.c          |    8 +-------
 mm/hugetlb.c             |    4 +---
 mm/memcontrol.c          |    4 +---
 mm/mempolicy.c           |    8 ++------
 mm/page_isolation.c      |    9 +++------
 mm/slab.c                |   13 +++----------
 7 files changed, 28 insertions(+), 36 deletions(-)

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
@@ -259,6 +261,20 @@ static inline int __next_node(int n, con
 	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
+/*
+ * Find the next present node in src, starting after node n, wrapping around to
+ * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
+ */
+#define next_node_in(n, src) __next_node_in((n), &(src))
+static inline int __next_node_in(int node, const nodemask_t *srcp)
+{
+	int ret = __next_node(node, srcp);
+
+	if (ret == MAX_NUMNODES)
+		ret = __first_node(srcp);
+	return ret;
+}
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
@@ -1388,9 +1388,7 @@ int mem_cgroup_select_victim_node(struct
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
@@ -347,9 +347,7 @@ static void mpol_rebind_nodemask(struct
 		BUG();
 
 	if (!node_isset(current->il_next, tmp)) {
-		current->il_next = next_node(current->il_next, tmp);
-		if (current->il_next >= MAX_NUMNODES)
-			current->il_next = first_node(tmp);
+		current->il_next = next_node_in(current->il_next, tmp);
 		if (current->il_next >= MAX_NUMNODES)
 			current->il_next = numa_node_id();
 	}
@@ -1709,9 +1707,7 @@ static unsigned interleave_nodes(struct
 	struct task_struct *me = current;
 
 	nid = me->il_next;
-	next = next_node(nid, policy->v.nodes);
-	if (next >= MAX_NUMNODES)
-		next = first_node(policy->v.nodes);
+	next = next_node_in(nid, policy->v.nodes);
 	if (next < MAX_NUMNODES)
 		me->il_next = next;
 	return nid;
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
@@ -519,22 +519,15 @@ static DEFINE_PER_CPU(unsigned long, sla
 
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
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
sched-add-schedule_timeout_idle.patch
drivers-input-eliminate-input_compat_test-macro.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

