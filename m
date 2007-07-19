From: akpm@linux-foundation.org
Subject: + ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:46:44 -0700
Message-ID: <200707192346.l6JNkiYp029085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934889AbXGSXrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henry.su@amd.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     ata: add more device IDs for supporting ATI SB700 SATA controller completely 
has been added to the -mm tree.  Its filename is
     ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ata: add more device IDs for supporting ATI SB700 SATA controller completely 
From: "Henry Su" <henry.su@amd.com>

The sata controller device ID will be different according to the onchip
 sata type setting in system BIOS:

Device                                              Device ID
SATA in IDE mode                                     0x4390
SATA in AHCI mode                                    0x4391
SATA in RAID mode with non-Raid 5 driver             0x4392
SATA in RAID mode with Raid 5 driver                 0x4393

Signed-off-by: "Henry Su" <henry.su@amd.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/ata/ahci.c~ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely
+++ a/drivers/ata/ahci.c
@@ -417,7 +417,10 @@ static const struct pci_device_id ahci_p
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 IDE */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700 AHCI */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700 nor-raid5 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700 raid5 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
_

Patches currently in -mm which might be from henry.su@amd.com are

origin.patch
ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely.patch
