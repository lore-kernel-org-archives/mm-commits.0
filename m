From: akpm@linux-foundation.org
Subject: + cciss-fix-scatter-gather-cleanup-problems.patch added to -mm tree
Date: Thu, 19 Nov 2009 16:05:09 -0800
Message-ID: <200911200005.nAK0597f027817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737AbZKTAFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 19:05:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, brace@beardog.cce.hp.com, jens.axboe@oracle.com


The patch titled
     cciss: fix scatter gather cleanup problems
has been added to the -mm tree.  Its filename is
     cciss-fix-scatter-gather-cleanup-problems.patch

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
Subject: cciss: fix scatter gather cleanup problems
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

On driver unload, only free up the extra scatter gather data if they were
allocated in the first place (the controller supports it) and don't forget
to free up the sg_cmd_list array of pointers.

Signed-off-by: Don Brace <brace@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-scatter-gather-cleanup-problems drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-scatter-gather-cleanup-problems
+++ a/drivers/block/cciss.c
@@ -4326,10 +4326,15 @@ clean4:
 	for (k = 0; k < hba[i]->nr_cmds; k++)
 		kfree(hba[i]->scatter_list[k]);
 	kfree(hba[i]->scatter_list);
-	for (j = 0; j < hba[i]->nr_cmds; j++) {
-		if (hba[i]->cmd_sg_list[j])
-			kfree(hba[i]->cmd_sg_list[j]->sgchain);
-		kfree(hba[i]->cmd_sg_list[j]);
+	/* Only free up extra s/g lists if controller supports them */
+	if (hba[i]->chainsize > 0) {
+		for (j = 0; j < hba[i]->nr_cmds; j++) {
+			if (hba[i]->cmd_sg_list[j]) {
+				kfree(hba[i]->cmd_sg_list[j]->sgchain);
+				kfree(hba[i]->cmd_sg_list[j]);
+			}
+		}
+		kfree(hba[i]->cmd_sg_list);
 	}
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
@@ -4448,9 +4453,15 @@ static void __devexit cciss_remove_one(s
 	for (j = 0; j < hba[i]->nr_cmds; j++)
 		kfree(hba[i]->scatter_list[j]);
 	kfree(hba[i]->scatter_list);
-	for (j = 0; j < hba[i]->nr_cmds; j++) {
-		kfree(hba[i]->cmd_sg_list[j]->sgchain);
-		kfree(hba[i]->cmd_sg_list[j]);
+	/* Only free up extra s/g lists if controller supports them */
+	if (hba[i]->chainsize > 0) {
+		for (j = 0; j < hba[i]->nr_cmds; j++) {
+			if (hba[i]->cmd_sg_list[j]) {
+				kfree(hba[i]->cmd_sg_list[j]->sgchain);
+				kfree(hba[i]->cmd_sg_list[j]);
+			}
+		}
+		kfree(hba[i]->cmd_sg_list);
 	}
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
cciss-fix-scatter-gather-cleanup-problems.patch

