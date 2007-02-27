From: akpm@linux-foundation.org
Subject: + bug-in-gdthc-crashing-machine.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:50:04 -0800
Message-ID: <200702272050.l1RKo88K028080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbXB0Uvg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg@dorchain.net, Achim_Leubner@adaptec.com, James.Bottomley@steeleye.com, stable@kernel.org


The patch titled
     bug in gdth.c crashing machine
has been added to the -mm tree.  Its filename is
     bug-in-gdthc-crashing-machine.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bug in gdth.c crashing machine
From: Joerg Dorchain <joerg@dorchain.net>

Undocumented...

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: <stable@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/gdth.c~bug-in-gdthc-crashing-machine drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~bug-in-gdthc-crashing-machine
+++ a/drivers/scsi/gdth.c
@@ -3091,6 +3091,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw64.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw64.cmd,scp->cmnd,16);
+            cmdp->u.raw64.sg_ranz    = 0;
         } else {
             cmdp->u.raw.reserved   = 0;
             cmdp->u.raw.mdisc_time = 0;
@@ -3107,6 +3108,7 @@ static int gdth_fill_raw_cmd(int hanum,S
             cmdp->u.raw.direction  = 
                 gdth_direction_tab[scp->cmnd[0]]==DOU ? GDTH_DATA_OUT:GDTH_DATA_IN;
             memcpy(cmdp->u.raw.cmd,scp->cmnd,12);
+            cmdp->u.raw.sg_ranz    = 0;
         }
 
         if (scp->use_sg) {
_

Patches currently in -mm which might be from joerg@dorchain.net are

bug-in-gdthc-crashing-machine.patch
