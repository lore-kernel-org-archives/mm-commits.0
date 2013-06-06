From: akpm@linux-foundation.org
Subject: [to-be-updated] list_lru-per-memcg-walks.patch removed from -mm
 tree
Date: Thu, 06 Jun 2013 12:35:15 -0700
Message-ID: <51b0e473.SO8wbv8tAa8QNxeX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3FFTfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] list_lru-per-memcg-walks.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:15 -0700


The patch titled
     Subject: list_lru: per-memcg walks
has been removed from the -mm tree.  Its filename was
     list_lru-per-memcg-walks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: list_lru: per-memcg walks

This patch extend the list_lru interfaces to allow for a memcg parameter. 
Because most of its users won't need it, instead of modifying the function
signatures we create a new set of _memcg() functions and write the old API
ontop of that.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h   |   26 +++++++--
 include/linux/memcontrol.h |    2 
 lib/list_lru.c             |   97 ++++++++++++++++++++++++++---------
 3 files changed, 97 insertions(+), 28 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-per-memcg-walks include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-per-memcg-walks
+++ a/include/linux/list_lru.h
@@ -100,7 +100,15 @@ static inline int list_lru_init_memcg(st
 int list_lru_add(struct list_lru *lru, struct list_head *item);
 int list_lru_del(struct list_lru *lru, struct list_head *item);
 
-unsigned long list_lru_count_node(struct list_lru *lru, int nid);
+unsigned long list_lru_count_node_memcg(struct list_lru *lru, int nid,
+					struct mem_cgroup *memcg);
+
+static inline unsigned long
+list_lru_count_node(struct list_lru *lru, int nid)
+{
+	return list_lru_count_node_memcg(lru, nid, NULL);
+}
+
 static inline unsigned long list_lru_count(struct list_lru *lru)
 {
 	long count = 0;
@@ -118,9 +126,19 @@ typedef enum lru_status
 typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
 
 
-unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
-				 list_lru_walk_cb isolate, void *cb_arg,
-				 unsigned long *nr_to_walk);
+unsigned long
+list_lru_walk_node_memcg(struct list_lru *lru, int nid,
+			 list_lru_walk_cb isolate, void *cb_arg,
+			 unsigned long *nr_to_walk, struct mem_cgroup *memcg);
+
+static inline unsigned long
+list_lru_walk_node(struct list_lru *lru, int nid,
+		 list_lru_walk_cb isolate, void *cb_arg,
+		 unsigned long *nr_to_walk)
+{
+	return list_lru_walk_node_memcg(lru, nid, isolate, cb_arg,
+					nr_to_walk, NULL);
+}
 
 static inline unsigned long
 list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
diff -puN include/linux/memcontrol.h~list_lru-per-memcg-walks include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~list_lru-per-memcg-walks
+++ a/include/linux/memcontrol.h
@@ -593,6 +593,8 @@ static inline bool memcg_kmem_is_active(
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
 
+#define memcg_limited_groups_array_size 0
+
 static inline bool memcg_kmem_enabled(void)
 {
 	return false;
diff -puN lib/list_lru.c~list_lru-per-memcg-walks lib/list_lru.c
--- a/lib/list_lru.c~list_lru-per-memcg-walks
+++ a/lib/list_lru.c
@@ -50,13 +50,16 @@ lru_node_of_index(struct list_lru *lru,
 	rcu_read_lock();
 	rmb();
 	/*
-	 * The array exist, but the particular memcg does not. That is an
-	 * impossible situation: it would mean we are trying to add to a list
-	 * belonging to a memcg that does not exist. Either wasn't created or
-	 * has been already freed. In both cases it should no longer have
-	 * objects. BUG_ON to avoid a NULL dereference.
+	 * The array exist, but the particular memcg does not. This cannot
+	 * happen when we are called from memcg_kmem_lru_of_page with a
+	 * definite memcg, but it can happen when we are iterating over all
+	 * memcgs (for instance, when disposing all lists.
 	 */
-	BUG_ON(!lru->memcg_lrus[index]);
+	if (!lru->memcg_lrus[index]) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
 	nlru = &lru->memcg_lrus[index]->node[nid];
 	rcu_read_unlock();
 	return nlru;
@@ -80,6 +83,23 @@ memcg_kmem_lru_of_page(struct list_lru *
 	return lru_node_of_index(lru, memcg_id, nid);
 }
 
+/*
+ * This helper will loop through all node-data in the LRU, either global or
+ * per-memcg.  If memcg is either not present or not used,
+ * memcg_limited_groups_array_size will be 0. _idx starts at -1, and it will
+ * still be allowed to execute once.
+ *
+ * We convention that for _idx = -1, the global node info should be used.
+ * After that, we will go through each of the memcgs, starting at 0.
+ *
+ * We don't need any kind of locking for the loop because
+ * memcg_limited_groups_array_size can only grow, gaining new fields at the
+ * end. The old ones are just copied, and any interesting manipulation happen
+ * in the node list itself, and we already lock the list.
+ */
+#define for_each_memcg_lru_index(_idx)	\
+	for ((_idx) = -1; ((_idx) < memcg_limited_groups_array_size); (_idx)++)
+
 int
 list_lru_add(
 	struct list_lru	*lru,
@@ -139,10 +159,19 @@ list_lru_del(
 EXPORT_SYMBOL_GPL(list_lru_del);
 
 unsigned long
-list_lru_count_node(struct list_lru *lru, int nid)
+list_lru_count_node_memcg(struct list_lru *lru, int nid,
+			  struct mem_cgroup *memcg)
 {
 	long count = 0;
-	struct list_lru_node *nlru = &lru->node[nid];
+	int memcg_id = -1;
+	struct list_lru_node *nlru;
+
+	if (memcg && memcg_kmem_is_active(memcg))
+		memcg_id = memcg_cache_id(memcg);
+
+	nlru = lru_node_of_index(lru, memcg_id, nid);
+	if (!nlru)
+		return 0;
 
 	spin_lock(&nlru->lock);
 	BUG_ON(nlru->nr_items < 0);
@@ -151,19 +180,28 @@ list_lru_count_node(struct list_lru *lru
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(list_lru_count_node);
+EXPORT_SYMBOL_GPL(list_lru_count_node_memcg);
 
 unsigned long
-list_lru_walk_node(
+list_lru_walk_node_memcg(
 	struct list_lru		*lru,
 	int			nid,
 	list_lru_walk_cb	isolate,
 	void			*cb_arg,
-	unsigned long		*nr_to_walk)
+	unsigned long		*nr_to_walk,
+	struct mem_cgroup	*memcg)
 {
-	struct list_lru_node	*nlru = &lru->node[nid];
 	struct list_head *item, *n;
 	unsigned long isolated = 0;
+	struct list_lru_node *nlru;
+	int memcg_id = -1;
+
+	if (memcg && memcg_kmem_is_active(memcg))
+		memcg_id = memcg_cache_id(memcg);
+
+	nlru = lru_node_of_index(lru, memcg_id, nid);
+	if (!nlru)
+		return 0;
 
 	spin_lock(&nlru->lock);
 	list_for_each_safe(item, n, &nlru->list) {
@@ -200,7 +238,7 @@ restart:
 	spin_unlock(&nlru->lock);
 	return isolated;
 }
-EXPORT_SYMBOL_GPL(list_lru_walk_node);
+EXPORT_SYMBOL_GPL(list_lru_walk_node_memcg);
 
 static unsigned long
 list_lru_dispose_all_node(
@@ -208,23 +246,34 @@ list_lru_dispose_all_node(
 	int			nid,
 	list_lru_dispose_cb	dispose)
 {
-	struct list_lru_node	*nlru = &lru->node[nid];
+	struct list_lru_node *nlru;
 	LIST_HEAD(dispose_list);
 	unsigned long disposed = 0;
+	int idx;
 
-	spin_lock(&nlru->lock);
-	while (!list_empty(&nlru->list)) {
-		list_splice_init(&nlru->list, &dispose_list);
-		disposed += nlru->nr_items;
-		nlru->nr_items = 0;
-		node_clear(nid, lru->active_nodes);
-		spin_unlock(&nlru->lock);
-
-		dispose(&dispose_list);
+	for_each_memcg_lru_index(idx) {
+		nlru = lru_node_of_index(lru, idx, nid);
+		if (!nlru)
+			continue;
 
 		spin_lock(&nlru->lock);
+		while (!list_empty(&nlru->list)) {
+			list_splice_init(&nlru->list, &dispose_list);
+
+			if (atomic_long_sub_and_test(nlru->nr_items,
+							&lru->node_totals[nid]))
+				node_clear(nid, lru->active_nodes);
+			disposed += nlru->nr_items;
+			nlru->nr_items = 0;
+			spin_unlock(&nlru->lock);
+
+			dispose(&dispose_list);
+
+			spin_lock(&nlru->lock);
+		}
+		spin_unlock(&nlru->lock);
 	}
-	spin_unlock(&nlru->lock);
+
 	return disposed;
 }
 
_

Patches currently in -mm which might be from glommer@openvz.org are

memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

