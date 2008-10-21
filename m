From: akpm@linux-foundation.org
Subject: + pci-use-pci_ioremap_bar-in-drivers-serial.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:16:48 -0700
Message-ID: <200810212116.m9LLGmhT021753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbYJUVQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk


The patch titled
     pci: use pci_ioremap_bar() in drivers/serial
has been added to the -mm tree.  Its filename is
     pci-use-pci_ioremap_bar-in-drivers-serial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/serial
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/serial. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    6 ++----
 drivers/serial/icom.c     |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/serial/8250_pci.c~pci-use-pci_ioremap_bar-in-drivers-serial drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~pci-use-pci_ioremap_bar-in-drivers-serial
+++ a/drivers/serial/8250_pci.c
@@ -339,8 +339,7 @@ static int sbs_init(struct pci_dev *dev)
 {
 	u8 __iomem *p;
 
-	p = ioremap_nocache(pci_resource_start(dev, 0),
-						pci_resource_len(dev, 0));
+	p = pci_ioremap_bar(dev, 0);
 
 	if (p == NULL)
 		return -ENOMEM;
@@ -364,8 +363,7 @@ static void __devexit sbs_exit(struct pc
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
@@ -1553,8 +1553,7 @@ static int __devinit icom_probe(struct p
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
linux-next.patch
mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch
pci-use-pci_ioremap_bar-in-drivers-misc.patch
pci-use-pci_ioremap_bar-in-drivers-mmc.patch
pci-use-pci_ioremap_bar-in-drivers-edac.patch
pci-use-pci_ioremap_bar-in-drivers-video.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

