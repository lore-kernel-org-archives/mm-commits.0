From: akpm@linux-foundation.org
Subject: + drivers-scsi-iprc-remove-an-unneeded-check.patch added to -mm tree
Date: Tue, 14 Aug 2012 17:09:04 -0700
Message-ID: <20120815000904.F0B9B5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35443 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2HOAJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 20:09:07 -0400
Received: by eekd4 with SMTP id d4so47857eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 17:09:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


The patch titled
     Subject: drivers/scsi/ipr.c: remove an unneeded check
has been added to the -mm tree.  Its filename is
     drivers-scsi-iprc-remove-an-unneeded-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
drivers-scsi-iprc-missing-unlock-before-a-return.patch
drivers-scsi-iprc-remove-an-unneeded-check.patch

