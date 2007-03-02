From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-return-sync-cache-call-with-success.patch removed from -mm tree
Date: Fri, 02 Mar 2007 13:46:55 -0800
Message-ID: <200703022146.l22Lku6i019963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42243 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030359AbXCBVrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas - return sync cache call with success
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-return-sync-cache-call-with-success.patch

This patch was dropped because it is obsolete

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
@@ -871,6 +871,18 @@ megasas_queue_command(struct scsi_cmnd *
 		break;
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

scsi-megaraid_sas-return-sync-cache-call-with-success.patch
