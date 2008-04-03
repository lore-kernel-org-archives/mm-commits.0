From: akpm@linux-foundation.org
Subject: - pageflags-get-rid-of-flags_reserved-sparc64-fix.patch removed from -mm tree
Date: Wed, 02 Apr 2008 22:33:27 -0700
Message-ID: <200804030533.m335XRs7020713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052AbYDCFdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 01:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc64: fix NR_PAGEFLAGS check
has been removed from the -mm tree.  Its filename was
     pageflags-get-rid-of-flags_reserved-sparc64-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: fix NR_PAGEFLAGS check
From: Christoph Lameter <clameter@sgi.com>

Sparc64 requires that there be exactly 32 page flags in use by the VM.

I guess it does not matter if the VM uses less? So change the test and
only fail if the VM uses more than 32 page flags.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved-sparc64-fix arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved-sparc64-fix
+++ a/arch/sparc64/mm/init.c
@@ -1300,7 +1300,7 @@ void __init paging_init(void)
 	 * functions like clear_dcache_dirty_cpu use the cpu mask
 	 * in 13-bit signed-immediate instruction fields.
 	 */
-	BUILD_BUG_ON(BITS_PER_LONG - NR_PAGEFLAGS != 32);
+	BUILD_BUG_ON(BITS_PER_LONG - NR_PAGEFLAGS < 32);
 	BUILD_BUG_ON(SECTIONS_WIDTH + NODES_WIDTH + ZONES_WIDTH +
 		ilog2(roundup_pow_of_two(NR_CPUS)) >
 				BITS_PER_LONG - NR_PAGEFLAGS);
_

Patches currently in -mm which might be from clameter@sgi.com are

git-unionfs.patch
git-slub.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-mem_map-allocation-continuous.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-get-rid-of-flags_reserved-sparc64-fix.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
page-flags-handle-pg_uncached-like-all-other-flags.patch
page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
mm-remove-unused-max_nodes_shift.patch
vmcoreinfo-add-page-flags-values.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

