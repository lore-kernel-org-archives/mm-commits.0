From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:09 -0700
Message-ID: <5232194d.wPLG1lpnEG42pTJ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:09 -0700


The patch titled
     Subject: mm, hugetlb: fix and clean-up node iteration code to alloc or free
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: fix and clean-up node iteration code to alloc or free

Current node iteration code have a minor problem which do one more node
rotation if we can't succeed to allocate.  For example, if we start to
allocate at node 0, we stop to iterate at node 0.  Then we start to
allocate at node 1 for next allocation.

I introduce new macros "for_each_node_mask_to_[alloc|free]" and fix and
clean-up node iteration code to alloc or free.  This makes code more
understandable.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  143 ++++++++++++++++++++-----------------------------
 1 file changed, 61 insertions(+), 82 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free
+++ a/mm/hugetlb.c
@@ -772,33 +772,6 @@ static int hstate_next_node_to_alloc(str
 	return nid;
 }
 
-static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
-{
-	struct page *page;
-	int start_nid;
-	int next_nid;
-	int ret = 0;
-
-	start_nid = hstate_next_node_to_alloc(h, nodes_allowed);
-	next_nid = start_nid;
-
-	do {
-		page = alloc_fresh_huge_page_node(h, next_nid);
-		if (page) {
-			ret = 1;
-			break;
-		}
-		next_nid = hstate_next_node_to_alloc(h, nodes_allowed);
-	} while (next_nid != start_nid);
-
-	if (ret)
-		count_vm_event(HTLB_BUDDY_PGALLOC);
-	else
-		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
-
-	return ret;
-}
-
 /*
  * helper for free_pool_huge_page() - return the previously saved
  * node ["this node"] from which to free a huge page.  Advance the
@@ -817,6 +790,40 @@ static int hstate_next_node_to_free(stru
 	return nid;
 }
 
+#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
+		nr_nodes--)
+
+#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
+		nr_nodes--)
+
+static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
+{
+	struct page *page;
+	int nr_nodes, node;
+	int ret = 0;
+
+	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
+		page = alloc_fresh_huge_page_node(h, node);
+		if (page) {
+			ret = 1;
+			break;
+		}
+	}
+
+	if (ret)
+		count_vm_event(HTLB_BUDDY_PGALLOC);
+	else
+		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+
+	return ret;
+}
+
 /*
  * Free huge page from pool from next node to free.
  * Attempt to keep persistent huge pages more or less
@@ -826,36 +833,31 @@ static int hstate_next_node_to_free(stru
 static int free_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
 							 bool acct_surplus)
 {
-	int start_nid;
-	int next_nid;
+	int nr_nodes, node;
 	int ret = 0;
 
-	start_nid = hstate_next_node_to_free(h, nodes_allowed);
-	next_nid = start_nid;
-
-	do {
+	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
 		/*
 		 * If we're returning unused surplus pages, only examine
 		 * nodes with surplus pages.
 		 */
-		if ((!acct_surplus || h->surplus_huge_pages_node[next_nid]) &&
-		    !list_empty(&h->hugepage_freelists[next_nid])) {
+		if ((!acct_surplus || h->surplus_huge_pages_node[node]) &&
+		    !list_empty(&h->hugepage_freelists[node])) {
 			struct page *page =
-				list_entry(h->hugepage_freelists[next_nid].next,
+				list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
 			list_del(&page->lru);
 			h->free_huge_pages--;
-			h->free_huge_pages_node[next_nid]--;
+			h->free_huge_pages_node[node]--;
 			if (acct_surplus) {
 				h->surplus_huge_pages--;
-				h->surplus_huge_pages_node[next_nid]--;
+				h->surplus_huge_pages_node[node]--;
 			}
 			update_and_free_page(h, page);
 			ret = 1;
 			break;
 		}
-		next_nid = hstate_next_node_to_free(h, nodes_allowed);
-	} while (next_nid != start_nid);
+	}
 
 	return ret;
 }
@@ -1192,14 +1194,12 @@ static struct page *alloc_huge_page(stru
 int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
-	int nr_nodes = nodes_weight(node_states[N_MEMORY]);
+	int nr_nodes, node;
 
-	while (nr_nodes) {
+	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
 		void *addr;
 
-		addr = __alloc_bootmem_node_nopanic(
-				NODE_DATA(hstate_next_node_to_alloc(h,
-						&node_states[N_MEMORY])),
+		addr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
 				huge_page_size(h), huge_page_size(h), 0);
 
 		if (addr) {
@@ -1211,7 +1211,6 @@ int __weak alloc_bootmem_huge_page(struc
 			m = addr;
 			goto found;
 		}
-		nr_nodes--;
 	}
 	return 0;
 
@@ -1350,48 +1349,28 @@ static inline void try_to_free_low(struc
 static int adjust_pool_surplus(struct hstate *h, nodemask_t *nodes_allowed,
 				int delta)
 {
-	int start_nid, next_nid;
-	int ret = 0;
+	int nr_nodes, node;
 
 	VM_BUG_ON(delta != -1 && delta != 1);
 
-	if (delta < 0)
-		start_nid = hstate_next_node_to_alloc(h, nodes_allowed);
-	else
-		start_nid = hstate_next_node_to_free(h, nodes_allowed);
-	next_nid = start_nid;
-
-	do {
-		int nid = next_nid;
-		if (delta < 0)  {
-			/*
-			 * To shrink on this node, there must be a surplus page
-			 */
-			if (!h->surplus_huge_pages_node[nid]) {
-				next_nid = hstate_next_node_to_alloc(h,
-								nodes_allowed);
-				continue;
-			}
+	if (delta < 0) {
+		for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
+			if (h->surplus_huge_pages_node[node])
+				goto found;
 		}
-		if (delta > 0) {
-			/*
-			 * Surplus cannot exceed the total number of pages
-			 */
-			if (h->surplus_huge_pages_node[nid] >=
-						h->nr_huge_pages_node[nid]) {
-				next_nid = hstate_next_node_to_free(h,
-								nodes_allowed);
-				continue;
-			}
+	} else {
+		for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
+			if (h->surplus_huge_pages_node[node] <
+					h->nr_huge_pages_node[node])
+				goto found;
 		}
+	}
+	return 0;
 
-		h->surplus_huge_pages += delta;
-		h->surplus_huge_pages_node[nid] += delta;
-		ret = 1;
-		break;
-	} while (next_nid != start_nid);
