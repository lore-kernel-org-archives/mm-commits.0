From: akpm@linux-foundation.org
Subject: - pm-ahci-speed-up-resume.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:36:13 -0700
Message-ID: <200807141936.m6EJaDZ8024071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744AbYGNTgi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, jeff@garzik.org, pavel@ucw.cz, rjw@sisk.pl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pm: ahci: speed up resume
has been removed from the -mm tree.  Its filename was
     pm-ahci-speed-up-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
pm-schedule-sysrq-poweroff-on-boot-cpu.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
dcdbas-use-memory_read_from_buffer.patch
dell_rbu-use-memory_read_from_buffer.patch

