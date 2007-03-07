From: akpm@linux-foundation.org
Subject: - scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:07 -0800
Message-ID: <200703070421.l274L7GD018871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161290AbXCGEVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Scheduled removal of SA_xxx interrupt flags fixups 3
has been removed from the -mm tree.  Its filename was
     scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags fixups 3
From: Thomas Gleixner <tglx@linutronix.de>

The obsolete SA_xxx interrupt flags have been used despite the scheduled
removal.  Fixup the remaining users in -mm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmitime.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/vmitime.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3 arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c~scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3
+++ a/arch/i386/kernel/vmitime.c
@@ -123,12 +123,10 @@ static struct clocksource clocksource_vm
 static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id);
 
 static struct irqaction vmi_timer_irq  = {
-	vmi_timer_interrupt,
-	SA_INTERRUPT,
-	CPU_MASK_NONE,
-	"VMI-alarm",
-	NULL,
-	NULL
+	.handler = vmi_timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "VMI-alarm",
 };
 
 /* Alarm rate */
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
