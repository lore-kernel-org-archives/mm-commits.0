From: akpm@linux-foundation.org
Subject: - ahci-request-all-pci-bars.patch removed from -mm tree
Date: Tue, 18 Mar 2008 16:23:05 -0700
Message-ID: <200803182323.m2INN5Rr021277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbYCSTlk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci: request all PCI BARs
has been removed from the -mm tree.  Its filename was
     ahci-request-all-pci-bars.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ahci: request all PCI BARs
From: Tejun Heo <htejun@gmail.com>

ahci is often implemented with accompanying SFF compatible interface and
legacy IDE driver may attach to the legacy IO ports when the controller is
already claimed by ahci and vice-versa.  This patch makes ahci use
pcim_iomap_regions_request_all() so that all IO regions are claimed on attach.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ahci.c~ahci-request-all-pci-bars drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-request-all-pci-bars
+++ a/drivers/ata/ahci.c
@@ -2241,7 +2241,10 @@ static int ahci_init_one(struct pci_dev 
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
devres-implement-pcim_iomap_regions_request_all.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
add-macros-similar-to-min-max-min_t-max_t.patch
ata-remove-fit-macro.patch

