From: akpm@linux-foundation.org
Subject: +
 drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 15:33:22 -0800
Message-ID: <528fe9c2.v+sGApKScv3US6bE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3KVXdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 18:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sameo@linux.intel.com, oakad@yahoo.com, maximlevitsky@gmail.com, micky_ching@realsil.com.cn

Subject: + drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch added to -mm tree
To: micky_ching@realsil.com.cn,maximlevitsky@gmail.com,oakad@yahoo.com,sameo@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 15:33:22 -0800


The patch titled
     Subject: drivers/memstick/host/rtsx_pci_ms.c: fix ms card data transfer bug
has been added to the -mm tree.  Its filename is
     drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Micky Ching <micky_ching@realsil.com.cn>
Subject: drivers/memstick/host/rtsx_pci_ms.c: fix ms card data transfer bug

This patch is used to add support for ms card. The main difference
between ms card and mspro card is long data transfer mode. mspro card
can use auto mode DMA for long data transfer, but ms can not use this
mode, it should use normal mode DMA.

The memstick core add support for ms card, but the original driver will
make ms card fail at initialize, because it use auto mode DMA. This
patch can make ms card work properly.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/rtsx_pci_ms.c |   30 +++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -puN drivers/memstick/host/rtsx_pci_ms.c~drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug drivers/memstick/host/rtsx_pci_ms.c
--- a/drivers/memstick/host/rtsx_pci_ms.c~drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug
+++ a/drivers/memstick/host/rtsx_pci_ms.c
@@ -145,6 +145,8 @@ static int ms_transfer_data(struct realt
 	unsigned int length = sg->length;
 	u16 sec_cnt = (u16)(length / 512);
 	u8 val, trans_mode, dma_dir;
+	struct memstick_dev *card = host->msh->card;
+	bool pro_card = card->id.type == MEMSTICK_TYPE_PRO;
 
 	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x, data_dir = %s, length = %d\n",
 			__func__, tpc, (data_dir == READ) ? "READ" : "WRITE",
@@ -152,19 +154,21 @@ static int ms_transfer_data(struct realt
 
 	if (data_dir == READ) {
 		dma_dir = DMA_DIR_FROM_CARD;
-		trans_mode = MS_TM_AUTO_READ;
+		trans_mode = pro_card ? MS_TM_AUTO_READ : MS_TM_NORMAL_READ;
 	} else {
 		dma_dir = DMA_DIR_TO_CARD;
-		trans_mode = MS_TM_AUTO_WRITE;
+		trans_mode = pro_card ? MS_TM_AUTO_WRITE : MS_TM_NORMAL_WRITE;
 	}
 
 	rtsx_pci_init_cmd(pcr);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_H,
-			0xFF, (u8)(sec_cnt >> 8));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_L,
-			0xFF, (u8)sec_cnt);
+	if (pro_card) {
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_H,
+				0xFF, (u8)(sec_cnt >> 8));
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_L,
+				0xFF, (u8)sec_cnt);
+	}
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
@@ -192,8 +196,14 @@ static int ms_transfer_data(struct realt
 	}
 
 	rtsx_pci_read_register(pcr, MS_TRANS_CFG, &val);
-	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT))
-		return -EIO;
+	if (pro_card) {
+		if (val & (MS_INT_CMDNK | MS_INT_ERR |
+				MS_CRC16_ERR | MS_RDY_TIMEOUT))
+			return -EIO;
+	} else {
+		if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT))
+			return -EIO;
+	}
 
 	return 0;
 }
@@ -462,8 +472,8 @@ static int rtsx_pci_ms_set_param(struct
 			clock = 19000000;
 			ssc_depth = RTSX_SSC_DEPTH_500K;
 
-			err = rtsx_pci_write_register(pcr, MS_CFG,
-					0x18, MS_BUS_WIDTH_1);
+			err = rtsx_pci_write_register(pcr, MS_CFG, 0x58,
+					MS_BUS_WIDTH_1 | PUSH_TIME_DEFAULT);
 			if (err < 0)
 				return err;
 		} else if (value == MEMSTICK_PAR4) {
_

Patches currently in -mm which might be from micky_ching@realsil.com.cn are

drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch

