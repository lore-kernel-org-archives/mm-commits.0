From: akpm@linux-foundation.org
Subject: [folded-merged]
 common-dma-mapping-introduce-common-remapping-functions-fix-2.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:35:02 -0700
Message-ID: <5436f176.OP1nw+hrPBYzMpXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: Protect remapping functions with CONFIG_MMU
has been removed from the -mm tree.  Its filename was
     common-dma-mapping-introduce-common-remapping-functions-fix-2.patch

This patch was dropped because it was folded into common-dma-mapping-introduce-common-remapping-functions.patch

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: common: dma-mapping: Protect remapping functions with CONFIG_MMU

The dma remapping functions use vmalloc features which are
not defined for CONFIG_MMU=n

drivers/built-in.o: In function `dma_common_pages_remap':
  drivers/base/dma-mapping.c:311: undefined reference to `get_vm_area_caller'
  drivers/base/dma-mapping.c:315: undefined reference to `map_vm_area'
drivers/built-in.o: In function `dma_common_free_remap':
  drivers/base/dma-mapping.c:328: undefined reference to `find_vm_area'

These functions aren't applicable for nommu targets so protect them
with #ifdef CONFIG_MMU

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-mapping.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix-2 drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix-2
+++ a/drivers/base/dma-mapping.c
@@ -270,6 +270,7 @@ int dma_common_mmap(struct device *dev,
 }
 EXPORT_SYMBOL(dma_common_mmap);
 
+#ifdef CONFIG_MMU
 /*
  * remaps an array of PAGE_SIZE pages into another vm_area
  * Cannot be used in non-sleeping contexts
@@ -335,3 +336,4 @@ void dma_common_free_remap(void *cpu_add
 	unmap_kernel_range((unsigned long)cpu_addr, size);
 	vunmap(cpu_addr);
 }
+#endif
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
common-dma-mapping-introduce-common-remapping-functions-fix-4.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch

