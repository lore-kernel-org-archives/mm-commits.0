From: akpm@linux-foundation.org
Subject: + dma-mapping-ia64-add-config_dma_api_debug-support.patch added to -mm tree
Date: Thu, 28 May 2009 00:20:42 -0700
Message-ID: <200905280720.n4S7KgcR008396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485AbZE1HU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com


The patch titled
     dma-mapping: ia64: add CONFIG_DMA_API_DEBUG support
has been added to the -mm tree.  Its filename is
     dma-mapping-ia64-add-config_dma_api_debug-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: ia64: add CONFIG_DMA_API_DEBUG support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
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

linux-next.patch
vino-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
net-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
sg_io-dont-perform-unneeded-copy-in-compat-code.patch
usb-replace-dma_sync_single-and-dma_sync_sg-with-dma_sync_single_for_cpu-and-dma_sync_sg_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

