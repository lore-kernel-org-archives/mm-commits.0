From: akpm@linux-foundation.org
Subject: + scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch added to -mm tree
Date: Mon, 04 Aug 2008 17:41:38 -0700
Message-ID: <200808050041.m750fcvF008273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758920AbYHEAln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 20:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, bo.yang@lsi.com


The patch titled
     scsi: megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
has been added to the -mm tree.  Its filename is
     scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: megaraid_sas: add the shutdown DCMD cmd to driver shutdown routine
From: "Yang, Bo" <Bo.Yang@lsi.com>

Add the shutdown DCMD cmd to driver shutdown routine to make megaraid sas
FW shutdown proper.

Signed-off-by Bo Yang<bo.yang@lsi.com>
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

scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush.patch
scsi-megaraid_sas-add-the-shutdown-dcmd-cmd-to-driver-shutdown-routine.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
scsi-megaraid_sas-version-and-documentation-update.patch

