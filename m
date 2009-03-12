From: akpm@linux-foundation.org
Subject: + cciss-resubmit-kernel-scan-thread-for-msa2012.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:47:14 -0700
Message-ID: <200903122247.n2CMlEIc013594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbZCLWsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com


The patch titled
     cciss: kernel scan thread for MSA2012
has been added to the -mm tree.  Its filename is
     cciss-resubmit-kernel-scan-thread-for-msa2012.patch

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
Subject: cciss: kernel scan thread for MSA2012
From: Mike Miller <mike.miller@hp.com>

The MSA2012 cannot inform the driver of configuration changes since all
management is out of band.  This is a departure from any storage we have
supported in the past.  We need some way to detect changes on the topology
so we implement this kernel thread.  In some instances there's nothing we
can do from the driver (like LUN failure) so just print out a message.  In
the case where logical volumes are added or deleted we call
rebuild_lun_table to refresh the driver's view of the world.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c     |   88 +++++++++++++++++++++++++++++++++++-
 drivers/block/cciss.h     |    2 
 drivers/block/cciss_cmd.h |   23 +++++++++
 3 files changed, 111 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-resubmit-kernel-scan-thread-for-msa2012 drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-resubmit-kernel-scan-thread-for-msa2012
+++ a/drivers/block/cciss.c
@@ -51,6 +51,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
+#include <linux/kthread.h>
 
 #define CCISS_DRIVER_VERSION(maj,min,submin) ((maj<<16)|(min<<8)|(submin))
 #define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
@@ -186,6 +187,8 @@ static int sendcmd_withirq(__u8 cmd, int
 			   __u8 page_code, int cmd_type);
 
 static void fail_all_cmds(unsigned long ctlr);
+static int scan_thread(void *data);
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -735,6 +738,12 @@ static int cciss_getgeo(struct block_dev
 	return 0;
 }
 
+static void check_ioctl_unit_attention(ctlr_info_t *host, CommandList_struct *c)
+{
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
+		(void)check_for_unit_attention(host, c);
+}
 /*
  * ioctl
  */
@@ -1029,6 +1038,8 @@ static int cciss_ioctl(struct block_devi
 					 iocommand.buf_size,
 					 PCI_DMA_BIDIRECTIONAL);
 
+			check_ioctl_unit_attention(host, c);
+
 			/* Copy the error information out */
 			iocommand.error_info = *(c->err_info);
 			if (copy_to_user
@@ -1180,6 +1191,7 @@ static int cciss_ioctl(struct block_devi
 					(dma_addr_t) temp64.val, buff_size[i],
 					PCI_DMA_BIDIRECTIONAL);
 			}
+			check_ioctl_unit_attention(host, c);
 			/* Copy the error information out */
 			ioc->error_info = *(c->err_info);
 			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2585,12 +2597,14 @@ static inline unsigned int make_status_b
 		((driver_byte & 0xff) << 24);
 }
 
-static inline int evaluate_target_status(CommandList_struct *cmd)
+static inline int evaluate_target_status(ctlr_info_t *h,
+			CommandList_struct *cmd, int *retry_cmd)
 {
 	unsigned char sense_key;
 	unsigned char status_byte, msg_byte, host_byte, driver_byte;
 	int error_value;
 
+	*retry_cmd = 0;
 	/* If we get in here, it means we got "target status", that is, scsi status */
 	status_byte = cmd->err_info->ScsiStatus;
 	driver_byte = DRIVER_OK;
@@ -2618,6 +2632,11 @@ static inline int evaluate_target_status
 	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
 		error_value = 0;
 
+	if (check_for_unit_attention(h, cmd)) {
+		*retry_cmd = !blk_pc_request(cmd->rq);
+		return 0;
+	}
+
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
 		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
@@ -2657,7 +2676,7 @@ static inline void complete_command(ctlr
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		rq->errors = evaluate_target_status(cmd);
+		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (blk_fs_request(cmd->rq)) {
@@ -3008,6 +3027,63 @@ static irqreturn_t do_cciss_intr(int irq
 	return IRQ_HANDLED;
 }
 
+static int scan_thread(void *data)
+{
+	ctlr_info_t *h = data;
+	int rc;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	h->rescan_wait = &wait;
+
+	for (;;) {
+		rc = wait_for_completion_interruptible(&wait);
+		if (kthread_should_stop())
+			break;
+		if (!rc)
+			rebuild_lun_table(h, 0);
+	}
+	return 0;
+}
+
+static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
+{
+	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+		return 0;
+
+	switch (c->err_info->SenseInfo[12]) {
+	case STATE_CHANGED:
+		printk(KERN_WARNING "cciss%d: a state change "
+			"detected, command retried\n", h->ctlr);
+		return 1;
+	break;
+	case LUN_FAILED:
+		printk(KERN_WARNING "cciss%d: LUN failure "
+			"detected, action required\n", h->ctlr);
+		return 1;
+	break;
+	case REPORT_LUNS_CHANGED:
+		printk(KERN_WARNING "cciss%d: report LUN data "
+			"changed\n", h->ctlr);
+		if (h->rescan_wait)
+			complete(h->rescan_wait);
+		return 1;
+	break;
+	case POWER_OR_RESET:
+		printk(KERN_WARNING "cciss%d: a power on "
+			"or device reset detected\n", h->ctlr);
+		return 1;
+	break;
+	case UNIT_ATTENTION_CLEARED:
+		printk(KERN_WARNING "cciss%d: unit attention "
+		    "cleared by another initiator\n", h->ctlr);
+		return 1;
+	break;
+	default:
+		printk(KERN_WARNING "cciss%d: unknown "
+			"unit attention detected\n", h->ctlr);
+				return 1;
+	}
+}
+
 /*
  *  We cannot read the structure directly, for portability we must use
  *   the io functions.
@@ -3753,6 +3829,11 @@ static int __devinit cciss_init_one(stru
 	hba[i]->busy_initializing = 0;
 
 	rebuild_lun_table(hba[i], 1);
+	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
+				"cciss_scan%02d", i);
+	if (IS_ERR(hba[i]->cciss_scan_thread))
+		return PTR_ERR(hba[i]->cciss_scan_thread);
+
 	return 1;
 
 clean4:
@@ -3828,6 +3909,7 @@ static void __devexit cciss_remove_one(s
 		printk(KERN_ERR "cciss: Unable to remove device \n");
 		return;
 	}
+
 	tmp_ptr = pci_get_drvdata(pdev);
 	i = tmp_ptr->ctlr;
 	if (hba[i] == NULL) {
@@ -3836,6 +3918,8 @@ static void __devexit cciss_remove_one(s
 		return;
 	}
 
+	kthread_stop(hba[i]->cciss_scan_thread);
+
 	remove_proc_entry(hba[i]->devname, proc_cciss);
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 
diff -puN drivers/block/cciss.h~cciss-resubmit-kernel-scan-thread-for-msa2012 drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-resubmit-kernel-scan-thread-for-msa2012
+++ a/drivers/block/cciss.h
@@ -121,6 +121,8 @@ struct ctlr_info 
 	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
+	struct completion *rescan_wait;
+	struct task_struct *cciss_scan_thread;
 };
 
 /*  Defining the diffent access_menthods */
diff -puN drivers/block/cciss_cmd.h~cciss-resubmit-kernel-scan-thread-for-msa2012 drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-resubmit-kernel-scan-thread-for-msa2012
+++ a/drivers/block/cciss_cmd.h
@@ -25,6 +25,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 //transfer direction
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-resubmit-kernel-scan-thread-for-msa2012.patch
cciss-change-to-discover-first-memory-bar.patch

