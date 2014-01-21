From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch removed from
 -mm tree
Date: Tue, 21 Jan 2014 15:33:43 -0800
Message-ID: <52df03d7.76KQRw0Hh1oiToUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUXdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, grygorii.strashko@ti.com, santosh.shilimkar@ti.com

Subject: [folded-merged] mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch removed from -mm tree
To: santosh.shilimkar@ti.com,grygorii.strashko@ti.com,tj@kernel.org,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:33:43 -0800


The patch titled
     Subject: mm/memblock: fix buld of "cris" arch
has been removed from the -mm tree.  Its filename was
     mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch

This patch was dropped because it was folded into mm-memblock-add-memblock-memory-allocation-apis.patch

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/memblock: fix buld of "cris" arch

From: Grygorii Strashko <grygorii.strashko@ti.com>

The build of "criss" arch is broken after applying new memblock API
series.

In file included from arch/cris/mm/init.c:13:0:
include/linux/bootmem.h: In function 'memblock_virt_alloc':
include/linux/bootmem.h:229:55: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h:229:55: note: each undeclared identifier is reported only once for each function it appears in
include/linux/bootmem.h: In function 'memblock_virt_alloc_nopanic':
include/linux/bootmem.h:237:63: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node':
include/linux/bootmem.h:250:27: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node_nopanic':
include/linux/bootmem.h:258:28: error: 'KSEG_C' undeclared (first use in this function)

In file included from mm/bootmem.c:14:0:
include/linux/bootmem.h: In function 'memblock_virt_alloc':
include/linux/bootmem.h:229:55: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h:229:55: note: each undeclared identifier is reported only once for each function it appears in
include/linux/bootmem.h: In function 'memblock_virt_alloc_nopanic':
include/linux/bootmem.h:237:63: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node':
include/linux/bootmem.h:250:27: error: 'KSEG_C' undeclared (first use in this function)

The "cris" arch defines memory parameters in a different manner than other
arch's and they are splitted between 2 headers: <asm/page.h> and <asm/mmu.h>

As result, now build is failed if "bootmem.h" included before
<asm/page.h> and <asm/mmu.h>. Hence, fix it by including additional
header in bootmem.h.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/bootmem.h~mm-memblock-add-memblock-memory-allocation-apis-fix-2 include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-memblock-add-memblock-memory-allocation-apis-fix-2
+++ a/include/linux/bootmem.h
@@ -5,6 +5,7 @@
 #define _LINUX_BOOTMEM_H
 
 #include <linux/mmzone.h>
+#include <linux/mm_types.h>
 #include <asm/dma.h>
 
 /*
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix-4.patch
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

