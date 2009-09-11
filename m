From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-rework-hstate_next_node_-functions.patch removed from -mm tree
Date: Fri, 11 Sep 2009 10:42:51 -0700
Message-ID: <200909111742.n8BHgp2I021609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbZIKRoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 13:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: rework hstate_next_node_* functions
has been removed from the -mm tree.  Its filename was
     hugetlb-rework-hstate_next_node_-functions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: rework hstate_next_node_* functions
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This is V6 of a series of patches to provide control over the location of
the allocation and freeing of persistent huge pages on a NUMA platform. 
Please consider V6 [patches 1-6] for merging into mmotm.

This series uses two mechanisms to constrain the nodes from which
persistent huge pages are allocated: 1) the task NUMA mempolicy of the
task modifying "nr_hugepages", based on a suggestion by Mel Gorman; and 2)
a subset of the hugepages hstate sysfs attributes have been added [in V4]
to each node system device under:

	/sys/devices/node/node[0-9]*/hugepages.

The per node attibutes allow direct assignment of a huge page count on a
specific node, regardless of the task's mempolicy or cpuset constraints.  



This patch:

Modify the hstate_next_node* functions to allow them to be called to
obtain the "start_nid".  Then, whereas prior to this patch we
unconditionally called hstate_next_node_to_{alloc|free}(), whether or not
we successfully allocated/freed a huge page on the node, now we only call
these functions on failure to alloc/free to advance to next allowed node.

Factor out the next_node_allowed() function to handle wrap at end of
node_online_map.  In this version, the allowed nodes include all of the
online nodes.

Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   70 +++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-rework-hstate_next_node_-functions mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-rework-hstate_next_node_-functions
+++ a/mm/hugetlb.c
@@ -622,6 +622,20 @@ static struct page *alloc_fresh_huge_pag
 }
 
 /*
+ * common helper function for hstate_next_node_to_{alloc|free}.
+ * return next node in node_online_map, wrapping at end.
+ */
+static int next_node_allowed(int nid)
+{
+	nid = next_node(nid, node_online_map);
+	if (nid == MAX_NUMNODES)
+		nid = first_node(node_online_map);
+	VM_BUG_ON(nid >= MAX_NUMNODES);
+
+	return nid;
+}
+
+/*
  * Use a helper variable to find the next node and then
  * copy it back to next_nid_to_alloc afterwards:
  * otherwise there's a window in which a racer might
@@ -634,12 +648,12 @@ static struct page *alloc_fresh_huge_pag
  */
 static int hstate_next_node_to_alloc(struct hstate *h)
 {
-	int next_nid;
-	next_nid = next_node(h->next_nid_to_alloc, node_online_map);
-	if (next_nid == MAX_NUMNODES)
-		next_nid = first_node(node_online_map);
+	int nid, next_nid;
+
+	nid = h->next_nid_to_alloc;
+	next_nid = next_node_allowed(nid);
 	h->next_nid_to_alloc = next_nid;
-	return next_nid;
+	return nid;
 }
 
 static int alloc_fresh_huge_page(struct hstate *h)
@@ -649,15 +663,17 @@ static int alloc_fresh_huge_page(struct 
 	int next_nid;
 	int ret = 0;
 
-	start_nid = h->next_nid_to_alloc;
+	start_nid = hstate_next_node_to_alloc(h);
 	next_nid = start_nid;
 
 	do {
 		page = alloc_fresh_huge_page_node(h, next_nid);
-		if (page)
+		if (page) {
 			ret = 1;
+			break;
+		}
 		next_nid = hstate_next_node_to_alloc(h);
-	} while (!page && next_nid != start_nid);
+	} while (next_nid != start_nid);
 
 	if (ret)
 		count_vm_event(HTLB_BUDDY_PGALLOC);
@@ -668,17 +684,19 @@ static int alloc_fresh_huge_page(struct 
 }
 
 /*
- * helper for free_pool_huge_page() - find next node
- * from which to free a huge page
+ * helper for free_pool_huge_page() - return the next node
+ * from which to free a huge page.  Advance the next node id
+ * whether or not we find a free huge page to free so that the
+ * next attempt to free addresses the next node.
  */
 static int hstate_next_node_to_free(struct hstate *h)
 {
-	int next_nid;
-	next_nid = next_node(h->next_nid_to_free, node_online_map);
-	if (next_nid == MAX_NUMNODES)
-		next_nid = first_node(node_online_map);
+	int nid, next_nid;
+
+	nid = h->next_nid_to_free;
+	next_nid = next_node_allowed(nid);
 	h->next_nid_to_free = next_nid;
-	return next_nid;
+	return nid;
 }
 
 /*
@@ -693,7 +711,7 @@ static int free_pool_huge_page(struct hs
 	int next_nid;
 	int ret = 0;
 
-	start_nid = h->next_nid_to_free;
+	start_nid = hstate_next_node_to_free(h);
 	next_nid = start_nid;
 
 	do {
@@ -715,9 +733,10 @@ static int free_pool_huge_page(struct hs
 			}
 			update_and_free_page(h, page);
 			ret = 1;
+			break;
 		}
 		next_nid = hstate_next_node_to_free(h);
-	} while (!ret && next_nid != start_nid);
+	} while (next_nid != start_nid);
 
 	return ret;
 }
@@ -1028,10 +1047,9 @@ int __weak alloc_bootmem_huge_page(struc
 		void *addr;
 
 		addr = __alloc_bootmem_node_nopanic(
-				NODE_DATA(h->next_nid_to_alloc),
+				NODE_DATA(hstate_next_node_to_alloc(h)),
 				huge_page_size(h), huge_page_size(h), 0);
 
-		hstate_next_node_to_alloc(h);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1167,29 +1185,31 @@ static int adjust_pool_surplus(struct hs
 	VM_BUG_ON(delta != -1 && delta != 1);
 
 	if (delta < 0)
-		start_nid = h->next_nid_to_alloc;
+		start_nid = hstate_next_node_to_alloc(h);
 	else
-		start_nid = h->next_nid_to_free;
+		start_nid = hstate_next_node_to_free(h);
 	next_nid = start_nid;
 
 	do {
 		int nid = next_nid;
 		if (delta < 0)  {
-			next_nid = hstate_next_node_to_alloc(h);
 			/*
 			 * To shrink on this node, there must be a surplus page
 			 */
-			if (!h->surplus_huge_pages_node[nid])
+			if (!h->surplus_huge_pages_node[nid]) {
+				next_nid = hstate_next_node_to_alloc(h);
 				continue;
+			}
 		}
 		if (delta > 0) {
-			next_nid = hstate_next_node_to_free(h);
 			/*
 			 * Surplus cannot exceed the total number of pages
 			 */
 			if (h->surplus_huge_pages_node[nid] >=
-						h->nr_huge_pages_node[nid])
+						h->nr_huge_pages_node[nid]) {
+				next_nid = hstate_next_node_to_free(h);
 				continue;
+			}
 		}
 
 		h->surplus_huge_pages += delta;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-fcns.patch
hugetlb-introduce-alloc_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy-fix.patch
hugetlb-promote-numa_no_node-to-generic-constant.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-add-per-node-hstate-attributes-fix.patch
hugetlb-update-hugetlb-documentation-for-mempolicy-based-management.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

