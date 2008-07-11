From: akpm@linux-foundation.org
Subject: + pm-ahci-speed-up-resume.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:40:43 -0700
Message-ID: <200807111846.m6BIkOkC031009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbYGKSqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rui.zhang@intel.com, jeff@garzik.org, pavel@ucw.cz, rjw@sisk.pl, tj@kernel.org


The patch titled
     pm: ahci: speed up resume
has been added to the -mm tree.  Its filename is
     pm-ahci-speed-up-resume.patch

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
Subject: pm: ahci: speed up resume
From: Zhang Rui <rui.zhang@intel.com>

During resume, sleep 1 second to wait for the HBA reset to finish is a waste
of time.

According to the AHCI 1.2 spec, We should poll the HOST_CTL register, and
return error if the host reset is not finished within 1 second.

Test results show that the HBA reset can be done quickly(in usecs).  And this
patch may save nearly 1 second during resume.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/ata/ahci.c~pm-ahci-speed-up-resume drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~pm-ahci-speed-up-resume
+++ a/drivers/ata/ahci.c
@@ -1142,12 +1142,15 @@ static int ahci_reset_controller(struct 
 			readl(mmio + HOST_CTL); /* flush */
 		}
 
-		/* reset must complete within 1 second, or
+		/*
+		 * to perform host reset, OS should set HOST_RESET
+		 * and poll until this bit is read to be "0".
+		 * reset must complete within 1 second, or
 		 * the hardware should be considered fried.
 		 */
-		ssleep(1);
+		tmp = ata_wait_register(mmio + HOST_CTL, HOST_RESET,
+					HOST_RESET, 10, 1000);
 
-		tmp = readl(mmio + HOST_CTL);
 		if (tmp & HOST_RESET) {
 			dev_printk(KERN_ERR, host->dev,
 				   "controller reset failed (0x%x)\n", tmp);
_

Patches currently in -mm which might be from rui.zhang@intel.com are

linux-next.patch
pm-ahci-speed-up-resume.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

