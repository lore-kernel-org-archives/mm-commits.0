From: akpm@linux-foundation.org
Subject: + ahcic-remove-non-existing-sb600-raid-id.patch added to -mm tree
Date: Wed, 11 Apr 2007 15:33:11 -0700
Message-ID: <200704112233.l3BMXBI7016323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304AbXDKWdN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 18:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: conke.hu@gmail.com


The patch titled
     ahci.c: remove non-existing SB600 raid id
has been added to the -mm tree.  Its filename is
     ahcic-remove-non-existing-sb600-raid-id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ahcic-remove-non-existing-sb600-raid-id.patch
