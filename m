From: akpm@linux-foundation.org
Subject: - bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:35:39 -0800
Message-ID: <200812012235.mB1MZdmc021525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbYLAWfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dwmw2@infradead.org, jacmet@sunsite.dk, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     bdi-register-sysfs-bdi-device-only-once-per-queue-fix
has been removed from the -mm tree.  Its filename was
     bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch

This patch was dropped because it was folded into bdi-register-sysfs-bdi-device-only-once-per-queue.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bdi-register-sysfs-bdi-device-only-once-per-queue-fix
From: Andrew Morton <akpm@linux-foundation.org>

Add a WARN_ON so we know which drivers are misbehaving.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue-fix mm/backing-dev.c
--- a/mm/backing-dev.c~bdi-register-sysfs-bdi-device-only-once-per-queue-fix
+++ a/mm/backing-dev.c
@@ -176,7 +176,7 @@ int bdi_register(struct backing_dev_info
 	int ret = 0;
 	struct device *dev;
 
-	if (bdi->dev)
+	if (WARN_ON(bdi->dev))
 		goto exit;
 
 	va_start(args, fmt);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-introduce-resource-usage-limits.patch
ntfs-dont-fool-kernel-doc.patch
drivers-gpu-drm-i915-i915_irqc-fix-warning.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events.patch
bdi-register-sysfs-bdi-device-only-once-per-queue.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

