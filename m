From: akpm@linux-foundation.org
Subject: + ahci-request-all-pci-bars.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:37:47 -0700
Message-ID: <200803120437.m2C4bl28010276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbYCLEiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com


The patch titled
     ahci: request all PCI BARs
has been added to the -mm tree.  Its filename is
     ahci-request-all-pci-bars.patch

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
ahci-request-all-pci-bars.patch

