From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:28 -0800
Message-ID: <200901301914.n0UJESHS027433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZA3TRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, daniel@ffwll.ch, eric@anholt.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/i915/intel_lvds.c: fix locking snafu
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/i915/intel_lvds.c: fix locking snafu
From: Andrew Morton <akpm@linux-foundation.org>

s/unlock/lock/

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12575

Reported-by: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@linux.ie>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -311,7 +311,7 @@ static int intel_lvds_get_modes(struct d
 	if (dev_priv->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode;
 
-		mutex_unlock(&dev->mode_config.mutex);
+		mutex_lock(&dev->mode_config.mutex);
 		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
 		drm_mode_probed_add(connector, mode);
 		mutex_unlock(&dev->mode_config.mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation-checkpatch-fixes.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
kvm-unbork.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
drivers-ata-sata_silc-needs-dmih.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

