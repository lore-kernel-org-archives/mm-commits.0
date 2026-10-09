Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9569B40803D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525542; cv=none; b=JXRr3UVZ9UMrppEe2I1XiQ8k0qxK5l7C5DIj9Iwm5t8YORvQ4I1cjq47bODlykm7jlWHCkyf0uJIPd3LLlZ48HXea1CE5g6fxGM3DpYu7M4b2kNOWvVznaEuNYJuzpGTNTtimLNocsl0IePpgxW147YaZm1+AwWJdQZRruPGd6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525542; c=relaxed/simple;
	bh=4HHruWwIbDgjzglyd2yIjZI1fDsc3L4HCfT8HPLDVjA=;
	h=Date:To:From:Subject:Message-Id; b=VMKXU6RYMCE3OvHtcMFxFxpBKB3ZyvSrNNHQqSP5UtBNj1G6rD/fTX51WbrseHAfQcL2qxmNTCTD0d+bLr9yNomIsHdpRfH7TU1STjeOlB0+0JpCyOdHgjj65Ps5vsEHBsKqu4uJEQynUtFUaFL6tnWeMqCRHUmeLIx3cMGkVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oll0xhqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oll0xhqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B911F000FF;
	Fri,  9 Oct 2026 05:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525541;
	bh=/pxqbAHiF3LGwbE5c/bNbzJBX66LBx10OjoFVh8zWp8=;
	h=Date:To:From:Subject;
	b=oll0xhqizl6G2nkF9x0qnTvlrXZpIxsDQeCk3ngJHKvIYi++MQJCsX+Ux+6xVCNHt
	 DW77osFv7u8C3s6UrG6yaihdLIYQrudKfFURZFNyxTdND0Ltm9srzfWhiEfrHVrLgT
	 tb1mGGTDFJzvZUDbp/oUOvUQtZrGRDihr9Tl+RaM=
Date: Thu, 08 Oct 2026 22:59:00 -0700
To: mm-commits@vger.kernel.org,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,rdunlap@infradead.org,qi.zheng@linux.dev,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,lance.yang@linux.dev,david@kernel.org,corbet@lwn.net,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch removed from -mm tree
Message-Id: <20261009055901.68B911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: switch device DAX to shared tail vmemmap pages
has been removed from the -mm tree.  Its filename was
     powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 22:06:24 +0800

The powerpc radix compound vmemmap population path still finds a reusable
tail page by walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared vmemmap page directly to simplify the code.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the device DAX vmemmap optimization path with HugeTLB.

[muchun.song@linux.dev: use try_get_page()]
  Link: https://lore.kernel.org/20260930152826.76084-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260930140627.57431-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 arch/powerpc/mm/book3s64/radix_pgtable.c |   88 +++------------------
 include/linux/vmemmap-optimization.h     |    6 +
 mm/sparse-vmemmap.c                      |    6 -
 3 files changed, 21 insertions(+), 79 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -19,6 +19,7 @@
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
 #include <linux/kfence.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -1041,13 +1042,17 @@ static pte_t * __meminit radix__vmemmap_
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
-			get_page(reuse);
+			if (!try_get_page(reuse))
+				return NULL;
 			p = page_to_virt(reuse);
 			pr_debug("Tail page reuse vmemmap mapping\n");
 		}
@@ -1250,59 +1255,6 @@ static pte_t * __meminit radix__vmemmap_
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1272,12 @@ int __meminit vmemmap_populate_compound_
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
+
+	tail_page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1349,10 +1307,9 @@ int __meminit vmemmap_populate_compound_
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << order;
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1334,8 @@ int __meminit vmemmap_populate_compound_
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
--- a/include/linux/vmemmap-optimization.h~powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/include/linux/vmemmap-optimization.h
@@ -83,6 +83,12 @@ static inline unsigned int pfn_to_sectio
 {
 	return 0;
 }
+
+static inline struct page *vmemmap_shared_tail_page(unsigned int order,
+						    struct zone *zone)
+{
+	return NULL;
+}
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
 static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
--- a/mm/sparse-vmemmap.c~powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages
+++ a/mm/sparse-vmemmap.c
@@ -240,12 +240,6 @@ struct page __ref *vmemmap_shared_tail_p
 
 	return page;
 }
-#else
-static inline struct page *vmemmap_shared_tail_page(unsigned int order,
-						    struct zone *zone)
-{
-	return NULL;
-}
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

