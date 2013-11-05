From: akpm@linux-foundation.org
Subject: +
 drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch
 added to -mm tree
Date: Tue, 05 Nov 2013 13:11:16 -0800
Message-ID: <52795ef4.iBZ/Tb3lWKUgsNle%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3KEVLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 16:11:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maximlevitsky@gmail.com, micky_ching@realsil.com.cn

Subject: + drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug.patch added to -mm tree
To: micky_ching@realsil.com.cn,maximlevitsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 13:11:16 -0800


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

Unlike mspro card, ms card use normal read/write mode for DMA data
transfer.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/rtsx_pci_ms.c |   87 ++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 6 deletions(-)

diff -puN drivers/memstick/host/rtsx_pci_ms.c~drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug drivers/memstick/host/rtsx_pci_ms.c
--- a/drivers/memstick/host/rtsx_pci_ms.c~drivers-memstick-host-rtsx_pci_msc-fix-ms-card-data-transfer-bug
+++ a/drivers/memstick/host/rtsx_pci_ms.c
@@ -137,8 +137,9 @@ static int ms_power_off(struct realtek_p
 	return rtsx_pci_card_pull_ctl_disable(pcr, RTSX_MS_CARD);
 }
 
-static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
-		u8 tpc, u8 cfg, struct scatterlist *sg)
+static int mspro_transfer_data(struct realtek_pci_ms *host,
+			unsigned char data_dir, u8 tpc, u8 cfg,
+			struct scatterlist *sg)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
@@ -198,6 +199,77 @@ static int ms_transfer_data(struct realt
 	return 0;
 }
 
+static int ms_transfer_data(struct realtek_pci_ms *host,
+			unsigned char data_dir, u8 tpc, u8 cfg,
+			struct scatterlist *sg)
+{
+	struct rtsx_pcr *pcr = host->pcr;
+	int err;
+	unsigned int length = sg->length;
+	u8 val, trans_mode, dma_dir;
+	struct completion trans_done;
+	int timeleft;
+
+	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x, data_dir = %s, length = %d\n",
+			__func__, tpc, (data_dir == READ) ? "READ" : "WRITE",
+			length);
+
+	if (data_dir == READ) {
+		dma_dir = DMA_DIR_FROM_CARD;
+		trans_mode = MS_TM_NORMAL_READ;
+	} else {
+		dma_dir = DMA_DIR_TO_CARD;
+		trans_mode = MS_TM_NORMAL_WRITE;
+	}
+
+	rtsx_pci_init_cmd(pcr);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
+			DMA_DONE_INT, DMA_DONE_INT);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC3, 0xFF, (u8)(length >> 24));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC2, 0xFF, (u8)(length >> 16));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC1, 0xFF, (u8)(length >> 8));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC0, 0xFF, (u8)length);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
+			0x03 | DMA_PACK_SIZE_MASK, dma_dir | DMA_EN | DMA_512);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
+			0x01, RING_BUFFER);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANSFER,
+			0xFF, MS_TRANSFER_START | trans_mode);
+	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, MS_TRANSFER,
+			MS_TRANSFER_END, MS_TRANSFER_END);
+
+	rtsx_pci_send_cmd_no_wait(pcr);
+
+	err = rtsx_pci_transfer_data(pcr, sg, 1, data_dir == READ, 10000);
+	if (err < 0) {
+		ms_print_debug_regs(host);
+		ms_clear_error(host);
+		return err;
+	}
+
+	if (pcr->trans_result == TRANS_NOT_READY) {
+		init_completion(&trans_done);
+		timeleft = wait_for_completion_interruptible_timeout(
+			&trans_done, 1000);
+		if (timeleft < 0) {
+			dev_dbg(ms_dev(host),
+				"%s: timeout wait for ok interrupt.\n",
+				__func__);
+			return -ETIMEDOUT;
+		}
+	}
+	rtsx_pci_read_register(pcr, MS_TRANS_CFG, &val);
+	if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT))
+		return -EIO;
+
+	return 0;
+}
+
 static int ms_write_bytes(struct realtek_pci_ms *host, u8 tpc,
 		u8 cfg, u8 cnt, u8 *data, u8 *int_reg)
 {
@@ -340,6 +412,7 @@ static int ms_read_bytes(struct realtek_
 static int rtsx_pci_ms_issue_cmd(struct realtek_pci_ms *host)
 {
 	struct memstick_request *req = host->req;
+	struct memstick_dev *card = host->msh->card;
 	int err = 0;
 	u8 cfg = 0, int_reg;
 
@@ -350,9 +423,12 @@ static int rtsx_pci_ms_issue_cmd(struct
 			cfg = WAIT_INT;
 	}
 
-	if (req->long_data) {
+	if (req->long_data && card->id.type != MEMSTICK_TYPE_PRO) {
 		err = ms_transfer_data(host, req->data_dir,
 				req->tpc, cfg, &(req->sg));
+	} else if (req->long_data) {
+		err = mspro_transfer_data(host, req->data_dir,
+				req->tpc, cfg, &(req->sg));
 	} else {
 		if (req->data_dir == READ) {
 			err = ms_read_bytes(host, req->tpc, cfg,
@@ -461,9 +537,8 @@ static int rtsx_pci_ms_set_param(struct
 		if (value == MEMSTICK_SERIAL) {
 			clock = 19000000;
 			ssc_depth = RTSX_SSC_DEPTH_500K;
