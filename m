From: akpm@linux-foundation.org
Subject: - scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:59 -0800
Message-ID: <200703152156.l2FLuxfj027603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42328 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXCOV5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greg@kroah.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 3
has been removed from the -mm tree.  Its filename was
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags fixups 3
From: Thomas Gleixner <tglx@linutronix.de>

The obsolete SA_xxx interrupt flags have been used despite the scheduled
removal.  Fixup the remaining users in -mm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/nozomi.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4 drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4
+++ a/drivers/char/nozomi.c
@@ -1386,7 +1386,7 @@ static int nozomi_setup_interrupt(struct
 {
 	int rval;
 
-	rval = request_irq(dc->pdev->irq, &interrupt_handler, SA_SHIRQ,
+	rval = request_irq(dc->pdev->irq, &interrupt_handler, IRQF_SHARED,
 			   NOZOMI_NAME, dc);
 	if (rval)
 		dev_err(&dc->pdev->dev, "Cannot open because IRQ %d "
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch
hrtimer-fixup-unlocked-access-to-wall_to_monotonic.patch
paravirt-build-fixes.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
