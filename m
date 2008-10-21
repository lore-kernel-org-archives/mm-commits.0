From: akpm@linux-foundation.org
Subject: + pci-use-pci_ioremap_bar-in-drivers-misc.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:16:39 -0700
Message-ID: <200810212116.m9LLGdRq021665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbYJUVQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     pci: use pci_ioremap_bar() in drivers/misc
has been added to the -mm tree.  Its filename is
     pci-use-pci_ioremap_bar-in-drivers-misc.patch

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
Subject: pci: use pci_ioremap_bar() in drivers/misc
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/misc. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ibmasm/module.c |    3 +--
 drivers/misc/tifm_7xx1.c     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/misc/ibmasm/module.c~pci-use-pci_ioremap_bar-in-drivers-misc drivers/misc/ibmasm/module.c
--- a/drivers/misc/ibmasm/module.c~pci-use-pci_ioremap_bar-in-drivers-misc
+++ a/drivers/misc/ibmasm/module.c
@@ -104,8 +104,7 @@ static int __devinit ibmasm_init_one(str
 	}
 
 	sp->irq = pdev->irq;
-	sp->base_address = ioremap(pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0));
+	sp->base_address = pci_ioremap_bar(pdev, 0);
 	if (!sp->base_address) {
 		dev_err(sp->dev, "Failed to ioremap pci memory\n");
 		result =  -ENODEV;
diff -puN drivers/misc/tifm_7xx1.c~pci-use-pci_ioremap_bar-in-drivers-misc drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~pci-use-pci_ioremap_bar-in-drivers-misc
+++ a/drivers/misc/tifm_7xx1.c
@@ -354,8 +354,7 @@ static int tifm_7xx1_probe(struct pci_de
 	fm->has_ms_pif = tifm_7xx1_has_ms_pif;
 	pci_set_drvdata(dev, fm);
 
-	fm->addr = ioremap(pci_resource_start(dev, 0),
-			   pci_resource_len(dev, 0));
+	fm->addr = pci_ioremap_bar(dev, 0);
 	if (!fm->addr)
 		goto err_out_free;
 
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

