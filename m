From: akpm@linux-foundation.org
Subject: + remove-protection-of-lanana-reserved-majors.patch added to -mm tree
Date: Wed, 04 Apr 2007 10:49:07 -0700
Message-ID: <200704041749.l34Hn7NJ026597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXDDRt3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 13:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     remove protection of LANANA-reserved majors
has been added to the -mm tree.  Its filename is
     remove-protection-of-lanana-reserved-majors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove protection of LANANA-reserved majors
From: Andrew Morton <akpm@linux-foundation.org>

Revert all this.  It can cause device-mapper to receive a different major from
earlier kernels and it turns out that the Amanda backup program checks major
numbers on files when performing incremental backups.

Which is a bit broken of Amanda, but this feature isn't important enough to
justify the churn.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c          |    2 --
 drivers/base/core.c    |   14 --------------
 fs/char_dev.c          |    2 --
 include/linux/kdev_t.h |    2 --
 4 files changed, 20 deletions(-)

diff -puN drivers/base/core.c~remove-protection-of-lanana-reserved-majors drivers/base/core.c
--- a/drivers/base/core.c~remove-protection-of-lanana-reserved-majors
+++ a/drivers/base/core.c
@@ -28,20 +28,6 @@ int (*platform_notify)(struct device * d
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
 /*
- * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
- */
-bool is_lanana_major(unsigned int major)
-{
-	if (major >= 60 && major <= 63)
-		return 1;
-	if (major >= 120 && major <= 127)
-		return 1;
-	if (major >= 240 && major <= 254)
-		return 1;
-	return 0;
-}
-
-/*
  * sysfs bindings for devices.
  */
 
diff -puN block/genhd.c~remove-protection-of-lanana-reserved-majors block/genhd.c
--- a/block/genhd.c~remove-protection-of-lanana-reserved-majors
+++ a/block/genhd.c
@@ -62,8 +62,6 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			if (is_lanana_major(index))
-				continue;
 			if (major_names[index] == NULL)
 				break;
 		}
diff -puN fs/char_dev.c~remove-protection-of-lanana-reserved-majors fs/char_dev.c
--- a/fs/char_dev.c~remove-protection-of-lanana-reserved-majors
+++ a/fs/char_dev.c
@@ -109,8 +109,6 @@ __register_chrdev_region(unsigned int ma
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
-			if (is_lanana_major(i))
-				continue;
 			if (chrdevs[i] == NULL)
 				break;
 		}
diff -puN include/linux/kdev_t.h~remove-protection-of-lanana-reserved-majors include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~remove-protection-of-lanana-reserved-majors
+++ a/include/linux/kdev_t.h
@@ -87,8 +87,6 @@ static inline unsigned sysv_minor(u32 de
 	return dev & 0x3ffff;
 }
 
-bool is_lanana_major(unsigned int major);
-
 #else /* __KERNEL__ */
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-driver-core-do-not-wait-unnecessarily-in-driver_unregister.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
git-parisc.patch
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
utrace-x86_64-fix.patch
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
remove-protection-of-lanana-reserved-majors.patch
