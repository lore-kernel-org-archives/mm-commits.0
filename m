Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6212D390613
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081633; cv=none; b=IJ+f7JBozUOmQQMOPhF1/dTXGWnQHi7Y3b+qkHNo7hOTxh70siwkYyJI9ta8EV7KM1Qlbxdu7bKx51Df6/9tkpY4eF9UmTQ0SQO8PHQBKN9trUlRbXCYhoC6YRjPYl8buJajplfaCNh5Y1euzXarzRHVJOpoJM8ii8tIYVXde0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081633; c=relaxed/simple;
	bh=P9gxtJqed1NQDKk+FHeADd210xEOLR3QRhFzcwLBi+8=;
	h=Date:To:From:Subject:Message-Id; b=ltVIhjZZeUSzkXiHbHJmiT08I5n1KvhY5ONLNuk+xB5BPm+60C2areYXdz+umFotNufJjZ+MZITWZ2X4Wp92jgpxZyMT4CqrT0MpegKbtE+j6iCbNf1Wc4V3nigFQUjv4rlC1FPKeKzdg+JZ4t5bkGZbNKF9eKau5mhCEdhBsfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJYUvz3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJYUvz3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F321F00893;
	Thu, 10 Sep 2026 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081631;
	bh=Vq1Uc+txmKajKqMpQuERC6sXBO4NjZlFTTWoaOPZcws=;
	h=Date:To:From:Subject;
	b=WJYUvz3SpKVz00hDWAknx4f4Lz1TVOI9G3ik1LBzdcyht7EQSSSetsEK4o+DHDCOK
	 F5YEc67Lhu2TJwi9I5qsuIFXpuZVkR5CeGiHwLpeGIXzbb67f+nIKRsfTXjEHK4bA+
	 cXQB34njPPkj0q4sHAF7NWvRcN8vCcN+dtGLHsxY=
Date: Thu, 10 Sep 2026 16:07:10 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch removed from -mm tree
Message-Id: <20260910230711.36F321F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
Date: Tue, 8 Sep 2026 11:03:28 +0800

Device DAX still uses vmemmap_populate_compound_pages() to populate its
compound-page vmemmap mappings.  That helper allocates the head and first
tail vmemmap pages explicitly, then reuses the first tail page for the
remaining tail page mappings.

Device DAX is being moved to the section-based vmemmap optimization
infrastructure, but it cannot switch to the generic section-based
population path yet.  Once a later patch records the DAX compound-page
geometry in the section order, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Add a DAX-specific population flag for this transition.  It keeps DAX
head/first-tail allocations on the normal vmemmap allocation path, while
preserving the existing page reference for reused DAX tail mappings.

Link:
https://lore.kernel.org/20260908030335.96549-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders
+++ a/mm/sparse-vmemmap.c
@@ -35,8 +35,8 @@
 /*
  * Flags for vmemmap_populate_range and friends.
  */
-/* Get a ref on the head page struct page, for ZONE_DEVICE compound pages */
-#define VMEMMAP_POPULATE_PAGEREF	0x0001
+/* Vmemmap population for ZONE_DEVICE compound pages */
+#define VMEMMAP_POPULATE_DAX		0x0001
 
 #include "internal.h"
 #include "mm_init.h"
@@ -208,13 +208,17 @@ struct page __ref *vmemmap_shared_tail_p
 }
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-					 struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, unsigned long flags)
 {
 	struct zone *zone;
 	struct page *page;
 	const unsigned int order = pfn_to_section_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	/*
+	 * Device DAX still relies on vmemmap_populate_compound_pages() for
+	 * head/first-tail allocation and tail-page reuse.
+	 */
+	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -236,7 +240,7 @@ static pte_t * __meminit vmemmap_pte_pop
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -251,7 +255,7 @@ static pte_t * __meminit vmemmap_pte_pop
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -511,6 +515,7 @@ static int __meminit vmemmap_populate_co
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	unsigned long flags = VMEMMAP_POPULATE_DAX;
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
 		pte = compound_section_tail_page(start);
@@ -522,8 +527,7 @@ static int __meminit vmemmap_populate_co
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -531,13 +535,13 @@ static int __meminit vmemmap_populate_co
 		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
-		pte = vmemmap_populate_address(addr, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(addr, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
 		/* Populate the tail pages vmemmap page */
 		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, 0);
+		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
 		if (!pte)
 			return -ENOMEM;
 
@@ -547,8 +551,7 @@ static int __meminit vmemmap_populate_co
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)),
-					    VMEMMAP_POPULATE_PAGEREF);
+					    pte_pfn(ptep_get(pte)), flags);
 		if (rc)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
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
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

