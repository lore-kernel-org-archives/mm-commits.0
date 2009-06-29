From: akpm@linux-foundation.org
Subject: + hugetlb-balance-freeing-of-huge-pages-across-nodes.patch added to -mm tree
Date: Mon, 29 Jun 2009 15:43:46 -0700
Message-ID: <200906292243.n5TMhkpa023879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZF2WoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 18:44:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, agl@us.ibm.com, apw@canonical.com, eric.whitney@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com


The patch titled
     hugetlb: balance freeing of huge pages across nodes
has been added to the -mm tree.  Its filename is
     hugetlb-balance-freeing-of-huge-pages-across-nodes.patch

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
Subject: hugetlb: balance freeing of huge pages across nodes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Free huges pages from nodes in round robin fashion in an attempt to keep
[persistent a.k.a static] hugepages balanced across nodes

New function free_pool_huge_page() is modeled on and performs roughly the
inverse of alloc_fresh_huge_page().  Replaces dequeue_huge_page() which
now has no callers, so this patch removes it.

Helper function hstate_next_node_to_free() uses new hstate member
next_to_free_nid to distribute "frees" across all nodes with huge pages.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 
 mm/hugetlb.c            |  132 ++++++++++++++++++++++++--------------
 2 files changed, 88 insertions(+), 47 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-balance-freeing-of-huge-pages-across-nodes include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-balance-freeing-of-huge-pages-across-nodes
+++ a/include/linux/hugetlb.h
@@ -183,7 +183,8 @@ unsigned long hugetlb_get_unmapped_area(
 #define HSTATE_NAME_LEN 32
 /* Defines one hugetlb page size */
 struct hstate {
-	int hugetlb_next_nid;
+	int next_nid_to_alloc;
+	int next_nid_to_free;
 	unsigned int order;
 	unsigned long mask;
 	unsigned long max_huge_pages;
diff -puN mm/hugetlb.c~hugetlb-balance-freeing-of-huge-pages-across-nodes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-balance-freeing-of-huge-pages-across-nodes
+++ a/mm/hugetlb.c
@@ -456,24 +456,6 @@ static void enqueue_huge_page(struct hst
 	h->free_huge_pages_node[nid]++;
 }
 
-static struct page *dequeue_huge_page(struct hstate *h)
-{
-	int nid;
-	struct page *page = NULL;
-
-	for (nid = 0; nid < MAX_NUMNODES; ++nid) {
-		if (!list_empty(&h->hugepage_freelists[nid])) {
-			page = list_entry(h->hugepage_freelists[nid].next,
-					  struct page, lru);
-			list_del(&page->lru);
-			h->free_huge_pages--;
-			h->free_huge_pages_node[nid]--;
-			break;
-		}
-	}
-	return page;
-}
-
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address, int avoid_reserve)
@@ -641,7 +623,7 @@ static struct page *alloc_fresh_huge_pag
 
 /*
  * Use a helper variable to find the next node and then
- * copy it back to hugetlb_next_nid afterwards:
+ * copy it back to next_nid_to_alloc afterwards:
  * otherwise there's a window in which a racer might
  * pass invalid nid MAX_NUMNODES to alloc_pages_exact_node.
  * But we don't need to use a spin_lock here: it really
@@ -650,13 +632,13 @@ static struct page *alloc_fresh_huge_pag
  * if we just successfully allocated a hugepage so that
  * the next caller gets hugepages on the next node.
  */
-static int hstate_next_node(struct hstate *h)
+static int hstate_next_node_to_alloc(struct hstate *h)
 {
 	int next_nid;
-	next_nid = next_node(h->hugetlb_next_nid, node_online_map);
+	next_nid = next_node(h->next_nid_to_alloc, node_online_map);
 	if (next_nid == MAX_NUMNODES)
 		next_nid = first_node(node_online_map);
-	h->hugetlb_next_nid = next_nid;
+	h->next_nid_to_alloc = next_nid;
 	return next_nid;
 }
 
@@ -667,14 +649,15 @@ static int alloc_fresh_huge_page(struct 
 	int next_nid;
 	int ret = 0;
 
-	start_nid = h->hugetlb_next_nid;
+	start_nid = h->next_nid_to_alloc;
+	next_nid = start_nid;
 
 	do {
-		page = alloc_fresh_huge_page_node(h, h->hugetlb_next_nid);
+		page = alloc_fresh_huge_page_node(h, next_nid);
 		if (page)
 			ret = 1;
-		next_nid = hstate_next_node(h);
-	} while (!page && h->hugetlb_next_nid != start_nid);
+		next_nid = hstate_next_node_to_alloc(h);
+	} while (!page && next_nid != start_nid);
 
 	if (ret)
 		count_vm_event(HTLB_BUDDY_PGALLOC);
@@ -684,6 +667,52 @@ static int alloc_fresh_huge_page(struct 
 	return ret;
 }
 
+/*
+ * helper for free_pool_huge_page() - find next node
+ * from which to free a huge page
+ */
+static int hstate_next_node_to_free(struct hstate *h)
+{
+	int next_nid;
+	next_nid = next_node(h->next_nid_to_free, node_online_map);
+	if (next_nid == MAX_NUMNODES)
+		next_nid = first_node(node_online_map);
+	h->next_nid_to_free = next_nid;
+	return next_nid;
+}
+
+/*
+ * Free huge page from pool from next node to free.
+ * Attempt to keep persistent huge pages more or less
+ * balanced over allowed nodes.
+ * Called with hugetlb_lock locked.
+ */
+static int free_pool_huge_page(struct hstate *h)
+{
+	int start_nid;
+	int next_nid;
+	int ret = 0;
+
+	start_nid = h->next_nid_to_free;
+	next_nid = start_nid;
+
+	do {
+		if (!list_empty(&h->hugepage_freelists[next_nid])) {
+			struct page *page =
+				list_entry(h->hugepage_freelists[next_nid].next,
+					  struct page, lru);
+			list_del(&page->lru);
+			h->free_huge_pages--;
+			h->free_huge_pages_node[next_nid]--;
+			update_and_free_page(h, page);
+			ret = 1;
+		}
+		next_nid = hstate_next_node_to_free(h);
+	} while (!ret && next_nid != start_nid);
+
+	return ret;
+}
+
 static struct page *alloc_buddy_huge_page(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
 {
@@ -1008,7 +1037,7 @@ int __weak alloc_bootmem_huge_page(struc
 		void *addr;
 
 		addr = __alloc_bootmem_node_nopanic(
-				NODE_DATA(h->hugetlb_next_nid),
+				NODE_DATA(h->next_nid_to_alloc),
 				huge_page_size(h), huge_page_size(h), 0);
 
 		if (addr) {
@@ -1020,7 +1049,7 @@ int __weak alloc_bootmem_huge_page(struc
 			m = addr;
 			goto found;
 		}
-		hstate_next_node(h);
+		hstate_next_node_to_alloc(h);
 		nr_nodes--;
 	}
 	return 0;
@@ -1141,31 +1170,43 @@ static inline void try_to_free_low(struc
  */
 static int adjust_pool_surplus(struct hstate *h, int delta)
 {
-	static int prev_nid;
-	int nid = prev_nid;
+	int start_nid, next_nid;
 	int ret = 0;
 
 	VM_BUG_ON(delta != -1 && delta != 1);
-	do {
-		nid = next_node(nid, node_online_map);
-		if (nid == MAX_NUMNODES)
-			nid = first_node(node_online_map);
 
-		/* To shrink on this node, there must be a surplus page */
-		if (delta < 0 && !h->surplus_huge_pages_node[nid])
-			continue;
-		/* Surplus cannot exceed the total number of pages */
-		if (delta > 0 && h->surplus_huge_pages_node[nid] >=
+	if (delta < 0)
+		start_nid = h->next_nid_to_alloc;
+	else
+		start_nid = h->next_nid_to_free;
+	next_nid = start_nid;
+
+	do {
+		int nid = next_nid;
+		if (delta < 0)  {
+			next_nid = hstate_next_node_to_alloc(h);
+			/*
+			 * To shrink on this node, there must be a surplus page
+			 */
+			if (!h->surplus_huge_pages_node[nid])
+				continue;
+		}
+		if (delta > 0) {
+			next_nid = hstate_next_node_to_free(h);
+			/*
+			 * Surplus cannot exceed the total number of pages
+			 */
+			if (h->surplus_huge_pages_node[nid] >=
 						h->nr_huge_pages_node[nid])
-			continue;
+				continue;
+		}
 
 		h->surplus_huge_pages += delta;
 		h->surplus_huge_pages_node[nid] += delta;
 		ret = 1;
 		break;
-	} while (nid != prev_nid);
+	} while (next_nid != start_nid);
 
-	prev_nid = nid;
 	return ret;
 }
 
@@ -1227,10 +1268,8 @@ static unsigned long set_max_huge_pages(
 	min_count = max(count, min_count);
 	try_to_free_low(h, min_count);
 	while (min_count < persistent_huge_pages(h)) {
-		struct page *page = dequeue_huge_page(h);
-		if (!page)
+		if (!free_pool_huge_page(h))
 			break;
-		update_and_free_page(h, page);
 	}
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, 1))
@@ -1442,7 +1481,8 @@ void __init hugetlb_add_hstate(unsigned 
 	h->free_huge_pages = 0;
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
-	h->hugetlb_next_nid = first_node(node_online_map);
+	h->next_nid_to_alloc = first_node(node_online_map);
+	h->next_nid_to_free = first_node(node_online_map);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch

