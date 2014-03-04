From: akpm@linux-foundation.org
Subject: + powerpc-handle-new-__get_cpu_var-calls-in-314.patch added to
 -mm tree
Date: Tue, 04 Mar 2014 14:27:54 -0800
Message-ID: <5316536a.WOQNR28u/DdDfTOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810AbaCDW1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, paulus@samba.org, benh@kernel.crashing.org, cl@linux.com

Subject: + powerpc-handle-new-__get_cpu_var-calls-in-314.patch added to -mm tree
To: cl@linux.com,benh@kernel.crashing.org,paulus@samba.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:54 -0800


The patch titled
     Subject: powerpc: handle new __get_cpu_var calls in 3.14
has been added to the -mm tree.  Its filename is
     powerpc-handle-new-__get_cpu_var-calls-in-314.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-handle-new-__get_cpu_var-calls-in-314.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-handle-new-__get_cpu_var-calls-in-314.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: powerpc: handle new __get_cpu_var calls in 3.14

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/irq.c            |    2 +-
 arch/powerpc/kernel/kgdb.c           |    2 +-
 arch/powerpc/kernel/mce.c            |   24 ++++++++++++------------
 arch/powerpc/kernel/time.c           |    4 ++--
 arch/powerpc/mm/hugetlbpage-book3e.c |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/kernel/irq.c~powerpc-handle-new-__get_cpu_var-calls-in-314 arch/powerpc/kernel/irq.c
--- a/arch/powerpc/kernel/irq.c~powerpc-handle-new-__get_cpu_var-calls-in-314
+++ a/arch/powerpc/kernel/irq.c
@@ -486,7 +486,7 @@ void __do_irq(struct pt_regs *regs)
 
 	/* And finally process it */
 	if (unlikely(irq == NO_IRQ))
-		__get_cpu_var(irq_stat).spurious_irqs++;
+		__this_cpu_inc(irq_stat.spurious_irqs);
 	else {
 		desc = irq_to_desc(irq);
 		if (likely(desc))
diff -puN arch/powerpc/kernel/kgdb.c~powerpc-handle-new-__get_cpu_var-calls-in-314 arch/powerpc/kernel/kgdb.c
--- a/arch/powerpc/kernel/kgdb.c~powerpc-handle-new-__get_cpu_var-calls-in-314
+++ a/arch/powerpc/kernel/kgdb.c
@@ -155,7 +155,7 @@ static int kgdb_singlestep(struct pt_reg
 {
 	struct thread_info *thread_info, *exception_thread_info;
 	struct thread_info *backup_current_thread_info =
-		&__get_cpu_var(kgdb_thread_info);
+		this_cpu_ptr(&kgdb_thread_info);
 
 	if (user_mode(regs))
 		return 0;
diff -puN arch/powerpc/kernel/mce.c~powerpc-handle-new-__get_cpu_var-calls-in-314 arch/powerpc/kernel/mce.c
--- a/arch/powerpc/kernel/mce.c~powerpc-handle-new-__get_cpu_var-calls-in-314
+++ a/arch/powerpc/kernel/mce.c
@@ -73,8 +73,8 @@ void save_mce_event(struct pt_regs *regs
 		    uint64_t addr)
 {
 	uint64_t srr1;
-	int index = __get_cpu_var(mce_nest_count)++;
-	struct machine_check_event *mce = &__get_cpu_var(mce_event[index]);
+	int index = __this_cpu_inc_return(mce_nest_count);
+	struct machine_check_event *mce = __this_cpu_read(mce_event[index]);
 
 	/*
 	 * Return if we don't have enough space to log mce event.
@@ -143,7 +143,7 @@ void save_mce_event(struct pt_regs *regs
  */
 int get_mce_event(struct machine_check_event *mce, bool release)
 {
-	int index = __get_cpu_var(mce_nest_count) - 1;
+	int index = __this_cpu_read(mce_nest_count) - 1;
 	struct machine_check_event *mc_evt;
 	int ret = 0;
 
@@ -153,7 +153,7 @@ int get_mce_event(struct machine_check_e
 
 	/* Check if we have MCE info to process. */
 	if (index < MAX_MC_EVT) {
-		mc_evt = &__get_cpu_var(mce_event[index]);
+		mc_evt = __this_cpu_read(mce_event[index]);
 		/* Copy the event structure and release the original */
 		if (mce)
 			*mce = *mc_evt;
@@ -163,7 +163,7 @@ int get_mce_event(struct machine_check_e
 	}
 	/* Decrement the count to free the slot. */
 	if (release)
-		__get_cpu_var(mce_nest_count)--;
+		__this_cpu_dec(mce_nest_count);
 
 	return ret;
 }
@@ -184,13 +184,13 @@ void machine_check_queue_event(void)
 	if (!get_mce_event(&evt, MCE_EVENT_RELEASE))
 		return;
 
-	index = __get_cpu_var(mce_queue_count)++;
+	index = __this_cpu_inc_return(mce_queue_count);
 	/* If queue is full, just return for now. */
 	if (index >= MAX_MC_EVT) {
-		__get_cpu_var(mce_queue_count)--;
+		__this_cpu_dec(mce_queue_count);
 		return;
 	}
-	__get_cpu_var(mce_event_queue[index]) = evt;
+	__this_cpu_write(mce_event_queue[index], evt);
 
 	/* Queue irq work to process this event later. */
 	irq_work_queue(&mce_event_process_work);
@@ -208,11 +208,11 @@ static void machine_check_process_queued
 	 * For now just print it to console.
 	 * TODO: log this error event to FSP or nvram.
 	 */
-	while (__get_cpu_var(mce_queue_count) > 0) {
-		index = __get_cpu_var(mce_queue_count) - 1;
+	while (__this_cpu_read(mce_queue_count) > 0) {
+		index = __this_cpu_read(mce_queue_count) - 1;
 		machine_check_print_event_info(
-				&__get_cpu_var(mce_event_queue[index]));
-		__get_cpu_var(mce_queue_count)--;
+				this_cpu_ptr(&mce_event_queue[index]));
+		__this_cpu_dec(mce_queue_count);
 	}
 }
 
diff -puN arch/powerpc/kernel/time.c~powerpc-handle-new-__get_cpu_var-calls-in-314 arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-handle-new-__get_cpu_var-calls-in-314
+++ a/arch/powerpc/kernel/time.c
@@ -531,7 +531,7 @@ void timer_interrupt(struct pt_regs * re
 		*next_tb = ~(u64)0;
 		if (evt->event_handler)
 			evt->event_handler(evt);
-		__get_cpu_var(irq_stat).timer_irqs_event++;
+		__this_cpu_inc(irq_stat.timer_irqs_event);
 	} else {
 		now = *next_tb - now;
 		if (now <= DECREMENTER_MAX)
@@ -539,7 +539,7 @@ void timer_interrupt(struct pt_regs * re
 		/* We may have raced with new irq work */
 		if (test_irq_work_pending())
 			set_dec(1);
-		__get_cpu_var(irq_stat).timer_irqs_others++;
+		__this_cpu_inc(irq_stat.timer_irqs_others);
 	}
 
 #ifdef CONFIG_PPC64
diff -puN arch/powerpc/mm/hugetlbpage-book3e.c~powerpc-handle-new-__get_cpu_var-calls-in-314 arch/powerpc/mm/hugetlbpage-book3e.c
--- a/arch/powerpc/mm/hugetlbpage-book3e.c~powerpc-handle-new-__get_cpu_var-calls-in-314
+++ a/arch/powerpc/mm/hugetlbpage-book3e.c
@@ -33,7 +33,7 @@ static inline int tlb1_next(void)
 
 	ncams = mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY;
 
-	index = __get_cpu_var(next_tlbcam_idx);
+	index = this_cpu_read(next_tlbcam_idx);
 
 	/* Just round-robin the entries and wrap when we hit the end */
 	if (unlikely(index == ncams - 1))
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

