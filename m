From: akpm@linux-foundation.org
Subject: + pci-x-pci-express-read-control-interfaces-myrinet.patch added to -mm tree
Date: Tue, 15 May 2007 12:38:19 -0700
Message-ID: <200705151938.l4FJcJ7X015905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762283AbXEOTin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oruba@amd.com, brice@myri.com, rolandd@cisco.com, shemminger@linux-foundation.org


The patch titled
     PCI-X/PCI-Express read control interfaces: use them in myrinet
has been added to the -mm tree.  Its filename is
     pci-x-pci-express-read-control-interfaces-myrinet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI-X/PCI-Express read control interfaces: use them in myrinet
From: "Peter Oruba" <peter.oruba@amd.com>

These driver changes incorporate the proposed PCI-X / PCI-Express read byte
count interface.  Reading and setting those valuse doesn't take place
"manually", instead wrapping functions are called to allow quirks for some
PCI bridges.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on work by Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Brice Goglin <brice@myri.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/myri10ge/myri10ge.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/myri10ge/myri10ge.c~pci-x-pci-express-read-control-interfaces-myrinet drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~pci-x-pci-express-read-control-interfaces-myrinet
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -2873,8 +2873,7 @@ static int myri10ge_probe(struct pci_dev
 			status);
 		goto abort_with_netdev;
 	}
-	val = (val & ~PCI_EXP_DEVCTL_READRQ) | (5 << 12);
-	status = pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, val);
+	status = pcie_set_readrq(pdev, 4096);
 	if (status != 0) {
 		dev_err(&pdev->dev, "Error %d writing PCI_EXP_DEVCTL\n",
 			status);
_

Patches currently in -mm which might be from peter.oruba@amd.com are

pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces.patch
pci-x-pci-express-read-control-interfaces-fix.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
