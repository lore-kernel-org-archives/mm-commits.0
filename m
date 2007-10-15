From: akpm@linux-foundation.org
Subject: + tehuti-possible-leak-in-bdx_probe.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:50:59 -0700
Message-ID: <200710152250.l9FMoxsd029354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbXJOWvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fmalita@gmail.com, andy@greyhouse.net, baum@tehutinetworks.net


The patch titled
     tehuti: possible leak in bdx_probe
has been added to the -mm tree.  Its filename is
     tehuti-possible-leak-in-bdx_probe.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tehuti: possible leak in bdx_probe
From: Florin Malita <fmalita@gmail.com>

If pci_enable_device fails, bdx_probe returns without freeing the
allocated pci_nic structure.

Coverity CID 1908.

Signed-off-by: Florin Malita <fmalita@gmail.com>
Acked-by: Alexander Indenbaum <baum@tehutinetworks.net>
Acked-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tehuti.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/tehuti.c~tehuti-possible-leak-in-bdx_probe drivers/net/tehuti.c
--- a/drivers/net/tehuti.c~tehuti-possible-leak-in-bdx_probe
+++ a/drivers/net/tehuti.c
@@ -1906,7 +1906,7 @@ bdx_probe(struct pci_dev *pdev, const st
 
     /************** pci *****************/
 	if ((err = pci_enable_device(pdev)))	/* it trigers interrupt, dunno why. */
-		RET(err);			/* it's not a problem though */
+		goto err_pci;			/* it's not a problem though */
 
 	if (!(err = pci_set_dma_mask(pdev, DMA_64BIT_MASK)) &&
 	    !(err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))) {
@@ -2076,6 +2076,7 @@ err_out_res:
 	pci_release_regions(pdev);
 err_dma:
 	pci_disable_device(pdev);
+err_pci:
 	vfree(nic);
 
 	RET(err);
_

Patches currently in -mm which might be from fmalita@gmail.com are

origin.patch
tehuti-possible-leak-in-bdx_probe.patch
