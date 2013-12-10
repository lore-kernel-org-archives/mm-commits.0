From: akpm@linux-foundation.org
Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
 added to -mm tree
Date: Tue, 10 Dec 2013 14:47:15 -0800
Message-ID: <52a799f3.q625eXSn1sCGHzIz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3LJWrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:47:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, grygorii.strashko@ti.com, santosh.shilimkar@ti.com

Subject: + mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch added to -mm tree
To: santosh.shilimkar@ti.com,grygorii.strashko@ti.com,tj@kernel.org,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:47:15 -0800


The patch titled
     Subject: mm/memblock: fix buld of "cris" arch
has been added to the -mm tree.  Its filename is
     mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-memblock-memory-allocation-apis-fix-2.patch

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
Subject: mm/memblock: fix buld of "cris" arch


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

