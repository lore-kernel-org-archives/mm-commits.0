From: akpm@linux-foundation.org
Subject: + synclink_gt-add-compat_ioctl-fix.patch added to -mm tree
Date: Thu, 03 May 2007 17:53:16 -0700
Message-ID: <200705040053.l440rGOB026170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767561AbXEDAx0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 20:53:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, paulkf@microgate.com


The patch titled
     synclink_gt-add-compat_ioctl-fix
has been added to the -mm tree.  Its filename is
     synclink_gt-add-compat_ioctl-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink_gt-add-compat_ioctl-fix
From: Andrew Morton <akpm@linux-foundation.org>

- Fix i386 build:

In file included from drivers/char/synclink_gt.c:85:
include/linux/synclink.h:175: error: expected specifier-qualifier-list before 'compat_ulong_t'

- We might as well do the same ifdef-avoidery trick around compat_ioctl()
  too.  That required that it be renamed.

- It is fishy that apart from out outlier in kexec.h, synclink.h is the
  only header file which uses compat_ulong_t.  Are we doing this right?

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   16 +++++++++-------
 include/linux/synclink.h   |    5 +++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl-fix drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl-fix
+++ a/drivers/char/synclink_gt.c
@@ -1176,15 +1176,16 @@ static int ioctl(struct tty_struct *tty,
 }
 
 #ifdef CONFIG_COMPAT
-static long compat_ioctl(struct tty_struct *tty, struct file *file,
+static long synclink_compat_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
 	int rc = -ENOIOCTLCMD;
 
-	if (sanity_check(info, tty->name, "compat_ioctl"))
+	if (sanity_check(info, tty->name, "synclink_compat_ioctl"))
 		return -ENODEV;
-	DBGINFO(("%s compat_ioctl() cmd=%08X\n", info->device_name, cmd));
+	DBGINFO(("%s synclink_compat_ioctl() cmd=%08X\n",
+		info->device_name, cmd));
 
 	switch (cmd) {
 
@@ -1219,9 +1220,12 @@ static long compat_ioctl(struct tty_stru
 		break;
 	}
 
-	DBGINFO(("%s compat_ioctl() cmd=%08X rc=%d\n", info->device_name, cmd, rc));
+	DBGINFO(("%s synclink_compat_ioctl() cmd=%08X rc=%d\n",
+		info->device_name, cmd, rc));
 	return rc;
 }
+#else
+#define synclink_compat_ioctl NULL
 #endif
 
 /*
@@ -3554,9 +3558,7 @@ static const struct tty_operations ops =
 	.chars_in_buffer = chars_in_buffer,
 	.flush_buffer = flush_buffer,
 	.ioctl = ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = compat_ioctl,
-#endif
+	.compat_ioctl = synclink_compat_ioctl,
 	.throttle = throttle,
 	.unthrottle = unthrottle,
 	.send_xchar = send_xchar,
diff -puN include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix include/linux/synclink.h
--- a/include/linux/synclink.h~synclink_gt-add-compat_ioctl-fix
+++ a/include/linux/synclink.h
@@ -169,9 +169,9 @@ typedef struct _MGSL_PARAMS
 
 } MGSL_PARAMS, *PMGSL_PARAMS;
 
+#ifdef CONFIG_COMPAT
 /* provide 32 bit ioctl compatibility on 64 bit systems */
-struct MGSL_PARAMS32
-{
+struct MGSL_PARAMS32 {
 	compat_ulong_t	mode;
 	unsigned char	loopback;
 	unsigned short	flags;
@@ -186,6 +186,7 @@ struct MGSL_PARAMS32
 	unsigned char	stop_bits;
 	unsigned char	parity;
 };
+#endif
 
 #define MICROGATE_VENDOR_ID 0x13c0
 #define SYNCLINK_DEVICE_ID 0x0010
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
git-drm.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-nfs.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
fix-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
do_tty_write-can-block-even-with-o_nonblock-tidy.patch
tty-add-compat_ioctl-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
rename-thread_info-to-stack-fix.patch
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
w1-build-fix.patch
