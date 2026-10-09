Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806D41DE01
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525537; cv=none; b=TGrqwjKdQJx7yDAT2F/gCISKfXlxueO8CocuFkKrToFytK8SBlWzF+l4dLtNmnXXxNA3vxeiAb9XSJQrrkZTgh9EdSN2aGZ68QOku+7o30rQhN7WGhvPzoD/VQp1VNiInS75kdw9w7sdJ79o2gsd6MybCkXRGPgsHmPZH3l7hYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525537; c=relaxed/simple;
	bh=bBHkCQHZFWSn44qpQdJgySK3qb8lnEv2OTvmRezAGiA=;
	h=Date:To:From:Subject:Message-Id; b=Wc0itDc+skQ+ZGEJR6/c72k1DoKHK9dgxpCHhVkXmRmw48Xeykt5E/CDwKgxSVAEtkUszMyS6gqTmxp/0CKAVL4QyhPw52r9nL8NnhVMw2BhvCM33CIt4LVMBL1yRdWsBpStxkFPrQQOnlJ3BFR18rgvEU8dF3RdGPt1VS43xXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axxZCcGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axxZCcGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAD81F000FF;
	Fri,  9 Oct 2026 05:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525535;
	bh=ijAOUTfk/vm5++b8bdfKkc4cEs9aY2J8Vo6cfoDWOZQ=;
	h=Date:To:From:Subject;
	b=axxZCcGfo/eL6qZgNM5WVQohaRBdkgoESocDIKxgR6ULk/0vmEnTBzuAQq5MPtQD+
	 TzG8urrIB0aJCj6tgRXPdZLPeUTbdA82kV4PzkO9fcfFyvFuh3cBxeD7iaeyEUweZR
	 ccASHfmhAZS3iZ1qKPyPL3Kt1OgN1A9+GccTYgIk=
Date: Thu, 08 Oct 2026 22:58:54 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch removed from -mm tree
Message-Id: <20261009055855.3CAD81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
Date: Wed, 30 Sep 2026 22:06:20 +0800

Device DAX still uses vmemmap_populate_compound_pages() to populate its
compound-page vmemmap mappings.  That helper allocates the head and first
tail vmemmap pages explicitly, then reuses the first tail page for the
remaining tail page mappings.

Device DAX is being moved to the section-based vmemmap optimization
infrastructure, but it cannot switch to the generic section-based
population path yet.  Once a later patch records the DAX compound page
order in section metadata, DAX head and first-tail PFNs can look
optimizable to the generic helpers as well.

Rename the existing VMEMMAP_POPULATE_PAGEREF flag to VMEMMAP_POPULATE_DAX
and pass it through all paths in vmemmap_populate_compound_pages() during
this transition.  This keeps DAX head/first-tail allocations on the normal
vmemmap allocation path, while preserving the existing page reference for
reused DAX tail mappings.

Link: https://lore.kernel.org/20260930140627.57431-6-songmuchun@bytedance.com
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

 mm/sparse-vmemmap.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders
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
@@ -247,13 +247,17 @@ static inline struct page *vmemmap_share
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-					 struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, unsigned long flags)
 {
 	struct zone *zone;
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	if (!vmemmap_optimizable_pfn(pfn))
+	/*
+	 * Device DAX still relies on vmemmap_populate_compound_pages() for
+	 * head/first-tail allocation and tail-page reuse.
+	 */
+	if (!vmemmap_optimizable_pfn(pfn) || flags & VMEMMAP_POPULATE_DAX)
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
 	zone = pfn_to_zone(pfn, node);
@@ -275,7 +279,7 @@ static pte_t * __meminit vmemmap_pte_pop
 		pte_t entry;
 
 		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+			void *p = vmemmap_alloc_pte(pfn, node, altmap, flags);
 
 			if (!p)
 				return NULL;
@@ -290,7 +294,7 @@ static pte_t * __meminit vmemmap_pte_pop
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
 			 */
-			if (flags & VMEMMAP_POPULATE_PAGEREF)
+			if (flags & VMEMMAP_POPULATE_DAX)
 				get_page(pfn_to_page(ptpfn));
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
@@ -547,6 +551,7 @@ static int __meminit vmemmap_populate_co
 						     unsigned long end, int node,
 						     struct dev_pagemap *pgmap)
 {
+	const unsigned long flags = VMEMMAP_POPULATE_DAX;
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
@@ -561,8 +566,7 @@ static int __meminit vmemmap_populate_co
 		 * with just tail struct pages.
 		 */
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)),
-					      VMEMMAP_POPULATE_PAGEREF);
+					      pte_pfn(ptep_get(pte)), flags);
 	}
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
@@ -570,13 +574,13 @@ static int __meminit vmemmap_populate_co
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
 
@@ -586,8 +590,7 @@ static int __meminit vmemmap_populate_co
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

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

