From: akpm@linux-foundation.org
Subject: - sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:11 -0700
Message-ID: <200708242055.l7OKtBnk013942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXHXUzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sparsemem: ensure we initialise the node mapping for SPARSEMEM_STATIC
has been removed from the -mm tree.  Its filename was
     sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparsemem: ensure we initialise the node mapping for SPARSEMEM_STATIC
From: Andy Whitcroft <apw@shadowen.org>

Booting SPARSEMEM on NUMA systems trips a BUG in page_alloc.c:

	Initializing HighMem for node 0 (00038000:00100000)
	Initializing HighMem for node 1 (00100000:001ffe00)
	------------[ cut here ]------------
	kernel BUG at /home/apw/git/linux-2.6/mm/page_alloc.c:456!
	[...]

This occurs because the section to node id mapping is not being
setup correctly during init under SPARSEMEM_STATIC, leading to an
attempt to free pages from all nodes into the zones on node 0.

When the zone_table[] was removed in the following commit, a new
section to node mapping table was introduced:

    commit 89689ae7f95995723fbcd5c116c47933a3bb8b13
    [PATCH] Get rid of zone_table[]

That conversion inadvertantly only initialised the node mapping in
SPARSEMEM_EXTREME.  Ensure we initialise the node mapping in
SPARSEMEM_STATIC.

[akpm@linux-foundation.org: make the stubs static inline]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/sparse.c~sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static mm/sparse.c
--- a/mm/sparse.c~sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static
+++ a/mm/sparse.c
@@ -41,6 +41,15 @@ int page_to_nid(struct page *page)
 	return section_to_node_table[page_to_section(page)];
 }
 EXPORT_SYMBOL(page_to_nid);
+
+static void set_section_nid(unsigned long section_nr, int nid)
+{
+	section_to_node_table[section_nr] = nid;
+}
+#else /* !NODE_NOT_IN_PAGE_FLAGS */
+static inline void set_section_nid(unsigned long section_nr, int nid)
+{
+}
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -68,10 +77,6 @@ static int __meminit sparse_index_init(u
 	struct mem_section *section;
 	int ret = 0;
 
-#ifdef NODE_NOT_IN_PAGE_FLAGS
-	section_to_node_table[section_nr] = nid;
-#endif
-
 	if (mem_section[root])
 		return -EEXIST;
 
@@ -148,6 +153,7 @@ void __init memory_present(int nid, unsi
 		struct mem_section *ms;
 
 		sparse_index_init(section, nid);
+		set_section_nid(section, nid);
 
 		ms = __nr_to_section(section);
 		if (!ms->section_mem_map)
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mips-irix_getcontext-will-always-fail-efault.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
