Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE7D2DA765
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081243; cv=none; b=op6uvlTsew2EmMvjLzjuq8V1e4+UrpqhkNTFzGsUV6mKiWklEXdDGoX8uKJLmN2O90pi1apiWYKKU3QvOfJEdZISGa0dqodcKWx5TyEf3OyfE4Nv4AH8M2B+fmRuxdWofLpsSu9tJUxl/5YDkz4Fof87JiMnmURl7tjx9YzH+xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081243; c=relaxed/simple;
	bh=ZvoQRxv5I6i3wnaE2su07BKXWV6Cm3F8QGNNsf+hddw=;
	h=Date:To:From:Subject:Message-Id; b=JN9w/QhkNngmAERpIczWpErXMHDYz238u0/JGSgGuQoOTY9hWE0Zu2YsWsdA9Npq7VF2fzSSNfiRJS4XyNDlotclW1RlMSB/k9qTr5Fp9Zq3Vd0NrAlzzlU1YINjsgRXapUF0M15XPZYANpKLV66hMn95qTI+okVUztZWFFugAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DvNUHJSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DvNUHJSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7631F00893;
	Thu, 10 Sep 2026 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081241;
	bh=SSgPUCPOsIBvPhYwjigbqjRHdni0GjV2Le/Gu8rvcxU=;
	h=Date:To:From:Subject;
	b=DvNUHJSen0Gf5wVyzv1gPlX199lXDk8t/0in7vzndOnZRyqJeViqzpWDvE6TDvcsh
	 AdMLR03PrZi2d4hGh+FhqshrhGOzY8n25UH+3bIP/3CoMmepviWvkkaxD/nnRCD4G6
	 z0c7Xzxg2tUJyTeVg8jLcVjdsRB6DxKv9ucX7stk=
Date: Thu, 10 Sep 2026 16:00:40 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-rename-hvo-order-macros.patch removed from -mm tree
Message-Id: <20260910230041.5B7631F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: rename HVO order macros
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-rename-hvo-order-macros.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: rename HVO order macros
Date: Tue, 25 Aug 2026 16:45:53 +0800

The macros VMEMMAP_TAIL_MIN_ORDER and NR_VMEMMAP_TAILS describe the order
range where HVO can be applied, but their names tie that range to the
tail-page cache implementation.

Rename them with a VMEMMAP_OPTIMIZATION prefix and use the new names in
the HVO paths.  This makes the code describe the optimization requirements
rather than the tail-page cache implementation detail.

No functional change intended.

Link: https://lore.kernel.org/20260825084608.47437-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   17 +++++++++--------
 mm/hugetlb.c           |    4 ++--
 mm/hugetlb_vmemmap.c   |    2 +-
 mm/sparse-vmemmap.c    |    4 ++--
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/include/linux/mmzone.h
@@ -107,13 +107,14 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/*
- * vmemmap optimization (like HVO) is only possible for page orders that fill
- * two or more pages with struct pages.
- */
-#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
-#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
-#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+#define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
+
+#define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
+	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
+#define VMEMMAP_OPTIMIZATION_NR_ORDERS		\
+	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? __VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -1158,7 +1159,7 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
 #endif
 } ____cacheline_internodealigned_in_smp;
 
--- a/mm/hugetlb.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/hugetlb.c
@@ -3368,7 +3368,7 @@ void __init hugetlb_bootmem_struct_page_
 	struct zone *zone;
 
 	for_each_zone(zone) {
-		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+		for (int i = 0; i < VMEMMAP_OPTIMIZATION_NR_ORDERS; i++) {
 			struct page *tail, *p;
 			unsigned int order;
 
@@ -3376,7 +3376,7 @@ void __init hugetlb_bootmem_struct_page_
 			if (!tail)
 				continue;
 
-			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			order = i + VMEMMAP_OPTIMIZATION_MIN_ORDER;
 			p = page_to_virt(tail);
 			/*
 			 * prep_and_add_bootmem_folios() can access pageblock
--- a/mm/hugetlb_vmemmap.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/hugetlb_vmemmap.c
@@ -494,7 +494,7 @@ static bool vmemmap_should_optimize_foli
 
 static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
-	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	struct page *tail, *p;
 	int node = zone_to_nid(zone);
 
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-rename-hvo-order-macros
+++ a/mm/sparse-vmemmap.c
@@ -329,12 +329,12 @@ static __meminit struct page *vmemmap_ge
 	unsigned int idx;
 	int node = zone_to_nid(zone);
 
-	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
 		return NULL;
 	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
 		return NULL;
 
-	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

