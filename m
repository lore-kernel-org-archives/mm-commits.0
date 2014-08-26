From: akpm@linux-foundation.org
Subject: +
 common-dma-mapping-introduce-common-remapping-functions-fix-2.patch added
 to -mm tree
Date: Tue, 26 Aug 2014 13:35:13 -0700
Message-ID: <53fcef81.tCB9RZMMeY9OX8GA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49737 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaHZUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 16:35:14 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so4070974pab.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 13:35:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: Protect remapping functions with CONFIG_MMU
has been added to the -mm tree.  Its filename is
     common-dma-mapping-introduce-common-remapping-functions-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
common-dma-mapping-introduce-common-remapping-functions-fix.patch
common-dma-mapping-introduce-common-remapping-functions-fix-2.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
debugging-keep-track-of-page-owners.patch

