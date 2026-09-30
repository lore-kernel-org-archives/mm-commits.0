Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510713CFF66
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 19:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794913; cv=none; b=LtSU5KlREcNnOyoSLFziGFFtOrXT310naYUyrMn+OFf4QlwsNSQFrQ+AE3/7geBwIh+fsffLkfLrwYfNOOnE60aOhb/inkF+Fd7lxbaGoZrV8hy3QNCa18RsUcx+I4/ZHp+5SPML8K/aMk8ZRVQDLQsAmK/l+oOHLxQDwl3HWms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794913; c=relaxed/simple;
	bh=bgkt9xZinXpkzOuIUWpKkrufFQMHB6knGPx2faJimMM=;
	h=Date:To:From:Subject:Message-Id; b=qIXTaziS6EOTRA7HJeFoJvoMC45g5bop3oOVNyyL+x7zJOmjIPvMnS3FdJXf8Bz3Yg4J5Px9ahXFZn/1NSVSSNhTkJG48LVos1A+gUy7HdRBPBX924W4HlvPHwvVLQ78f0vbt0Y+LADK9cq/mV/AJFHCkfAlC8KeDX7TCYdVrJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tcZRxGN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tcZRxGN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BF51F000FF;
	Wed, 30 Sep 2026 19:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790794912;
	bh=LMo3yamaJG+RQ0R67rwQcDq4etH2QnXCB/E27kdCY7Q=;
	h=Date:To:From:Subject;
	b=tcZRxGN1iLMzeNqZSIZuUvSHiQHercoBwNmzmixATziHcHahBEek3P4/drOsGkDJq
	 v761iPD/aybGY1nPlAehkMpOCjOfrs0TCVDGc3T4Agm8DUrNFotfMplOGkN4S+h1sZ
	 WHo/BbZKkVt7GW5WxGfWF+E2KRw5ZVvAzFiF38rI=
Date: Wed, 30 Sep 2026 12:01:51 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch added to mm-unstable branch
Message-Id: <20260930190151.E3BF51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 22:06:22 +0800

HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages. 
Device DAX has not been switched to that mechanism yet.

Switch device DAX to vmemmap_shared_tail_page() as well.  This aligns DAX
with HugeTLB by using the common per-zone shared tail vmemmap page.

The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
which supplies the compound page order recorded in section metadata before
vmemmap population.  Unlike FS-DAX, DEV-DAX does not modify tail struct
pages, so sharing them is safe.

Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
initialize its entries with PG_reserved for device zones.  Also skip
poisoning vmemmap-optimizable sections while their struct pages may be
shared.

Each PTE mapping the shared device DAX tail page takes a page reference. 
A sufficiently large range could therefore cycle the reference count back
to zero if population were allowed to continue after it became
non-positive.  Use try_get_page() so further mappings fail at that point. 
The section population error path tears down mappings created for the
failed section, while the warning makes this currently impractical limit
visible.

Link: https://lore.kernel.org/20260930140627.57431-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 include/linux/mmzone.h |   10 ++++++
 mm/memory_hotplug.c    |    6 ++-
 mm/sparse-vmemmap.c    |   63 ++++++++++++++++-----------------------
 3 files changed, 40 insertions(+), 39 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/include/linux/mmzone.h
@@ -2143,11 +2143,21 @@ static inline int online_device_section(
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section *section)
 {
 	return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 static inline int online_section_nr(unsigned long nr)
--- a/mm/memory_hotplug.c~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/mm/memory_hotplug.c
@@ -43,6 +43,7 @@
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
+#include "sparse.h"
 
 enum {
 	MEMMAP_ON_MEMORY_DISABLE = 0,
@@ -554,8 +555,9 @@ void remove_pfn_range_from_zone(struct z
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/mm/sparse-vmemmap.c
@@ -225,6 +225,8 @@ struct page __ref *vmemmap_shared_tail_p
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
 		prep_compound_tail(page, NULL, order);
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
 	}
 
 	page = virt_to_page(addr);
@@ -288,14 +290,18 @@ static pte_t * __meminit vmemmap_pte_pop
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			if (flags & VMEMMAP_POPULATE_DAX)
-				get_page(pfn_to_page(ptpfn));
+			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			    !try_get_page(pfn_to_page(ptpfn)))
+				return NULL;
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
@@ -529,47 +535,27 @@ static bool __meminit reuse_compound_sec
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
-{
-	pte_t *pte;
-
-	addr -= PAGE_SIZE;
-
-	/*
-	 * Assuming sections are populated sequentially, the previous section's
-	 * page data can be reused.
-	 */
-	pte = pte_offset_kernel(pmd_off_k(addr), addr);
-	if (!pte)
-		return NULL;
-
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
 	const unsigned long flags = VMEMMAP_POPULATE_DAX;
+	const unsigned int order = pfn_to_section_compound_order(start_pfn);
 	unsigned long size, addr;
 	pte_t *pte;
+	struct page *page;
 	int rc;
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!page)
+		return -ENOMEM;
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)), flags);
-	}
+					      page_to_pfn(page), flags);
 
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
@@ -585,12 +571,12 @@ static int __meminit vmemmap_populate_co
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)), flags);
+					    page_to_pfn(page), flags);
 		if (rc)
 			return -ENOMEM;
 	}
@@ -922,13 +908,16 @@ int __meminit sparse_add_section(int nid
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
-	 * Poison uninitialized struct pages in order to catch invalid flags
-	 * combinations.
+	 * Poison uninitialized struct pages to catch invalid flag combinations.
+	 *
+	 * Tail struct pages in a vmemmap-optimized section are initialized and
+	 * shared during vmemmap population, so they must not be overwritten here.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

