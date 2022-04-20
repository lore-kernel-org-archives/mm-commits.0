Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43380C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382637AbiDTVoH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382619AbiDTVoE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D2238D9A
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D92A861856
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD49C385A0;
        Wed, 20 Apr 2022 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490875;
        bh=sbwiyzCkZB7JNhf75IX8KzKuPf9oE8aA3PvgbPkdqc8=;
        h=Date:To:From:Subject:From;
        b=VsInyO4Q+sJIsiYDzOitbbbMUQshrReR1nq7iDj/+iLSjyyceZkCmGKdsI0y2BE/Z
         GM1Ig9uMjm6JTjRcSmt8clMpD+KzuQLImP0Y2UecuvB/BucNtC3AWeIB4uxZcmazR7
         wCy17UhphtFjKo1wkvdh+1iPpFMxQAenMY2+CbO4=
Date:   Wed, 20 Apr 2022 14:41:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.l.verma@intel.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, jgg@ziepe.ca, jane.chu@oracle.com,
        hch@lst.de, dan.j.williams@intel.com, corbet@lwn.net,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch added to -mm tree
Message-Id: <20220420214115.3DD49C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap: add a pgmap argument to section activation
has been added to the -mm tree.  Its filename is
     mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch

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
Subject: mm/sparse-vmemmap: add a pgmap argument to section activation

Patch series "sparse-vmemmap: memory savings for compound devmaps (device-dax)", v9.

This series minimizes 'struct page' overhead by pursuing a similar
approach as Muchun Song series "Free some vmemmap pages of hugetlb page"
(now merged since v5.14), but applied to devmap with @vmemmap_shift
(device-dax).  

The vmemmap dedpulication original idea (already used in HugeTLB) is to
reuse/deduplicate tail page vmemmap areas, particular the area which only
describes tail pages.  So a vmemmap page describes 64 struct pages, and
the first page for a given ZONE_DEVICE vmemmap would contain the head page
and 63 tail pages.  The second vmemmap page would contain only tail pages,
and that's what gets reused across the rest of the subsection/section. 
The bigger the page size, the bigger the savings (2M hpage -> save 6
vmemmap pages; 1G hpage -> save 4094 vmemmap pages).  

This is done for PMEM /specifically only/ on device-dax configured
namespaces, not fsdax.  In other words, a devmap with a @vmemmap_shift.

In terms of savings, per 1Tb of memory, the struct page cost would go down
with compound devmap:

* with 2M pages we lose 4G instead of 16G (0.39% instead of 1.5% of
  total memory)

* with 1G pages we lose 40MB instead of 16G (0.0014% instead of 1.5% of
  total memory)

The series is mostly summed up by patch 4, and to summarize what the
series does:

Patches 1 - 3: Minor cleanups in preparation for patch 4.  Move the very
nice docs of hugetlb_vmemmap.c into a Documentation/vm/ entry.

Patch 4: Patch 4 is the one that takes care of the struct page savings
(also referred to here as tail-page/vmemmap deduplication).  Much like
Muchun series, we reuse the second PTE tail page vmemmap areas across a
given @vmemmap_shift On important difference though, is that contrary to
the hugetlbfs series, there's no vmemmap for the area because we are
late-populating it as opposed to remapping a system-ram range.  IOW no
freeing of pages of already initialized vmemmap like the case for
hugetlbfs, which greatly simplifies the logic (besides not being
arch-specific).  altmap case unchanged and still goes via the
vmemmap_populate().  Also adjust the newly added docs to the device-dax
case.

[Note that device-dax is still a little behind HugeTLB in terms of
savings.  I have an additional simple patch that reuses the head vmemmap
page too, as a follow-up.  That will double the savings and namespaces
initialization.]

Patch 5: Initialize fewer struct pages depending on the page size with
DRAM backed struct pages -- because fewer pages are unique and most tail
pages (with bigger vmemmap_shift).

    NVDIMM namespace bootstrap improves from ~268-358 ms to
    ~80-110/<1ms on 128G NVDIMMs with 2M and 1G respectivally.  And struct
    page needed capacity will be 3.8x / 1071x smaller for 2M and 1G
    respectivelly.  Tested on x86 with 1.5Tb of pmem (including pinning,
    and RDMA registration/deregistration scalability with 2M MRs)


This patch (of 5):

In support of using compound pages for devmap mappings, plumb the pgmap
down to the vmemmap_populate implementation.  Note that while altmap is
retrievable from pgmap the memory hotplug code passes altmap without
pgmap[*], so both need to be independently plumbed.

So in addition to @altmap, pass @pgmap to sparse section populate
functions namely:

	sparse_add_section
	  section_activate
	    populate_section_memmap
   	      __populate_section_memmap

Passing @pgmap allows __populate_section_memmap() to both fetch the
vmemmap_shift in which memmap metadata is created for and also to let
sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
whether to just reuse tail pages from past onlined sections.

While at it, fix the kdoc for @altmap for sparse_add_section().

[*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/

Link: https://lkml.kernel.org/r/20220420155310.9712-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20220420155310.9712-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    5 ++++-
 include/linux/mm.h             |    3 ++-
 mm/memory_hotplug.c            |    3 ++-
 mm/sparse-vmemmap.c            |    3 ++-
 mm/sparse.c                    |   26 ++++++++++++++++----------
 5 files changed, 26 insertions(+), 14 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation
+++ a/include/linux/memory_hotplug.h
@@ -15,6 +15,7 @@ struct memory_block;
 struct memory_group;
 struct resource;
 struct vmem_altmap;
+struct dev_pagemap;
 
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
 /*
@@ -122,6 +123,7 @@ typedef int __bitwise mhp_t;
 struct mhp_params {
 	struct vmem_altmap *altmap;
 	pgprot_t pgprot;
+	struct dev_pagemap *pgmap;
 };
 
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
@@ -333,7 +335,8 @@ extern void remove_pfn_range_from_zone(s
 				       unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap);
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(struct mem_section *ms,
 		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset, struct vmem_altmap *altmap);
--- a/include/linux/mm.h~mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation
+++ a/include/linux/mm.h
@@ -3210,7 +3210,8 @@ int vmemmap_remap_alloc(unsigned long st
 
 void *sparse_buffer_alloc(unsigned long size);
 struct page * __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
--- a/mm/memory_hotplug.c~mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation
+++ a/mm/memory_hotplug.c
@@ -328,7 +328,8 @@ int __ref __add_pages(int nid, unsigned
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap);
+		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
+					 params->pgmap);
 		if (err)
 			break;
 		cond_resched();
--- a/mm/sparse.c~mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation
+++ a/mm/sparse.c
@@ -427,7 +427,8 @@ static unsigned long __init section_map_
 }
 
 struct page __init *__populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
 	struct page *map = sparse_buffer_alloc(size);
@@ -524,7 +525,7 @@ static void __init sparse_init_nid(int n
 			break;
 
 		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-				nid, NULL);
+				nid, NULL, NULL);
 		if (!map) {
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
@@ -629,9 +630,10 @@ void offline_mem_sections(unsigned long
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap);
+	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -700,7 +702,8 @@ static int fill_subsection_map(unsigned
 }
 #else
 struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	return kvmalloc_node(array_size(sizeof(struct page),
 					PAGES_PER_SECTION), GFP_KERNEL, nid);
@@ -823,7 +826,8 @@ static void section_deactivate(unsigned
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
@@ -855,7 +859,7 @@ static struct page * __meminit section_a
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
@@ -869,7 +873,8 @@ static struct page * __meminit section_a
  * @nid: The node to add section on
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
- * @altmap: device page map
+ * @altmap: alternate pfns to allocate the memmap backing store
+ * @pgmap: alternate compound page geometry for devmap mappings
  *
  * This is only intended for hotplug.
  *
@@ -883,7 +888,8 @@ static struct page * __meminit section_a
  * * -ENOMEM	- Out of memory.
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -894,7 +900,7 @@ int __meminit sparse_add_section(int nid
 	if (ret < 0)
 		return ret;
 
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation
+++ a/mm/sparse-vmemmap.c
@@ -641,7 +641,8 @@ int __meminit vmemmap_populate_basepages
 }
 
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-sparse-vmemmap-add-a-pgmap-argument-to-section-activation.patch
mm-sparse-vmemmap-refactor-core-of-vmemmap_populate_basepages-to-helper.patch
mm-hugetlb_vmemmap-move-comment-block-to-documentation-vm.patch
mm-sparse-vmemmap-improve-memory-savings-for-compound-devmaps.patch
mm-page_alloc-reuse-tail-struct-pages-for-compound-devmaps.patch

