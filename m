From: akpm@linux-foundation.org
Subject: + natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch added to -mm tree
Date: Thu, 03 May 2007 13:02:00 -0700
Message-ID: <200705032002.l43K20P4018664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbXECUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, broonie@sirena.org.uk, jeff@garzik.org, thockin@hockin.org


The patch titled
     natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix
has been added to the -mm tree.  Its filename is
     natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix
From: Andrew Morton <akpm@linux-foundation.org>

whitespace bustage

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/net/natsemi.c~natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix
+++ a/drivers/net/natsemi.c
@@ -661,13 +661,13 @@ static int netdev_get_regs(struct net_de
 static int netdev_get_eeprom(struct net_device *dev, u8 *buf);
 static const struct ethtool_ops ethtool_ops;
 
-#define NATSEMI_ATTR(_name) \
-static ssize_t natsemi_show_##_name(struct device *dev, \
-         struct device_attribute *attr, char *buf); \
-	 static ssize_t natsemi_set_##_name(struct device *dev, \
-		struct device_attribute *attr, \
-	        const char *buf, size_t count); \
-	 static DEVICE_ATTR(_name, 0644, natsemi_show_##_name, natsemi_set_##_name)
+#define NATSEMI_ATTR(_name)						\
+static ssize_t natsemi_show_##_name(struct device *dev,			\
+	struct device_attribute *attr, char *buf);			\
+	static ssize_t natsemi_set_##_name(struct device *dev,		\
+		struct device_attribute *attr,				\
+		const char *buf, size_t count);				\
+	static DEVICE_ATTR(_name, 0644, natsemi_show_##_name, natsemi_set_##_name)
 
 #define NATSEMI_CREATE_FILE(_dev, _name) \
          device_create_file(&_dev->dev, &dev_attr_##_name)
@@ -693,14 +693,14 @@ static ssize_t natsemi_set_dspcfg_workar
 	int new_setting;
 	u32 flags;
 
-        /* Find out the new setting */
-        if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
-                new_setting = 1;
-        else if (!strncmp("off", buf, count - 1)
-                 || !strncmp("0", buf, count - 1))
+	/* Find out the new setting */
+	if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
+		new_setting = 1;
+	else if (!strncmp("off", buf, count - 1) ||
+			!strncmp("0", buf, count - 1))
 		new_setting = 0;
 	else
-                 return count;
+		return count;
 
 	spin_lock_irqsave(&np->lock, flags);
 
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
zlib-backout.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
git-drm.patch
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
git-wireless.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
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
