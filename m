From: akpm@linux-foundation.org
Subject: + memcg-reduce-the-size-of-struct-memcg-244-fold.patch added to -mm tree
Date: Thu, 24 Jan 2013 15:51:17 -0800
Message-ID: <20130124235118.58B415A4129@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:34148 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AXXvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 18:51:19 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so639911ghb.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 15:51:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: memcg: reduce the size of struct memcg 244-fold.
has been added to the -mm tree.  Its filename is
     memcg-reduce-the-size-of-struct-memcg-244-fold.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: reduce the size of struct memcg 244-fold.

In order to maintain all the memcg bookkeeping, we need per-node
descriptors, which will in turn contain a per-zone descriptor.

Because we want to statically allocate those, this array ends up being
very big.  Part of the reason is that we allocate something large enough
to hold MAX_NUMNODES, the compile time constant that holds the maximum
number of nodes we would ever consider.

However, we can do better in some cases if the firmware help us.  This is
true for modern x86 machines; coincidentally one of the architectures in
which MAX_NUMNODES tends to be very big.

By using the firmware-provided maximum number of nodes instead of
MAX_NUMNODES, we can reduce the memory footprint of struct memcg
considerably.  In the extreme case in which we have only one node, this
reduces the size of the structure from ~ 64k to ~2k.  This is particularly
important because it means that we will no longer resort to the vmalloc
area for the struct memcg on defconfigs.  We also have enough room for an
extra node and still be outside vmalloc.

One also has to keep in mind that with the industry's ability to fit more
processors in a die as fast as the FED prints money, a nodes = 2
configuration is already respectably big.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-reduce-the-size-of-struct-memcg-244-fold mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reduce-the-size-of-struct-memcg-244-fold
+++ a/mm/memcontrol.c
@@ -180,7 +180,7 @@ struct mem_cgroup_per_node {
 };
 
 struct mem_cgroup_lru_info {
-	struct mem_cgroup_per_node *nodeinfo[MAX_NUMNODES];
+	struct mem_cgroup_per_node *nodeinfo[0];
 };
 
 /*
@@ -284,17 +284,6 @@ struct mem_cgroup {
 	 */
 	struct res_counter kmem;
 	/*
-	 * Per cgroup active and inactive list, similar to the
-	 * per zone LRU lists.
-	 */
-	struct mem_cgroup_lru_info info;
-	int last_scanned_node;
-#if MAX_NUMNODES > 1
-	nodemask_t	scan_nodes;
-	atomic_t	numainfo_events;
-	atomic_t	numainfo_updating;
-#endif
-	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
@@ -357,8 +346,29 @@ struct mem_cgroup {
         /* Index in the kmem_cache->memcg_params->memcg_caches array */
 	int kmemcg_id;
 #endif
+
+	int last_scanned_node;
+#if MAX_NUMNODES > 1
+	nodemask_t	scan_nodes;
+	atomic_t	numainfo_events;
+	atomic_t	numainfo_updating;
+#endif
+	/*
+	 * Per cgroup active and inactive list, similar to the
+	 * per zone LRU lists.
+	 *
+	 * WARNING: This has to be the last element of the struct. Don't
+	 * add new fields after this point.
+	 */
+	struct mem_cgroup_lru_info info;
 };
 
+static inline size_t memcg_size(void)
+{
+	return sizeof(struct mem_cgroup) +
+		nr_node_ids * sizeof(struct mem_cgroup_per_node);
+}
+
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
@@ -5923,9 +5933,9 @@ static void free_mem_cgroup_per_zone_inf
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
-	int size = sizeof(struct mem_cgroup);
+	size_t size = memcg_size();
 
-	/* Can be very big if MAX_NUMNODES is very big */
+	/* Can be very big if nr_node_ids is very big */
 	if (size < PAGE_SIZE)
 		memcg = kzalloc(size, GFP_KERNEL);
 	else
@@ -5962,7 +5972,7 @@ out_free:
 static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
-	int size = sizeof(struct mem_cgroup);
+	size_t size = memcg_size();
 
 	mem_cgroup_remove_from_trees(memcg);
 	free_css_id(&mem_cgroup_subsys, &memcg->css);
_

Patches currently in -mm which might be from glommer@parallels.com are

memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

