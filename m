From: akpm@linux-foundation.org
Subject: + page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:08:26 -0700
Message-ID: <200904232308.n3NN8QC7009869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbZDWXNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux-foundation.org, a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: use a pre-calculated value instead of num_online_nodes() in fast paths
has been added to the -mm tree.  Its filename is
     page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch

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
Subject: page allocator: use a pre-calculated value instead of num_online_nodes() in fast paths
From: Christoph Lameter <cl@linux-foundation.org>

num_online_nodes() is called in a number of places but most often by the
page allocator when deciding whether the zonelist needs to be filtered
based on cpusets or the zonelist cache.  This is actually a heavy function
and touches a number of cache lines.

This patch stores the number of online nodes at boot time and updates the
value when nodes get onlined and offlined.  The value is then used in a
number of important paths in place of num_online_nodes().

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   15 ++++++++++++++-
 mm/hugetlb.c             |    4 ++--
 mm/page_alloc.c          |   10 ++++++----
 mm/slub.c                |    2 +-
 net/sunrpc/svc.c         |    2 +-
 5 files changed, 24 insertions(+), 9 deletions(-)

diff -puN include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths include/linux/nodemask.h
--- a/include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/include/linux/nodemask.h
@@ -408,6 +408,19 @@ static inline int num_node_state(enum no
 #define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
 
 extern int nr_node_ids;
+extern int nr_online_nodes;
+
+static inline void node_set_online(int nid)
+{
+	node_set_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
+
+static inline void node_set_offline(int nid)
+{
+	node_clear_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -434,7 +447,7 @@ static inline int num_node_state(enum no
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
-
+#define nr_online_nodes		1
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
diff -puN mm/hugetlb.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/hugetlb.c
--- a/mm/hugetlb.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/hugetlb.c
@@ -875,7 +875,7 @@ static void return_unused_surplus_pages(
 	 * can no longer free unreserved surplus pages. This occurs when
 	 * the nodes with surplus pages have no free pages.
 	 */
-	unsigned long remaining_iterations = num_online_nodes();
+	unsigned long remaining_iterations = nr_online_nodes;
 
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
@@ -904,7 +904,7 @@ static void return_unused_surplus_pages(
 			h->surplus_huge_pages--;
 			h->surplus_huge_pages_node[nid]--;
 			nr_pages--;
-			remaining_iterations = num_online_nodes();
+			remaining_iterations = nr_online_nodes;
 		}
 	}
 }
diff -puN mm/page_alloc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/page_alloc.c
@@ -165,7 +165,9 @@ static unsigned long __meminitdata dma_r
 
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
+int nr_online_nodes __read_mostly = 1;
 EXPORT_SYMBOL(nr_node_ids);
+EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -1467,7 +1469,7 @@ this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
-		if (NUMA_BUILD && !did_zlc_setup && num_online_nodes() > 1) {
+		if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
 			/*
 			 * we do zlc_setup after the first zone is tried but only
 			 * if there are multiple nodes make it worthwhile
@@ -2266,7 +2268,7 @@ int numa_zonelist_order_handler(ctl_tabl
 }
 
 
-#define MAX_NODE_LOAD (num_online_nodes())
+#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -2475,7 +2477,7 @@ static void build_zonelists(pg_data_t *p
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
-	load = num_online_nodes();
+	load = nr_online_nodes;
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
@@ -2626,7 +2628,7 @@ void build_all_zonelists(void)
 
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
-			num_online_nodes(),
+			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
diff -puN mm/slub.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/slub.c
--- a/mm/slub.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/slub.c
@@ -3714,7 +3714,7 @@ static int list_locations(struct kmem_ca
 						 to_cpumask(l->cpus));
 		}
 
-		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
+		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " nodes=");
 			len += nodelist_scnprintf(buf + len, PAGE_SIZE - len - 50,
diff -puN net/sunrpc/svc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/net/sunrpc/svc.c
@@ -124,7 +124,7 @@ svc_pool_map_choose_mode(void)
 {
 	unsigned int node;
 
-	if (num_online_nodes() > 1) {
+	if (nr_online_nodes > 1) {
 		/*
 		 * Actually have multiple NUMA nodes,
 		 * so split pools on NUMA node boundaries
_

Patches currently in -mm which might be from cl@linux-foundation.org are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
reiser4.patch
slab-leaks3-default-y.patch

