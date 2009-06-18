From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-ia64-add-config_dma_api_debug-support.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:19 -0700
Message-ID: <200906182248.n5IMmJPI007414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594AbZFRW6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: ia64: add CONFIG_DMA_API_DEBUG support
has been removed from the -mm tree.  Its filename was
     dma-mapping-ia64-add-config_dma_api_debug-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: ia64: add CONFIG_DMA_API_DEBUG support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: "Luck, Tony" <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc; "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig                   |    1 +
 arch/ia64/include/asm/dma-mapping.h |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/ia64/Kconfig~dma-mapping-ia64-add-config_dma_api_debug-support arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~dma-mapping-ia64-add-config_dma_api_debug-support
+++ a/arch/ia64/Kconfig
@@ -28,6 +28,7 @@ config IA64
 	select HAVE_DMA_ATTRS
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DMA_API_DEBUG
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-ia64-add-config_dma_api_debug-support arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-ia64-add-config_dma_api_debug-support
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -8,6 +8,7 @@
 #include <asm/machvec.h>
 #include <linux/scatterlist.h>
 #include <asm/swiotlb.h>
+#include <linux/dma-debug.h>
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
@@ -24,13 +25,18 @@ static inline void *dma_alloc_coherent(s
 				       dma_addr_t *daddr, gfp_t gfp)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->alloc_coherent(dev, size, daddr, gfp);
+	void *caddr;
+
+	caddr = ops->alloc_coherent(dev, size, daddr, gfp);
+	debug_dma_alloc_coherent(dev, size, *daddr, caddr);
+	return caddr;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *caddr, dma_addr_t daddr)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	debug_dma_free_coherent(dev, size, caddr, daddr);
 	ops->free_coherent(dev, size, caddr, daddr);
 }
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch

