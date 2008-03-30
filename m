From: akpm@linux-foundation.org
Subject: - mptbase-reset-ioc-initiator-during-pci-resume.patch removed from -mm tree
Date: Sun, 30 Mar 2008 16:47:34 -0700
Message-ID: <200803302347.m2UNlYGc013328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754739AbYC3Xrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 30 Mar 2008 19:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, mm-commits@vger.kernel.org


The patch titled
     mptbase: reset ioc initiator during PCI resume
has been removed from the -mm tree.  Its filename was
     mptbase-reset-ioc-initiator-during-pci-resume.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Cc: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: <Sathya.Prakash@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-during-pci-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1892,6 +1892,12 @@ mpt_resume(struct pci_dev *pdev)
 		}
 	}
 
+	/* put ioc into READY_STATE */
+	if(SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
+		printk(MYIOC_s_ERR_FMT
+		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
+	}
+
 	/* bring ioc to operational state */
 	printk(MYIOC_s_INFO_FMT "Sending mpt_do_ioc_recovery\n", ioc->name);
 	recovery_state = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
_

Patches currently in -mm which might be from djwong@us.ibm.com are

cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch
cpufreq-document-the-currently-undocumented-parts-of-the-sysfs-interface.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch

