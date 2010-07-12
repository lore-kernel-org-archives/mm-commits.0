From: akpm@linux-foundation.org
Subject: + drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:22:33 -0700
Message-ID: <201007122322.o6CNMXKg002969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab0GLXXE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cyril.jayaprakash@gmail.com, James.Bottomley@HansenPartnership.com


The patch titled
     drivers/scsi/pmcraid.c: remove unwanted cast for void* pointers
has been added to the -mm tree.  Its filename is
     drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers.patch

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
Subject: drivers/scsi/pmcraid.c: remove unwanted cast for void* pointers
From: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>

Signed-off-by: Cyril Jayaprakash <cyril.jayaprakash@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/pmcraid.c~drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers
+++ a/drivers/scsi/pmcraid.c
@@ -3599,8 +3599,7 @@ static int pmcraid_chr_open(struct inode
  */
 static int pmcraid_chr_release(struct inode *inode, struct file *filep)
 {
-	struct pmcraid_instance *pinstance =
-		((struct pmcraid_instance *)filep->private_data);
+	struct pmcraid_instance *pinstance = filep->private_data;
 
 	filep->private_data = NULL;
 	fasync_helper(-1, filep, 0, &pinstance->aen_queue);
@@ -3619,7 +3618,7 @@ static int pmcraid_chr_fasync(int fd, st
 	struct pmcraid_instance *pinstance;
 	int rc;
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 	mutex_lock(&pinstance->aen_queue_lock);
 	rc = fasync_helper(fd, filep, mode, &pinstance->aen_queue);
 	mutex_unlock(&pinstance->aen_queue_lock);
@@ -4110,7 +4109,7 @@ static long pmcraid_chr_ioctl(
 		return retval;
 	}
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 
 	if (!pinstance) {
 		pmcraid_info("adapter instance is not found\n");
_

Patches currently in -mm which might be from cyril.jayaprakash@gmail.com are

drivers-scsi-pmcraidc-remove-unwanted-cast-for-void-pointers.patch

