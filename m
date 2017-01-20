From: akpm@linux-foundation.org
Subject: + mm-cleanup-sparse_init_one_section-return-value.patch added to
 -mm tree
Date: Thu, 19 Jan 2017 16:05:58 -0800
Message-ID: <58815466.yy9HPJUdudKfOHaB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753361AbdATAHY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup sparse_init_one_section() return value
has been added to the -mm tree.  Its filename is
     mm-cleanup-sparse_init_one_section-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-sparse_init_one_section-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-sparse_init_one_section-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: cleanup sparse_init_one_section() return value

We mark and check that the section is present under a spin_lock() in
sparse_add_one_section(), so the lock ensures it will not change between
those 2 events.  Also, we do not check the -EBUSY return value in
sparse_init().  Just make sparse_init_one_section() return void and clean
up the error handling.

Link: http://lkml.kernel.org/r/148486362851.19694.4580553117827074003.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN mm/sparse.c~mm-cleanup-sparse_init_one_section-return-value mm/sparse.c
--- a/mm/sparse.c~mm-cleanup-sparse_init_one_section-return-value
+++ a/mm/sparse.c
@@ -231,19 +231,14 @@ struct page *sparse_decode_mem_map(unsig
 	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
 }
 
-static int __meminit sparse_init_one_section(struct mem_section *ms,
+static void __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
 		struct mem_section_usage *usage)
 {
-	if (!present_section(ms))
-		return -EINVAL;
-
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum) |
 		SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
-
-	return 1;
 }
 
 unsigned long usemap_size(void)
@@ -690,11 +685,6 @@ static void free_map_bootmem(struct page
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-/*
- * returns the number of sections whose mem_maps were properly
- * set.  If this is <=0, then that means that the passed-in
- * map was not consumed and must be freed.
- */
 int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
@@ -725,7 +715,7 @@ int __meminit sparse_add_one_section(str
 
 	ms = __pfn_to_section(start_pfn);
 	if (ms->section_mem_map & SECTION_MARKED_PRESENT) {
-		ret = -EEXIST;
+		ret = -EBUSY;
 		goto out;
 	}
 
@@ -733,15 +723,16 @@ int __meminit sparse_add_one_section(str
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
-	ret = sparse_init_one_section(ms, section_nr, memmap, usage);
+	sparse_init_one_section(ms, section_nr, memmap, usage);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
-	if (ret <= 0) {
+	if (ret < 0 && ret != -EEXIST) {
 		kfree(usage);
 		__kfree_section_memmap(memmap);
+		return ret;
 	}
-	return ret;
+	return 0;
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch

