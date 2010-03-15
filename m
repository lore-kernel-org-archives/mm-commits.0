From: akpm@linux-foundation.org
Subject: + dpt_i20-several-use-after-free-issues.patch added to -mm tree
Date: Mon, 15 Mar 2010 13:45:33 -0700
Message-ID: <201003152045.o2FKjXkp021547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab0COUpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 16:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, James.Bottomley@HansenPartnership.com, aacraid@adaptec.com


The patch titled
     dpt_i20: several use after free issues
has been added to the -mm tree.  Its filename is
     dpt_i20-several-use-after-free-issues.patch

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
Subject: dpt_i20: several use after free issues
From: Dan Carpenter <error27@gmail.com>

adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next" before
calling it.  Also inside adpt_i2o_delete_hba() itself, there was another
use after free bug which I fixed by moving the kfree() down a line.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~dpt_i20-several-use-after-free-issues drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~dpt_i20-several-use-after-free-issues
+++ a/drivers/scsi/dpt_i2o.c
@@ -188,7 +188,8 @@ MODULE_DEVICE_TABLE(pci,dptids);
 static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
-	adpt_hba* pHba;
+	adpt_hba *pHba;
+	adpt_hba *next;
 
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
@@ -206,7 +207,8 @@ static int adpt_detect(struct scsi_host_
 	}
 
 	/* In INIT state, Activate IOPs */
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		// Activate does get status , init outbound, and get hrt
 		if (adpt_i2o_activate_hba(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
@@ -243,7 +245,8 @@ rebuild_sys_tab:
 	PDEBUG("HBA's in OPERATIONAL state\n");
 
 	printk("dpti: If you have a lot of devices this could take a few minutes.\n");
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		printk(KERN_INFO"%s: Reading the hardware resource table.\n", pHba->name);
 		if (adpt_i2o_lct_get(pHba) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -263,7 +266,8 @@ rebuild_sys_tab:
 		adpt_sysfs_class = NULL;
 	}
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
@@ -1229,11 +1233,10 @@ static void adpt_i2o_delete_hba(adpt_hba
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
