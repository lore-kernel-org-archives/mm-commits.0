From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:01 -0800
Message-ID: <200702170717.l1H7H1s2021758@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946532AbXBQHRF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas - donot process cmds if hw_crit_error is set
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: megaraid_sas - donot process cmds if hw_crit_error is set
From: Sumant Patro <sumantp@lsil.com>

Checks if hw_crit_error is set.  If it is set, we donot process commands. 
Checks added in megasas_queue_command and command completion routines.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -841,6 +841,11 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
+
+	/* Don't process if we have already declared adapter dead */
+	if (instance->hw_crit_error)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1282,11 +1287,13 @@ megasas_deplete_reply_queue(struct megas
 	if(instance->instancet->clear_intr(instance->reg_set))
 		return IRQ_NONE;
 
+	if (instance->hw_crit_error)
+		goto out_done;
         /*
 	 * Schedule the tasklet for cmd completion
 	 */
 	tasklet_schedule(&instance->isr_tasklet);
-
+out_done:
 	return IRQ_HANDLED;
 }
 
@@ -1741,6 +1748,10 @@ static void megasas_complete_cmd_dpc(uns
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
 
+	/* If we have already declared adapter dead, donot complete cmds */
+	if (instance->hw_crit_error)
+		return;
+
 	producer = *instance->producer;
 	consumer = *instance->consumer;
 
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
git-scsi-misc.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-return-sync-cache-call-with-success.patch
