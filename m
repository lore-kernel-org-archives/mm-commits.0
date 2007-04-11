From: akpm@linux-foundation.org
Subject: + random-warning-squishes.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:35:05 -0700
Message-ID: <200704111935.l3BJZ5te012403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030185AbXDKTfU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     random warning squishes
has been added to the -mm tree.  Its filename is
     random-warning-squishes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: random warning squishes
From: Ingo Molnar <mingo@elte.hu>

grumble.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/efi.c      |    2 +-
 fs/isofs/namei.c            |    2 +-
 fs/jffs2/erase.c            |    2 +-
 ipc/sem.c                   |    2 +-
 kernel/audit.c              |    2 +-
 net/core/flow.c             |    2 +-
 net/sunrpc/svc.c            |    2 +-
 sound/core/control_compat.c |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/efi.c~random-warning-squishes arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~random-warning-squishes
+++ a/arch/i386/kernel/efi.c
@@ -278,7 +278,7 @@ void efi_memmap_walk(efi_freemem_callbac
 	struct range {
 		unsigned long start;
 		unsigned long end;
-	} prev, curr;
+	} prev = { } /* shut up gcc */ , curr = { } /* shut up gcc */ ;
 	efi_memory_desc_t *md;
 	unsigned long start, end;
 	void *p;
diff -puN fs/isofs/namei.c~random-warning-squishes fs/isofs/namei.c
--- a/fs/isofs/namei.c~random-warning-squishes
+++ a/fs/isofs/namei.c
@@ -158,7 +158,7 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long block = 0, offset = 0 /* avoid stupid gcc warning */;
 	struct inode *inode;
 	struct page *page;
 
diff -puN fs/jffs2/erase.c~random-warning-squishes fs/jffs2/erase.c
--- a/fs/jffs2/erase.c~random-warning-squishes
+++ a/fs/jffs2/erase.c
@@ -364,7 +364,7 @@ static void jffs2_mark_erased_block(stru
 {
 	size_t retlen;
 	int ret;
-	uint32_t bad_offset;
+	uint32_t bad_offset = 0 /* shut up gcc */;
 
 	switch (jffs2_block_check_erase(c, jeb, &bad_offset)) {
 	case -EAGAIN:	goto refile;
diff -puN ipc/sem.c~random-warning-squishes ipc/sem.c
--- a/ipc/sem.c~random-warning-squishes
+++ a/ipc/sem.c
@@ -858,7 +858,7 @@ static int semctl_down(struct ipc_namesp
 {
 	struct sem_array *sma;
 	int err;
-	struct sem_setbuf setbuf;
+	struct sem_setbuf setbuf = { /* shut up gcc warning */ };
 	struct kern_ipc_perm *ipcp;
 
 	memset(&setbuf, 0, sizeof(setbuf));
diff -puN kernel/audit.c~random-warning-squishes kernel/audit.c
--- a/kernel/audit.c~random-warning-squishes
+++ a/kernel/audit.c
@@ -969,7 +969,7 @@ struct audit_buffer *audit_log_start(str
 {
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
-	unsigned int		serial;
+	unsigned int		serial = 0 /* shut up gcc */;
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
diff -puN net/core/flow.c~random-warning-squishes net/core/flow.c
--- a/net/core/flow.c~random-warning-squishes
+++ a/net/core/flow.c
@@ -172,7 +172,7 @@ static int flow_key_compare(struct flowi
 void *flow_cache_lookup(struct flowi *key, u16 family, u8 dir,
 			flow_resolve_t resolver)
 {
-	struct flow_cache_entry *fle, **head;
+	struct flow_cache_entry *fle, **head = NULL /* shut up GCC */;
 	unsigned int hash;
 	int cpu;
 
diff -puN net/sunrpc/svc.c~random-warning-squishes net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~random-warning-squishes
+++ a/net/sunrpc/svc.c
@@ -547,7 +547,7 @@ __svc_create_thread(svc_thread_fn func, 
 	struct svc_rqst	*rqstp;
 	int		error = -ENOMEM;
 	int		have_oldmask = 0;
-	cpumask_t	oldmask;
+	cpumask_t	oldmask = CPU_MASK_NONE /* shut up GCC */;
 
 	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
 	if (!rqstp)
diff -puN sound/core/control_compat.c~random-warning-squishes sound/core/control_compat.c
--- a/sound/core/control_compat.c~random-warning-squishes
+++ a/sound/core/control_compat.c
@@ -219,7 +219,7 @@ static int copy_ctl_value_from_user(stru
 				    struct snd_ctl_elem_value32 __user *data32,
 				    int *typep, int *countp)
 {
-	int i, type, count, size;
+	int i, type, count = 0 /* shut up gcc warning */, size;
 	unsigned int indirect;
 
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-improve-napi-logic.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-clean-up-paravirt-patchable-wrappers.patch
paravirt_ops-add-common-patching-machinery.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
forcedeth-work-around-null-skb-dereference-crash.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
enhance-initcall_debug-measure-latency.patch
simplify-kallsyms_lookup.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
kthread-dont-depend-on-work-queues.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
