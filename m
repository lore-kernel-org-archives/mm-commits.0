From: akpm@linux-foundation.org
Subject: - replace-pci_find_device-in-drivers-telephony-ixjc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:13 -0700
Message-ID: <200705090246.l492kDAb008823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031757AbXEICqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: surya.prabhakar@wipro.com, mm-commits@vger.kernel.org


The patch titled
     replace pci_find_device in drivers/telephony/ixj.c
has been removed from the -mm tree.  Its filename was
     replace-pci_find_device-in-drivers-telephony-ixjc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: replace pci_find_device in drivers/telephony/ixj.c
From: Surya <surya.prabhakar@wipro.com>

Cleaning up of pci_find_device in drivers/telephony/ixj.c.

Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/ixj.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/telephony/ixj.c~replace-pci_find_device-in-drivers-telephony-ixjc drivers/telephony/ixj.c
--- a/drivers/telephony/ixj.c~replace-pci_find_device-in-drivers-telephony-ixjc
+++ a/drivers/telephony/ixj.c
@@ -7692,7 +7692,7 @@ static int __init ixj_probe_pci(int *cnt
 	IXJ *j = NULL;
 
 	for (i = 0; i < IXJMAX - *cnt; i++) {
-		pci = pci_find_device(PCI_VENDOR_ID_QUICKNET,
+		pci = pci_get_device(PCI_VENDOR_ID_QUICKNET,
 				      PCI_DEVICE_ID_QUICKNET_XJ, pci);
 		if (!pci)
 			break;
@@ -7712,6 +7712,7 @@ static int __init ixj_probe_pci(int *cnt
 			printk(KERN_INFO "ixj: found Internet PhoneJACK PCI at 0x%x\n", j->DSPbase);
 		++*cnt;
 	}
+	pci_dev_put(pci);
 	return probe;
 }
 
_

Patches currently in -mm which might be from surya.prabhakar@wipro.com are

origin.patch
