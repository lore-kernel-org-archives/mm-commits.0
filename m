From: akpm@linux-foundation.org
Subject: - deprecate-sa_interrupt-and-friends.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:13:27 -0700
Message-ID: <200704062013.l36KDRa2017970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbXDFUNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     deprecate SA_INTERRUPT and friends
has been removed from the -mm tree.  Its filename was
     deprecate-sa_interrupt-and-friends.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: deprecate SA_INTERRUPT and friends
From: Andrew Morton <akpm@linux-foundation.org>

Do ridiculous things to force a deprecated warning when someone uses one of
the old SA_* flags.  We can remove all this in six months or so.  To give all
those out-of-tree drivers time to catch up.

It'll cause build errors if someone is using SA_foo in a static initialiser,
but the fix for that is to use IRQF_foo.

Based on an idea from tglx.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    2 -
 ia64/kernel/irq_ia64.c                     |    0 
 include/linux/interrupt.h                  |   37 +++++++++++++------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-sa_interrupt-and-friends Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-sa_interrupt-and-friends
+++ a/Documentation/feature-removal-schedule.txt
@@ -171,7 +171,7 @@ Who:	Greg Kroah-Hartman <gregkh@suse.de>
 ---------------------------
 
 What:	Interrupt only SA_* flags
-When:	Januar 2007
+When:	August 2007
 Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
 	out of the signal namespace.
 
diff -puN include/linux/interrupt.h~deprecate-sa_interrupt-and-friends include/linux/interrupt.h
--- a/include/linux/interrupt.h~deprecate-sa_interrupt-and-friends
+++ a/include/linux/interrupt.h
@@ -57,17 +57,32 @@
  * Migration helpers. Scheduled for removal in 1/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+#define emit_old_interrupt_name(old, new)				\
+static inline unsigned __deprecated emit_old_interrupt_name_##old(void)	\
+{									\
+	return (new);							\
+}
+
+emit_old_interrupt_name(SA_INTERRUPT, IRQF_DISABLED)
+#define SA_INTERRUPT emit_old_interrupt_name_SA_INTERRUPT()
+emit_old_interrupt_name(SA_SAMPLE_RANDOM, IRQF_SAMPLE_RANDOM)
+#define SA_SAMPLE_RANDOM emit_old_interrupt_name_SA_SAMPLE_RANDOM()
+emit_old_interrupt_name(SA_SHIRQ, IRQF_SHARED)
+#define SA_SHIRQ emit_old_interrupt_name_SA_SHIRQ()
+emit_old_interrupt_name(SA_PROBEIRQ, IRQF_PROBE_SHARED)
+#define SA_PROBEIRQ emit_old_interrupt_name_SA_PROBEIRQ()
+emit_old_interrupt_name(SA_PERCPU, IRQF_PERCPU)
+#define SA_PERCPU emit_old_interrupt_name_SA_PERCPU()
+emit_old_interrupt_name(SA_TRIGGER_LOW, IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_LOW emit_old_interrupt_name_SA_TRIGGER_LOW()
+emit_old_interrupt_name(SA_TRIGGER_HIGH, IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_HIGH emit_old_interrupt_name_SA_TRIGGER_HIGH()
+emit_old_interrupt_name(SA_TRIGGER_FALLING, IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_FALLING emit_old_interrupt_name_SA_TRIGGER_FALLING()
+emit_old_interrupt_name(SA_TRIGGER_RISING, IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_RISING emit_old_interrupt_name_SA_TRIGGER_RISING()
+emit_old_interrupt_name(SA_TRIGGER_MASK, IRQF_TRIGGER_MASK)
+#define SA_TRIGGER_MASK emit_old_interrupt_name_SA_TRIGGER_MASK()
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
diff -puN arch/ia64/kernel/irq_ia64.c~deprecate-sa_interrupt-and-friends arch/ia64/kernel/irq_ia64.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
revert-driver-core-do-not-wait-unnecessarily-in-driver_unregister.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-hid-vs-git-input.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-ocfs2.patch
git-parisc.patch
git-r8169-fixup.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
driver_bfin_serial_core-update.patch
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
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
