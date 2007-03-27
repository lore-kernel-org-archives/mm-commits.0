From: akpm@linux-foundation.org
Subject: + i386-fix-bogus-return-value-in-hpet_next_event.patch added to -mm tree
Date: Mon, 26 Mar 2007 23:24:05 -0800
Message-ID: <200703270724.l2R7O9Xu010456@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43570 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310AbXC0HYY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 03:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386: fix bogus return value in hpet_next_event()
has been added to the -mm tree.  Its filename is
     i386-fix-bogus-return-value-in-hpet_next_event.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix bogus return value in hpet_next_event()
From: Thomas Gleixner <tglx@linutronix.de>

The clockevents / tick management code expects an error value, when the
event is already expired. hpet_next_event() returns 1 in that case.

Fix it to return the proper -ETIME error code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-fix-bogus-return-value-in-hpet_next_event arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-fix-bogus-return-value-in-hpet_next_event
+++ a/arch/i386/kernel/hpet.c
@@ -197,7 +197,7 @@ static int hpet_next_event(unsigned long
 	cnt += delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
-	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0);
+	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
 }
 
 /*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
i386-fix-bogus-return-value-in-hpet_next_event.patch
hrtimers-fix-reprogramming-smp-race.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
