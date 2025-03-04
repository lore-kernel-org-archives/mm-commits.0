Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A01B4247
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056549; cv=none; b=GMCbuKFjezo7bXKiaHu3OijLpJUlV2grjv0CEYDH9JpqhCcJKurodn0/wtqMy8NkukTiV2AdaLTqyjFDSEZtuGtLNxESDjQsRuwI5xIXrgLiZG92NXmgVBDeN7i4Me8WbYui3erSu+ZXVr8Fo7xPu00HTCKBpoFUvPvoHFNY3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056549; c=relaxed/simple;
	bh=njQ445wBSpjvOYkUq6Ya9nMky9pUHXlkYOUouJo69KQ=;
	h=Date:To:From:Subject:Message-Id; b=WBEZWv3irakCyC/9uHXX81OjxNbRBsrf4EmWCzSny7zCf9WcV9wg86FRVncLyuFPJb8iU7XSv/soMBW2vuDlemygVZqAJnCWtH7y3gqVrzv3Rdm75XLMIXypaue2NYpX+Y5rBWpx6oOO/n7TAky2fQ9hG04OjtG4Bek816uydRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h2vPy9g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h2vPy9g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8677C4CEE4;
	Tue,  4 Mar 2025 02:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056549;
	bh=njQ445wBSpjvOYkUq6Ya9nMky9pUHXlkYOUouJo69KQ=;
	h=Date:To:From:Subject:From;
	b=h2vPy9g8mj1k5gSWWNrBxOInYRCimPDIt/45cxio5LHBi/4GvjU2CJZ5fRVDaHqCT
	 zzIHbz9gg9rk1yQ4SsVpbhMsNMSF65skcfkfc1b11JM54jKuTtXIOvwY6YRZt1ANiz
	 4OApWX2azluiiTGSeSwG8v73e7jD+CBs/l/20sY0=
Date: Mon, 03 Mar 2025 18:49:08 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch added to mm-unstable branch
Message-Id: <20250304024908.E8677C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: check bootmem pages for zone intersections
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -3312,6 +3313,44 @@ static void __init prep_and_add_bootmem_
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
@@ -3319,14 +3358,25 @@ static void __init prep_and_add_bootmem_
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
@@ -3598,13 +3648,20 @@ static void __init hugetlb_init_hstates(
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
@@ -2300,6 +2300,31 @@ void set_zone_contiguous(struct zone *zo
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

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_hugetlb_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

