From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch added to -mm tree
Date: Wed, 07 Feb 2007 13:36:13 -0800
Message-ID: <200702072136.l17LaDal027921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854AbXBGVgQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 16:36:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sumantp@lsil.com, sumant.patro@lsi.com


The patch titled
     scsi: megaraid_sas - throttle io if FW is busy
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: megaraid_sas - throttle io if FW is busy
From: Sumant Patro <sumantp@lsil.com>

Checks added in megasas_queue_command to know if FW is able to process
commands within timeout period.  If number of retries is 2 or greater, the
driver stops sending cmd to FW.  IO is resumed if pending cmd count reduces to
16 or 5 seconds has elapsed from the time cmds were last sent to FW.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |    3 ++
 2 files changed, 30 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-throttle-io-if-fw-is-busy drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-throttle-io-if-fw-is-busy
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -839,6 +839,7 @@ megasas_queue_command(struct scsi_cmnd *
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
+	unsigned long sec;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
@@ -856,6 +857,23 @@ megasas_queue_command(struct scsi_cmnd *
 		goto out_done;
 	}
 
+	/* Check if we can process cmds */
+	if(instance->is_busy){
+		sec = (jiffies - instance->last_time) / HZ;
+		if(sec<5)
+			return SCSI_MLQUEUE_HOST_BUSY;
+		else{
+			instance->is_busy=0;
+			instance->last_time=0;
+		}
+	}
+
+	if(scmd->retries>1){
+		/* FW is busy */
+		instance->is_busy=1;
+		instance->last_time=jiffies;
+	}
+
 	cmd = megasas_get_cmd(instance);
 	if (!cmd)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1200,6 +1218,7 @@ megasas_complete_cmd(struct megasas_inst
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
+	int outstanding;
 
 	if (cmd->scmd) {
 		cmd->scmd->SCp.ptr = (char *)0;
@@ -1313,6 +1332,12 @@ megasas_complete_cmd(struct megasas_inst
 		       hdr->cmd);
 		break;
 	}
+
+	if(instance->is_busy){
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if(outstanding<17)
+			instance->is_busy=0;
+	}
 }
 
 /**
@@ -2384,6 +2409,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
 	megasas_dbg_lvl = 0;
+	instance->is_busy = 0;
+	instance->last_time = 0;
 
 	/*
 	 * Initialize MFI Firmware
diff -puN drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-throttle-io-if-fw-is-busy drivers/scsi/megaraid/megaraid_sas.h
--- a/drivers/scsi/megaraid/megaraid_sas.h~scsi-megaraid_sas-throttle-io-if-fw-is-busy
+++ a/drivers/scsi/megaraid/megaraid_sas.h
@@ -1102,6 +1102,9 @@ struct megasas_instance {
 	atomic_t fw_outstanding;
 	u32 hw_crit_error;
 
+	u8 is_busy;
+	unsigned long last_time;
+
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
 };
_

Patches currently in -mm which might be from sumantp@lsil.com are

git-scsi-misc.patch
scsi-megaraid_sas-stop-cmd-processing-if.patch
scsi-megaraid_sas-added-bios_param-in.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-preallocate-memory-for-ioctl.patch
scsi-megaraid_sas-update-version-and-author-info.patch
