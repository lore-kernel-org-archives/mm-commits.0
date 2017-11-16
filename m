From: akpm@linux-foundation.org
Subject: [patch 089/131] mm: stop zeroing memory during allocation
 in vmemmap
Date: Wed, 15 Nov 2017 17:36:44 -0800
Message-ID: <20171116013644.GQuGNfq53%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933058AbdKPBgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, willy@infradead.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: stop zeroing memory during allocation in vmemmap

vmemmap_alloc_block() will no longer zero the block, so zero memory at its
call sites for everything except struct pages.  Struct page memory is
zero'd by struct page initialization.

Replace allocators in sparse-vmemmap to use the non-zeroing version.  So,
we will get the performance improvement by zeroing the memory in parallel
when struct pages are zeroed.

Add struct page zeroing as a part of initialization of other fields in
__init_single_page().

This single thread performance collected on: Intel(R) Xeon(R) CPU E7-8895
v3 @ 2.60GHz with 1T of memory (268400646 pages in 8 nodes):

                         BASE            FIX
sparse_init     11.244671836s   0.007199623s
zone_sizes_init  4.879775891s   8.355182299s
                  --------------------------
Total           16.124447727s   8.362381922s

sparse_init is where memory for struct pages is zeroed, and the zeroing
part is moved later in this patch into __init_single_page(), which is
called from zone_sizes_init().

[akpm@linux-foundation.org: make vmemmap_alloc_block_zero() private to sparse-vmemmap.c]
Link: http://lkml.kernel.org/r/20171013173214.27300-10-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Tested-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    1 +
 mm/sparse-vmemmap.c |   26 ++++++++++++++++++--------
 mm/sparse.c         |    6 +++---
 3 files changed, 22 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap mm/page_alloc.c
--- a/mm/page_alloc.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap
+++ a/mm/page_alloc.c
@@ -1168,6 +1168,7 @@ static void free_one_page(struct zone *z
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid)
 {
+	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
diff -puN mm/sparse.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap mm/sparse.c
--- a/mm/sparse.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap
+++ a/mm/sparse.c
@@ -453,9 +453,9 @@ void __init sparse_mem_maps_populate_nod
 	}
 
 	size = PAGE_ALIGN(size);
-	map = memblock_virt_alloc_try_nid(size * map_count,
-					  PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
-					  BOOTMEM_ALLOC_ACCESSIBLE, nodeid);
+	map = memblock_virt_alloc_try_nid_raw(size * map_count,
+					      PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					      BOOTMEM_ALLOC_ACCESSIBLE, nodeid);
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))
diff -puN mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-stop-zeroing-memory-during-allocation-in-vmemmap
+++ a/mm/sparse-vmemmap.c
@@ -42,7 +42,7 @@ static void * __ref __earlyonly_bootmem_
 				unsigned long align,
 				unsigned long goal)
 {
-	return memblock_virt_alloc_try_nid(size, align, goal,
+	return memblock_virt_alloc_try_nid_raw(size, align, goal,
 					    BOOTMEM_ALLOC_ACCESSIBLE, node);
 }
 
@@ -55,9 +55,8 @@ void * __meminit vmemmap_alloc_block(uns
 	if (slab_is_available()) {
 		struct page *page;
 
-		page = alloc_pages_node(node,
-			GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
-			get_order(size));
+		page = alloc_pages_node(node, GFP_KERNEL | __GFP_RETRY_MAYFAIL,
+					get_order(size));
 		if (page)
 			return page_address(page);
 		return NULL;
@@ -180,11 +179,22 @@ pte_t * __meminit vmemmap_pte_populate(p
 	return pte;
 }
 
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
 pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		pmd_populate_kernel(&init_mm, pmd, p);
@@ -196,7 +206,7 @@ pud_t * __meminit vmemmap_pud_populate(p
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		pud_populate(&init_mm, pud, p);
@@ -208,7 +218,7 @@ p4d_t * __meminit vmemmap_p4d_populate(p
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		p4d_populate(&init_mm, p4d, p);
@@ -220,7 +230,7 @@ pgd_t * __meminit vmemmap_pgd_populate(u
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
-		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 		if (!p)
 			return NULL;
 		pgd_populate(&init_mm, pgd, p);
_
