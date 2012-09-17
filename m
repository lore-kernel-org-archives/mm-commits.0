From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-iprc-remove-an-unneeded-check.patch removed from -mm tree
Date: Mon, 17 Sep 2012 12:33:23 -0700
Message-ID: <20120917193325.8D43420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34962 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab2IQTd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 15:33:29 -0400
Received: by eekd4 with SMTP id d4so418423eek.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 12:33:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ipr.c: remove an unneeded check
has been removed from the -mm tree.  Its filename was
     drivers-scsi-iprc-remove-an-unneeded-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/scsi/ipr.c: remove an unneeded check

"rc" is always zero here, so there is no need to check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.c~drivers-scsi-iprc-remove-an-unneeded-check drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~drivers-scsi-iprc-remove-an-unneeded-check
+++ a/drivers/scsi/ipr.c
@@ -5847,7 +5847,7 @@ static int ipr_queuecommand(struct Scsi_
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmnd *ipr_cmd;
 	unsigned long lock_flags;
-	int rc = 0;
+	int rc;
 
 	ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 
@@ -5905,12 +5905,10 @@ static int ipr_queuecommand(struct Scsi_
 	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE))
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 
-	if (likely(rc == 0)) {
-		if (ioa_cfg->sis64)
-			rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
-		else
-			rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
-	}
+	if (ioa_cfg->sis64)
+		rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
+	else
+		rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
 
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (unlikely(rc || (!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
checkpatch-update-suggested-printk-conversions.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch

