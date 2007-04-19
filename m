From: akpm@linux-foundation.org
Subject: - ahcic-remove-non-existing-sb600-raid-id.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:32 -0700
Message-ID: <200704192002.l3JK2Wn2029394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766997AbXDSUCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: conke.hu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci.c: remove non-existing SB600 raid id
has been removed from the -mm tree.  Its filename was
     ahcic-remove-non-existing-sb600-raid-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ahci.c: remove non-existing SB600 raid id
From: "Conke Hu" <conke.hu@gmail.com>

SB600 RAID and SB600 SATA is the same controller and share the same PCI ID
0x4380.  There is no such PCI ID 0x4381.

Signed-off-by: Conke Hu <conke.hu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c      |    3 +--
 include/linux/pci_ids.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/ata/ahci.c~ahcic-remove-non-existing-sb600-raid-id drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahcic-remove-non-existing-sb600-raid-id
+++ a/drivers/ata/ahci.c
@@ -413,8 +413,7 @@ static const struct pci_device_id ahci_p
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
 
 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
-	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
diff -puN include/linux/pci_ids.h~ahcic-remove-non-existing-sb600-raid-id include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~ahcic-remove-non-existing-sb600-raid-id
+++ a/include/linux/pci_ids.h
@@ -368,7 +368,6 @@
 #define PCI_DEVICE_ID_ATI_IXP400_SATA   0x4379
 #define PCI_DEVICE_ID_ATI_IXP400_SATA2	0x437a
 #define PCI_DEVICE_ID_ATI_IXP600_SATA	0x4380
-#define PCI_DEVICE_ID_ATI_IXP600_SRAID	0x4381
 #define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
 
_

Patches currently in -mm which might be from conke.hu@gmail.com are

git-libata-all.patch
