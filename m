From: akpm@linux-foundation.org
Subject: + hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:41:08 -0700
Message-ID: <200710032141.l93Lf9Br010051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785AbXJCVmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, bill.irwin@oracle.com, dave.mccracken@oracle.com, david@gibson.dropbear.id.au, kenchen@google.com, mel@csn.ul.ie, pbadari@us.ibm.com


The patch titled
     hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings
has been added to the -mm tree.  Its filename is
     hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings
From: Adam Litke <agl@us.ibm.com>

Because we overcommit hugepages for MAP_PRIVATE mappings, it is possible that
the hugetlb pool will be exhausted or completely reserved when a hugepage is
needed to satisfy a page fault.  Before killing the process in this situation,
try to allocate a hugepage directly from the buddy allocator.

The explicitly configured pool size becomes a low watermark.  When dynamically
grown, the allocated huge pages are accounted as a surplus over the watermark.
 As huge pages are freed on a node, surplus pages are released to the buddy
allocator so that the pool will shrink back to the watermark.

Surplus accounting also allows for friendlier explicit pool resizing.  When
shrinking a pool that is fully in-use, increase the surplus so pages will be
returned to the buddy allocator as soon as they are freed.  When growing a
pool that has a surplus, consume the surplus first and then allocate new
pages.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Dave McCracken <dave.mccracken@oracle.com>
Cc: William Irwin <bill.irwin@oracle.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/hugetlb.c~hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings
+++ a/mm/hugetlb.c
@@ -23,10 +23,12 @@
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static unsigned long nr_huge_pages, free_huge_pages, resv_huge_pages;
+static unsigned long surplus_huge_pages;
 unsigned long max_huge_pages;
 static struct list_head hugepage_freelists[MAX_NUMNODES];
 static unsigned int nr_huge_pages_node[MAX_NUMNODES];
 static unsigned int free_huge_pages_node[MAX_NUMNODES];
+static unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
@@ -109,15 +111,57 @@ static void update_and_free_page(struct 
 
 static void free_huge_page(struct page *page)
 {
-	BUG_ON(page_count(page));
+	int nid = page_to_nid(page);
 
+	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
 	spin_lock(&hugetlb_lock);
-	enqueue_huge_page(page);
+	if (surplus_huge_pages_node[nid]) {
+		update_and_free_page(page);
+		surplus_huge_pages--;
+		surplus_huge_pages_node[nid]--;
+	} else {
+		enqueue_huge_page(page);
+	}
 	spin_unlock(&hugetlb_lock);
 }
 
+/*
+ * Increment or decrement surplus_huge_pages.  Keep node-specific counters
+ * balanced by operating on them in a round-robin fashion.
+ * Returns 1 if an adjustment was made.
+ */
+static int adjust_pool_surplus(int delta)
+{
+	static int prev_nid;
+	int nid = prev_nid;
+	int ret = 0;
+
+	VM_BUG_ON(delta != -1 && delta != 1);
+	do {
+		nid = next_node(nid, node_online_map);
+		if (nid == MAX_NUMNODES)
+			nid = first_node(node_online_map);
+
+		/* To shrink on this node, there must be a surplus page */
+		if (delta < 0 && !surplus_huge_pages_node[nid])
+			continue;
+		/* Surplus cannot exceed the total number of pages */
+		if (delta > 0 && surplus_huge_pages_node[nid] >=
+						nr_huge_pages_node[nid])
+			continue;
+
+		surplus_huge_pages += delta;
+		surplus_huge_pages_node[nid] += delta;
+		ret = 1;
+		break;
+	} while (nid != prev_nid);
+
+	prev_nid = nid;
+	return ret;
+}
+
 static int alloc_fresh_huge_page(void)
 {
 	static int prev_nid;
@@ -150,10 +194,30 @@ static int alloc_fresh_huge_page(void)
 	return 0;
 }
 
+static struct page *alloc_buddy_huge_page(struct vm_area_struct *vma,
+						unsigned long address)
+{
+	struct page *page;
+
+	page = alloc_pages(htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
+					HUGETLB_PAGE_ORDER);
+	if (page) {
+		set_compound_page_dtor(page, free_huge_page);
+		spin_lock(&hugetlb_lock);
+		nr_huge_pages++;
+		nr_huge_pages_node[page_to_nid(page)]++;
+		surplus_huge_pages++;
+		surplus_huge_pages_node[page_to_nid(page)]++;
+		spin_unlock(&hugetlb_lock);
+	}
+
+	return page;
+}
+
 static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr)
 {
-	struct page *page;
+	struct page *page = NULL;
 
 	spin_lock(&hugetlb_lock);
 	if (vma->vm_flags & VM_MAYSHARE)
@@ -173,7 +237,16 @@ fail:
 	if (vma->vm_flags & VM_MAYSHARE)
 		resv_huge_pages++;
 	spin_unlock(&hugetlb_lock);
-	return NULL;
+
+	/*
+	 * Private mappings do not use reserved huge pages so the allocation
+	 * may have failed due to an undersized hugetlb pool.  Try to grab a
+	 * surplus huge page from the buddy allocator.
+	 */
+	if (!(vma->vm_flags & VM_MAYSHARE))
+		page = alloc_buddy_huge_page(vma, addr);
+
+	return page;
 }
 
 static int __init hugetlb_init(void)
@@ -241,26 +314,62 @@ static inline void try_to_free_low(unsig
 }
 #endif
 
+#define persistent_huge_pages (nr_huge_pages - surplus_huge_pages)
 static unsigned long set_max_huge_pages(unsigned long count)
 {
-	while (count > nr_huge_pages) {
-		if (!alloc_fresh_huge_page())
-			return nr_huge_pages;
-	}
-	if (count >= nr_huge_pages)
-		return nr_huge_pages;
+	unsigned long min_count, ret;
 
+	/*
+	 * Increase the pool size
+	 * First take pages out of surplus state.  Then make up the
+	 * remaining difference by allocating fresh huge pages.
+	 */
 	spin_lock(&hugetlb_lock);
-	count = max(count, resv_huge_pages);
-	try_to_free_low(count);
-	while (count < nr_huge_pages) {
+	while (surplus_huge_pages && count > persistent_huge_pages) {
+		if (!adjust_pool_surplus(-1))
+			break;
+	}
+
+	while (count > persistent_huge_pages) {
+		int ret;
+		/*
+		 * If this allocation races such that we no longer need the
+		 * page, free_huge_page will handle it by freeing the page
+		 * and reducing the surplus.
+		 */
+		spin_unlock(&hugetlb_lock);
+		ret = alloc_fresh_huge_page();
+		spin_lock(&hugetlb_lock);
+		if (!ret)
+			goto out;
+
+	}
+	if (count >= persistent_huge_pages)
+		goto out;
+
+	/*
+	 * Decrease the pool size
+	 * First return free pages to the buddy allocator (being careful
+	 * to keep enough around to satisfy reservations).  Then place
+	 * pages into surplus state as needed so the pool will shrink
+	 * to the desired size as pages become free.
+	 */
+	min_count = max(count, resv_huge_pages);
+	try_to_free_low(min_count);
+	while (min_count < persistent_huge_pages) {
 		struct page *page = dequeue_huge_page(NULL, 0);
 		if (!page)
 			break;
 		update_and_free_page(page);
 	}
+	while (count < persistent_huge_pages) {
+		if (!adjust_pool_surplus(1))
+			break;
+	}
+out:
+	ret = persistent_huge_pages;
 	spin_unlock(&hugetlb_lock);
-	return nr_huge_pages;
+	return ret;
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
@@ -292,10 +401,12 @@ int hugetlb_report_meminfo(char *buf)
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
+			"HugePages_Surp:  %5lu\n"
 			"Hugepagesize:    %5lu kB\n",
 			nr_huge_pages,
 			free_huge_pages,
 			resv_huge_pages,
+			surplus_huge_pages,
 			HPAGE_SIZE/1024);
 }
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
