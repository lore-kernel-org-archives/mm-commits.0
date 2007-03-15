From: akpm@linux-foundation.org
Subject: - bug-in-gdthc-crashing-machine.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:34 -0800
Message-ID: <200703152159.l2FLxYVX027830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbXCOWBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg@dorchain.net, Achim_Leubner@adaptec.com, James.Bottomley@steeleye.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     bug in gdth.c crashing machine
has been removed from the -mm tree.  Its filename was
     bug-in-gdthc-crashing-machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bug in gdth.c crashing machine
From: Joerg Dorchain <joerg@dorchain.net>

The current gdth driver crashes the machine with a panic() when
accessing certain tape drives, really not a good thing for stable.

This patch fixes it, tested by me and acknowledged by Achim.
See http://lkml.org/lkml/2006/10/13/60 and
http://lkml.org/lkml/2006/10/12/35 for further reference.

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Acked-by: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: <stable@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 ++
 1 files changed, 2 insertions(+)

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

git-scsi-rc-fixes.patch
