From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch added to
 -mm tree
Date: Mon, 25 May 2020 13:19:41 -0700
Message-ID: <20200525201941.kkbLSuHe_%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388994AbgEYUTm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 May 2020 16:19:42 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: x86/kaslr: take CONFIG_RANDOMIZE_MEMORY into account in kaslr_enabled()
has been added to the -mm tree.  Its filename is
     x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch

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
Subject: x86/kaslr: take CONFIG_RANDOMIZE_MEMORY into account in kaslr_enabled()

Until refactoring of the init_trampoline(), kaslr_enabled() was used only
inside '#ifdef CONFIG_RANDOMIZE_MEMORY' and reported only the state of the
command line override.

The simplification of init_trampoline() made kaslr_enabled() visible for
builds with CONFIG_RANDOMIZE_MEMORY=n and in this case it will return true
if the randomization was not disabled on the command line.

This in turn will call a dummy init_trampoline_kaslr() instead of setting
trampline_pgd_entry directly.

As the result, the kernel reboots while starting the secondary CPUs, e.g.
kernel test bot reported:

...
[    0.244628] Performance Events: unsupported p6 CPU model 60 no PMU driver, software events only.
[    0.244993] rcu: Hierarchical SRCU implementation.
[    0.245617] smp: Bringing up secondary CPUs ...
[    0.247388] x86: Booting SMP configuration:
BUG: kernel reboot-without-warning in boot stage

Adding a check for IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) to kaslr_enabled()
resolves the issue.

Link: http://lkml.kernel.org/r/20200525104045.GB13212@linux.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/setup.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/setup.h~x86-mm-simplify-init_trampoline-and-surrounding-logic-fix
+++ a/arch/x86/include/asm/setup.h
@@ -75,7 +75,8 @@ extern char _text[];
 
 static inline bool kaslr_enabled(void)
 {
-	return !!(boot_params.hdr.loadflags & KASLR_FLAG);
+	return IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) &&
+		!!(boot_params.hdr.loadflags & KASLR_FLAG);
 }
 
 /*
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

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
h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
powerpc-add-support-for-folded-p4d-page-tables-fix-2.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
