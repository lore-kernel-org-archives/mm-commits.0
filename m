From: akpm@linux-foundation.org
Subject: [merged] list_lru-get-rid-of-active_nodes.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:19:57 -0800
Message-ID: <54de5c6d.tFNWTqXieQKj4mty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru: get rid of ->active_nodes
has been removed from the -mm tree.  Its filename was
     list_lru-get-rid-of-active_nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: list_lru: get rid of ->active_nodes

The active_nodes mask allows us to skip empty nodes when walking over
list_lru items from all nodes in list_lru_count/walk.  However, these
functions are never called from hot paths, so it doesn't seem we need such
kind of optimization there.  OTOH, removing the mask will make it easier
to make list_lru per-memcg.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    5 ++---
 mm/list_lru.c            |   10 +++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-get-rid-of-active_nodes include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-get-rid-of-active_nodes
+++ a/include/linux/list_lru.h
@@ -31,7 +31,6 @@ struct list_lru_node {
 
 struct list_lru {
 	struct list_lru_node	*node;
-	nodemask_t		active_nodes;
 };
 
 void list_lru_destroy(struct list_lru *lru);
@@ -94,7 +93,7 @@ static inline unsigned long list_lru_cou
 	long count = 0;
 	int nid;
 
-	for_each_node_mask(nid, lru->active_nodes)
+	for_each_node_state(nid, N_NORMAL_MEMORY)
 		count += list_lru_count_node(lru, nid);
 
 	return count;
@@ -142,7 +141,7 @@ list_lru_walk(struct list_lru *lru, list
 	long isolated = 0;
 	int nid;
 
-	for_each_node_mask(nid, lru->active_nodes) {
+	for_each_node_state(nid, N_NORMAL_MEMORY) {
 		isolated += list_lru_walk_node(lru, nid, isolate,
 					       cb_arg, &nr_to_walk);
 		if (nr_to_walk <= 0)
diff -puN mm/list_lru.c~list_lru-get-rid-of-active_nodes mm/list_lru.c
--- a/mm/list_lru.c~list_lru-get-rid-of-active_nodes
+++ a/mm/list_lru.c
@@ -19,8 +19,7 @@ bool list_lru_add(struct list_lru *lru,
 	WARN_ON_ONCE(nlru->nr_items < 0);
 	if (list_empty(item)) {
 		list_add_tail(item, &nlru->list);
-		if (nlru->nr_items++ == 0)
-			node_set(nid, lru->active_nodes);
+		nlru->nr_items++;
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -37,8 +36,7 @@ bool list_lru_del(struct list_lru *lru,
 	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
 		list_del_init(item);
-		if (--nlru->nr_items == 0)
-			node_clear(nid, lru->active_nodes);
+		nlru->nr_items--;
 		WARN_ON_ONCE(nlru->nr_items < 0);
 		spin_unlock(&nlru->lock);
 		return true;
@@ -90,8 +88,7 @@ restart:
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
 		case LRU_REMOVED:
-			if (--nlru->nr_items == 0)
-				node_clear(nid, lru->active_nodes);
+			nlru->nr_items--;
 			WARN_ON_ONCE(nlru->nr_items < 0);
 			isolated++;
 			/*
@@ -133,7 +130,6 @@ int list_lru_init_key(struct list_lru *l
 	if (!lru->node)
 		return -ENOMEM;
 
-	nodes_clear(lru->active_nodes);
 	for (i = 0; i < nr_node_ids; i++) {
 		spin_lock_init(&lru->node[i].lock);
 		if (key)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

