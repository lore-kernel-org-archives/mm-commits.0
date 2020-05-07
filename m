From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-free=5Farea=5Finit-allow-defining-max=5Fzone=5Fpfn-in-?=
 =?US-ASCII?Q?descending-order-fix-2.patch?= added to -mm tree
Date: Thu, 07 May 2020 14:13:33 -0700
Message-ID: <20200507211333.MuYcfK-hc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbgEGVNe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 17:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rppt@linux.ibm.com, Vineet.Gupta1@synopsys.com


The patch titled
     Subject: arc: free_area_init(): take into account PAE40 mode
has been added to the -mm tree.  Its filename is
     mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arc: free_area_init(): take into account PAE40 mode

The arch_has_descending_max_zone_pfns() does not take into account physical
memory layout for PAE40 configuration.
With PAE40 enabled, the HIGHMEM is actually higher than NORMAL and
arch_has_descending_max_zone_pfns() should return false in this case.

Link: http://lkml.kernel.org/r/20200507205900.GH683243@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/mm/init.c~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2
+++ a/arch/arc/mm/init.c
@@ -79,7 +79,7 @@ void __init early_init_dt_add_memory_arc
 
 bool arch_has_descending_max_zone_pfns(void)
 {
-	return true;
+	return !IS_ENABLED(CONFIG_ARC_HAS_PAE40);
 }
 
 /*
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
