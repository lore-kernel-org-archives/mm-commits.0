From: akpm@linux-foundation.org
Subject: - dma-intel_ioatdma-build-fix.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:10 -0700
Message-ID: <200708201912.l7KJCABU018331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbXHTTM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     dma: INTEL_IOATDMA build fix
has been removed from the -mm tree.  Its filename was
     dma-intel_ioatdma-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma: INTEL_IOATDMA build fix
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Make CONFIG_INTEL_IOATDMA select CONFIG_DCA because it uses code
exported from said dependency:

# CONFIG_DCA is not set
CONFIG_INTEL_IOATDMA=m

ERROR: "alloc_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "register_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "unregister_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "free_dca_provider" [drivers/dma/ioatdma.ko] undefined!
make[1]: *** [__modpost] Error 1

"select" seems ok because CONFIG_DCA looks library-like and doesn't itself
depend upon anything else.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/dma/Kconfig~dma-intel_ioatdma-build-fix drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~dma-intel_ioatdma-build-fix
+++ a/drivers/dma/Kconfig
@@ -28,6 +28,7 @@ comment "DMA Devices"
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
 	depends on DMA_ENGINE && PCI
+	select DCA
 	default m
 	---help---
 	  Enable support for the Intel(R) I/OAT DMA engine.
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

clean-up-duplicate-includes-in-kernel.patch
