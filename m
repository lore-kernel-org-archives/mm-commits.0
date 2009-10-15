From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-multiple-calls-to-pci_release_regions.patch removed from -mm tree
Date: Thu, 15 Oct 2009 11:43:40 -0700
Message-ID: <200910151843.n9FIhenC023689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262AbZJOSoe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 14:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix multiple calls to pci_release_regions
has been removed from the -mm tree.  Its filename was
     cciss-fix-multiple-calls-to-pci_release_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch

