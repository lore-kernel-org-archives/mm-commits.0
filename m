From: akpm@linux-foundation.org
Subject: - scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:28 -0800
Message-ID: <200703070422.l274MSkj018991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbXCGEZ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 3
has been removed from the -mm tree.  Its filename was
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags fixups 3
From: Thomas Gleixner <tglx@linutronix.de>

The obsolete SA_xxx interrupt flags have been used despite the scheduled
removal.  Fixup the remaining users in -mm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/fw-ohci.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firewire/fw-ohci.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5 drivers/firewire/fw-ohci.c
--- a/drivers/firewire/fw-ohci.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5
+++ a/drivers/firewire/fw-ohci.c
@@ -1101,7 +1101,7 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
 	if (request_irq(dev->irq, irq_handler,
-			SA_SHIRQ, ohci_driver_name, ohci)) {
+			IRQF_SHARED, ohci_driver_name, ohci)) {
 		fw_error("Failed to allocate shared interrupt %d.\n",
 			 dev->irq);
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
paravirt-build-fixes.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
