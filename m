From: akpm@linux-foundation.org
Subject: + mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch added to -mm tree
Date: Tue, 29 Apr 2008 14:26:10 -0700
Message-ID: <200804292126.m3TLQBb9010607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYD2V0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 17:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mingo@elte.hu


The patch titled
     mm: make defensive checks around PFN values registered for memory usage
has been added to the -mm tree.  Its filename is
     mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make defensive checks around PFN values registered for memory usage
From: Mel Gorman <mel@csn.ul.ie>

There are a number of different views to how much memory is currently active. 
There is the arch-independent zone-sizing view, the bootmem allocator and
memory models view.

Architectures register this information at different times and is not
necessarily in sync particularly with respect to some SPARSEMEM limitations. 

This patch introduces mminit_validate_memmodel_limits() which is able to
validate and correct PFN ranges with respect to the memory model.  It is only
SPARSEMEM that currently validates itself.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c    |    1 +
 mm/internal.h   |   12 ++++++++++++
 mm/page_alloc.c |    2 ++
 mm/sparse.c     |   37 +++++++++++++++++++++++++++++--------
 4 files changed, 44 insertions(+), 8 deletions(-)

diff -puN mm/bootmem.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage mm/bootmem.c
--- a/mm/bootmem.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage
+++ a/mm/bootmem.c
@@ -91,6 +91,7 @@ static unsigned long __init init_bootmem
 	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long mapsize;
 
+	mminit_validate_memmodel_limits(&start, &end);
 	bdata->node_bootmem_map = phys_to_virt(PFN_PHYS(mapstart));
 	bdata->node_boot_start = PFN_PHYS(start);
 	bdata->node_low_pfn = end;
diff -puN mm/internal.h~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage mm/internal.h
--- a/mm/internal.h~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage
+++ a/mm/internal.h
@@ -98,4 +98,16 @@ static inline void mminit_verify_page_li
 {
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
+
+/* mminit_validate_memmodel_limits is independent of CONFIG_DEBUG_MEMORY_INIT */
+#if defined(CONFIG_SPARSEMEM)
+extern void mminit_validate_memmodel_limits(unsigned long *start_pfn,
+				unsigned long *end_pfn);
+#else
+static inline void mminit_validate_memmodel_limits(unsigned long *start_pfn,
+				unsigned long *end_pfn)
+{
+}
+#endif /* CONFIG_SPARSEMEM */
+
 #endif
diff -puN mm/page_alloc.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage
+++ a/mm/page_alloc.c
@@ -3537,6 +3537,8 @@ void __init add_active_range(unsigned in
 			  nid, start_pfn, end_pfn,
 			  nr_nodemap_entries, MAX_ACTIVE_REGIONS);
 
+	mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
+
 	/* Merge with existing active regions if possible */
 	for (i = 0; i < nr_nodemap_entries; i++) {
 		if (early_node_map[i].nid != nid)
diff -puN mm/sparse.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage mm/sparse.c
--- a/mm/sparse.c~mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage
+++ a/mm/sparse.c
@@ -12,6 +12,7 @@
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include "internal.h"
 
 /*
  * Permanent SPARSEMEM data:
@@ -147,22 +148,41 @@ static inline int sparse_early_nid(struc
 	return (section->section_mem_map >> SECTION_NID_SHIFT);
 }
 
-/* Record a memory area against a node. */
-void __init memory_present(int nid, unsigned long start, unsigned long end)
+/* Validate the physical addressing limitations of the model */
+void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
+						unsigned long *end_pfn)
 {
-	unsigned long max_arch_pfn = 1UL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
-	unsigned long pfn;
+	unsigned long max_sparsemem_pfn = 1UL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
 
 	/*
 	 * Sanity checks - do not allow an architecture to pass
 	 * in larger pfns than the maximum scope of sparsemem:
 	 */
-	if (start >= max_arch_pfn)
-		return;
-	if (end >= max_arch_pfn)
-		end = max_arch_pfn;
+	if (*start_pfn > max_sparsemem_pfn) {
+		mminit_dprintk(MMINIT_WARNING, "pfnvalidation",
+			"Start of range %lu -> %lu exceeds SPARSEMEM max %lu\n",
+			*start_pfn, *end_pfn, max_sparsemem_pfn);
+		WARN_ON_ONCE(1);
+		*start_pfn = max_sparsemem_pfn;
+		*end_pfn = max_sparsemem_pfn;
+	}
+
+	if (*end_pfn > max_sparsemem_pfn) {
+		mminit_dprintk(MMINIT_WARNING, "pfnvalidation",
+			"End of range %lu -> %lu exceeds SPARSEMEM max %lu\n",
+			*start_pfn, *end_pfn, max_sparsemem_pfn);
+		WARN_ON_ONCE(1);
+		*end_pfn = max_sparsemem_pfn;
+	}
+}
+
+/* Record a memory area against a node. */
+void __init memory_present(int nid, unsigned long start, unsigned long end)
+{
+	unsigned long pfn;
 
 	start &= PAGE_SECTION_MASK;
+	mminit_validate_memmodel_limits(&start, &end);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
 		unsigned long section = pfn_to_section_nr(pfn);
 		struct mem_section *ms;
@@ -187,6 +207,7 @@ unsigned long __init node_memmap_size_by
 	unsigned long pfn;
 	unsigned long nr_pages = 0;
 
+	mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		if (nid != early_pfn_to_nid(pfn))
 			continue;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-fix-usemap-initialization.patch
mm-fix-misleading-__gfp_repeat-related-comments.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

