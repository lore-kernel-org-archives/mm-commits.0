From: akpm@linux-foundation.org
Subject: + dma-intel_ioatdma-build-fix.patch added to -mm tree
Date: Wed, 25 Jul 2007 22:05:11 -0700
Message-ID: <200707260505.l6Q55BLL015092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbXGZFF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ssatyam@cse.iitk.ac.in, shannon.nelson@intel.com


The patch titled
     dma: INTEL_IOATDMA build fix
has been added to the -mm tree.  Its filename is
     dma-intel_ioatdma-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 1 insertion(+)

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

dma-intel_ioatdma-build-fix.patch
kthread-silence-bogus-section-mismatch-warning.patch
clean-up-duplicate-includes-in-kernel.patch
