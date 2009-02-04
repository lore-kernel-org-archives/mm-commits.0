From: akpm@linux-foundation.org
Subject: [folded] sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix.patch removed from -mm tree
Date: Wed, 04 Feb 2009 15:09:33 -0800
Message-ID: <200902042309.n14N9XIu017196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbZBDXJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 18:09:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, R.E.Wolff@BitWizard.nl, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix
has been removed from the -mm tree.  Its filename was
     sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix.patch

This patch was dropped because it was folded into sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix another such path - missed func_exit().

Cc: Dan Carpenter <error27@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix
+++ a/drivers/char/sx.c
@@ -1713,8 +1713,8 @@ static long sx_fw_ioctl(struct file *fil
 		for (i = 0; i < SX_NBOARDS; i++)
 			sx_dprintk(SX_DEBUG_FIRMWARE, "<%x> ", boards[i].flags);
 		sx_dprintk(SX_DEBUG_FIRMWARE, "\n");
-		unlock_kernel();
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 
 	switch (cmd) {
@@ -1845,6 +1845,7 @@ static long sx_fw_ioctl(struct file *fil
 		rc = -ENOTTY;
 		break;
 	}
+out:
 	unlock_kernel();
 	func_exit();
 	return rc;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
early-platform-driver-v3-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage-checkpatch-fixes.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-constify-pci_bus_assign_resources.patch
pci-constify-pci_bus_add_devices.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-fix-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
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

