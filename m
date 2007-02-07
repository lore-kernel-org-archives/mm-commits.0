From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-stop-cmd-processing-if.patch added to -mm tree
Date: Wed, 07 Feb 2007 13:36:09 -0800
Message-ID: <200702072136.l17La9Xq027915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422799AbXBGVgM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 16:36:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sumantp@lsil.com, sumant.patro@lsi.com


The patch titled
     scsi: megaraid_sas - stop cmd processing if hw_crit_error is set
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-stop-cmd-processing-if.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: megaraid_sas - stop cmd processing if hw_crit_error is set
From: Sumant Patro <sumantp@lsil.com>

Checks if hw_crit_error is set before processing cmds.  Added in
megasas_queue_command and command completion routines.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-stop-cmd-processing-if drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-stop-cmd-processing-if
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -841,6 +841,11 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
+
+	/* Don't process if we have already declared adapter dead */
+	if(instance->hw_crit_error)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1282,11 +1287,13 @@ megasas_deplete_reply_queue(struct megas
 	if(instance->instancet->clear_intr(instance->reg_set))
 		return IRQ_NONE;
 
+	if(instance->hw_crit_error)
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
+	if(instance->hw_crit_error)
+		return;
+
 	producer = *instance->producer;
 	consumer = *instance->consumer;
 
_

Patches currently in -mm which might be from sumantp@lsil.com are

git-scsi-misc.patch
scsi-megaraid_sas-stop-cmd-processing-if.patch
scsi-megaraid_sas-added-bios_param-in.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-preallocate-memory-for-ioctl.patch
scsi-megaraid_sas-update-version-and-author-info.patch
