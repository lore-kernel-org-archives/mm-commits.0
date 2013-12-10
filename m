From: akpm@linux-foundation.org
Subject: +
 arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch added
 to -mm tree
Date: Mon, 09 Dec 2013 16:29:38 -0800
Message-ID: <52a66072.JZkjCHL80pxmrlur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3LJA3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: + arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch added to -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:38 -0800


The patch titled
     Subject: arch/arm/kernel/: use memblock apis for early memory allocations
has been added to the -mm tree.  Its filename is
     arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch

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
Subject: arch/arm/kernel/: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/devtree.c |    2 +-
 arch/arm/kernel/setup.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/kernel/devtree.c~arch-arm-kernel-use-memblock-apis-for-early-memory-allocations arch/arm/kernel/devtree.c
--- a/arch/arm/kernel/devtree.c~arch-arm-kernel-use-memblock-apis-for-early-memory-allocations
+++ a/arch/arm/kernel/devtree.c
@@ -33,7 +33,7 @@ void __init early_init_dt_add_memory_arc
 
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return alloc_bootmem_align(size, align);
+	return memblock_virt_alloc(size, align);
 }
 
 void __init arm_dt_memblock_reserve(void)
diff -puN arch/arm/kernel/setup.c~arch-arm-kernel-use-memblock-apis-for-early-memory-allocations arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~arch-arm-kernel-use-memblock-apis-for-early-memory-allocations
+++ a/arch/arm/kernel/setup.c
@@ -717,7 +717,7 @@ static void __init request_standard_reso
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = alloc_bootmem_low(sizeof(*res));
+		res = memblock_virt_alloc(sizeof(*res), 0);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
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
linux-next.patch

