From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-iprc-missing-unlock-before-a-return.patch removed from -mm tree
Date: Mon, 17 Sep 2012 11:37:09 -0700
Message-ID: <20120917183710.CD5635C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59810 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab2IQShO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 14:37:14 -0400
Received: by weyr1 with SMTP id r1so417473wey.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 11:37:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ipr.c: missing unlock before a return
has been removed from the -mm tree.  Its filename was
     drivers-scsi-iprc-missing-unlock-before-a-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/scsi/ipr.c: missing unlock before a return

We recently changed the locking in this function, but this return was
missed.  It needs an unlock and the IRQs need to be restored.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~drivers-scsi-iprc-missing-unlock-before-a-return drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~drivers-scsi-iprc-missing-unlock-before-a-return
+++ a/drivers/scsi/ipr.c
@@ -5874,8 +5874,11 @@ static int ipr_queuecommand(struct Scsi_
 		goto err_nodev;
 	}
 
-	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
+	if (ipr_is_gata(res) && res->sata_port) {
+		rc = ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
+		spin_unlock_irqrestore(shost->host_lock, lock_flags);
+		return rc;
+	}
 
 	ipr_cmd = __ipr_get_free_ipr_cmnd(ioa_cfg);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
drivers-scsi-iprc-remove-an-unneeded-check.patch
checkpatch-update-suggested-printk-conversions.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch

