From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-mspro-specific-data-transfer-method.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:14:32 -0800
Message-ID: <201012092014.oB9KEWgS004591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812Ab0LIUPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:15:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: add support for MSPro specific data transfer method
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-mspro-specific-data-transfer-method.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add support for MSPro specific data transfer method
From: Alex Dubov <oakad@yahoo.com>

This patch enables faster data transfer to/from MSPro media for enabled hosts
(currently only jmb38x_ms). Other supported hosts and transfer methods (HG,
XC) to follow.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   63 +++++++++++++++++++++++---
 drivers/memstick/host/jmb38x_ms.c   |    2 
 include/linux/memstick.h            |    7 ++
 3 files changed, 64 insertions(+), 8 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-add-support-for-mspro-specific-data-transfer-method drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-add-support-for-mspro-specific-data-transfer-method
+++ a/drivers/memstick/core/mspro_block.c
@@ -588,12 +588,10 @@ static int h_mspro_block_transfer_data(s
 		return mspro_block_complete_req(card, (*mrq)->error);
 
 	switch ((*mrq)->tpc) {
-	case MS_TPC_WRITE_REG:
-		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
-		(*mrq)->need_card_int = 1;
-		return 0;
+	case MS_TPC_EX_SET_CMD:
 	case MS_TPC_SET_CMD:
 		t_val = (*mrq)->int_reg;
+		msb->mrq_handler = h_mspro_block_transfer_data;
 		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
 		if (msb->caps & MEMSTICK_CAP_AUTO_GET_INT)
 			goto has_int_reg;
@@ -663,6 +661,20 @@ has_int_reg:
 	}
 }
 
+static int h_mspro_block_invoke_cmd(struct memstick_dev *card,
+				    struct memstick_request **mrq)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+
+	if ((*mrq)->error)
+		return mspro_block_complete_req(card, (*mrq)->error);
+
+	card->next_request = h_mspro_block_transfer_data;
+	memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
+	(*mrq)->need_card_int = 1;
+	return 0;
+}
+
 /*** Transfer setup functions for different access methods. ***/
 
 /** Setup data transfer request for SET_CMD TPC with arguments in card
@@ -688,11 +700,37 @@ static void h_mspro_block_setup_cmd(stru
 	param.data_address = cpu_to_be32((uint32_t)offset);
 
 	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_transfer_data;
+	msb->mrq_handler = h_mspro_block_invoke_cmd;
 	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
 			  &param, sizeof(param));
 }
 
+/** Setup data transfer request for EX_SET_CMD TPC with arguments in TPC packet.
+ *
+ *  @card    Current media instance
+ *  @offset  Target data offset in bytes
+ *  @length  Required transfer length in bytes.
+ */
+static void h_mspro_block_ex_setup_cmd(struct memstick_dev *card, u64 offset,
+				       size_t length)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_ex_cmd_param param = {
+		.command = msb->transfer_cmd,
+		.data_count = cpu_to_be16((uint16_t)(length / msb->page_size)),
+		/* ISO C90 warning precludes direct initialization for now. */
+		.data_address = 0
+	};
+
+	do_div(offset, msb->page_size);
+	param.data_address = cpu_to_be32((uint32_t)offset);
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_transfer_data;
+	memstick_init_req(&card->current_mrq, MS_TPC_EX_SET_CMD,
+			  &param, sizeof(param));
+}
+
 /*** Data transfer ***/
 
 static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
@@ -718,13 +756,12 @@ try_again:
 		t_off <<= 9;
 		count = blk_rq_bytes(msb->block_req);
 
-		msb->setup_transfer(card, t_off, count);
-
 		msb->data_dir = rq_data_dir(msb->block_req);
 		msb->transfer_cmd = msb->data_dir == READ
 				    ? MSPRO_CMD_READ_DATA
 				    : MSPRO_CMD_WRITE_DATA;
 
+		msb->setup_transfer(card, t_off, count);
 		memstick_new_req(card->host);
 		return 0;
 	}
@@ -1170,6 +1207,18 @@ static int mspro_block_init_card(struct 
 	dev_dbg(&card->dev, "card r/w status %d\n", msb->read_only ? 0 : 1);
 
 	msb->page_size = 512;
+
+	/* All MSPro media devices are expected to support extended command
+	 * transfer mode. Faulty or old adapters may chose not to advertise
+	 * this capability and rely on somewhat slower default mode.
+	 *
+	 * Even more advanced HG and XC modes of operation, when implemented,
+	 * will have to be selected after media attribute parsing, to ensure
+	 * full compatibility.
+	 */
+	if (msb->caps & MEMSTICK_CAP_EX_CMD)
+		msb->setup_transfer = h_mspro_block_ex_setup_cmd;
+
 	rc = mspro_block_read_attributes(card);
 	if (rc)
 		return rc;
diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-add-support-for-mspro-specific-data-transfer-method drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-add-support-for-mspro-specific-data-transfer-method
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -894,7 +894,7 @@ static struct memstick_host *jmb38x_ms_a
 	msh->request = jmb38x_ms_submit_req;
 	msh->set_param = jmb38x_ms_set_param;
 
-	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
+	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8 | MEMSTICK_CAP_EX_CMD;
 
 	setup_timer(&host->timer, jmb38x_ms_abort, (unsigned long)msh);
 
diff -puN include/linux/memstick.h~memstick-add-support-for-mspro-specific-data-transfer-method include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-add-support-for-mspro-specific-data-transfer-method
+++ a/include/linux/memstick.h
@@ -105,6 +105,12 @@ struct mspro_param_register {
 	unsigned char  tpc_param;
 } __attribute__((packed));
 
+struct mspro_ex_cmd_param {
+	unsigned char command;
+	__be16        data_count;
+	__be32        data_address;
+} __packed;
+
 struct mspro_io_info_register {
 	unsigned char version;
 	unsigned char io_category;
@@ -279,6 +285,7 @@ struct memstick_host {
 #define MEMSTICK_CAP_AUTO_GET_INT  1
 #define MEMSTICK_CAP_PAR4          2
 #define MEMSTICK_CAP_PAR8          4
+#define MEMSTICK_CAP_EX_CMD        8
 
 	struct work_struct  media_checker;
 	struct device       dev;
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-core-fix-device_register-error-handling.patch
memstick-fix-setup-for-jmicron-38x-controllers.patch
memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch
memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch
memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch
memstick-remove-mspro_block_mutex.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch

