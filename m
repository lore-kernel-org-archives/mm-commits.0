From: akpm@linux-foundation.org
Subject: + cciss-fix-multiple-calls-to-pci_release_regions.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:08:05 -0700
Message-ID: <200910122208.n9CM85wo030494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454AbZJLWJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, jens.axboe@oracle.com, mike.miller@hp.com


The patch titled
     cciss: fix multiple calls to pci_release_regions
has been added to the -mm tree.  Its filename is
     cciss-fix-multiple-calls-to-pci_release_regions.patch

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
Subject: cciss: fix multiple calls to pci_release_regions
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Fix multiple calls to pci_release_regions.  If cciss_pci_init fails, it
already does any necessary call to pci_release_regions, so this does not
need to be done again in cciss_init_one in that case.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/block/cciss.c~cciss-fix-multiple-calls-to-pci_release_regions drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-multiple-calls-to-pci_release_regions
+++ a/drivers/block/cciss.c
@@ -4254,7 +4254,7 @@ static int __devinit cciss_init_one(stru
 	mutex_init(&hba[i]->busy_shutting_down);
 
 	if (cciss_pci_init(hba[i], pdev) != 0)
-		goto clean0;
+		goto clean_no_release_regions;
 
 	sprintf(hba[i]->devname, "cciss%d", i);
 	hba[i]->ctlr = i;
@@ -4391,13 +4391,14 @@ clean2:
 clean1:
 	cciss_destroy_hba_sysfs_entry(hba[i]);
 clean0:
+	pci_release_regions(pdev);
+clean_no_release_regions:
 	hba[i]->busy_initializing = 0;
 
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 	return -1;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
cciss-fix-multiple-calls-to-pci_release_regions.patch
cciss-add-cciss_allow_hpsa-module-parameter.patch

