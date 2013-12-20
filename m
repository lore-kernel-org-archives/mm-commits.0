From: akpm@linux-foundation.org
Subject: + x86-memblock-set-current-limit-to-max-low-memory-address.patch
 added to -mm tree
Date: Fri, 20 Dec 2013 13:29:51 -0800
Message-ID: <52b4b6cf.Xtl4NmrnxF17PjBR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3LTV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 16:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com

Subject: + x86-memblock-set-current-limit-to-max-low-memory-address.patch added to -mm tree
To: santosh.shilimkar@ti.com
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 13:29:51 -0800


The patch titled
     x86: memblock: set current limit to max low memory address
has been added to the -mm tree.  Its filename is
     x86-memblock-set-current-limit-to-max-low-memory-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-memblock-set-current-limit-to-max-low-memory-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-memblock-set-current-limit-to-max-low-memory-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
x86: memblock: set current limit to max low memory address

The memblock current limit value is used to limit early boot
memory allocations below max low memory address by deafult, as
the kernel can access only to the low memory.

Hence, set memblock current limit value to the max mapped low
memory address instead of max mapped memory address.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    4 ++--
 arch/x86/kernel/setup.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-memblock-set-current-limit-to-max-low-memory-address arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-memblock-set-current-limit-to-max-low-memory-address
+++ a/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-static inline phys_addr_t get_max_mapped(void)
+static inline phys_addr_t get_max_low_mapped(void)
 {
-	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
+	return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
diff -puN arch/x86/kernel/setup.c~x86-memblock-set-current-limit-to-max-low-memory-address arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-memblock-set-current-limit-to-max-low-memory-address
+++ a/arch/x86/kernel/setup.c
@@ -1101,7 +1101,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock_set_current_limit(get_max_mapped());
+	memblock_set_current_limit(get_max_low_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
linux-next.patch

