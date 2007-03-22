From: akpm@linux-foundation.org
Subject: + optional-led-trigger-for-libata.patch added to -mm tree
Date: Thu, 22 Mar 2007 13:49:37 -0700
Message-ID: <200703222049.l2MKnb6X030033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238AbXCVUtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chainsaw@gentoo.org, htejun@gmail.com, jeff@garzik.org


The patch titled
     Optional LED trigger for libata
has been added to the -mm tree.  Its filename is
     optional-led-trigger-for-libata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Optional LED trigger for libata
From: Tony Vroon <chainsaw@gentoo.org>

This adds an optional wrapper around ata_ac_issue_prot that triggers the
LED layer.  This is used for the PMU LED on G5 towers (IDE trigger).  My
test platform is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2
(sata_svw) controller.  Now respun as a single patch, and the function name
shortened as requested.

Signed-off-by: Tony Vroon <chainsaw@gentoo.org>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   21 +++++++++++++++++++++
 drivers/ata/sata_svw.c    |    2 +-
 include/linux/libata.h    |    1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/ata/libata-core.c~optional-led-trigger-for-libata drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~optional-led-trigger-for-libata
+++ a/drivers/ata/libata-core.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
 #include <linux/scatterlist.h>
+#include <linux/leds.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -5186,6 +5187,25 @@ unsigned int ata_qc_issue_prot(struct at
 }
 
 /**
+ *	ata_qc_issue_prot_ledtrigger - trigger LED core
+ *	@qc: command to issue to device
+ *
+ *	This triggers the LED core and then calls the
+ *	regular ata_qc_issue_prot function.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, AC_ERR_* mask on failure
+ */
+unsigned int ata_qc_issue_prot_ledtrigger(struct ata_queued_cmd *qc)
+{
+	ledtrig_ide_activity();
+	return ata_qc_issue_prot(qc);
+}
+
+/**
  *	ata_host_intr - Handle host interrupt for given (port, task)
  *	@ap: Port on which interrupt arrived (possibly...)
  *	@qc: Taskfile currently active in engine
@@ -6452,6 +6472,7 @@ EXPORT_SYMBOL_GPL(ata_hsm_move);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
 EXPORT_SYMBOL_GPL(ata_qc_issue_prot);
+EXPORT_SYMBOL_GPL(ata_qc_issue_prot_ledtrigger);
 EXPORT_SYMBOL_GPL(ata_tf_load);
 EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
diff -puN drivers/ata/sata_svw.c~optional-led-trigger-for-libata drivers/ata/sata_svw.c
--- a/drivers/ata/sata_svw.c~optional-led-trigger-for-libata
+++ a/drivers/ata/sata_svw.c
@@ -348,7 +348,7 @@ static const struct ata_port_operations 
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= ata_qc_prep,
-	.qc_issue		= ata_qc_issue_prot,
+	.qc_issue		= ata_qc_issue_prot_ledtrigger,
 	.data_xfer		= ata_data_xfer,
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
diff -puN include/linux/libata.h~optional-led-trigger-for-libata include/linux/libata.h
--- a/include/linux/libata.h~optional-led-trigger-for-libata
+++ a/include/linux/libata.h
@@ -784,6 +784,7 @@ extern void ata_data_xfer_noirq(struct a
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
+extern unsigned int ata_qc_issue_prot_ledtrigger(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
 		unsigned int buflen);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
_

Patches currently in -mm which might be from chainsaw@gentoo.org are

optional-led-trigger-for-libata.patch
