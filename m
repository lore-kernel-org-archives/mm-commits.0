From: akpm@linux-foundation.org
Subject: + hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:30:18 -0700
Message-ID: <200710151930.l9FJUIET021038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759282AbXJOTbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, agl@us.ibm.com, clameter@sgi.com, hermes@gibson.dropbear.id.au, kamezawa.hiroyu@jp.fujitsu.com, kenchen@google.com, lee.schermerhorn@hp.com, pbadari@us.ibm.com, wli@holomorphy.com


The patch titled
     hugetlb: fix hugepage allocation with memoryless nodes
has been added to the -mm tree.  Its filename is
     hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: fix hugepage allocation with memoryless nodes
From: Nishanth Aravamudan <nacc@us.ibm.com>

Anton found a problem with the hugetlb pool allocation when some nodes have
no memory (http://marc.info/?l=linux-mm&m=118133042025995&w=2).  Lee worked
on versions that tried to fix it, but none were accepted.  Christoph has
created a set of patches which allow for GFP_THISNODE allocations to fail
if the node has no memory.

Currently, alloc_fresh_huge_page() returns NULL when it is not able to
allocate a huge page on the current node, as specified by its custom
interleave variable.  The callers of this function, though, assume that a
failure in alloc_fresh_huge_page() indicates no hugepages can be allocated
on the system period.  This might not be the case, for instance, if we have
an uneven NUMA system, and we happen to try to allocate a hugepage on a
node with less memory and fail, while there is still plenty of free memory
on the other nodes.

To correct this, make alloc_fresh_huge_page() search through all online
nodes before deciding no hugepages can be allocated.  Add a helper function
for actually allocating the hugepage.  Use a new global nid iterator to
control which nid to allocate on.

Note: we expect particular semantics for __GFP_THISNODE, which are now
enforced even for memoryless nodes.  That is, there is should be no
fallback to other nodes.  Therefore, we rely on the nid passed into
alloc_pages_node() to be the nid the page comes from.  If this is
incorrect, accounting will break.

Tested on x86 !NUMA, x86 NUMA, x86_64 NUMA and ppc64 NUMA (with 2
memoryless nodes).

Before on the ppc64 box:
Trying to clear the hugetlb pool
Done.       0 free
Trying to resize the pool to 100
Node 0 HugePages_Free:     25
Node 1 HugePages_Free:     75
Node 2 HugePages_Free:      0
Node 3 HugePages_Free:      0
Done. Initially     100 free
Trying to resize the pool to 200
Node 0 HugePages_Free:     50
Node 1 HugePages_Free:    150
Node 2 HugePages_Free:      0
Node 3 HugePages_Free:      0
Done.     200 free

After:
Trying to clear the hugetlb pool
Done.       0 free
Trying to resize the pool to 100
Node 0 HugePages_Free:     50
Node 1 HugePages_Free:     50
Node 2 HugePages_Free:      0
Node 3 HugePages_Free:      0
Done. Initially     100 free
Trying to resize the pool to 200
Node 0 HugePages_Free:    100
Node 1 HugePages_Free:    100
Node 2 HugePages_Free:      0
Node 3 HugePages_Free:      0
Done.     200 free

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   63 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-hugepage-allocation-with-memoryless-nodes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-hugepage-allocation-with-memoryless-nodes
+++ a/mm/hugetlb.c
@@ -32,6 +32,7 @@ static unsigned int surplus_huge_pages_n
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 int hugetlb_dynamic_pool;
+static int hugetlb_next_nid;
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -165,36 +166,56 @@ static int adjust_pool_surplus(int delta
 	return ret;
 }
 
-static int alloc_fresh_huge_page(void)
+static struct page *alloc_fresh_huge_page_node(int nid)
 {
-	static int prev_nid;
 	struct page *page;
-	int nid;
-
-	/*
-	 * Copy static prev_nid to local nid, work on that, then copy it
-	 * back to prev_nid afterwards: otherwise there's a window in which
-	 * a racer might pass invalid nid MAX_NUMNODES to alloc_pages_node.
-	 * But we don't need to use a spin_lock here: it really doesn't
-	 * matter if occasionally a racer chooses the same nid as we do.
-	 */
-	nid = next_node(prev_nid, node_online_map);
-	if (nid == MAX_NUMNODES)
-		nid = first_node(node_online_map);
-	prev_nid = nid;
 
-	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
-					HUGETLB_PAGE_ORDER);
+	page = alloc_pages_node(nid,
+		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|__GFP_NOWARN,
+		HUGETLB_PAGE_ORDER);
 	if (page) {
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
 		nr_huge_pages++;
-		nr_huge_pages_node[page_to_nid(page)]++;
+		nr_huge_pages_node[nid]++;
 		spin_unlock(&hugetlb_lock);
 		put_page(page); /* free it into the hugepage allocator */
-		return 1;
 	}
-	return 0;
+
+	return page;
+}
+
+static int alloc_fresh_huge_page(void)
+{
+	struct page *page;
+	int start_nid;
+	int next_nid;
+	int ret = 0;
+
+	start_nid = hugetlb_next_nid;
+
+	do {
+		page = alloc_fresh_huge_page_node(hugetlb_next_nid);
+		if (page)
+			ret = 1;
+		/*
+		 * Use a helper variable to find the next node and then
+		 * copy it back to hugetlb_next_nid afterwards:
+		 * otherwise there's a window in which a racer might
+		 * pass invalid nid MAX_NUMNODES to alloc_pages_node.
+		 * But we don't need to use a spin_lock here: it really
+		 * doesn't matter if occasionally a racer chooses the
+		 * same nid as we do.  Move nid forward in the mask even
+		 * if we just successfully allocated a hugepage so that
+		 * the next caller gets hugepages on the next node.
+		 */
+		next_nid = next_node(hugetlb_next_nid, node_online_map);
+		if (next_nid == MAX_NUMNODES)
+			next_nid = first_node(node_online_map);
+		hugetlb_next_nid = next_nid;
+	} while (!page && hugetlb_next_nid != start_nid);
+
+	return ret;
 }
 
 static struct page *alloc_buddy_huge_page(struct vm_area_struct *vma,
@@ -365,6 +386,8 @@ static int __init hugetlb_init(void)
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&hugepage_freelists[i]);
 
+	hugetlb_next_nid = first_node(node_online_map);
+
 	for (i = 0; i < max_huge_pages; ++i) {
 		if (!alloc_fresh_huge_page())
 			break;
_

Patches currently in -mm which might be from nacc@us.ibm.com are

memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
hugetlbfs-read-support.patch
hugetlbfs-read-support-fix-2-fix.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
