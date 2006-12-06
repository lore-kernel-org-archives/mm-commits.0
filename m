From: akpm@osdl.org
Subject: - i386-kernel-smpc-dont-use-set_irq_regs.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:18 -0800
Message-ID: <200612062224.kB6MOIuM018608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937708AbWLFWZ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:25:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ak@suse.de, dhowells@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386/kernel/smp.c: don't use set_irq_regs()
has been removed from the -mm tree.  Its filename was
     i386-kernel-smpc-dont-use-set_irq_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386/kernel/smp.c: don't use set_irq_regs()
From: Oleg Nesterov <oleg@tv-sign.ru>

We don't need to setup _irq_regs in smp_xxx_interrupt (except apic timer).
These handlers run with irqs disabled and do not call functions which need
"struct pt_regs".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smp.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN arch/i386/kernel/smp.c~i386-kernel-smpc-dont-use-set_irq_regs arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~i386-kernel-smpc-dont-use-set_irq_regs
+++ a/arch/i386/kernel/smp.c
@@ -322,7 +322,6 @@ static inline void leave_mm (unsigned lo
 
 fastcall void smp_invalidate_interrupt(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	unsigned long cpu;
 
 	cpu = get_cpu();
@@ -353,7 +352,6 @@ fastcall void smp_invalidate_interrupt(s
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
-	set_irq_regs(old_regs);
 }
 
 static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
@@ -608,14 +606,11 @@ void smp_send_stop(void)
  */
 fastcall void smp_reschedule_interrupt(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	ack_APIC_irq();
-	set_irq_regs(old_regs);
 }
 
 fastcall void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	void (*func) (void *info) = call_data->func;
 	void *info = call_data->info;
 	int wait = call_data->wait;
@@ -639,7 +634,6 @@ fastcall void smp_call_function_interrup
 		mb();
 		atomic_inc(&call_data->finished);
 	}
-	set_irq_regs(old_regs);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

taskstats_exit_alloc-optimize-simplify.patch
taskstats-cleanup-do_exit-path.patch
taskstats-cleanup-signal-stats-allocation.patch
taskstats-factor-out-reply-assembling.patch
taskstats-use-nla_reserve-for-reply-assembling.patch
taskstats-cleanup-reply-assembling.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
pidhash-temporary-debug-checks.patch

