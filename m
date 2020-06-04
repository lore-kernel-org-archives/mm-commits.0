From: akpm@linux-foundation.org
Subject: [merged]
 sparc32-register-memory-occupied-by-kernel-as-memblockmemory.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 10:21:21 -0700
Message-ID: <20200604172121.9Coq1NbIT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, linux@roeck-us.net, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: sparc32: register memory occupied by kernel as memblock.memory
has been removed from the -mm tree.  Its filename was
     sparc32-register-memory-occupied-by-kernel-as-memblockmemory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: sparc32: register memory occupied by kernel as memblock.memory

sparc32 never registered the memory occupied by the kernel image with
memblock_add() and it only reserved this memory with meblock_reserve().

With openbios as system firmware, the memory occupied by the kernel is
reserved in openbios and removed from mem.available.  The prom setup code
in the kernel uses mem.available to set up the memory banks and
essentially there is a hole for the memory occupied by the kernel image.

Later in bootmem_init() this memory is memblock_reserve()d.

Up until recently, memmap initialization would call __init_single_page()
for the pages in that hole, the free_low_memory_core_early() would mark
them as reserved and everything would be Ok.

After the change in memmap initialization introduced by the commit "mm:
memmap_init: iterate over memblock regions rather that check each PFN",
the hole is skipped and the page structs for it are not initialized.  And
when they are passed from memblock to page allocator as reserved, the
latter gets confused.

Simply registering the memory occupied by the kernel with memblock_add()
resolves this issue.

Tested on qemu-system-sparc with Debian Etch [1] userspace.

[1] https://people.debian.org/~aurel32/qemu/sparc/debian_etch_sparc_small.qcow2

Link: https://lkml.kernel.org/r/20200517000050.GA87467@roeck-us.nlllllet/
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/mm/init_32.c~sparc32-register-memory-occupied-by-kernel-as-memblockmemory
+++ a/arch/sparc/mm/init_32.c
@@ -193,6 +193,7 @@ unsigned long __init bootmem_init(unsign
 	/* Reserve the kernel text/data/bss. */
 	size = (start_pfn << PAGE_SHIFT) - phys_base;
 	memblock_reserve(phys_base, size);
+	memblock_add(phys_base, size);
 
 	size = memblock_phys_mem_size() - memblock_reserved_size();
 	*pages_avail = (size >> PAGE_SHIFT) - high_pages;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
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
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
