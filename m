From: akpm@linux-foundation.org
Subject: - pageflags-get-rid-of-flags_reserved-sparc64-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:54:20 -0700
Message-ID: <200804280654.m3S6sKcM012709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762306AbYD1Gy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc64: fix NR_PAGEFLAGS check
has been removed from the -mm tree.  Its filename was
     pageflags-get-rid-of-flags_reserved-sparc64-fix.patch

This patch was dropped because it was folded into pageflags-get-rid-of-flags_reserved.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: fix NR_PAGEFLAGS check
From: Christoph Lameter <clameter@sgi.com>

Update checks to make sure that we can place the cpu number in the upper
portion of the page flags.

Its okay if we use less than 32 page flags.  There can only be a problem if
the page flags grow beyond 32 bits to reach into the area reserved for the cpu
number.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/init.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved-sparc64-fix arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~pageflags-get-rid-of-flags_reserved-sparc64-fix
+++ a/arch/sparc64/mm/init.c
@@ -1300,10 +1300,21 @@ void __init paging_init(void)
 	 * functions like clear_dcache_dirty_cpu use the cpu mask
 	 * in 13-bit signed-immediate instruction fields.
 	 */
-	BUILD_BUG_ON(BITS_PER_LONG - NR_PAGEFLAGS != 32);
+
+	/*
+	 * Page flags must not reach into upper 32 bits that are used
+	 * for the cpu number
+	 */
+	BUILD_BUG_ON(NR_PAGEFLAGS > 32);
+
+	/*
+	 * The bit fields placed in the high range must not reach below
+	 * the 32 bit boundary. Otherwise we cannot place the cpu field
+	 * at the 32 bit boundary.
+	 */
 	BUILD_BUG_ON(SECTIONS_WIDTH + NODES_WIDTH + ZONES_WIDTH +
-		ilog2(roundup_pow_of_two(NR_CPUS)) >
-				BITS_PER_LONG - NR_PAGEFLAGS);
+		ilog2(roundup_pow_of_two(NR_CPUS)) > 32);
+
 	BUILD_BUG_ON(NR_CPUS > 4096);
 
 	kern_base = (prom_boot_mapping_phys_low >> 22UL) << 22UL;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
hotplug-memory-make-online_page-common.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-small-header-file-cleanup.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
mempolicy-fix-parsing-of-tmpfs-mpol-mount-option.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
pageflags-standardize-comment-inclusion-in-asm-offsetsh-and-fix-mips.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-get-rid-of-flags_reserved-sparc64-fix.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
page-flags-handle-pg_uncached-like-all-other-flags.patch
page-flags-add-pageflags_false-for-flags-that-are-always-false.patch
mm-get-rid-of-__zone_count.patch
pageflags_extended-and-separate-page-flags-for-head-and-tail.patch
vmcoreinfo-add-page-flags-values.patch
mempolicy-rename-mpol_free-to-mpol_put.patch
mempolicy-rename-mpol_copy-to-mpol_dup.patch
mempolicy-write-lock-mmap_sem-while-changing-task-mempolicy.patch
mempolicy-fixup-fallback-for-default-shmem-policy.patch
mempolicy-rename-struct-mempolicy-policy-member-to-mode.patch
mempolicy-mark-shared-policies-for-unref.patch
mempolicy-document-setget_policy-vm_ops-apis.patch
mempolicy-rework-mempolicy-reference-counting.patch
mempolicy-use-mpol_preferred-for-system-wide-default-policy.patch
mempolicy-mpol_preferred-cleanups-for-local-allocation.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy.patch
mempolicy-use-mpol_f_local-to-indicate-preferred-local-policy-fix.patch
mempolicy-clean-up-mpol-to-str-mempolicy-formatting.patch
mempolicy-rework-shmem-mpol-parsing-and-display.patch
mempolicy-support-mpol=local-tmpfs-mount-option.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch
add-cond_resched-to-refresh_cpu_vm_stats.patch

