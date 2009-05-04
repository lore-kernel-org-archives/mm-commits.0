From: akpm@linux-foundation.org
Subject: + remove-put_cpu_no_resched.patch added to -mm tree
Date: Mon, 04 May 2009 15:55:31 -0700
Message-ID: <200905042255.n44MtVjk025987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbZEDW73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 18:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, Trond.Myklebust@netapp.com, bfields@fieldses.org, mingo@elte.hu, tony.luck@intel.com


The patch titled
     remove put_cpu_no_resched()
has been added to the -mm tree.  Its filename is
     remove-put_cpu_no_resched.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove put_cpu_no_resched()
From: Thomas Gleixner <tglx@linutronix.de>

put_cpu_no_resched() is an optimization of put_cpu() which unfortunately
can cause high latencies.

The nfs iostats code uses put_cpu_no_resched() in a code sequence where a
reschedule request caused by an interrupt between the get_cpu() and the
put_cpu_no_resched() can delay the reschedule for at least HZ.

The other users of put_cpu_no_resched() optimize correctly in interrupt
code, but there is no real harm in using the put_cpu() function which is
an alias for preempt_enable().  The extra check of the preemmpt count is
not as critical as the potential source of missing a reschedule.

Debugged in the preempt-rt tree and verified in mainline.

Impact: remove a high latency source

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    2 +-
 fs/nfs/iostat.h            |    4 ++--
 include/linux/smp.h        |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~remove-put_cpu_no_resched arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~remove-put_cpu_no_resched
+++ a/arch/ia64/kernel/perfmon.c
@@ -5595,7 +5595,7 @@ pfm_interrupt_handler(int irq, void *arg
 		(*pfm_alt_intr_handler->handler)(irq, arg, regs);
 	}
 
-	put_cpu_no_resched();
+	put_cpu();
 	return IRQ_HANDLED;
 }
 
diff -puN fs/nfs/iostat.h~remove-put_cpu_no_resched fs/nfs/iostat.h
--- a/fs/nfs/iostat.h~remove-put_cpu_no_resched
+++ a/fs/nfs/iostat.h
@@ -31,7 +31,7 @@ static inline void nfs_inc_server_stats(
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(server->io_stats, cpu);
 	iostats->events[stat]++;
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -50,7 +50,7 @@ static inline void nfs_add_server_stats(
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(server->io_stats, cpu);
 	iostats->bytes[stat] += addend;
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 static inline void nfs_add_stats(const struct inode *inode,
diff -puN include/linux/smp.h~remove-put_cpu_no_resched include/linux/smp.h
--- a/include/linux/smp.h~remove-put_cpu_no_resched
+++ a/include/linux/smp.h
@@ -177,7 +177,6 @@ static inline void init_call_single_data
 
 #define get_cpu()		({ preempt_disable(); smp_processor_id(); })
 #define put_cpu()		preempt_enable()
-#define put_cpu_no_resched()	preempt_enable_no_resched()
 
 /*
  * Callback to arch code if there's nosmp or maxcpus=0 on the
_

Patches currently in -mm which might be from tglx@linutronix.de are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-simplify-highmem-related-kconfig-entries.patch
x86-enable-gart-iommu-only-after-setting-up-protection-methods.patch
avr32-remove-obsolete-hw_interrupt_type.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch
timers-allow-deferrable-timers-for-intervals-tv2-tv5-to-be-deferred.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch
clockevent-export-register_device-and-delta2ns.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
drivers-mfd-remove-obsolete-irq_desc_t-typedef.patch
parisc-remove-obsolete-hw_interrupt_type.patch
revert-genirq-assert-that-irq-handlers-are-indeed-running-in-hardirq-context.patch
alpha-remove-obsolete-hw_interrupt_type.patch
m32r-remove-obsolete-hw_interrupt_type.patch
um-remove-obsolete-hw_interrupt_type.patch
kmap_types-make-most-arches-use-generic-header-file.patch
remove-put_cpu_no_resched.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch

