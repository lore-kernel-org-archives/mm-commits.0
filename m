From: akpm@linux-foundation.org
Subject: [merged] pci-use-pci_ioremap_bar-in-drivers-serial.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:04 -0700
Message-ID: <200906241911.n5OJB4VF011327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757176AbZFXTLK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     pci: use pci_ioremap_bar() in drivers/serial
has been removed from the -mm tree.  Its filename was
     pci-use-pci_ioremap_bar-in-drivers-serial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/serial
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/serial. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    6 ++----
 drivers/serial/icom.c     |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/serial/8250_pci.c~pci-use-pci_ioremap_bar-in-drivers-serial drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~pci-use-pci_ioremap_bar-in-drivers-serial
+++ a/drivers/serial/8250_pci.c
@@ -398,8 +398,7 @@ static int sbs_init(struct pci_dev *dev)
 {
 	u8 __iomem *p;
 
-	p = ioremap_nocache(pci_resource_start(dev, 0),
-						pci_resource_len(dev, 0));
+	p = pci_ioremap_bar(dev, 0);
 
 	if (p == NULL)
 		return -ENOMEM;
@@ -423,8 +422,7 @@ static void __devexit sbs_exit(struct pc
 {
 	u8 __iomem *p;
 
-	p = ioremap_nocache(pci_resource_start(dev, 0),
-					pci_resource_len(dev, 0));
+	p = pci_ioremap_bar(dev, 0);
 	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
 	if (p != NULL)
 		writeb(0, p + OCT_REG_CR_OFF);
diff -puN drivers/serial/icom.c~pci-use-pci_ioremap_bar-in-drivers-serial drivers/serial/icom.c
--- a/drivers/serial/icom.c~pci-use-pci_ioremap_bar-in-drivers-serial
+++ a/drivers/serial/icom.c
@@ -1548,8 +1548,7 @@ static int __devinit icom_probe(struct p
 		goto probe_exit1;
 	}
 
-	 icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
-						pci_resource_len(dev, 0));
+	 icom_adapter->base_addr = pci_ioremap_bar(dev, 0);
 
 	if (!icom_adapter->base_addr)
 		goto probe_exit1;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch

