From: akpm@linux-foundation.org
Subject: + drivers-scsi-iprc-missing-unlock-before-a-return.patch added to -mm tree
Date: Tue, 14 Aug 2012 17:08:19 -0700
Message-ID: <20120815000819.B4C511E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34188 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2HOAIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 20:08:21 -0400
Received: by obbwc20 with SMTP id wc20so764347obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 17:08:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ipr.c: missing unlock before a return
has been added to the -mm tree.  Its filename is
     drivers-scsi-iprc-missing-unlock-before-a-return.patch

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
drivers-scsi-iprc-missing-unlock-before-a-return.patch

