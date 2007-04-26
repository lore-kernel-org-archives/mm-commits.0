From: akpm@linux-foundation.org
Subject: - applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:13:45 -0700
Message-ID: <200704260713.l3Q7DjmK023503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933166AbXDZHOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khali@linux-fr.org, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix
has been removed from the -mm tree.  Its filename was
     applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix
+++ a/drivers/hwmon/applesmc.c
@@ -117,7 +117,7 @@ struct dmi_match_data {
 	int temperature_set;
 };
 
-static const int debug = 0;
+static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
@@ -752,9 +752,8 @@ static void applesmc_brightness_set(stru
 	backlight_value = value;
 	ret = queue_work(applesmc_led_wq, &backlight_work);
 
-	if (debug && (!ret)) {
+	if (debug && (!ret))
 		printk(KERN_DEBUG "applesmc: work was already on the queue.\n");
-	}
 }
 
 static ssize_t applesmc_key_count_show(struct device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agp-build-fix.patch
git-cpufreq-borkage-fix.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
fix-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
dev_dbg-check-dev_dbg-arguments.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
apple-smc-driver-hardware-monitoring-and-control.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-gfs2-nmw.patch
gfs2-printk-warning-fixes.patch
git-ieee1394.patch
sbp2-include-fixes.patch
fw-device-printk-fix.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-mtd-build-fix.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-export-ieee80211_debug_level.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
sctp_getsockopt_local_addrs-type-fix.patch
git-net-fix-yamc.patch
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
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api-fix.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
git-block-fixup.patch
cxacru-add-documentation-file-fix.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface-fix-fix.patch
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
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
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
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
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
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-build-hack.patch
lguest-build-hack-2.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
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
