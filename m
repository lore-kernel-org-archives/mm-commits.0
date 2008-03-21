From: akpm@linux-foundation.org
Subject: - memstick-automatically-retrieve-int-value-from-command-response.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:03 -0700
Message-ID: <200803212030.m2LKU3A2008949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758673AbYCUUaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: automatically retrieve "INT" value from command response
has been removed from the -mm tree.  Its filename was
     memstick-automatically-retrieve-int-value-from-command-response.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: automatically retrieve "INT" value from command response
From: Alex Dubov <oakad@yahoo.com>

MemoryStick storage cards, when in parallel mode, send several meaningful bits
of their "INT" register as part of command response.  This data is stored by
host and can be used to spare invocation of "GET_INT" TPC on each data page
transferred between host and card.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |    9 +---
 drivers/memstick/core/mspro_block.c |   15 ++++----
 drivers/memstick/host/jmb38x_ms.c   |   48 ++++++++++++++------------
 drivers/memstick/host/tifm_ms.c     |   17 +++++----
 include/linux/memstick.h            |    1 
 5 files changed, 49 insertions(+), 41 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-automatically-retrieve-int-value-from-command-response drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-automatically-retrieve-int-value-from-command-response
+++ a/drivers/memstick/core/memstick.c
@@ -276,8 +276,6 @@ void memstick_init_req_sg(struct memstic
 		mrq->need_card_int = 1;
 	else
 		mrq->need_card_int = 0;
-
-	mrq->get_int_reg = 0;
 }
 EXPORT_SYMBOL(memstick_init_req_sg);
 
@@ -311,8 +309,6 @@ void memstick_init_req(struct memstick_r
 		mrq->need_card_int = 1;
 	else
 		mrq->need_card_int = 0;
-
-	mrq->get_int_reg = 0;
 }
 EXPORT_SYMBOL(memstick_init_req);
 
@@ -342,6 +338,7 @@ static int h_memstick_read_dev_id(struct
 			card->id.class = id_reg.class;
 		}
 		complete(&card->mrq_complete);
+		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
 		return -EAGAIN;
 	}
 }
@@ -422,7 +419,6 @@ static void memstick_power_on(struct mem
 {
 	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
-	msleep(1);
 }
 
 static void memstick_check(struct work_struct *work)
@@ -579,7 +575,8 @@ EXPORT_SYMBOL(memstick_suspend_host);
 void memstick_resume_host(struct memstick_host *host)
 {
 	mutex_lock(&host->lock);
-	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	if (host->card)
+		memstick_power_on(host);
 	mutex_unlock(&host->lock);
 	memstick_detect_change(host);
 }
diff -puN drivers/memstick/core/mspro_block.c~memstick-automatically-retrieve-int-value-from-command-response drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-automatically-retrieve-int-value-from-command-response
+++ a/drivers/memstick/core/mspro_block.c
@@ -133,6 +133,7 @@ struct mspro_devinfo {
 struct mspro_block_data {
 	struct memstick_dev   *card;
 	unsigned int          usage_count;
+	unsigned int          caps;
 	struct gendisk        *disk;
 	struct request_queue  *queue;
 	spinlock_t            q_lock;
@@ -577,7 +578,6 @@ static int h_mspro_block_wait_for_ced(st
 static int h_mspro_block_transfer_data(struct memstick_dev *card,
 				       struct memstick_request **mrq)
 {
-	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	unsigned char t_val = 0;
 	struct scatterlist t_sg = { 0 };
@@ -591,12 +591,12 @@ static int h_mspro_block_transfer_data(s
 	switch ((*mrq)->tpc) {
 	case MS_TPC_WRITE_REG:
 		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
-		(*mrq)->get_int_reg = 1;
+		(*mrq)->need_card_int = 1;
 		return 0;
 	case MS_TPC_SET_CMD:
 		t_val = (*mrq)->int_reg;
 		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
-		if (host->caps & MEMSTICK_CAP_AUTO_GET_INT)
+		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT)
 			goto has_int_reg;
 		return 0;
 	case MS_TPC_GET_INT:
@@ -646,12 +646,12 @@ has_int_reg:
 					   ? MS_TPC_READ_LONG_DATA
 					   : MS_TPC_WRITE_LONG_DATA,
 				     &t_sg);
-		(*mrq)->get_int_reg = 1;
+		(*mrq)->need_card_int = 1;
 		return 0;
 	case MS_TPC_READ_LONG_DATA:
 	case MS_TPC_WRITE_LONG_DATA:
 		msb->current_page++;
-		if (host->caps & MEMSTICK_CAP_AUTO_GET_INT) {
+		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT) {
 			t_val = (*mrq)->int_reg;
 			goto has_int_reg;
 		} else {
@@ -1052,7 +1052,8 @@ static int mspro_block_init_card(struct 
 	if (memstick_set_rw_addr(card))
 		return -EIO;
 
-	if (host->caps & MEMSTICK_CAP_PAR4) {
+	msb->caps = host->caps;
+	if (msb->caps & MEMSTICK_CAP_PAR4) {
 		if (mspro_block_switch_to_parallel(card))
 			printk(KERN_WARNING "%s: could not switch to "
 			       "parallel interface\n", card->dev.bus_id);
@@ -1062,6 +1063,8 @@ static int mspro_block_init_card(struct 
 	if (rc)
 		return rc;
 	dev_dbg(&card->dev, "card activated\n");
+	if (msb->system != MEMSTICK_SYS_SERIAL)
+		msb->caps |= MEMSTICK_CAP_AUTO_GET_INT;
 
 	card->next_request = h_mspro_block_req_init;
 	msb->mrq_handler = h_mspro_block_get_ro;
diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-automatically-retrieve-int-value-from-command-response drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-automatically-retrieve-int-value-from-command-response
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -57,8 +57,6 @@ struct jmb38x_ms_host {
 	unsigned long           timeout_jiffies;
 	struct timer_list       timer;
 	struct memstick_request *req;
-	unsigned char           eject:1,
-				use_dma:1;
 	unsigned char           cmd_flags;
 	unsigned char           io_pos;
 	unsigned int            io_word[2];
@@ -95,9 +93,22 @@ struct jmb38x_ms {
 #define HOST_CONTROL_IF_PAR4   0x1
 #define HOST_CONTROL_IF_PAR8   0x3
 
+#define STATUS_BUSY             0x00080000
+#define STATUS_MS_DAT7          0x00040000
+#define STATUS_MS_DAT6          0x00020000
+#define STATUS_MS_DAT5          0x00010000
+#define STATUS_MS_DAT4          0x00008000
+#define STATUS_MS_DAT3          0x00004000
+#define STATUS_MS_DAT2          0x00002000
+#define STATUS_MS_DAT1          0x00001000
+#define STATUS_MS_DAT0          0x00000800
 #define STATUS_HAS_MEDIA        0x00000400
 #define STATUS_FIFO_EMPTY       0x00000200
 #define STATUS_FIFO_FULL        0x00000100
+#define STATUS_MS_CED           0x00000080
+#define STATUS_MS_ERR           0x00000040
+#define STATUS_MS_BRQ           0x00000020
+#define STATUS_MS_CNK           0x00000001
 
 #define INT_STATUS_TPC_ERR      0x00080000
 #define INT_STATUS_CRC_ERR      0x00040000
@@ -124,7 +135,7 @@ enum {
 	CMD_READY    = 0x01,
 	FIFO_READY   = 0x02,
 	REG_DATA     = 0x04,
-	AUTO_GET_INT = 0x08
+	DMA_DATA     = 0x08
 };
 
 static unsigned int jmb38x_ms_read_data(struct jmb38x_ms_host *host,
@@ -367,28 +378,27 @@ static int jmb38x_ms_issue_cmd(struct me
 		cmd |= TPC_DIR;
 	if (host->req->need_card_int)
 		cmd |= TPC_WAIT_INT;
-	if (host->req->get_int_reg)
-		cmd |= TPC_GET_INT;
 
 	data = host->req->data;
 
-	host->use_dma = !no_dma;
+	if (!no_dma)
+		host->cmd_flags |= DMA_DATA;
 
 	if (host->req->long_data) {
 		data_len = host->req->sg.length;
 	} else {
 		data_len = host->req->data_len;
-		host->use_dma = 0;
+		host->cmd_flags &= ~DMA_DATA;
 	}
 
 	if (data_len <= 8) {
 		cmd &= ~(TPC_DATA_SEL | 0xf);
 		host->cmd_flags |= REG_DATA;
 		cmd |= data_len & 0xf;
-		host->use_dma = 0;
+		host->cmd_flags &= ~DMA_DATA;
 	}
 
-	if (host->use_dma) {
+	if (host->cmd_flags & DMA_DATA) {
 		if (1 != pci_map_sg(host->chip->pdev, &host->req->sg, 1,
 				    host->req->data_dir == READ
 				    ? PCI_DMA_FROMDEVICE
@@ -451,13 +461,12 @@ static void jmb38x_ms_complete_cmd(struc
 		readl(host->addr + INT_STATUS));
 	dev_dbg(msh->cdev.dev, "c hstatus %08x\n", readl(host->addr + STATUS));
 
-	if (host->req->get_int_reg) {
-		t_val = readl(host->addr + TPC_P0);
-		host->req->int_reg = (t_val & 0xff);
-	}
+	host->req->int_reg = readl(host->addr + STATUS) & 0xff;
+
+	writel(0, host->addr + BLOCK);
+	writel(0, host->addr + DMA_CONTROL);
 
-	if (host->use_dma) {
-		writel(0, host->addr + DMA_CONTROL);
+	if (host->cmd_flags & DMA_DATA) {
 		pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
 			     host->req->data_dir == READ
 			     ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
@@ -509,7 +518,7 @@ static irqreturn_t jmb38x_ms_isr(int irq
 			else
 				host->req->error = -ETIME;
 		} else {
-			if (host->use_dma) {
+			if (host->cmd_flags & DMA_DATA) {
 				if (irq_status & INT_STATUS_EOTRAN)
 					host->cmd_flags |= FIFO_READY;
 			} else {
@@ -775,13 +784,10 @@ static struct memstick_host *jmb38x_ms_a
 	snprintf(host->host_id, DEVICE_ID_SIZE, DRIVER_NAME ":slot%d",
 		 host->id);
 	host->irq = jm->pdev->irq;
-	host->timeout_jiffies = msecs_to_jiffies(4000);
+	host->timeout_jiffies = msecs_to_jiffies(1000);
 	msh->request = jmb38x_ms_request;
 	msh->set_param = jmb38x_ms_set_param;
-	/*
-	msh->caps = MEMSTICK_CAP_AUTO_GET_INT | MEMSTICK_CAP_PAR4
-		    | MEMSTICK_CAP_PAR8;
-	*/
+
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
 	setup_timer(&host->timer, jmb38x_ms_abort, (unsigned long)msh);
diff -puN drivers/memstick/host/tifm_ms.c~memstick-automatically-retrieve-int-value-from-command-response drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c~memstick-automatically-retrieve-int-value-from-command-response
+++ a/drivers/memstick/host/tifm_ms.c
@@ -340,11 +340,20 @@ static void tifm_ms_complete_cmd(struct 
 
 	del_timer(&host->timer);
 
-	if (host->use_dma)
+	host->req->int_reg = readl(sock->addr + SOCK_MS_STATUS) & 0xff;
+	host->req->int_reg = (host->req->int_reg & 1)
+			     | ((host->req->int_reg << 4) & 0xe0);
+
+	writel(TIFM_FIFO_INT_SETALL,
+	       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
+	writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
+
+	if (host->use_dma) {
 		tifm_unmap_sg(sock, &host->req->sg, 1,
 			      host->req->data_dir == READ
 			      ? PCI_DMA_FROMDEVICE
 			      : PCI_DMA_TODEVICE);
+	}
 
 	writel((~TIFM_CTRL_LED) & readl(sock->addr + SOCK_CONTROL),
 	       sock->addr + SOCK_CONTROL);
@@ -424,12 +433,6 @@ static void tifm_ms_card_event(struct ti
 		else if (host_status & TIFM_MS_STAT_CRC)
 			host->req->error = -EILSEQ;
 
-		if (host->req->error) {
-			writel(TIFM_FIFO_INT_SETALL,
-			       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
-			writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
-		}
