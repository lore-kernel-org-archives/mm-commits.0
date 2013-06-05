From: akpm@linux-foundation.org
Subject: + list_lru-per-node-list-infrastructure.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:10:51 -0700
Message-ID: <51afc57b.+MqRwNc7yXDpjl/D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + list_lru-per-node-list-infrastructure.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:10:51 -0700


The patch titled
     Subject: list_lru: per-node list infrastructure
has been added to the -mm tree.  Its filename is
     list_lru-per-node-list-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: list_lru: per-node list infrastructure

Now that we have an LRU list API, we can start to enhance the
implementation.  This splits the single LRU list into per-node lists and
locks to enhance scalability.  Items are placed on lists according to the
node the memory belongs to.  To make scanning the lists efficient, also
track whether the per-node lists have entries in them in a active
nodemask.

Note:

We use a fixed-size array for the node LRU, this struct can be very big if
MAX_NUMNODES is big.  If this becomes a problem this is fixable by turning
this into a pointer and dynamically allocating this to nr_node_ids.  This
quantity is firwmare-provided, and still would provide room for all nodes
at the cost of a pointer lookup and an extra allocation.  Because that
allocation will most likely come from a may very well fail.

[glommer@openvz.org: fixed warnings, added note about node lru]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Greg Thelen <gthelen@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   24 ++++-
 lib/list_lru.c           |  161 +++++++++++++++++++++++++++----------
 2 files changed, 139 insertions(+), 46 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-per-node-list-infrastructure include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-per-node-list-infrastructure
+++ a/include/linux/list_lru.h
@@ -8,6 +8,7 @@
 #define _LRU_LIST_H
 
 #include <linux/list.h>
+#include <linux/nodemask.h>
 
 enum lru_status {
 	LRU_REMOVED,		/* item removed from list */
@@ -17,20 +18,31 @@ enum lru_status {
 				   internally, but has to return locked. */
 };
 
-struct list_lru {
+struct list_lru_node {
 	spinlock_t		lock;
 	struct list_head	list;
 	long			nr_items;
+} ____cacheline_aligned_in_smp;
+
+struct list_lru {
+	/*
+	 * Because we use a fixed-size array, this struct can be very big if
+	 * MAX_NUMNODES is big. If this becomes a problem this is fixable by
+	 * turning this into a pointer and dynamically allocating this to
+	 * nr_node_ids. This quantity is firwmare-provided, and still would
+	 * provide room for all nodes at the cost of a pointer lookup and an
+	 * extra allocation. Because that allocation will most likely come from
+	 * a different slab cache than the main structure holding this
+	 * structure, we may very well fail.
+	 */
+	struct list_lru_node	node[MAX_NUMNODES];
+	nodemask_t		active_nodes;
 };
 
 int list_lru_init(struct list_lru *lru);
 int list_lru_add(struct list_lru *lru, struct list_head *item);
 int list_lru_del(struct list_lru *lru, struct list_head *item);
-
-static inline unsigned long list_lru_count(struct list_lru *lru)
-{
-	return lru->nr_items;
-}
+unsigned long list_lru_count(struct list_lru *lru);
 
 typedef enum lru_status
 (*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
diff -puN lib/list_lru.c~list_lru-per-node-list-infrastructure lib/list_lru.c
--- a/lib/list_lru.c~list_lru-per-node-list-infrastructure
+++ a/lib/list_lru.c
@@ -6,6 +6,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/list_lru.h>
 
 int
@@ -13,14 +14,19 @@ list_lru_add(
 	struct list_lru	*lru,
 	struct list_head *item)
 {
-	spin_lock(&lru->lock);
+	int nid = page_to_nid(virt_to_page(item));
+	struct list_lru_node *nlru = &lru->node[nid];
+
+	spin_lock(&nlru->lock);
+	BUG_ON(nlru->nr_items < 0);
 	if (list_empty(item)) {
-		list_add_tail(item, &lru->list);
-		lru->nr_items++;
-		spin_unlock(&lru->lock);
+		list_add_tail(item, &nlru->list);
+		if (nlru->nr_items++ == 0)
+			node_set(nid, lru->active_nodes);
+		spin_unlock(&nlru->lock);
 		return 1;
 	}
-	spin_unlock(&lru->lock);
+	spin_unlock(&nlru->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(list_lru_add);
@@ -30,41 +36,69 @@ list_lru_del(
 	struct list_lru	*lru,
 	struct list_head *item)
 {
-	spin_lock(&lru->lock);
+	int nid = page_to_nid(virt_to_page(item));
+	struct list_lru_node *nlru = &lru->node[nid];
+
+	spin_lock(&nlru->lock);
 	if (!list_empty(item)) {
 		list_del_init(item);
-		lru->nr_items--;
-		spin_unlock(&lru->lock);
+		if (--nlru->nr_items == 0)
+			node_clear(nid, lru->active_nodes);
+		BUG_ON(nlru->nr_items < 0);
+		spin_unlock(&nlru->lock);
 		return 1;
 	}
-	spin_unlock(&lru->lock);
+	spin_unlock(&nlru->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
 unsigned long
-list_lru_walk(
-	struct list_lru *lru,
-	list_lru_walk_cb isolate,
-	void		*cb_arg,
-	unsigned long	nr_to_walk)
+list_lru_count(struct list_lru *lru)
 {
+	long count = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes) {
+		struct list_lru_node *nlru = &lru->node[nid];
+
+		spin_lock(&nlru->lock);
+		BUG_ON(nlru->nr_items < 0);
+		count += nlru->nr_items;
+		spin_unlock(&nlru->lock);
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(list_lru_count);
+
+static unsigned long
+list_lru_walk_node(
+	struct list_lru		*lru,
+	int			nid,
+	list_lru_walk_cb	isolate,
+	void			*cb_arg,
+	unsigned long		*nr_to_walk)
+{
+	struct list_lru_node	*nlru = &lru->node[nid];
 	struct list_head *item, *n;
-	unsigned long removed = 0;
+	unsigned long isolated = 0;
 
-	spin_lock(&lru->lock);
-	list_for_each_safe(item, n, &lru->list) {
+	spin_lock(&nlru->lock);
+	list_for_each_safe(item, n, &nlru->list) {
 		enum lru_status ret;
 		bool first_pass = true;
 restart:
-		ret = isolate(item, &lru->lock, cb_arg);
+		ret = isolate(item, &nlru->lock, cb_arg);
 		switch (ret) {
 		case LRU_REMOVED:
-			lru->nr_items--;
-			removed++;
+			if (--nlru->nr_items == 0)
+				node_clear(nid, lru->active_nodes);
+			BUG_ON(nlru->nr_items < 0);
+			isolated++;
 			break;
 		case LRU_ROTATE:
-			list_move_tail(item, &lru->list);
+			list_move_tail(item, &nlru->list);
 			break;
 		case LRU_SKIP:
 			break;
@@ -77,46 +111,93 @@ restart:
 			BUG();
 		}
 
-		if (nr_to_walk-- == 0)
+		if ((*nr_to_walk)-- == 0)
 			break;
 
 	}
-	spin_unlock(&lru->lock);
-	return removed;
+	spin_unlock(&nlru->lock);
+	return isolated;
 }
-EXPORT_SYMBOL_GPL(list_lru_walk);
 
 unsigned long
-list_lru_dispose_all(
-	struct list_lru *lru,
-	list_lru_dispose_cb dispose)
+list_lru_walk(
+	struct list_lru	*lru,
+	list_lru_walk_cb isolate,
+	void		*cb_arg,
+	unsigned long	nr_to_walk)
 {
-	unsigned long disposed = 0;
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
+EXPORT_SYMBOL_GPL(list_lru_walk);
+
+static unsigned long
+list_lru_dispose_all_node(
+	struct list_lru		*lru,
+	int			nid,
+	list_lru_dispose_cb	dispose)
+{
+	struct list_lru_node	*nlru = &lru->node[nid];
 	LIST_HEAD(dispose_list);
+	unsigned long disposed = 0;
 
-	spin_lock(&lru->lock);
-	while (!list_empty(&lru->list)) {
-		list_splice_init(&lru->list, &dispose_list);
-		disposed += lru->nr_items;
-		lru->nr_items = 0;
-		spin_unlock(&lru->lock);
+	spin_lock(&nlru->lock);
+	while (!list_empty(&nlru->list)) {
+		list_splice_init(&nlru->list, &dispose_list);
+		disposed += nlru->nr_items;
+		nlru->nr_items = 0;
+		node_clear(nid, lru->active_nodes);
+		spin_unlock(&nlru->lock);
 
 		dispose(&dispose_list);
 
-		spin_lock(&lru->lock);
+		spin_lock(&nlru->lock);
 	}
-	spin_unlock(&lru->lock);
+	spin_unlock(&nlru->lock);
 	return disposed;
 }
 
+unsigned long
+list_lru_dispose_all(
+	struct list_lru		*lru,
+	list_lru_dispose_cb	dispose)
+{
+	unsigned long disposed;
+	unsigned long total = 0;
+	int nid;
+
+	do {
+		disposed = 0;
+		for_each_node_mask(nid, lru->active_nodes) {
+			disposed += list_lru_dispose_all_node(lru, nid,
+							      dispose);
+		}
+		total += disposed;
+	} while (disposed != 0);
+
+	return total;
+}
+
 int
 list_lru_init(
 	struct list_lru	*lru)
 {
-	spin_lock_init(&lru->lock);
-	INIT_LIST_HEAD(&lru->list);
-	lru->nr_items = 0;
+	int i;
 
+	nodes_clear(lru->active_nodes);
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		spin_lock_init(&lru->node[i].lock);
+		INIT_LIST_HEAD(&lru->node[i].list);
+		lru->node[i].nr_items = 0;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(list_lru_init);
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
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
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

