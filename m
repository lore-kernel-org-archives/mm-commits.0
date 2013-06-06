From: akpm@linux-foundation.org
Subject: [to-be-updated] list_lru-per-node-api.patch removed from -mm tree
Date: Thu, 06 Jun 2013 12:34:47 -0700
Message-ID: <51b0e457.v/hnme1P3Lx0Ahvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3FFTes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] list_lru-per-node-api.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:47 -0700


The patch titled
     Subject: list_lru: per-node API
has been removed from the -mm tree.  Its filename was
     list_lru-per-node-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: list_lru: per-node API

This patch adapts the list_lru API to accept an optional node argument, to
be used by NUMA aware shrinking functions.  Code that does not care about
the NUMA placement of objects can still call into the very same functions
as before.  They will simply iterate over all nodes.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   35 ++++++++++++++++++++++++++++---
 lib/list_lru.c           |   41 ++++++++-----------------------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-per-node-api include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-per-node-api
+++ a/include/linux/list_lru.h
@@ -42,15 +42,44 @@ struct list_lru {
 int list_lru_init(struct list_lru *lru);
 int list_lru_add(struct list_lru *lru, struct list_head *item);
 int list_lru_del(struct list_lru *lru, struct list_head *item);
-unsigned long list_lru_count(struct list_lru *lru);
+
+unsigned long list_lru_count_node(struct list_lru *lru, int nid);
+static inline unsigned long list_lru_count(struct list_lru *lru)
+{
+	long count = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes)
+		count += list_lru_count_node(lru, nid);
+
+	return count;
+}
 
 typedef enum lru_status
 (*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
 
 typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
 
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-		   void *cb_arg, unsigned long nr_to_walk);
+
+unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
+				 list_lru_walk_cb isolate, void *cb_arg,
+				 unsigned long *nr_to_walk);
+
+static inline unsigned long
+list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+	      void *cb_arg, unsigned long nr_to_walk)
+{
+	long isolated = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes) {
+		isolated += list_lru_walk_node(lru, nid, isolate,
+					       cb_arg, &nr_to_walk);
+		if (nr_to_walk <= 0)
+			break;
+	}
+	return isolated;
+}
 
 unsigned long
 list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
diff -puN lib/list_lru.c~list_lru-per-node-api lib/list_lru.c
--- a/lib/list_lru.c~list_lru-per-node-api
+++ a/lib/list_lru.c
@@ -54,25 +54,21 @@ list_lru_del(
 EXPORT_SYMBOL_GPL(list_lru_del);
 
 unsigned long
-list_lru_count(struct list_lru *lru)
+list_lru_count_node(struct list_lru *lru, int nid)
 {
 	long count = 0;
-	int nid;
+	struct list_lru_node *nlru = &lru->node[nid];
 
-	for_each_node_mask(nid, lru->active_nodes) {
-		struct list_lru_node *nlru = &lru->node[nid];
-
-		spin_lock(&nlru->lock);
-		BUG_ON(nlru->nr_items < 0);
-		count += nlru->nr_items;
-		spin_unlock(&nlru->lock);
-	}
+	spin_lock(&nlru->lock);
+	BUG_ON(nlru->nr_items < 0);
+	count += nlru->nr_items;
+	spin_unlock(&nlru->lock);
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(list_lru_count);
+EXPORT_SYMBOL_GPL(list_lru_count_node);
 
-static unsigned long
+unsigned long
 list_lru_walk_node(
 	struct list_lru		*lru,
 	int			nid,
@@ -118,26 +114,7 @@ restart:
 	spin_unlock(&nlru->lock);
 	return isolated;
 }
-
-unsigned long
-list_lru_walk(
-	struct list_lru	*lru,
-	list_lru_walk_cb isolate,
-	void		*cb_arg,
-	unsigned long	nr_to_walk)
-{
-	long isolated = 0;
-	int nid;
-
-	for_each_node_mask(nid, lru->active_nodes) {
-		isolated += list_lru_walk_node(lru, nid, isolate,
-					       cb_arg, &nr_to_walk);
-		if (nr_to_walk <= 0)
-			break;
-	}
-	return isolated;
-}
-EXPORT_SYMBOL_GPL(list_lru_walk);
+EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
 static unsigned long
 list_lru_dispose_all_node(
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

