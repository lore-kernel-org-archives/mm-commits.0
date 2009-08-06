From: akpm@linux-foundation.org
Subject: [obsolete] genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:26:32 -0700
Message-ID: <200908062326.n76NQWFv008051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbZHFX2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, khilman@deeprootsystems.com, rjw@sisk.pl, rmk@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     genirq: do not disable IRQ_WAKEUP marked irqs on suspend
has been removed from the -mm tree.  Its filename was
     genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: do not disable IRQ_WAKEUP marked irqs on suspend
From: Thomas Gleixner <tglx@linutronix.de>

commit 0a0c5168df (PM: Introduce functions for suspending and resuming
device interrupts) iterates through all interrupts and disables them on
the hardware level.  Some architectures have functionality implemented to
mark an interrupt source as wakeup source for suspend, but the new power
management code disables them unconditionally which breaks the resume on
interrupt functionality.

The wakeup interrupts are marked in the status with the IRQ_WAKEUP bit. 
Skip the disablement for those interrupts which have the IRQ_WAKEUP bit
set.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/pm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/irq/pm.c~genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend kernel/irq/pm.c
--- a/kernel/irq/pm.c~genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend
+++ a/kernel/irq/pm.c
@@ -29,7 +29,8 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		if (!(desc->status & IRQ_WAKEUP))
+			__disable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
execve-must-clear-current-clear_child_tid-v2.patch
lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch
linux-next.patch
arch-x86-kernel-cpu-amdc-fix-x86_64-allnoconfig-build.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch
ia32-use-generic-sys_pipe.patch
preempt_active-add-default-defines.patch
posix_cpu_timers_exit_group-do-not-use-thread_group_cputimer.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch
futex-futex_wait_requeue_pi-commentary-corrections.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

