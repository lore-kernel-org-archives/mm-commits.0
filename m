From: akpm@linux-foundation.org
Subject: - i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:55 -0700
Message-ID: <200704112320.l3BNKtpU017525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35888 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161346AbXDKXVS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c: replace more deprecated SA_xxx interrupt flags
has been removed from the -mm tree.  Its filename was
     i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c: replace more deprecated SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

Fix the obnoxious users of the deprecated SA_xxx interrupt flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-bfin-twi.c~i2c-replace-more-deprecated-sa_xxx-interrupt-flags drivers/i2c/busses/i2c-bfin-twi.c
--- a/drivers/i2c/busses/i2c-bfin-twi.c~i2c-replace-more-deprecated-sa_xxx-interrupt-flags
+++ a/drivers/i2c/busses/i2c-bfin-twi.c
@@ -573,7 +573,7 @@ static int i2c_bfin_twi_probe(struct pla
 	p_adap->dev.parent = &dev->dev;
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		SA_INTERRUPT, dev->name, iface);
+		IRQF_DISABLED, dev->name, iface);
 	if (rc) {
 		dev_err(&(p_adap->dev), "i2c-bfin-twi: can't get IRQ %d !\n",
 			iface->irq);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-arm.patch
git-ieee1394.patch
git-input.patch
vioc-replace-more-deprecated-sa_xxx-interrupt-flags.patch
i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
