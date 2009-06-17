From: akpm@linux-foundation.org
Subject: [merged] remove-put_cpu_no_resched.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:22 -0700
Message-ID: <200906171837.n5HIbMXH003456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbZFQSyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, Trond.Myklebust@netapp.com, bfields@fieldses.org, mingo@elte.hu, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     remove put_cpu_no_resched()
has been removed from the -mm tree.  Its filename was
     remove-put_cpu_no_resched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: build fix]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    2 +-
 fs/nfs/iostat.h            |    6 +++---
 include/linux/smp.h        |    1 -
 3 files changed, 4 insertions(+), 5 deletions(-)

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
@@ -71,7 +71,7 @@ static inline void nfs_add_fscache_stats
 	cpu = get_cpu();
 	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
 	iostats->fscache[stat] += addend;
-	put_cpu_no_resched();
+	put_cpu();
 }
 #endif
 
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

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
ia64-remove-obsolete-no_irq_type.patch
ia64-remove-obsolete-irq_desc_t-typedef.patch
ia64-remove-obsolete-hw_interrupt_type.patch
parisc-remove-obsolete-hw_interrupt_type.patch
x86-fix-cpufreq-tsc-scaling.patch

