Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403052;
	b=UnpvY5691eEufA0B1AnphAxa76zovJv3qRMDsHR/nPIQGtyFhKWp0440v5BF/tCSWI5D
	 isYQ1WwIql/si4PXWnheY+vAxKF8YohTEKjB2nalPv7zRfs1I942Ggc8trIVB2wCqD4T8
	 nmI/zb2RBLGHn+ZHdfSt4VLRV0Sy56ufKFOiGBgvLh16gKJ6iufSXT1sL4p/pVjJs/SPG
	 lMeWVg0K8+hA82d+GVieCxdjfat7sPPiGNT8TeXYAjfPcU5piJqvs8/Rlgbe2TUeOJzfY
	 PU1oiGzaI7KOQfFsTxozR8tsRsxr8pE02LNMgBuPqAjD1T4M/65sgI4Pg5LpoZ2grEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403052;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=3+2/jjoJqh51QfgGb3UlArZblSIN6jEDgEtFxCqfdRY=;
	b=epJM9MOIwbbaU+2tjavNT2F/shZcbIC8zbKpvOMbXyCVxxtKZw6+lgRzjw1PrkfVtN08
	 LhBWVgP7KG5CPpPDN2Vf+YFNj+21u5m5NbJgJikZ3/eUAjxYk96e9gQKi1jCCf6fNPiZ4
	 lCmjR8jOYls6zb+0WIw/MFkSR5eriz3jZ9/FZBcOTV8KFYhg6shjCyHYGf4Xu88lfom8+
	 fg5AMyztY2CI7A7nmchPrq3vYb8e1HjParQPJ8JQxkzSS1X/0VlsWS56WMHasynoHNA48
	 dh4xMU4oYW8ALEUFrQmm41BzXrJetcBTPRzdg0dCx6STPvxyQR0aOnXvBAQ0MC6Y4qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u5uKVOt+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDA4606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 03:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u5uKVOt+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E5B1F000C6;
	Mon, 23 Nov 2026 03:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795403051;
	bh=3+2/jjoJqh51QfgGb3UlArZblSIN6jEDgEtFxCqfdRY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=u5uKVOt+366jC52TG1/myGc4eJ3YZ1gkMiBTBtVmsnP2qIbvlDkMIGbUKeiAUwU5L
	 Vktj+VyBdYAruH2gkPhPXCNAuv6r1RxN4YNs6zR8z9xQw2bPAiao7z7OaAC+7/WzZZ
	 7JNLu2rHJS+tZUHEZefuI+E+ZP4quYf9VZK0VPTs=
Date: Sun, 22 Nov 2026 19:04:10 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,
	ljs@kernel.org,lizhe.67@bytedance.com,liam@infradead.org,
	lance.yang@linux.dev,jthoughton@google.com,david@kernel.org,
	balbirs@nvidia.com,apopple@nvidia.com,songmuchun@bytedance.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120100856.16929-5-songmuchun@bytedance.com>
References: <20261120100856.16929-5-songmuchun@bytedance.com>
Subject: + mm-mm_init-factor-out-compound-page-initialization.patch added to mm-new branch
Message-Id: <20261123030411.64E5B1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mm_init: factor out compound page initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-factor-out-compound-page-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-factor-out-compound-page-initialization.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: factor out compound page initialization
Date: Fri, 20 Nov 2026 18:08:49 +0800

ZONE_DEVICE initializes compound struct pages while their refcounts remain
frozen. The setup is open-coded in memmap_init_compound(), including the
per-page initialization and compound tail preparation.

Factor the common setup into memmap_init_compound_page(). Keep the pgmap
association and MEMORY_DEVICE_GENERIC refcount handling in the
ZONE_DEVICE-specific path.

This provides an MM-internal helper for other early memmap users to
share.

No functional change is intended.

Link: https://patch.msgid.link/20261120100856.16929-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>

 mm/mm_init.c |  143 +++++++++++++++++++++++++------------------------
 mm/mm_init.h |    2 
 2 files changed, 76 insertions(+), 69 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-factor-out-compound-page-initialization
+++ a/mm/mm_init.c
@@ -718,6 +718,45 @@ static __meminit void pageblock_migratet
 	}
 }
 
+static void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, const struct zone *zone, struct page *template)
+{
+	/*
+	 * Refresh PFN-dependent fields in the template before the non-temporal
+	 * copy, so the destination page does not need cached stores after
+	 * memcpy_nontemporal().
+	 */
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone_idx(zone)))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
+}
+
+void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
+		const struct zone *zone, unsigned int order)
+{
+	unsigned long nr_pages = 1UL << order;
+	struct page template;
+
+	memmap_init_page(&template, zone_idx(zone), zone_to_nid(zone));
+	prep_compound_tail(&template, head, order);
+
+	/* Initialize the head page. */
+	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
+	set_page_count(head, 0);
+	__SetPageHead(head);
+
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+	/* Initialize the tail pages from PFN-independent template page. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
+	prep_compound_head(head, order);
+}
+
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1036,56 +1075,39 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
+static void memmap_init_zone_device_folio(struct folio *folio,
+		struct dev_pagemap *pgmap)
 {
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-	vmemmap_optimization_verify_zone(page);
-}
-
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
+	/*
+	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
+	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
+	 * @folio may be a stack template, while init_page_count() expects a
+	 * memmap-backed page.
+	 */
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&folio->_refcount, 1);
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer and
+	 * zone_device_data. It is a bug if a ZONE_DEVICE page is ever freed
+	 * or placed on a driver-private list.
+	 */
+	folio->pgmap = pgmap;
+	folio->page.zone_device_data = NULL;
 }
 
-static void __ref memmap_init_compound(struct page *head,
-				       unsigned long head_pfn,
-				       unsigned long zone_idx, int nid,
-				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+static void memmap_init_zone_device_pages(unsigned long start, unsigned long end,
+		const struct zone *zone, struct dev_pagemap *pgmap)
 {
-	unsigned long pfn, end_pfn = head_pfn + nr_pages;
-	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
 
-	memmap_init_page(&template, zone_idx, nid);
-	prep_compound_tail(&template, head, order);
+	memmap_init_page(&template, zone_idx(zone), zone_to_nid(zone));
+	memmap_init_zone_device_folio(page_folio(&template), pgmap);
 
-	__SetPageHead(head);
-	/* Initialize the tail pages from template. */
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
-	prep_compound_head(head, order);
+	for (unsigned long pfn = start; pfn < end; pfn++) {
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone, &template);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1094,16 +1116,11 @@ void __ref memmap_init_zone_device(struc
 				   struct dev_pagemap *pgmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
 	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
-	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
-	int nid = pgdat->node_id;
-	struct page template;
-	struct page *page;
 
-	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
+	if (WARN_ON_ONCE(!pgmap || !zone_is_zone_device(zone)))
 		return;
 
 	/*
@@ -1118,32 +1135,20 @@ void __ref memmap_init_zone_device(struc
 
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
-	memmap_init_page(&template, zone_idx, nid);
-	page_folio(&template)->pgmap = pgmap;
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
-	 * path. The remaining ZONE_DEVICE types start from zero here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	if (pgmap->type == MEMORY_DEVICE_GENERIC)
-		atomic_set(&template._refcount, 1);
+	if (pfns_per_compound == 1) {
+		memmap_init_zone_device_pages(start_pfn, end_pfn, zone, pgmap);
+		goto out;
+	}
 
-	/* Initialize the head pages from template. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		page = pfn_to_page(pfn);
-
-		zone_device_page_init_from_template(page, pfn, &template);
+		struct page *head = pfn_to_page(pfn);
 
+		memmap_init_compound_page(head, pfn, zone, pgmap->vmemmap_shift);
+		memmap_init_zone_device_folio(page_folio(head), pgmap);
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-
-		if (pfns_per_compound == 1)
-			continue;
-
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
 	}
-
+out:
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
 					 /* isolate */ false, /* atomic */ false);
 
--- a/mm/mm_init.h~mm-mm_init-factor-out-compound-page-initialization
+++ a/mm/mm_init.h
@@ -112,5 +112,7 @@ void memblock_free_all(void);
 void memmap_init_page(struct page *page, enum zone_type zone, int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
+		const struct zone *zone, unsigned int order);
 
 #endif /* __MM_MM_INIT_H */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch
mm-list_lru-fix-potential-infinite-loop-on-xa-node-allocation-failure.patch
mm-mm_init-verify-zones-for-template-initialized-pages.patch
mm-mm_init-factor-out-common-struct-page-initialization.patch
mm-mm_init-simplify-zone-device-page-initialization.patch
mm-mm_init-factor-out-compound-page-initialization.patch
mm-hugetlb-drop-boot-time-hvo-handling-for-gigantic-folios.patch
mm-hugetlb-initialize-all-struct-pages-for-bootmem-hugepages.patch
mm-hugetlb-use-common-compound-page-initialization-helper.patch
mm-mm_init-make-__init_single_page-static.patch
mm-cma-centralize-cma-pageblock-initialization.patch
mm-cma-localize-init_cma_pageblock-to-cmac.patch
mm-mm_init-move-pageblock-migratetype-init-to-memmap-helpers.patch

