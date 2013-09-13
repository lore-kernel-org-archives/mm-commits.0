From: akpm@linux-foundation.org
Subject: [merged] list_lru-per-node-list-infrastructure.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:16:01 -0700
Message-ID: <52338091.m92ded6cCMJjyCso%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] list_lru-per-node-list-infrastructure.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:01 -0700


The patch titled
     Subject: list_lru: per-node list infrastructure
has been removed from the -mm tree.  Its filename was
     list_lru-per-node-list-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: list_lru: per-node list infrastructure

Now that we have an LRU list API, we can start to enhance the
implementation.  This splits the single LRU list into per-node lists and
locks to enhance scalability.  Items are placed on lists according to the
node the memory belongs to.  To make scanning the lists efficient, also
track whether the per-node lists have entries in them in a active
nodemask.

Note: We use a fixed-size array for the node LRU, this struct can be very
big if MAX_NUMNODES is big.  If this becomes a problem this is fixable by
turning this into a pointer and dynamically allocating this to
nr_node_ids.  This quantity is firwmare-provided, and still would provide
room for all nodes at the cost of a pointer lookup and an extra
allocation.  Because that allocation will most likely come from a may very
well fail.

[glommer@openvz.org: fix warnings, added note about node lru]
[glommer@gmail.com: per-node list infrastructure fix]
[dchinner@redhat.com: fix broken LRU_RETRY behaviour]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Greg Thelen <gthelen@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   23 +++--
 mm/list_lru.c            |  169 ++++++++++++++++++++++++++-----------
 2 files changed, 138 insertions(+), 54 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-per-node-list-infrastructure include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-per-node-list-infrastructure
+++ a/include/linux/list_lru.h
@@ -8,6 +8,7 @@
 #define _LRU_LIST_H
 
 #include <linux/list.h>
+#include <linux/nodemask.h>
 
 /* list_lru_walk_cb has to always return one of those */
 enum lru_status {
@@ -18,11 +19,26 @@ enum lru_status {
 				   internally, but has to return locked. */
 };
 
-struct list_lru {
+struct list_lru_node {
 	spinlock_t		lock;
 	struct list_head	list;
 	/* kept as signed so we can catch imbalance bugs */
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
@@ -66,10 +82,7 @@ bool list_lru_del(struct list_lru *lru,
  * guarantee that the list is not updated while the count is being computed.
  * Callers that want such a guarantee need to provide an outer lock.
  */
-static inline unsigned long list_lru_count(struct list_lru *lru)
-{
-	return lru->nr_items;
-}
+unsigned long list_lru_count(struct list_lru *lru);
 
 typedef enum lru_status
 (*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
diff -puN mm/list_lru.c~list_lru-per-node-list-infrastructure mm/list_lru.c
--- a/mm/list_lru.c~list_lru-per-node-list-infrastructure
+++ a/mm/list_lru.c
@@ -6,112 +6,183 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/list_lru.h>
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
-	spin_lock(&lru->lock);
+	int nid = page_to_nid(virt_to_page(item));
+	struct list_lru_node *nlru = &lru->node[nid];
+
+	spin_lock(&nlru->lock);
+	WARN_ON_ONCE(nlru->nr_items < 0);
 	if (list_empty(item)) {
-		list_add_tail(item, &lru->list);
-		lru->nr_items++;
-		spin_unlock(&lru->lock);
+		list_add_tail(item, &nlru->list);
+		if (nlru->nr_items++ == 0)
+			node_set(nid, lru->active_nodes);
+		spin_unlock(&nlru->lock);
 		return true;
 	}
-	spin_unlock(&lru->lock);
+	spin_unlock(&nlru->lock);
 	return false;
 }
 EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_del(struct list_lru *lru, struct list_head *item)
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
+		WARN_ON_ONCE(nlru->nr_items < 0);
+		spin_unlock(&nlru->lock);
 		return true;
 	}
-	spin_unlock(&lru->lock);
+	spin_unlock(&nlru->lock);
 	return false;
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-			    void *cb_arg, unsigned long nr_to_walk)
+unsigned long list_lru_count(struct list_lru *lru)
+{
+	unsigned long count = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes) {
+		struct list_lru_node *nlru = &lru->node[nid];
+
+		spin_lock(&nlru->lock);
+		WARN_ON_ONCE(nlru->nr_items < 0);
+		count += nlru->nr_items;
+		spin_unlock(&nlru->lock);
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(list_lru_count);
+
+static unsigned long
+list_lru_walk_node(struct list_lru *lru, int nid, list_lru_walk_cb isolate,
+		   void *cb_arg, unsigned long *nr_to_walk)
 {
+
+	struct list_lru_node	*nlru = &lru->node[nid];
 	struct list_head *item, *n;
-	unsigned long removed = 0;
-	/*
-	 * If we don't keep state of at which pass we are, we can loop at
-	 * LRU_RETRY, since we have no guarantees that the caller will be able
-	 * to do something other than retry on the next pass. We handle this by
-	 * allowing at most one retry per object. This should not be altered
-	 * by any condition other than LRU_RETRY.
-	 */
-	bool first_pass = true;
+	unsigned long isolated = 0;
 
-	spin_lock(&lru->lock);
+	spin_lock(&nlru->lock);
 restart:
-	list_for_each_safe(item, n, &lru->list) {
+	list_for_each_safe(item, n, &nlru->list) {
 		enum lru_status ret;
-		ret = isolate(item, &lru->lock, cb_arg);
+
+		/*
+		 * decrement nr_to_walk first so that we don't livelock if we
+		 * get stuck on large numbesr of LRU_RETRY items
+		 */
+		if (--(*nr_to_walk) == 0)
+			break;
+
+		ret = isolate(item, &nlru->lock, cb_arg);
 		switch (ret) {
 		case LRU_REMOVED:
-			lru->nr_items--;
-			removed++;
+			if (--nlru->nr_items == 0)
+				node_clear(nid, lru->active_nodes);
+			WARN_ON_ONCE(nlru->nr_items < 0);
+			isolated++;
 			break;
 		case LRU_ROTATE:
-			list_move_tail(item, &lru->list);
+			list_move_tail(item, &nlru->list);
 			break;
 		case LRU_SKIP:
 			break;
 		case LRU_RETRY:
-			if (!first_pass) {
-				first_pass = true;
-				break;
-			}
-			first_pass = false;
+			/*
+			 * The lru lock has been dropped, our list traversal is
+			 * now invalid and so we have to restart from scratch.
+			 */
 			goto restart;
 		default:
 			BUG();
 		}
+	}
 
-		if (nr_to_walk-- == 0)
-			break;
+	spin_unlock(&nlru->lock);
+	return isolated;
+}
+EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
+unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+			    void *cb_arg, unsigned long nr_to_walk)
+{
+	unsigned long isolated = 0;
+	int nid;
+
+	for_each_node_mask(nid, lru->active_nodes) {
+		isolated += list_lru_walk_node(lru, nid, isolate,
+					       cb_arg, &nr_to_walk);
+		if (nr_to_walk <= 0)
+			break;
 	}
-	spin_unlock(&lru->lock);
-	return removed;
+	return isolated;
 }
 EXPORT_SYMBOL_GPL(list_lru_walk);
 
-unsigned long list_lru_dispose_all(struct list_lru *lru,
-				   list_lru_dispose_cb dispose)
+static unsigned long list_lru_dispose_all_node(struct list_lru *lru, int nid,
+					       list_lru_dispose_cb dispose)
 {
-	unsigned long disposed = 0;
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
 
+unsigned long list_lru_dispose_all(struct list_lru *lru,
+				   list_lru_dispose_cb dispose)
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
 int list_lru_init(struct list_lru *lru)
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

origin.patch
linux-next.patch
list_lru-per-node-api.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
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
list_lru-dynamically-adjust-node-arrays.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

