From: akpm@linux-foundation.org
Subject: + ia64-use-common-header-for-software-io-tlb.patch added to -mm tree
Date: Thu, 07 Aug 2008 14:12:24 -0700
Message-ID: <200808072112.m77LCOlf005610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbYHGVMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 17:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, tony.luck@intel.com


The patch titled
     ia64: use common header for software IO/TLB
has been added to the -mm tree.  Its filename is
     ia64-use-common-header-for-software-io-tlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: use common header for software IO/TLB
From: Joerg Roedel <joerg.roedel@amd.com>

Remove the swiotlb prototypes from the architecture code and use the
common header file instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/hwsw_iommu.c |    9 +--------
 arch/ia64/include/asm/machvec.h  |   22 +---------------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff -puN arch/ia64/hp/common/hwsw_iommu.c~ia64-use-common-header-for-software-io-tlb arch/ia64/hp/common/hwsw_iommu.c
--- a/arch/ia64/hp/common/hwsw_iommu.c~ia64-use-common-header-for-software-io-tlb
+++ a/arch/ia64/hp/common/hwsw_iommu.c
@@ -13,19 +13,12 @@
  */
 
 #include <linux/device.h>
+#include <linux/swiotlb.h>
 
 #include <asm/machvec.h>
 
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
-extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
-extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
-extern ia64_mv_dma_supported		swiotlb_dma_supported;
-extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
 
 /* hwiommu declarations & definitions: */
 
diff -puN arch/ia64/include/asm/machvec.h~ia64-use-common-header-for-software-io-tlb arch/ia64/include/asm/machvec.h
--- a/arch/ia64/include/asm/machvec.h~ia64-use-common-header-for-software-io-tlb
+++ a/arch/ia64/include/asm/machvec.h
@@ -11,6 +11,7 @@
 #define _ASM_IA64_MACHVEC_H
 
 #include <linux/types.h>
+#include <linux/swiotlb.h>
 
 /* forward declarations: */
 struct device;
@@ -294,27 +295,6 @@ extern void machvec_init_from_cmdline(co
 # endif /* CONFIG_IA64_GENERIC */
 
 /*
- * Declare default routines which aren't declared anywhere else:
- */
-extern ia64_mv_dma_init			swiotlb_init;
-extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
-extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single		swiotlb_map_single;
-extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
-extern ia64_mv_dma_unmap_single		swiotlb_unmap_single;
-extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
-extern ia64_mv_dma_map_sg		swiotlb_map_sg;
-extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg		swiotlb_unmap_sg;
-extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
-extern ia64_mv_dma_sync_single_for_cpu	swiotlb_sync_single_for_cpu;
-extern ia64_mv_dma_sync_sg_for_cpu	swiotlb_sync_sg_for_cpu;
-extern ia64_mv_dma_sync_single_for_device swiotlb_sync_single_for_device;
-extern ia64_mv_dma_sync_sg_for_device	swiotlb_sync_sg_for_device;
-extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
-extern ia64_mv_dma_supported		swiotlb_dma_supported;
