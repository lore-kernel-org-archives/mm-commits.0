From: akpm@linux-foundation.org
Subject: [merged] vme-bridges-use-pci_zalloc_consistent.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:42:59 -0700
Message-ID: <53ea6e43.vU022aDqQ+RTmf4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:40735 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaHLTnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:00 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919910oah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, manohar.vanga@gmail.com, martyn.welch@ge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vme: bridges: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     vme-bridges-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: vme: bridges: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vme/bridges/vme_ca91cx42.c |    6 ++----
 drivers/vme/bridges/vme_tsi148.c   |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/vme/bridges/vme_ca91cx42.c~vme-bridges-use-pci_zalloc_consistent drivers/vme/bridges/vme_ca91cx42.c
--- a/drivers/vme/bridges/vme_ca91cx42.c~vme-bridges-use-pci_zalloc_consistent
+++ a/drivers/vme/bridges/vme_ca91cx42.c
@@ -1555,16 +1555,14 @@ static int ca91cx42_crcsr_init(struct vm
 	}
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for CR/CSR "
 			"image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
-
 	crcsr_addr = slot * (512 * 1024);
 	iowrite32(bridge->crcsr_bus - crcsr_addr, bridge->base + VCSR_TO);
 
diff -puN drivers/vme/bridges/vme_tsi148.c~vme-bridges-use-pci_zalloc_consistent drivers/vme/bridges/vme_tsi148.c
--- a/drivers/vme/bridges/vme_tsi148.c~vme-bridges-use-pci_zalloc_consistent
+++ a/drivers/vme/bridges/vme_tsi148.c
@@ -2275,16 +2275,14 @@ static int tsi148_crcsr_init(struct vme_
 	bridge = tsi148_bridge->driver_priv;
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(tsi148_bridge->parent, "Failed to allocate memory for "
 			"CR/CSR image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
