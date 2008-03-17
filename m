From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-8-bit-parallel-mode.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:23:24 -0700
Message-ID: <200803172323.m2HNNO55003573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbYCQXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: add support for 8-bit parallel mode
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-8-bit-parallel-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: add support for 8-bit parallel mode
From: Alex Dubov <oakad@yahoo.com>

Newer MemoryStick (HG) cards and hosts support 8-bit parallel mode of
operation in addition to original 4-bit and 1-bit modes.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   81 +++++++++++++++++---------
 1 file changed, 55 insertions(+), 26 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-add-support-for-8-bit-parallel-mode drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-add-support-for-8-bit-parallel-mode
+++ a/drivers/memstick/core/mspro_block.c
@@ -816,12 +816,13 @@ static int mspro_block_wait_for_ced(stru
 	return card->current_mrq.error;
 }
 
-static int mspro_block_switch_to_parallel(struct memstick_dev *card)
+static int mspro_block_set_interface(struct memstick_dev *card,
+				     unsigned char sys_reg)
 {
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct mspro_param_register param = {
-		.system = MEMSTICK_SYS_PAR4,
+		.system = sys_reg,
 		.data_count = 0,
 		.data_address = 0,
 		.tpc_param = 0
@@ -833,41 +834,70 @@ static int mspro_block_switch_to_paralle
 			  sizeof(param));
 	memstick_new_req(host);
 	wait_for_completion(&card->mrq_complete);
-	if (card->current_mrq.error)
-		return card->current_mrq.error;
+	return card->current_mrq.error;
+}
+
+static int mspro_block_switch_interface(struct memstick_dev *card)
+{
+	struct memstick_host *host = card->host;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int rc = 0;
+
+	if (msb->caps & MEMSTICK_CAP_PAR4)
+		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR4);
+	else
+		return 0;
+
+	if (rc) {
+		printk(KERN_WARNING
+		       "%s: could not switch to 4-bit mode, error %d\n",
+		       card->dev.bus_id, rc);
+		return 0;
+	}
 
 	msb->system = MEMSTICK_SYS_PAR4;
 	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
+	printk(KERN_INFO "%s: switching to 4-bit parallel mode\n",
+	       card->dev.bus_id);
+
+	if (msb->caps & MEMSTICK_CAP_PAR8) {
+		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR8);
+
+		if (!rc) {
+			msb->system = MEMSTICK_SYS_PAR8;
+			host->set_param(host, MEMSTICK_INTERFACE,
+					MEMSTICK_PAR8);
+			printk(KERN_INFO
+			       "%s: switching to 8-bit parallel mode\n",
+			       card->dev.bus_id);
+		} else
+			printk(KERN_WARNING
+			       "%s: could not switch to 8-bit mode, error %d\n",
+			       card->dev.bus_id, rc);
+	}
 
 	card->next_request = h_mspro_block_req_init;
 	msb->mrq_handler = h_mspro_block_default;
 	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
 	memstick_new_req(card->host);
 	wait_for_completion(&card->mrq_complete);
+	rc = card->current_mrq.error;
 
-	if (card->current_mrq.error) {
+	if (rc) {
+		printk(KERN_WARNING
+		       "%s: interface error, trying to fall back to serial\n",
+		       card->dev.bus_id);
 		msb->system = MEMSTICK_SYS_SERIAL;
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-		msleep(1000);
+		msleep(10);
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
 
-		if (memstick_set_rw_addr(card))
-			return card->current_mrq.error;
-
-		param.system = msb->system;
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_default;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-				  sizeof(param));
-		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
-
-		return -EFAULT;
+		rc = memstick_set_rw_addr(card);
+		if (!rc)
+			rc = mspro_block_set_interface(card, msb->system);
 	}
-
-	return 0;
+	return rc;
 }
 
 /* Memory allocated for attributes by this function should be freed by
@@ -1053,12 +1083,11 @@ static int mspro_block_init_card(struct 
 		return -EIO;
 
 	msb->caps = host->caps;
-	if (msb->caps & MEMSTICK_CAP_PAR4) {
-		if (mspro_block_switch_to_parallel(card))
-			printk(KERN_WARNING "%s: could not switch to "
-			       "parallel interface\n", card->dev.bus_id);
-	}
+	rc = mspro_block_switch_interface(card);
+	if (rc)
+		return rc;
 
+	msleep(200);
 	rc = mspro_block_wait_for_ced(card);
 	if (rc)
 		return rc;
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-automatically-retrieve-int-value-from-command-response.patch
memstick-add-support-for-8-bit-parallel-mode.patch
memstick-optimize-setup-of-jmicron-host-parameters.patch

