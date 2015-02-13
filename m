From: akpm@linux-foundation.org
Subject: [merged]
 memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:20:28 -0800
Message-ID: <54de5c8c.Bn7i3gY9+DcDF4ci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbBMUU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: reparent list_lrus and free kmemcg_id on css offline
has been removed from the -mm tree.  Its filename was
     memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: reparent list_lrus and free kmemcg_id on css offline

Now, the only reason to keep kmemcg_id till css free is list_lru, which
uses it to distribute elements between per-memcg lists.  However, it can
be easily sorted out - we only need to change kmemcg_id of an offline
cgroup to its parent's id, making further list_lru_add()'s add elements to
the parent's list, and then move all elements from the offline cgroup's
list to the one of its parent.  It will work, because a racing
list_lru_del() does not need to know the list it is deleting the element
from.  It can decrement the wrong nr_items counter though, but the ongoing
reparenting will fix it.  After list_lru reparenting is done we are free
to release kmemcg_id saving a valuable slot in a per-memcg array for new
cgroups.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    3 +-
 mm/list_lru.c            |   46 ++++++++++++++++++++++++++++++++++---
 mm/memcontrol.c          |   39 +++++++++++++++++++++++++++----
 3 files changed, 79 insertions(+), 9 deletions(-)

diff -puN include/linux/list_lru.h~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline include/linux/list_lru.h
--- a/include/linux/list_lru.h~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline
+++ a/include/linux/list_lru.h
@@ -26,7 +26,7 @@ enum lru_status {
 
 struct list_lru_one {
 	struct list_head	list;
-	/* kept as signed so we can catch imbalance bugs */
+	/* may become negative during memcg reparenting */
 	long			nr_items;
 };
 
@@ -62,6 +62,7 @@ int __list_lru_init(struct list_lru *lru
 #define list_lru_init_memcg(lru)	__list_lru_init((lru), true, NULL)
 
 int memcg_update_all_list_lrus(int num_memcgs);
+void memcg_drain_all_list_lrus(int src_idx, int dst_idx);
 
 /**
  * list_lru_add: add an element to the lru list's tail
diff -puN mm/list_lru.c~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline mm/list_lru.c
--- a/mm/list_lru.c~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline
+++ a/mm/list_lru.c
@@ -100,7 +100,6 @@ bool list_lru_add(struct list_lru *lru,
 
 	spin_lock(&nlru->lock);
 	l = list_lru_from_kmem(nlru, item);
-	WARN_ON_ONCE(l->nr_items < 0);
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		l->nr_items++;
@@ -123,7 +122,6 @@ bool list_lru_del(struct list_lru *lru,
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
-		WARN_ON_ONCE(l->nr_items < 0);
 		spin_unlock(&nlru->lock);
 		return true;
 	}
@@ -156,7 +154,6 @@ static unsigned long __list_lru_count_on
 
 	spin_lock(&nlru->lock);
 	l = list_lru_from_memcg_idx(nlru, memcg_idx);
-	WARN_ON_ONCE(l->nr_items < 0);
 	count = l->nr_items;
 	spin_unlock(&nlru->lock);
 
@@ -458,6 +455,49 @@ fail:
 		memcg_cancel_update_list_lru(lru, old_size, new_size);
 	goto out;
 }
+
+static void memcg_drain_list_lru_node(struct list_lru_node *nlru,
+				      int src_idx, int dst_idx)
+{
+	struct list_lru_one *src, *dst;
+
+	/*
+	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
+	 * we have to use IRQ-safe primitives here to avoid deadlock.
+	 */
+	spin_lock_irq(&nlru->lock);
+
+	src = list_lru_from_memcg_idx(nlru, src_idx);
+	dst = list_lru_from_memcg_idx(nlru, dst_idx);
+
+	list_splice_init(&src->list, &dst->list);
+	dst->nr_items += src->nr_items;
+	src->nr_items = 0;
+
+	spin_unlock_irq(&nlru->lock);
+}
+
+static void memcg_drain_list_lru(struct list_lru *lru,
+				 int src_idx, int dst_idx)
+{
+	int i;
+
+	if (!list_lru_memcg_aware(lru))
+		return;
+
+	for (i = 0; i < nr_node_ids; i++)
+		memcg_drain_list_lru_node(&lru->node[i], src_idx, dst_idx);
+}
+
+void memcg_drain_all_list_lrus(int src_idx, int dst_idx)
+{
+	struct list_lru *lru;
+
+	mutex_lock(&list_lrus_mutex);
+	list_for_each_entry(lru, &list_lrus, list)
+		memcg_drain_list_lru(lru, src_idx, dst_idx);
+	mutex_unlock(&list_lrus_mutex);
+}
 #else
 static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
diff -puN mm/memcontrol.c~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline
+++ a/mm/memcontrol.c
@@ -334,6 +334,7 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM)
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
+	bool kmem_acct_activated;
 	bool kmem_acct_active;
 #endif
 
@@ -582,14 +583,10 @@ void memcg_put_cache_ids(void)
 struct static_key memcg_kmem_enabled_key;
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
-static void memcg_free_cache_id(int id);
-
 static void disarm_kmem_keys(struct mem_cgroup *memcg)
 {
-	if (memcg->kmemcg_id >= 0) {
+	if (memcg->kmem_acct_activated)
 		static_key_slow_dec(&memcg_kmem_enabled_key);
-		memcg_free_cache_id(memcg->kmemcg_id);
-	}
 	/*
 	 * This check can't live in kmem destruction function,
 	 * since the charges will outlive the cgroup
@@ -3322,6 +3319,7 @@ static int memcg_activate_kmem(struct me
 	int memcg_id;
 
 	BUG_ON(memcg->kmemcg_id >= 0);
+	BUG_ON(memcg->kmem_acct_activated);
 	BUG_ON(memcg->kmem_acct_active);
 
 	/*
@@ -3365,6 +3363,7 @@ static int memcg_activate_kmem(struct me
 	 * patched.
 	 */
 	memcg->kmemcg_id = memcg_id;
+	memcg->kmem_acct_activated = true;
 	memcg->kmem_acct_active = true;
 out:
 	return err;
@@ -4047,6 +4046,10 @@ static int memcg_init_kmem(struct mem_cg
 
 static void memcg_deactivate_kmem(struct mem_cgroup *memcg)
 {
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *parent, *child;
+	int kmemcg_id;
+
 	if (!memcg->kmem_acct_active)
 		return;
 
@@ -4059,6 +4062,32 @@ static void memcg_deactivate_kmem(struct
 	memcg->kmem_acct_active = false;
 
 	memcg_deactivate_kmem_caches(memcg);
+
+	kmemcg_id = memcg->kmemcg_id;
+	BUG_ON(kmemcg_id < 0);
+
+	parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		parent = root_mem_cgroup;
+
+	/*
+	 * Change kmemcg_id of this cgroup and all its descendants to the
+	 * parent's id, and then move all entries from this cgroup's list_lrus
+	 * to ones of the parent. After we have finished, all list_lrus
+	 * corresponding to this cgroup are guaranteed to remain empty. The
+	 * ordering is imposed by list_lru_node->lock taken by
+	 * memcg_drain_all_list_lrus().
+	 */
+	css_for_each_descendant_pre(css, &memcg->css) {
+		child = mem_cgroup_from_css(css);
+		BUG_ON(child->kmemcg_id != kmemcg_id);
+		child->kmemcg_id = parent->kmemcg_id;
+		if (!memcg->use_hierarchy)
+			break;
+	}
+	memcg_drain_all_list_lrus(kmemcg_id, parent->kmemcg_id);
+
+	memcg_free_cache_id(kmemcg_id);
 }
 
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

