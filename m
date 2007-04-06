From: akpm@linux-foundation.org
Subject: + kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch added to -mm tree
Date: Fri, 06 Apr 2007 14:46:37 -0700
Message-ID: <200704062146.l36LkbTG019858@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbXDFVqw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 17:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ananth@in.ibm.com, srinivasa@in.ibm.com


The patch titled
     kprobes-the-on-off-knob-thru-debugfs-updated-fix
has been added to the -mm tree.  Its filename is
     kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kprobes-the-on-off-knob-thru-debugfs-updated-fix
From: Andrew Morton <akpm@linux-foundation.org>

Use bool like a bool!

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated-fix
+++ a/kernel/kprobes.c
@@ -568,7 +568,7 @@ static int __kprobes __register_kprobe(s
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (kprobe_enabled == 1) {
+	if (kprobe_enabled) {
 		if (atomic_add_return(1, &kprobe_count) == \
 				(ARCH_INACTIVE_KPROBE_COUNT + 1))
 			register_page_fault_notifier(&kprobe_page_fault_nb);
@@ -620,7 +620,7 @@ valid_p:
 		 * enabled - otherwise, the breakpoint would already have
 		 * been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled == 1)
+		if (kprobe_enabled)
 			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 		cleanup_p = 1;
@@ -811,7 +811,7 @@ static int __init init_kprobes(void)
 	atomic_set(&kprobe_count, 0);
 
 	/* By default, kprobes are enabled */
-	kprobe_enabled = 1;
+	kprobe_enabled = true;
 
 	err = arch_init_kprobes();
 	if (!err)
@@ -911,7 +911,7 @@ static void __kprobes enable_all_kprobes
 	mutex_lock(&kprobe_mutex);
 
 	/* If kprobes are already enabled, just return */
-	if (kprobe_enabled == 1)
+	if (kprobe_enabled)
 		goto already_enabled;
 
 	/*
@@ -927,7 +927,7 @@ static void __kprobes enable_all_kprobes
 			arch_arm_kprobe(p);
 	}
 
-	kprobe_enabled = 1;
+	kprobe_enabled = true;
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -944,10 +944,10 @@ static void __kprobes disable_all_kprobe
 	mutex_lock(&kprobe_mutex);
 
 	/* If kprobes are already disabled, just return */
-	if (kprobe_enabled == 0)
+	if (!kprobe_enabled)
 		goto already_disabled;
 
-	kprobe_enabled = 0;
+	kprobe_enabled = false;
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-avr32.patch
git-avr32-fixup.patch
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
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
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
