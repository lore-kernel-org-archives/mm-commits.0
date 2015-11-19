From: akpm@linux-foundation.org
Subject: +
 dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 11:47:39 -0800
Message-ID: <564e275b.cgIoGGrZwPh/09Pt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbKSTrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 14:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentinrothberg@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: HAVE_DMA_ATTRS: remove leftovers in Kconfig
has been added to the -mm tree.  Its filename is
     dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -126,7 +126,6 @@ config S390
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
 	select HAVE_DEBUG_KMEMLEAK
-	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
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

dma-mapping-always-provide-the-dma_map_ops-based-implementation-fix.patch

