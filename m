From: akpm@linux-foundation.org
Subject: [merged] list_lru-per-node-api.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:16:03 -0700
Message-ID: <52338093.gfi49Rqc/4LHU2xW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: [merged] list_lru-per-node-api.patch removed from -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:03 -0700


The patch titled
     Subject: list_lru: per-node API
has been removed from the -mm tree.  Its filename was
     list_lru-per-node-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: list_lru: per-node API

This patch adapts the list_lru API to accept an optional node argument, to
be used by NUMA aware shrinking functions.  Code that does not care about
the NUMA placement of objects can still call into the very same functions
as before.  They will simply iterate over all nodes.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
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

 include/linux/list_lru.h |   39 ++++++++++++++++++++++++++++++++-----
 mm/list_lru.c            |   37 ++++++++---------------------------
 2 files changed, 43 insertions(+), 33 deletions(-)

diff -puN include/linux/list_lru.h~list_lru-per-node-api include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-per-node-api
+++ a/include/linux/list_lru.h
@@ -75,20 +75,32 @@ bool list_lru_add(struct list_lru *lru,
 bool list_lru_del(struct list_lru *lru, struct list_head *item);
 
 /**
- * list_lru_count: return the number of objects currently held by @lru
+ * list_lru_count_node: return the number of objects currently held by @lru
  * @lru: the lru pointer.
+ * @nid: the node id to count from.
  *
  * Always return a non-negative number, 0 for empty lists. There is no
  * guarantee that the list is not updated while the count is being computed.
  * Callers that want such a guarantee need to provide an outer lock.
  */
-unsigned long list_lru_count(struct list_lru *lru);
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
 /**
- * list_lru_walk: walk a list_lru, isolating and disposing freeable items.
+ * list_lru_walk_node: walk a list_lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
+ * @nid: the node id to scan from.
  * @isolate: callback function that is resposible for deciding what to do with
  *  the item currently being scanned
  * @cb_arg: opaque type that will be passed to @isolate
@@ -106,8 +118,25 @@ typedef enum lru_status
  *
  * Return value: the number of objects effectively removed from the LRU.
  */
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-		   void *cb_arg, unsigned long nr_to_walk);
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
 
 typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
 /**
diff -puN mm/list_lru.c~list_lru-per-node-api mm/list_lru.c
--- a/mm/list_lru.c~list_lru-per-node-api
+++ a/mm/list_lru.c
@@ -47,25 +47,22 @@ bool list_lru_del(struct list_lru *lru,
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
-unsigned long list_lru_count(struct list_lru *lru)
+unsigned long
+list_lru_count_node(struct list_lru *lru, int nid)
 {
 	unsigned long count = 0;
-	int nid;
+	struct list_lru_node *nlru = &lru->node[nid];
 
-	for_each_node_mask(nid, lru->active_nodes) {
-		struct list_lru_node *nlru = &lru->node[nid];
-
-		spin_lock(&nlru->lock);
-		WARN_ON_ONCE(nlru->nr_items < 0);
-		count += nlru->nr_items;
-		spin_unlock(&nlru->lock);
-	}
+	spin_lock(&nlru->lock);
+	WARN_ON_ONCE(nlru->nr_items < 0);
+	count += nlru->nr_items;
+	spin_unlock(&nlru->lock);
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(list_lru_count);
+EXPORT_SYMBOL_GPL(list_lru_count_node);
 
-static unsigned long
+unsigned long
 list_lru_walk_node(struct list_lru *lru, int nid, list_lru_walk_cb isolate,
 		   void *cb_arg, unsigned long *nr_to_walk)
 {
@@ -115,22 +112,6 @@ restart:
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
-unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
-			    void *cb_arg, unsigned long nr_to_walk)
-{
-	unsigned long isolated = 0;
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
