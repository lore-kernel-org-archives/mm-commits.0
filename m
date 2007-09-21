From: akpm@linux-foundation.org
Subject: + mptbase-reset-ioc-initiator-during-pci-resume.patch added to -mm tree
Date: Fri, 21 Sep 2007 03:11:46 -0700
Message-ID: <200709211011.l8LABkIb030368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbXIUKL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 06:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     mptbase: reset ioc initiator during PCI resume
has been added to the -mm tree.  Its filename is
     mptbase-reset-ioc-initiator-during-pci-resume.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mptbase: reset ioc initiator during PCI resume
From: "Darrick J. Wong" <djwong@us.ibm.com>

It appears that the LSI SAS 1064E chip needs to be reset after a
suspend/resume cycle before the driver attempts further communications with
the chip.  Without this patch, resuming the chip results in this error
message being printed repeatedly and no more disk I/O.

mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!

So far it seems to fix suspend/resume on all the MPT Fusion cards I have
(SAS and U320 SCSI) but since I don't know the internals of that chip I
can't say for sure if this is a proper fix.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1830,6 +1830,12 @@ mpt_resume(struct pci_dev *pdev)
 		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
 		CHIPREG_READ32(&ioc->chip->Doorbell));
 
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
 	/* bring ioc to operational state */
 	if ((recovery_state = mpt_do_ioc_recovery(ioc,
 	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
_

Patches currently in -mm which might be from djwong@us.ibm.com are

git-hwmon.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
