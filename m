From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 13:41:55 -0800
Message-ID: <569fff23.XOKEDQKCVcsTiZN1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbcATVl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, borntraeger@de.ibm.com, hch@lst.de, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HAVE_DMA_ATTRS: remove leftovers in Kconfig
has been removed from the -mm tree.  Its filename was
     dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch

This patch was dropped because it was folded into dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch

------------------------------------------------------
From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: HAVE_DMA_ATTRS: remove leftovers in Kconfig

The Kconfig option HAVE_DMA_ATTRS has been removed by
commit f6f306eeb7ea ("dma-mapping: always provide the dma_map_ops based
implementation").  Remove leftover references on this option.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig           |    1 -
 drivers/gpu/drm/vc4/Kconfig |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/s390/Kconfig~dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix arch/s390/Kconfig
--- a/arch/s390/Kconfig~dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix
+++ a/arch/s390/Kconfig
@@ -579,7 +579,6 @@ config QDIO
 
 menuconfig PCI
 	bool "PCI support"
-	select HAVE_DMA_ATTRS
 	select PCI_MSI
 	select IOMMU_SUPPORT
 	help
diff -puN drivers/gpu/drm/vc4/Kconfig~dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix drivers/gpu/drm/vc4/Kconfig
--- a/drivers/gpu/drm/vc4/Kconfig~dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix
+++ a/drivers/gpu/drm/vc4/Kconfig
@@ -1,7 +1,7 @@
 config DRM_VC4
 	tristate "Broadcom VC4 Graphics"
 	depends on ARCH_BCM2835 || COMPILE_TEST
-	depends on DRM && HAVE_DMA_ATTRS
+	depends on DRM
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
_

Patches currently in -mm which might be from valentinrothberg@gmail.com are

powerpc-enable-ubsan-support-fix.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch

