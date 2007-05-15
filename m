From: akpm@linux-foundation.org
Subject: + oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch added to -mm tree
Date: Mon, 14 May 2007 18:13:03 -0700
Message-ID: <200705150113.l4F1D5Fx030852@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676AbXEOBNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 21:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com


The patch titled
     OSS trident: replace deprecated pci_find_device with pci_get_device
has been added to the -mm tree.  Its filename is
     oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OSS trident: replace deprecated pci_find_device with pci_get_device
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff -puN sound/oss/trident.c~oss-trident-replace-deprecated-pci_find_device-with-pci_get_device sound/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-replace-deprecated-pci_find_device-with-pci_get_device
+++ a/sound/oss/trident.c
@@ -4454,9 +4454,9 @@ trident_probe(struct pci_dev *pci_dev, c
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl = 0;
-		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL,
-						PCI_DEVICE_ID_AL_M1533,
-						pci_dev_m1533);
+		pci_dev_m1533 = pci_get_device(PCI_VENDOR_ID_AL,
+					       PCI_DEVICE_ID_AL_M1533,
+					       pci_dev_m1533);
 		rc = -ENODEV;
 		if (pci_dev_m1533 == NULL)
 			goto out_proc_fs;
@@ -4470,6 +4470,8 @@ trident_probe(struct pci_dev *pci_dev, c
 			bits &= 0xbf;	/*clear bit 6 */
 			pci_write_config_byte(pci_dev_m1533, 0x7b, bits);
 		}
+		pci_dev_put(pci_dev_m1533);
+
 	} else if (card->pci_id == PCI_DEVICE_ID_INTERG_5050) {
 		card->alloc_pcm_channel = cyber_alloc_pcm_channel;
 		card->alloc_rec_pcm_channel = cyber_alloc_pcm_channel;
_

Patches currently in -mm which might be from muli@il.ibm.com are

git-pciseg.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
