From: akpm@linux-foundation.org
Subject: - add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:15:36 -0800
Message-ID: <200702160815.l1G8Faje024274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59718 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966181AbXBPIWS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:22:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     add-a-functions-to-handle-interrupt-affinity-setting alpha fix
has been removed from the -mm tree.  Its filename was
     add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch

This patch was dropped because it was folded into add-a-functions-to-handle-interrupt-affinity-setting.patch

------------------------------------------------------
Subject: add-a-functions-to-handle-interrupt-affinity-setting alpha fix
From: Andrew Morton <akpm@osdl.org>

kernel/irq/manage.c: In function 'irq_set_affinity':
kernel/irq/manage.c:75: error: invalid type argument of '->'
kernel/irq/manage.c:76: error: invalid type argument of '->'

nfi why.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/irq/manage.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc6-mm/kernel/irq/manage.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/kernel/irq/manage.c
+++ linux-2.6.20-rc6-mm/kernel/irq/manage.c
@@ -72,8 +72,8 @@ int irq_set_affinity(unsigned int irq, c
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	set_pending_irq(irq, cpumask);
 #else
-	irq_desc[irq]->affinity = cpumask;
-	irq_desc[irq]->chip->set_affinity(irq, cpumask);
+	desc->affinity = cpumask;
+	desc->chip->set_affinity(irq, cpumask);
 #endif
 	return 0;
 }

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
