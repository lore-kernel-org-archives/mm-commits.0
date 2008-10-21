From: akpm@linux-foundation.org
Subject: + cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:44:13 -0700
Message-ID: <200810212244.m9LMiDO4005620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYJUWpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:45:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, stable@kernel.org


The patch titled
     cciss: fix regression firmware not displayed in procfs
has been added to the -mm tree.  Its filename is
     cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix regression firmware not displayed in procfs
From: Mike Miller <mike.miller@hp.com>

This regression was introduced by commit
6ae5ce8e8d4de666f31286808d2285aa6a50fa40 ("cciss: remove redundant code").

This patch fixes a regression where the controller firmware version is not
displayed in procfs.  The previous patch would be called anytime something
changed.  This will get called only once for each controller.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again
+++ a/drivers/block/cciss.c
@@ -3403,7 +3403,8 @@ static int __devinit cciss_init_one(stru
 	int i;
 	int j = 0;
 	int rc;
-	int dac;
+	int dac, return_code;
+	InquiryData_struct *inq_buff = NULL;
 
 	i = alloc_cciss_hba();
 	if (i < 0)
@@ -3509,6 +3510,25 @@ static int __devinit cciss_init_one(stru
 	/* Turn the interrupts on so we can service requests */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
 
+	/* Get the firmware version */
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	if (inq_buff == NULL) {
+		printk(KERN_ERR "cciss: out of memory\n");
+		goto clean4;
+	}
+
+	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
+		sizeof(InquiryData_struct), 0, 0 , 0, TYPE_CMD);
+	if (return_code == IO_OK) {
+		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
+		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
+		hba[i]->firm_ver[2] = inq_buff->data_byte[34];
+		hba[i]->firm_ver[3] = inq_buff->data_byte[35];
+	} else {	 /* send command failed */
+		printk(KERN_WARNING "cciss: unable to determine firmware"
+			" version of controller\n");
+	}
+
 	cciss_procinit(i);
 
 	hba[i]->cciss_max_sectors = 2048;
@@ -3519,6 +3539,7 @@ static int __devinit cciss_init_one(stru
 	return 1;
 
 clean4:
+	kfree(inq_buff);
 #ifdef CONFIG_CISS_SCSI_TAPE
 	kfree(hba[i]->scsi_rejects.complete);
 #endif
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch
cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch

