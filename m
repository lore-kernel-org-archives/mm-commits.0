From: akpm@linux-foundation.org
Subject: - andi-hack-debug.patch removed from -mm tree
Date: Sat, 21 Apr 2007 23:53:35 -0700
Message-ID: <200704220656.l3M6uBdp021459@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964974AbXDVG4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 02:56:14 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l3M6uBpg022677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 21 Apr 2007 23:56:12 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     a
has been removed from the -mm tree.  Its filename was
     andi-hack-debug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: a
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |    9 ++
 arch/i386/kernel/sched-clock.c                    |   39 +++++++++++-
 arch/i386/kernel/tsc.c                            |   23 +++++--
 drivers/cpufreq/cpufreq.c                         |   17 +++++
 kernel/sys.c                                      |    9 ++
 5 files changed, 90 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/sched-clock.c~a arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c~a
+++ a/arch/i386/kernel/sched-clock.c
@@ -13,6 +13,8 @@
 #include <asm/cpufeature.h>
 #include <asm/timer.h>
 
+#define D() printk("%s:%d\n", __FILE__, __LINE__)
+
 /*
  * convert from cycles(64bits) => nanoseconds (64bits)
  *  basic equation:
@@ -80,16 +82,22 @@ unsigned long long sched_clock(void)
 /* Resync with new CPU frequency */
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
+	D();
 	if (!cpu_has_tsc) {
+		D();
 		sc->instable = 1;
 		return;
 	}
+	D();
 	/* RED-PEN protect with seqlock? I hope that's not needed
 	   because sched_clock callers should be able to tolerate small
 	   errors. */
 	sc->ns_base = ktime_to_ns(ktime_get());
+	D();
 	get_scheduled_cycles(sc->last_tsc);
+	D();
 	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / newfreq;
+	D();
 	sc->instable = 0;
 }
 
@@ -97,10 +105,16 @@ static void call_r_s_f(void *arg)
 {
 	struct cpufreq_freqs *freq = arg;
 	unsigned f = freq->new;
-	if (!f)
+	D();
+	if (!f) {
+		D();
 		f = cpufreq_get(freq->cpu);
-	if (!f)
+	}
+	if (!f) {
+		D();
 		f = tsc_khz;
+	}
+	D();
 	resync_sc_freq(&per_cpu(sc_data, freq->cpu), f);
 }
 
@@ -111,20 +125,27 @@ static int sc_freq_event(struct notifier
 	int cpu = get_cpu();
 	struct sc_data *sc = &per_cpu(sc_data, cpu);
 
+	D();
 	if (cpu_has(&cpu_data[cpu], X86_FEATURE_CONSTANT_TSC))
 		return NOTIFY_DONE;
+	D();
 	if (freq->old == freq->new)
 		return NOTIFY_DONE;
 
+	D();
 	switch (event) {
 	case CPUFREQ_RESUMECHANGE:  /* needed? */
+	D();
 	case CPUFREQ_PRECHANGE:
+	D();
 		/* Mark TSC as instable until cpu frequency change is done
 		   because we don't know when exactly it will change */
 		sc->instable = 1;
 		break;
 	case CPUFREQ_SUSPENDCHANGE:
+	D();
 	case CPUFREQ_POSTCHANGE:
+	D();
 		/* Frequency change is done -- update everything and
 		   mark TSC as stable again. */
 		if (cpu == freq->cpu)
@@ -135,7 +156,10 @@ static int sc_freq_event(struct notifier
 		break;
 	/* resume/suspend ?? */
 	}
+	D();
 	put_cpu();
+	D();
+	dump_stack();
 	return NOTIFY_DONE;
 }
 
@@ -147,10 +171,14 @@ static int __cpuinit
 sc_cpu_event(struct notifier_block *self, unsigned long event, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	D();
 	if (event == CPU_ONLINE) {
 		struct cpufreq_freqs f = { .cpu = cpu, .new = 0 };
+	D();
 		smp_call_function_single(cpu, call_r_s_f, &f, 0, 1);
+	D();
 	}
+	D();
 	return NOTIFY_DONE;
 }
 
@@ -162,14 +190,21 @@ static __init int init_sched_clock(void)
 {
 	int i;
 	struct cpufreq_freqs f = { .cpu = get_cpu(), .new = 0 };
+	D();
 	for_each_possible_cpu (i)
 		per_cpu(sc_data, i).instable = 1;
+	D();
 	WARN_ON(num_online_cpus() > 1);
+	D();
 	call_r_s_f(&f);
+	D();
 	put_cpu();
+	D();
 	register_cpu_notifier(&sc_cpu_notifier);
+	D();
 	cpufreq_register_notifier(&sc_freq_notifier,
 				 CPUFREQ_TRANSITION_NOTIFIER);
+	D();
 	return 0;
 }
 core_initcall(init_sched_clock);
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c~a arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c~a
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -34,6 +34,8 @@
 #define PFX		"speedstep-centrino: "
 #define MAINTAINER	"cpufreq@lists.linux.org.uk"
 
+#define D() printk("%s:%d\n", __FILE__, __LINE__)
+
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
 
 #define INTEL_MSR_RANGE	(0xffff)
@@ -749,8 +751,10 @@ static int centrino_target (struct cpufr
 
 			for_each_cpu_mask(k, online_policy_cpus) {
 				freqs.cpu = k;
+				D();
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
+				D();
 			}
 
 			first_cpu = 0;
@@ -769,7 +773,9 @@ static int centrino_target (struct cpufr
 
 	for_each_cpu_mask(k, online_policy_cpus) {
 		freqs.cpu = k;
+		D();
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+		D();
 	}
 
 	if (unlikely(retval)) {
@@ -792,8 +798,11 @@ static int centrino_target (struct cpufr
 		freqs.old = tmp;
 		for_each_cpu_mask(j, online_policy_cpus) {
 			freqs.cpu = j;
+			D();
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+			D();
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+			D();
 		}
 	}
 
diff -puN drivers/cpufreq/cpufreq.c~a drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~a
+++ a/drivers/cpufreq/cpufreq.c
@@ -32,6 +32,8 @@
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_CORE, \
 						"cpufreq-core", msg)
 
+#define D() printk("%s:%d\n", __FILE__, __LINE__)
+
 /**
  * The "cpufreq driver" - the arch- or hardware-dependent low
  * level driver of CPUFreq support, and its spinlock. This lock
@@ -302,6 +304,7 @@ static inline void adjust_jiffies(unsign
 }
 #endif
 
+extern int akpm;
 
 /**
  * cpufreq_notify_transition - call notifier chain and adjust_jiffies
@@ -317,11 +320,14 @@ void cpufreq_notify_transition(struct cp
 
 	BUG_ON(irqs_disabled());
 
+	D();
+
 	freqs->flags = cpufreq_driver->flags;
 	dprintk("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
 	policy = cpufreq_cpu_data[freqs->cpu];
+	D();
 	switch (state) {
 
 	case CPUFREQ_PRECHANGE:
@@ -329,6 +335,7 @@ void cpufreq_notify_transition(struct cp
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
 		 */
+		D();
 		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
 			if ((policy) && (policy->cpu == freqs->cpu) &&
 			    (policy->cur) && (policy->cur != freqs->old)) {
@@ -338,19 +345,29 @@ void cpufreq_notify_transition(struct cp
 				freqs->old = policy->cur;
 			}
 		}
+		D();
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_PRECHANGE, freqs);
+		D();
 		adjust_jiffies(CPUFREQ_PRECHANGE, freqs);
+		D();
 		break;
 
 	case CPUFREQ_POSTCHANGE:
+		D();
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
+		D();
+		akpm = 1;
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
+		akpm = 0;
+		D();
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
 			policy->cur = freqs->new;
+		D();
 		break;
 	}
+	D();
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 
diff -puN kernel/sys.c~a kernel/sys.c
--- a/kernel/sys.c~a
+++ a/kernel/sys.c
@@ -20,6 +20,7 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/key.h>
+#include <linux/kallsyms.h>
 #include <linux/times.h>
 #include <linux/posix-timers.h>
 #include <linux/security.h>
@@ -134,6 +135,9 @@ static int notifier_chain_unregister(str
 	return -ENOENT;
 }
 
+int akpm;
+EXPORT_SYMBOL(akpm);
+
 static int __kprobes notifier_call_chain(struct notifier_block **nl,
 		unsigned long val, void *v)
 {
@@ -143,6 +147,11 @@ static int __kprobes notifier_call_chain
 	nb = rcu_dereference(*nl);
 	while (nb) {
 		next_nb = rcu_dereference(nb->next);
+		if (akpm) {
+			printk("%s: call ", __FUNCTION__);
+			print_symbol("%s\n", (unsigned long)
+				nb->notifier_call);
+		}
 		ret = nb->notifier_call(nb, val, v);
 		if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)
 			break;
diff -puN arch/i386/kernel/tsc.c~a arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~a
+++ a/arch/i386/kernel/tsc.c
@@ -139,47 +139,60 @@ static unsigned int ref_freq = 0;
 static unsigned long loops_per_jiffy_ref = 0;
 static unsigned long cpu_khz_ref = 0;
 
+#define D() printk("%s:%d\n", __FILE__, __LINE__)
+
 static int
 time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
 {
 	struct cpufreq_freqs *freq = data;
 
+	D();
 	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
 		write_seqlock_irq(&xtime_lock);
+	D();
 
 	if (!ref_freq) {
 		if (!freq->old){
 			ref_freq = freq->new;
+			D();
 			goto end;
 		}
 		ref_freq = freq->old;
 		loops_per_jiffy_ref = cpu_data[freq->cpu].loops_per_jiffy;
 		cpu_khz_ref = cpu_khz;
+		D();
 	}
-
+	D();
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
 	    (val == CPUFREQ_RESUMECHANGE)) {
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
+			D();
 			cpu_data[freq->cpu].loops_per_jiffy =
 				cpufreq_scale(loops_per_jiffy_ref,
 						ref_freq, freq->new);
-
+		D();
 		if (cpu_khz) {
-
-			if (num_online_cpus() == 1)
+			D();
+			if (num_online_cpus() == 1) {
+				D();
 				cpu_khz = cpufreq_scale(cpu_khz_ref,
 						ref_freq, freq->new);
+				D();
+			}
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
+				D();
 				tsc_khz = cpu_khz;
 				mark_tsc_unstable("cpufreq changes");
+				D();
 			}
 		}
 	}
+	D();
 end:
 	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
 		write_sequnlock_irq(&xtime_lock);
-
+	D();
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
taskstats-fix-the-structure-members-alignment-issue-fix.patch
acpi-thermal-fix-mod_timer-interval.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
device_schedule_callback-needs-a-module-reference-fix.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
cxacru-add-documentation-file-fix.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
git-wireless-vs-git-net-3.patch
fix-x86_64-mm-fam10-mwait-idle.patch
more-fix-x86_64-mm-fam10-mwait-idle.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability-fix-fix.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
mm-bdi-init-hooks-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
