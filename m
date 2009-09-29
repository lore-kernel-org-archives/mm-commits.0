From: akpm@linux-foundation.org
Subject: + drivers-scsi-libsas-use-sam_good.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:57:36 -0700
Message-ID: <200909291957.n8TJvaAp021606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979AbZI2T6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/libsas: use SAM_GOOD
has been added to the -mm tree.  Its filename is
     drivers-scsi-libsas-use-sam_good.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/libsas: use SAM_GOOD
From: Julia Lawall <julia@diku.dk>

The field stat->stat should be compared to SAM_GOOD, not SAM_STAT_GOOD, as
done elsewhere in the same function.  Both constants have the same value.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_ata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libsas/sas_ata.c~drivers-scsi-libsas-use-sam_good drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~drivers-scsi-libsas-use-sam_good
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -112,7 +112,7 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-	} else if (stat->stat != SAM_STAT_GOOD) {
+	} else if (stat->stat != SAM_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
 			SAS_DPRINTK("%s: SAS error %x\n", __func__,
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-md-introduce-missing-kfree.patch
drivers-scsi-libsas-use-sam_good.patch

