From: akpm@linux-foundation.org
Subject: + sparsemem-record-when-a-section-has-a-valid-mem_map.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:37:18 -0700
Message-ID: <200707192337.l6JNbIUh028686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102AbXGSXiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, benh@kernel.crashing.org, clameter@sgi.com, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org, tony.luck@intel.com


The patch titled
     sparsemem: record when a section has a valid mem_map
has been added to the -mm tree.  Its filename is
     sparsemem-record-when-a-section-has-a-valid-mem_map.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparsemem: record when a section has a valid mem_map
From: Andy Whitcroft <apw@shadowen.org>

We have flags to indicate whether a section actually has a valid mem_map
associated with it.  This is never set and we rely solely on the present bit
to indicate a section is valid.  By definition a section is not valid if it
has no mem_map and there is a window during init where the present bit is set
but there is no mem_map, during which pfn_valid() will return true
incorrectly.

Use the existing SECTION_HAS_MEM_MAP flag to indicate the presence of a valid
mem_map.  Switch valid_section{,_nr} and pfn_valid() to this bit.  Add a new
present_section{,_nr} and pfn_present() interfaces for those users who care to
know that a section is going to be valid.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    6 +++---
 include/linux/mmzone.h |   16 ++++++++++++++--
 mm/sparse.c            |    9 +++++----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff -puN drivers/base/memory.c~sparsemem-record-when-a-section-has-a-valid-mem_map drivers/base/memory.c
--- a/drivers/base/memory.c~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/drivers/base/memory.c
@@ -239,7 +239,7 @@ store_mem_state(struct sys_device *dev, 
 	mem = container_of(dev, struct memory_block, sysdev);
 	phys_section_nr = mem->phys_index;
 
-	if (!valid_section_nr(phys_section_nr))
+	if (!present_section_nr(phys_section_nr))
 		goto out;
 
 	if (!strncmp(buf, "online", min((int)count, 6)))
@@ -419,7 +419,7 @@ int register_new_memory(struct mem_secti
 
 int unregister_memory_section(struct mem_section *section)
 {
-	if (!valid_section(section))
+	if (!present_section(section))
 		return -EINVAL;
 
 	return remove_memory_block(0, section, 0);
@@ -444,7 +444,7 @@ int __init memory_dev_init(void)
 	 * during boot and have been initialized
 	 */
 	for (i = 0; i < NR_MEM_SECTIONS; i++) {
-		if (!valid_section_nr(i))
+		if (!present_section_nr(i))
 			continue;
 		err = add_memory_block(0, __nr_to_section(i), MEM_ONLINE, 0);
 		if (!ret)
diff -puN include/linux/mmzone.h~sparsemem-record-when-a-section-has-a-valid-mem_map include/linux/mmzone.h
--- a/include/linux/mmzone.h~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/include/linux/mmzone.h
@@ -754,12 +754,17 @@ static inline struct page *__section_mem
 	return (struct page *)map;
 }
 
-static inline int valid_section(struct mem_section *section)
+static inline int present_section(struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
 
-static inline int section_has_mem_map(struct mem_section *section)
+static inline int present_section_nr(unsigned long nr)
+{
+	return present_section(__nr_to_section(nr));
+}
+
+static inline int valid_section(struct mem_section *section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
@@ -781,6 +786,13 @@ static inline int pfn_valid(unsigned lon
 	return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
 }
 
+static inline int pfn_present(unsigned long pfn)
+{
+        if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
+                return 0;
+        return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
+}
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
diff -puN mm/sparse.c~sparsemem-record-when-a-section-has-a-valid-mem_map mm/sparse.c
--- a/mm/sparse.c~sparsemem-record-when-a-section-has-a-valid-mem_map
+++ a/mm/sparse.c
@@ -170,7 +170,7 @@ unsigned long __init node_memmap_size_by
 		if (nid != early_pfn_to_nid(pfn))
 			continue;
 
-		if (pfn_valid(pfn))
+		if (pfn_present(pfn))
 			nr_pages += PAGES_PER_SECTION;
 	}
 
@@ -200,11 +200,12 @@ struct page *sparse_decode_mem_map(unsig
 static int __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map)
 {
-	if (!valid_section(ms))
+	if (!present_section(ms))
 		return -EINVAL;
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum);
+	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum) |
+							SECTION_HAS_MEM_MAP;
 
 	return 1;
 }
@@ -250,7 +251,7 @@ void __init sparse_init(void)
 	struct page *map;
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!valid_section_nr(pnum))
+		if (!present_section_nr(pnum))
 			continue;
 
 		map = sparse_early_mem_map_alloc(pnum);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
