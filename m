From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:41 -0700
Message-ID: <5390c9d5.2wmq4QB1TKSQyoo9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaFETtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mtosatti@redhat.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidlohr@hp.com, aarcange@redhat.com, lcapitulino@redhat.com

Subject: [merged] hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch removed from -mm tree
To: lcapitulino@redhat.com,aarcange@redhat.com,davidlohr@hp.com,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,mtosatti@redhat.com,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:41 -0700


The patch titled
     Subject: hugetlb: add support for gigantic page allocation at runtime
has been removed from the -mm tree.  Its filename was
     hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: add support for gigantic page allocation at runtime

HugeTLB is limited to allocating hugepages whose size are less than
MAX_ORDER order.  This is so because HugeTLB allocates hugepages via the
buddy allocator.  Gigantic pages (that is, pages whose size is greater
than MAX_ORDER order) have to be allocated at boottime.

However, boottime allocation has at least two serious problems.  First, it
doesn't support NUMA and second, gigantic pages allocated at boottime
can't be freed.

This commit solves both issues by adding support for allocating gigantic
pages during runtime.  It works just like regular sized hugepages, meaning
that the interface in sysfs is the same, it supports NUMA, and gigantic
pages can be freed.

For example, on x86_64 gigantic pages are 1GB big. To allocate two 1G
gigantic pages on node 1, one can do:

 # echo 2 > \
   /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages

And to free them all:

 # echo 0 > \
   /sys/devices/system/node/node1/hugepages/hugepages-1048576kB/nr_hugepages

The one problem with gigantic page allocation at runtime is that it can't
be serviced by the buddy allocator.  To overcome that problem, this commit
scans all zones from a node looking for a large enough contiguous region. 
When one is found, it's allocated by using CMA, that is, we call
alloc_contig_range() to do the actual allocation.  For example, on x86_64
we scan all zones looking for a 1GB contiguous region.  When one is found,
it's allocated by alloc_contig_range().

One expected issue with that approach is that such gigantic contiguous
regions tend to vanish as runtime goes by.  The best way to avoid this for
now is to make gigantic page allocations very early during system boot,
say from a init script.  Other possible optimization include using
compaction, which is supported by CMA but is not explicitly used by this
commit.

It's also important to note the following:

 1. Gigantic pages allocated at boottime by the hugepages= command-line
    option can be freed at runtime just fine

 2. This commit adds support for gigantic pages only to x86_64. The
    reason is that I don't have access to nor experience with other archs.
    The code is arch indepedent though, so it should be simple to add
    support to different archs

 3. I didn't add support for hugepage overcommit, that is allocating
    a gigantic page on demand when
   /proc/sys/vm/nr_overcommit_hugepages > 0. The reason is that I don't
   think it's reasonable to do the hard and long work required for
   allocating a gigantic page at fault time. But it should be simple
   to add this if wanted

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  166 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 155 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime
+++ a/mm/hugetlb.c
@@ -680,11 +680,150 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
+#if defined(CONFIG_CMA) && defined(CONFIG_X86_64)
+static void destroy_compound_gigantic_page(struct page *page,
+					unsigned long order)
+{
+	int i;
+	int nr_pages = 1 << order;
+	struct page *p = page + 1;
+
+	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+		__ClearPageTail(p);
+		set_page_refcounted(p);
+		p->first_page = NULL;
+	}
+
+	set_compound_order(page, 0);
+	__ClearPageHead(page);
+}
+
+static void free_gigantic_page(struct page *page, unsigned order)
+{
+	free_contig_range(page_to_pfn(page), 1 << order);
+}
+
+static int __alloc_gigantic_page(unsigned long start_pfn,
+				unsigned long nr_pages)
+{
+	unsigned long end_pfn = start_pfn + nr_pages;
+	return alloc_contig_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+}
+
+static bool pfn_range_valid_gigantic(unsigned long start_pfn,
+				unsigned long nr_pages)
+{
+	unsigned long i, end_pfn = start_pfn + nr_pages;
+	struct page *page;
+
+	for (i = start_pfn; i < end_pfn; i++) {
+		if (!pfn_valid(i))
+			return false;
+
+		page = pfn_to_page(i);
+
+		if (PageReserved(page))
+			return false;
+
+		if (page_count(page) > 0)
+			return false;
+
+		if (PageHuge(page))
+			return false;
+	}
+
+	return true;
+}
+
+static bool zone_spans_last_pfn(const struct zone *zone,
+			unsigned long start_pfn, unsigned long nr_pages)
+{
+	unsigned long last_pfn = start_pfn + nr_pages - 1;
+	return zone_spans_pfn(zone, last_pfn);
+}
+
+static struct page *alloc_gigantic_page(int nid, unsigned order)
+{
+	unsigned long nr_pages = 1 << order;
+	unsigned long ret, pfn, flags;
+	struct zone *z;
+
+	z = NODE_DATA(nid)->node_zones;
+	for (; z - NODE_DATA(nid)->node_zones < MAX_NR_ZONES; z++) {
+		spin_lock_irqsave(&z->lock, flags);
+
+		pfn = ALIGN(z->zone_start_pfn, nr_pages);
+		while (zone_spans_last_pfn(z, pfn, nr_pages)) {
+			if (pfn_range_valid_gigantic(pfn, nr_pages)) {
+				/*
+				 * We release the zone lock here because
+				 * alloc_contig_range() will also lock the zone
+				 * at some point. If there's an allocation
+				 * spinning on this lock, it may win the race
+				 * and cause alloc_contig_range() to fail...
+				 */
+				spin_unlock_irqrestore(&z->lock, flags);
+				ret = __alloc_gigantic_page(pfn, nr_pages);
+				if (!ret)
+					return pfn_to_page(pfn);
+				spin_lock_irqsave(&z->lock, flags);
+			}
+			pfn += nr_pages;
+		}
+
+		spin_unlock_irqrestore(&z->lock, flags);
+	}
+
+	return NULL;
+}
+
+static void prep_new_huge_page(struct hstate *h, struct page *page, int nid);
+static void prep_compound_gigantic_page(struct page *page, unsigned long order);
+
+static struct page *alloc_fresh_gigantic_page_node(struct hstate *h, int nid)
+{
+	struct page *page;
+
+	page = alloc_gigantic_page(nid, huge_page_order(h));
+	if (page) {
+		prep_compound_gigantic_page(page, huge_page_order(h));
+		prep_new_huge_page(h, page, nid);
+	}
+
+	return page;
+}
+
+static int alloc_fresh_gigantic_page(struct hstate *h,
+				nodemask_t *nodes_allowed)
+{
+	struct page *page = NULL;
+	int nr_nodes, node;
+
+	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
+		page = alloc_fresh_gigantic_page_node(h, node);
+		if (page)
+			return 1;
+	}
+
+	return 0;
+}
+
+static inline bool gigantic_page_supported(void) { return true; }
+#else
+static inline bool gigantic_page_supported(void) { return false; }
+static inline void free_gigantic_page(struct page *page, unsigned order) { }
+static inline void destroy_compound_gigantic_page(struct page *page,
+						unsigned long order) { }
+static inline int alloc_fresh_gigantic_page(struct hstate *h,
+					nodemask_t *nodes_allowed) { return 0; }
+#endif
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
 
-	VM_BUG_ON(hstate_is_gigantic(h));
+	if (hstate_is_gigantic(h) && !gigantic_page_supported())
+		return;
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
@@ -697,8 +836,13 @@ static void update_and_free_page(struct
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
-	arch_release_hugepage(page);
-	__free_pages(page, huge_page_order(h));
+	if (hstate_is_gigantic(h)) {
+		destroy_compound_gigantic_page(page, huge_page_order(h));
+		free_gigantic_page(page, huge_page_order(h));
+	} else {
+		arch_release_hugepage(page);
+		__free_pages(page, huge_page_order(h));
+	}
 }
 
 struct hstate *size_to_hstate(unsigned long size)
@@ -737,7 +881,7 @@ static void free_huge_page(struct page *
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (h->surplus_huge_pages_node[nid] && !hstate_is_gigantic(h)) {
+	if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		list_del(&page->lru);
 		update_and_free_page(h, page);
@@ -841,9 +985,6 @@ static struct page *alloc_fresh_huge_pag
 {
 	struct page *page;
 
-	if (hstate_is_gigantic(h))
-		return NULL;
-
 	page = alloc_pages_exact_node(nid,
 		htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
@@ -1478,7 +1619,7 @@ static unsigned long set_max_huge_pages(
 {
 	unsigned long min_count, ret;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_supported())
 		return h->max_huge_pages;
 
 	/*
@@ -1505,7 +1646,10 @@ static unsigned long set_max_huge_pages(
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
-		ret = alloc_fresh_huge_page(h, nodes_allowed);
+		if (hstate_is_gigantic(h))
+			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
+		else
+			ret = alloc_fresh_huge_page(h, nodes_allowed);
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
@@ -1605,7 +1749,7 @@ static ssize_t nr_hugepages_store_common
 		goto out;
 
 	h = kobj_to_hstate(kobj, &nid);
-	if (hstate_is_gigantic(h)) {
+	if (hstate_is_gigantic(h) && !gigantic_page_supported()) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -2112,7 +2256,7 @@ static int hugetlb_sysctl_handler_common
 
 	tmp = h->max_huge_pages;
 
-	if (write && hstate_is_gigantic(h))
+	if (write && hstate_is_gigantic(h) && !gigantic_page_supported())
 		return -EINVAL;
 
 	table->data = &tmp;
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

origin.patch
linux-next.patch

