From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:41:10 -0700
Message-ID: <200808181941.m7IJfAlZ008522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934267AbYHRTuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, bo.yang@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
From: "Yang, Bo" <Bo.Yang@lsi.com>

Add the shutdown DCMD cmd to driver shutdown routine to make megaraid sas
FW shutdown proper.

Signed-off-by: Bo Yang<bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2863,6 +2863,7 @@ static void megasas_shutdown(struct pci_
 {
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
 	megasas_flush_cache(instance);
+	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 }
 
 /**
_

Patches currently in -mm which might be from Bo.Yang@lsi.com are

linux-next.patch
drivers-scsi-megaraid-use-div_round_up.patch

