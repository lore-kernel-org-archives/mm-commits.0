From: akpm@linux-foundation.org
Subject: - i-oat-fix-null-device-in-call-to-dev_err.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:34 -0800
Message-ID: <200712202336.lBKNaYbI018813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbXLTXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, snakebyte@gmx.de, mm-commits@vger.kernel.org


The patch titled
     I/OAT: fix null device in call to dev_err()
has been removed from the -mm tree.  Its filename was
     i-oat-fix-null-device-in-call-to-dev_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: fix null device in call to dev_err()
From: Shannon Nelson <shannon.nelson@intel.com>

We can't use the device in a dev_err() after a kzalloc failure or after the
kfree, so simplify it to the pdev that was originally passed in.

Cc: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ioat_dma.c~i-oat-fix-null-device-in-call-to-dev_err drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-fix-null-device-in-call-to-dev_err
+++ a/drivers/dma/ioat_dma.c
@@ -1363,7 +1363,7 @@ err_completion_pool:
 err_dma_pool:
 	kfree(device);
 err_kzalloc:
-	dev_err(&device->pdev->dev,
+	dev_err(&pdev->dev,
 		"Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
 }
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
dca-convert-struct-class_device-to-struct-device.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch
