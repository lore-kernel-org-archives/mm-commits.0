From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-return-sync-cache-call-with-success.patch added to -mm tree
Date: Wed, 14 Feb 2007 20:20:47 -0800
Message-ID: <200702150420.l1F4KlKm019639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbXBOEUu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 23:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sumantp@lsil.com, sumant.patro@lsi.com


The patch titled
     scsi: megaraid_sas - return sync cache call with success
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-return-sync-cache-call-with-success.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: megaraid_sas - return sync cache call with success
From: Sumant Patro <sumantp@lsil.com>

FW does not support SYNCHRONIZE_CACHE cmd.  FW flush cache on its own.  So, we
just return success from the megasas_queue_command.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-return-sync-cache-call-with-success drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-return-sync-cache-call-with-success
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -857,6 +857,18 @@ megasas_queue_command(struct scsi_cmnd *
 		goto out_done;
 	}
 
+	switch (scmd->cmnd[0]) {
+		case SYNCHRONIZE_CACHE:
+			/*
+			 * FW takes care of flush cache on its own
+			 * No need to send it down
+			 */
+			scmd->result = DID_OK << 16;
+			goto out_done;
+		default:
+			break;
+	}
+
 	/* Check if we can accept cmds */
 	if (instance->is_busy) {
 		sec = (jiffies - instance->last_time) / HZ;
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
scsi-megaraid_sas-donot-process-cmds-if-hw_crit_error-is-set.patch
scsi-megaraid_sas-added-bios_param-in-scsi_host_template.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path.patch
scsi-megaraid_sas-return-sync-cache-call-with-success.patch
scsi-megaraid_sas-update-version-and-author-info.patch
