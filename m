From: akpm@linux-foundation.org
Subject: + replace-pci_find_device-in-drivers-telephony-ixjc.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:41:41 -0800
Message-ID: <200703072141.l27LffN5009914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992431AbXCGVln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: surya.prabhakar@wipro.com


The patch titled
     replace pci_find_device in drivers/telephony/ixj.c
has been added to the -mm tree.  Its filename is
     replace-pci_find_device-in-drivers-telephony-ixjc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: replace pci_find_device in drivers/telephony/ixj.c
From: Surya <surya.prabhakar@wipro.com>

Cleaning up of pci_find_device in drivers/telephony/ixj.c.

Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/telephony/ixj.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

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

replace-pci_find_device-in-drivers-telephony-ixjc.patch
