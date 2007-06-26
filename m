From: akpm@linux-foundation.org
Subject: + x86_64-block-irq-balancing-for-timer.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:08:10 -0700
Message-ID: <200706260008.l5Q08Aga014478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXFZAPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: block irq balancing for timer
has been added to the -mm tree.  Its filename is
     x86_64-block-irq-balancing-for-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: block irq balancing for timer
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Disable irq balancing on IRQ0.  Several SIS chipsets lock up when you try to
change affinity of IRQ #0.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/time.c~x86_64-block-irq-balancing-for-timer arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-block-irq-balancing-for-timer
+++ a/arch/x86_64/kernel/time.c
@@ -255,7 +255,7 @@ static unsigned int __init tsc_calibrate
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
