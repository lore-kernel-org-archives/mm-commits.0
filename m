Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1344216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188379; cv=none; b=QlZXdzAhCQ/QKsqed/v+iZWn6cprKzhimR4+pipKDvNW+maTip2M/1e8s433MLURlLzgMojIINHs9X3Son//9y8mUBJ+8uQTWIEl17WI9ZPZaIn6IfSr7k+aLsdYe3zoWR0sfElImUvd+sNUlnjWlVrf+a2GaYuo0LqrUjZ9CN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188379; c=relaxed/simple;
	bh=fGXNExOWRMHuOaB4B8fezggA20kAhsbi5HCgixF95xc=;
	h=Date:To:From:Subject:Message-Id; b=lhPy5qYikukipF/4Pn5j+mKaz2gQvuw5rFQIJyIAMituqockNNQSmFDyrvlEN++TOFcA+LdVKkfIjiZHI5HLo3+pNHEBomPAKfqWy0ZCHvKRMphxyIgRvPOZcD+/9gvSl+5I5jSCae5EuALO64Az/7/1JQ2mWR/dH/jCzd8kuac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q+ZqT39X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q+ZqT39X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815D5C4CEEC;
	Mon, 17 Mar 2025 05:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188379;
	bh=fGXNExOWRMHuOaB4B8fezggA20kAhsbi5HCgixF95xc=;
	h=Date:To:From:Subject:From;
	b=q+ZqT39XHn2CcnlDmWiS1ByQf3Mm46QE3RYgQJP2CDzzeDsZr0krL/kXtmE8ShAfI
	 /Y1/hsnrWZ4TdtIWZL3MekplG76pqqi46siwnvAYCvF/jVzUJ5h5s7l8Z9qdIylP1R
	 QWZ7YRROq35/7qA8f1j2MFQB5UbPlotjuBFN+U0s=
Date: Sun, 16 Mar 2025 22:12:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch removed from -mm tree
Message-Id: <20250317051259.815D5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: check bootmem pages for zone intersections
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: check bootmem pages for zone intersections
Date: Fri, 28 Feb 2025 18:29:14 +0000

Bootmem hugetlb pages are allocated using memblock, which isn't (and
mostly can't be) aware of zones.

So, they may end up crossing zone boundaries.  This would create
confusion, a hugetlb page that is part of multiple zones is bad.  Worse,
HVO might then end up stealthily re-assigning pages to a different zone
when a hugetlb page is freed, since the tail page structures beyond the
first vmemmap page would inherit the zone of the first page structures.

While the chance of this happening is low, you can definitely create a
configuration where this happens (especially using ZONE_MOVABLE).

To avoid this issue, check if bootmem hugetlb pages intersect with
multiple zones during the gather phase, and discard them, handing them to
the page allocator, if they do.  Record the number of invalid bootmem
pages per node and subtract them from the number of available pages at the
end, making it easier to do these checks in multiple places later on.

Link: https://lkml.kernel.org/r/20250228182928.2645936-14-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |   61 ++++++++++++++++++++++++++++++++++++++++++++++--
 mm/internal.h |    2 +
 mm/mm_init.c  |   25 +++++++++++++++++++
 3 files changed, 86 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-check-bootmem-pages-for-zone-intersections
+++ a/mm/hugetlb.c
@@ -62,6 +62,7 @@ static unsigned long hugetlb_cma_size_in
 static unsigned long hugetlb_cma_size __initdata;
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
+static unsigned long hstate_boot_nrinvalid[HUGE_MAX_HSTATE] __initdata;
 
 /*
  * Due to ordering constraints across the init code for various
@@ -3316,6 +3317,44 @@ static void __init prep_and_add_bootmem_
 	}
 }
 
+static bool __init hugetlb_bootmem_page_zones_valid(int nid,
+						    struct huge_bootmem_page *m)
+{
+	unsigned long start_pfn;
+	bool valid;
+
+	start_pfn = virt_to_phys(m) >> PAGE_SHIFT;
+
+	valid = !pfn_range_intersects_zones(nid, start_pfn,
+			pages_per_huge_page(m->hstate));
+	if (!valid)
+		hstate_boot_nrinvalid[hstate_index(m->hstate)]++;
+
+	return valid;
+}
+
+/*
+ * Free a bootmem page that was found to be invalid (intersecting with
+ * multiple zones).
+ *
+ * Since it intersects with multiple zones, we can't just do a free
+ * operation on all pages at once, but instead have to walk all
+ * pages, freeing them one by one.
+ */
+static void __init hugetlb_bootmem_free_invalid_page(int nid, struct page *page,
+					     struct hstate *h)
+{
+	unsigned long npages = pages_per_huge_page(h);
+	unsigned long pfn;
+
+	while (npages--) {
+		pfn = page_to_pfn(page);
+		__init_reserved_page_zone(pfn, nid);
+		free_reserved_page(page);
+		page++;
+	}
+}
+
 /*
  * Put bootmem huge pages into the standard lists after mem_map is up.
  * Note: This only applies to gigantic (order > MAX_PAGE_ORDER) pages.
@@ -3323,14 +3362,25 @@ static void __init prep_and_add_bootmem_
 static void __init gather_bootmem_prealloc_node(unsigned long nid)
 {
 	LIST_HEAD(folio_list);
-	struct huge_bootmem_page *m;
+	struct huge_bootmem_page *m, *tm;
 	struct hstate *h = NULL, *prev_h = NULL;
 
-	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 
 		h = m->hstate;
+		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
+			/*
+			 * Can't use this page. Initialize the
+			 * page structures if that hasn't already
+			 * been done, and give them to the page
+			 * allocator.
+			 */
+			hugetlb_bootmem_free_invalid_page(nid, page, h);
+			continue;
+		}
+
 		/*
 		 * It is possible to have multiple huge page sizes (hstates)
 		 * in this list.  If so, process each size separately.
@@ -3602,13 +3652,20 @@ static void __init hugetlb_init_hstates(
 static void __init report_hugepages(void)
 {
 	struct hstate *h;
+	unsigned long nrinvalid;
 
 	for_each_hstate(h) {
 		char buf[32];
 
+		nrinvalid = hstate_boot_nrinvalid[hstate_index(h)];
+		h->max_huge_pages -= nrinvalid;
+
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
 		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
 			buf, h->free_huge_pages);
+		if (nrinvalid)
+			pr_info("HugeTLB: %s page size: %lu invalid page%s discarded\n",
+					buf, nrinvalid, nrinvalid > 1 ? "s" : "");
 		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
--- a/mm/internal.h~mm-hugetlb-check-bootmem-pages-for-zone-intersections
+++ a/mm/internal.h
@@ -658,6 +658,8 @@ static inline struct page *pageblock_pfn
 }
 
 void set_zone_contiguous(struct zone *zone);
+bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
+			   unsigned long nr_pages);
 
 static inline void clear_zone_contiguous(struct zone *zone)
 {
--- a/mm/mm_init.c~mm-hugetlb-check-bootmem-pages-for-zone-intersections
+++ a/mm/mm_init.c
@@ -2287,6 +2287,31 @@ void set_zone_contiguous(struct zone *zo
 	zone->contiguous = true;
 }
 
+/*
+ * Check if a PFN range intersects multiple zones on one or more
+ * NUMA nodes. Specify the @nid argument if it is known that this
+ * PFN range is on one node, NUMA_NO_NODE otherwise.
+ */
+bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
+			   unsigned long nr_pages)
+{
+	struct zone *zone, *izone = NULL;
+
+	for_each_zone(zone) {
+		if (nid != NUMA_NO_NODE && zone_to_nid(zone) != nid)
+			continue;
+
+		if (zone_intersects(zone, start_pfn, nr_pages)) {
+			if (izone != NULL)
+				return true;
+			izone = zone;
+		}
+
+	}
+
+	return false;
+}
+
 static void __init mem_init_print_info(void);
 void __init page_alloc_init_late(void)
 {
_

Patches currently in -mm which might be from fvdl@google.com are


