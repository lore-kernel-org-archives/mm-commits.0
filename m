From: akpm@linux-foundation.org
Subject: + scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch added to -mm tree
Date: Mon, 05 Mar 2007 18:19:22 -0800
Message-ID: <200703060219.l262JMF2009213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933860AbXCFCTh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, greg@kroah.com, mingo@elte.hu


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 3
has been added to the -mm tree.  Its filename is
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch
