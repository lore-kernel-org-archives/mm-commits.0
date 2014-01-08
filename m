From: akpm@linux-foundation.org
Subject: + x86-mm-memblock-switch-to-use-numa_no_node.patch added to -mm
 tree
Date: Wed, 08 Jan 2014 14:27:54 -0800
Message-ID: <52cdd0ea.BJndGlBsZNFvLvDI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaAHW1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 17:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de, sfr@canb.auug.org.au, santosh.shilimkar@ti.com, rientjes@google.com, mingo@redhat.com, hpa@zytor.com, grygorii.strashko@ti.com

Subject: + x86-mm-memblock-switch-to-use-numa_no_node.patch added to -mm tree
To: grygorii.strashko@ti.com,hpa@zytor.com,mingo@redhat.com,rientjes@google.com,santosh.shilimkar@ti.com,sfr@canb.auug.org.au,tglx@linutronix.de,tj@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 14:27:54 -0800


The patch titled
     Subject: x86/mm: memblock: switch to use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     x86-mm-memblock-switch-to-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-memblock-switch-to-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-memblock-switch-to-use-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: x86/mm: memblock: switch to use NUMA_NO_NODE

Update X86 code to use NUMA_NO_NODE instead of MAX_NUMNODES while calling
memblock APIs, because memblock API will be changed to use NUMA_NO_NODE
and will produce warning during boot otherwise.

See:
 https://lkml.org/lkml/2013/12/9/898

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/check.c |    2 +-
 arch/x86/kernel/e820.c  |    2 +-
 arch/x86/mm/memtest.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/check.c~x86-mm-memblock-switch-to-use-numa_no_node arch/x86/kernel/check.c
--- a/arch/x86/kernel/check.c~x86-mm-memblock-switch-to-use-numa_no_node
+++ a/arch/x86/kernel/check.c
@@ -91,7 +91,7 @@ void __init setup_bios_corruption_check(
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL) {
 		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
 				PAGE_SIZE, corruption_check_size);
 		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
diff -puN arch/x86/kernel/e820.c~x86-mm-memblock-switch-to-use-numa_no_node arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~x86-mm-memblock-switch-to-use-numa_no_node
+++ a/arch/x86/kernel/e820.c
@@ -1120,7 +1120,7 @@ void __init memblock_find_dma_reserve(vo
 		nr_pages += end_pfn - start_pfn;
 	}
 
-	for_each_free_mem_range(u, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(u, NUMA_NO_NODE, &start, &end, NULL) {
 		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
 		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
 		if (start_pfn < end_pfn)
diff -puN arch/x86/mm/memtest.c~x86-mm-memblock-switch-to-use-numa_no_node arch/x86/mm/memtest.c
--- a/arch/x86/mm/memtest.c~x86-mm-memblock-switch-to-use-numa_no_node
+++ a/arch/x86/mm/memtest.c
@@ -74,7 +74,7 @@ static void __init do_one_pass(u64 patte
 	u64 i;
 	phys_addr_t this_start, this_end;
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
 		this_start = clamp_t(phys_addr_t, this_start, start, end);
 		this_end = clamp_t(phys_addr_t, this_end, start, end);
 		if (this_start < this_end) {
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-3.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
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
x86-mm-memblock-switch-to-use-numa_no_node.patch
mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

