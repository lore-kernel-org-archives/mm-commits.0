Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A6CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382651AbiDTVof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382645AbiDTVo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A2C4888C
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55D7CB82194
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0924BC385A1;
        Wed, 20 Apr 2022 21:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490883;
        bh=l9+PJUa9cvhMMdhxK0YYDwkgj8idlbovRHgkdAHB5dE=;
        h=Date:To:From:Subject:From;
        b=imm6J7nQO2oJ3r7gqHPF+zKRUXYgs5G2Xitt5jZZdlVhqflJGDuL8CgOKQdgUH5ag
         7bVCA9VNJwm6BWg1/qH9apYyaySBMqCMHmWQEPR7va7eqQu253muqnB8E+Tgr3xmb5
         zsZf9TYq9xJTRUToqPm3ZLb7UneO15SFnjp23HwQ=
Date:   Wed, 20 Apr 2022 14:41:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.l.verma@intel.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jgg@ziepe.ca, jane.chu@oracle.com,
        hch@lst.de, dan.j.williams@intel.com, corbet@lwn.net,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch added to -mm tree
Message-Id: <20220420214123.0924BC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap: improve memory savings for compound devmaps
has been added to the -mm tree.  Its filename is
     mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/sparse-vmemmap: improve memory savings for compound devmaps

A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it means
that pages are mapped at a given huge page alignment and utilize uses
compound pages as opposed to order-0 pages.

Take advantage of the fact that most tail pages look the same (except the
first two) to minimize struct page overhead.  Allocate a separate page for
the vmemmap area which contains the head page and separate for the next 64
pages.  The rest of the subsections then reuse this tail vmemmap page to
initialize the rest of the tail pages.

Sections are arch-dependent (e.g.  on x86 it's 64M, 128M or 512M) and when
initializing compound devmap with big enough @vmemmap_shift (e.g.  1G PUD)
it may cross multiple sections.  The vmemmap code needs to consult @pgmap
so that multiple sections that all map the same tail data can refer back
to the first copy of that data for a given gigantic page.

On compound devmaps with 2M align, this mechanism lets 6 pages be saved
out of the 8 necessary PFNs necessary to set the subsection's 512 struct
pages being mapped.  On a 1G compound devmap it saves 4094 pages.

Altmap isn't supported yet, given various restrictions in altmap pfn
allocator, thus fallback to the already in use vmemmap_populate().  It is
worth noting that altmap for devmap mappings was there to relieve the
pressure of inordinate amounts of memmap space to map terabytes of pmem. 
With compound pages the motivation for altmaps for pmem gets reduced.

Link: https://lkml.kernel.org/r/20220420155310.9712-5-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/vmemmap_dedup.rst |   56 ++++++++++-
 include/linux/mm.h                 |    2 
 mm/memremap.c                      |    1 
 mm/sparse-vmemmap.c                |  132 ++++++++++++++++++++++++---
 4 files changed, 177 insertions(+), 14 deletions(-)

--- a/Documentation/vm/vmemmap_dedup.rst~mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps
+++ a/Documentation/vm/vmemmap_dedup.rst
@@ -1,8 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-==================================
-Free some vmemmap pages of HugeTLB
-==================================
+=========================================
+A vmemmap diet for HugeTLB and Device DAX
+=========================================
+
+HugeTLB
+=======
 
 The struct page structures (page structs) are used to describe a physical
 page frame. By default, there is a one-to-one mapping from a page frame to
@@ -171,3 +174,50 @@ tail vmemmap pages are mapped to the hea
 more than one struct page struct with PG_head (e.g. 8 per 2 MB HugeTLB page)
 associated with each HugeTLB page. The compound_head() can handle this
 correctly (more details refer to the comment above compound_head()).
+
+Device DAX
+==========
+
+The device-dax interface uses the same tail deduplication technique explained
+in the previous chapter, except when used with the vmemmap in
+the device (altmap).
+
+The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
+PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
+
+The differences with HugeTLB are relatively minor.
+
+It only use 3 page structs for storing all information as opposed
+to 4 on HugeTLB pages.
+
+There's no remapping of vmemmap given that device-dax memory is not part of
+System RAM ranges initialized at boot. Thus the tail page deduplication
+happens at a later stage when we populate the sections. HugeTLB reuses the
+the head vmemmap page representing, whereas device-dax reuses the tail
+vmemmap page. This results in only half of the savings compared to HugeTLB.
+
+Deduplicated tail pages are not mapped read-only.
+
+Here's how things look like on device-dax after the sections are populated::
+
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
+ |           |                     |     0     | -------------> |     0     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     1     | -------------> |     1     |
+ |           |                     +-----------+                +-----------+
+ |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
+ |           |                     +-----------+                   | | | | |
+ |           |                     |     3     | ------------------+ | | | |
+ |           |                     +-----------+                     | | | |
+ |           |                     |     4     | --------------------+ | | |
+ |    PMD    |                     +-----------+                       | | |
+ |   level   |                     |     5     | ----------------------+ | |
+ |  mapping  |                     +-----------+                         | |
+ |           |                     |     6     | ------------------------+ |
+ |           |                     +-----------+                           |
+ |           |                     |     7     | --------------------------+
+ |           |                     +-----------+
+ |           |
+ |           |
+ |           |
+ +-----------+
--- a/include/linux/mm.h~mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps
+++ a/include/linux/mm.h
@@ -3217,7 +3217,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd,
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
 pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap);
+			    struct vmem_altmap *altmap, struct page *reuse);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
--- a/mm/memremap.c~mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps
+++ a/mm/memremap.c
@@ -307,6 +307,7 @@ void *memremap_pages(struct dev_pagemap
 {
 	struct mhp_params params = {
 		.altmap = pgmap_altmap(pgmap),
+		.pgmap = pgmap,
 		.pgprot = PAGE_KERNEL,
 	};
 	const int nr_range = pgmap->nr_range;
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps
+++ a/mm/sparse-vmemmap.c
@@ -533,16 +533,31 @@ void __meminit vmemmap_verify(pte_t *pte
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-				       struct vmem_altmap *altmap)
+				       struct vmem_altmap *altmap,
+				       struct page *reuse)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte)) {
 		pte_t entry;
 		void *p;
 
-		p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
-		if (!p)
-			return NULL;
+		if (!reuse) {
+			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			if (!p)
+				return NULL;
+		} else {
+			/*
+			 * When a PTE/PMD entry is freed from the init_mm
+			 * there's a a free_pages() call to this page allocated
+			 * above. Thus this get_page() is paired with the
+			 * put_page_testzero() on the freeing path.
+			 * This can only called by certain ZONE_DEVICE path,
+			 * and through vmemmap_populate_compound_pages() when
+			 * slab is available.
+			 */
+			get_page(reuse);
+			p = page_to_virt(reuse);
+		}
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(u
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap)
+					      struct vmem_altmap *altmap,
+					      struct page *reuse)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -629,7 +645,7 @@ static pte_t * __meminit vmemmap_populat
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -639,13 +655,14 @@ static pte_t * __meminit vmemmap_populat
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
+					    struct vmem_altmap *altmap,
+					    struct page *reuse)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+		pte = vmemmap_populate_address(addr, node, altmap, reuse);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -656,7 +673,95 @@ static int __meminit vmemmap_populate_ra
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap);
+	return vmemmap_populate_range(start, end, node, altmap, NULL);
+}
+
+/*
+ * For compound pages bigger than section size (e.g. x86 1G compound
+ * pages with 2M subsection size) fill the rest of sections as tail
+ * pages.
+ *
+ * Note that memremap_pages() resets @nr_range value and will increment
+ * it after each range successful onlining. Thus the value or @nr_range
+ * at section memmap populate corresponds to the in-progress range
+ * being onlined here.
+ */
+static bool __meminit reuse_compound_section(unsigned long start_pfn,
+					     struct dev_pagemap *pgmap)
+{
+	unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+	unsigned long offset = start_pfn -
+		PHYS_PFN(pgmap->ranges[pgmap->nr_range].start);
+
+	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
+}
+
+static pte_t * __meminit compound_section_tail_page(unsigned long addr)
+{
+	pte_t *pte;
+
+	addr -= PAGE_SIZE;
+
+	/*
+	 * Assuming sections are populated sequentially, the previous section's
+	 * page data can be reused.
+	 */
+	pte = pte_offset_kernel(pmd_off_k(addr), addr);
+	if (!pte)
+		return NULL;
+
+	return pte;
+}
+
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node,
+						     struct dev_pagemap *pgmap)
+{
+	unsigned long size, addr;
+	pte_t *pte;
+	int rc;
+
+	if (reuse_compound_section(start_pfn, pgmap)) {
+		pte = compound_section_tail_page(start);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the page that was populated in the prior iteration
+		 * with just tail struct pages.
+		 */
+		return vmemmap_populate_range(start, end, node, NULL,
+					      pte_page(*pte));
+	}
+
+	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	for (addr = start; addr < end; addr += size) {
+		unsigned long next = addr, last = addr + size;
+
+		/* Populate the head page vmemmap page */
+		pte = vmemmap_populate_address(addr, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/* Populate the tail pages vmemmap page */
+		next = addr + PAGE_SIZE;
+		pte = vmemmap_populate_address(next, node, NULL, NULL);
+		if (!pte)
+			return -ENOMEM;
+
+		/*
+		 * Reuse the previous page for the rest of tail pages
+		 * See layout diagram in Documentation/vm/vmemmap_dedup.rst
+		 */
+		next += PAGE_SIZE;
+		rc = vmemmap_populate_range(next, last, node, NULL,
+					    pte_page(*pte));
+		if (rc)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
@@ -665,12 +770,19 @@ struct page * __meminit __populate_secti
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
+	int r;
 
 	if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_populate(start, end, nid, altmap))
+	if (is_power_of_2(sizeof(struct page)) &&
+	    pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
+		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
+	else
+		r = vmemmap_populate(start, end, nid, altmap);
+
+	if (r < 0)
 		return NULL;
 
 	return pfn_to_page(pfn);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch
mm-sparse-vmemmap-refactor-core-of-vmemmap_populate_basepages-to-helper.patch
mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch
mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch
mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

