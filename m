From: akpm@linux-foundation.org
Subject: - pci-use-pci_ioremap_bar-in-drivers-edac.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:47 -0800
Message-ID: <200901072220.n07MKlj8019971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601AbZAGWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pci: use pci_ioremap_bar() in drivers/edac
has been removed from the -mm tree.  Its filename was
     pci-use-pci_ioremap_bar-in-drivers-edac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/edac
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/edac. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~pci-use-pci_ioremap_bar-in-drivers-edac drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~pci-use-pci_ioremap_bar-in-drivers-edac
+++ a/drivers/edac/i82875p_edac.c
@@ -311,9 +311,7 @@ static int i82875p_setup_overfl_dev(stru
 	}
 
 	/* cache is irrelevant for PCI bus reads/writes */
-	window = ioremap_nocache(pci_resource_start(dev, 0),
-				 pci_resource_len(dev, 0));
