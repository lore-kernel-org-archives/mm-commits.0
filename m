From: akpm@linux-foundation.org
Subject: - ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:22 -0700
Message-ID: <200707201942.l6KJgM3A013082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763668AbXGTTmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henry.su@amd.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ata: add more device IDs for supporting ATI SB700 SATA controller completely 
has been removed from the -mm tree.  Its filename was
     ata-add-more-device-ids-for-supporting-ati-sb700-sata-controller-completely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
