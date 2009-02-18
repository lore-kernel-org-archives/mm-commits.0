From: akpm@linux-foundation.org
Subject: [folded] lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 18 Feb 2009 13:58:22 -0800
Message-ID: <200902182158.n1ILwMIf006376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721AbZBRWBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 17:01:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Eric.Piel@tremplin-utc.net, giuseppe.bilotta@gmail.com, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch

This patch was dropped because it was folded into lis3lv02d-support-both-one-and-two-byte-sensors.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: switch and case should be at the same indent
#65: FILE: drivers/hwmon/hp_accel.c:249:
+	switch (adev.whoami) {
+		case LIS_DOUBLE_ID:
[...]
+		case LIS_SINGLE_ID:
[...]
+		default:

WARNING: line over 80 characters
#131: FILE: drivers/hwmon/lis3lv02d.c:221:
+	input_set_abs_params(adev.idev, ABS_X, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);

WARNING: line over 80 characters
#132: FILE: drivers/hwmon/lis3lv02d.c:222:
+	input_set_abs_params(adev.idev, ABS_Y, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);

WARNING: line over 80 characters
#133: FILE: drivers/hwmon/lis3lv02d.c:223:
+	input_set_abs_params(adev.idev, ABS_Z, -adev.mdps_max_val, adev.mdps_max_val, 3, 3);

WARNING: line over 80 characters
#177: FILE: drivers/hwmon/lis3lv02d.h:168:
+	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */

total: 1 errors, 4 warnings, 141 lines checked

./patches/lis3lv02d-support-both-one-and-two-byte-sensors.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes
+++ a/drivers/hwmon/hp_accel.c
@@ -271,20 +271,20 @@ static int lis3lv02d_add(struct acpi_dev
 
 	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &adev.whoami);
 	switch (adev.whoami) {
-		case LIS_DOUBLE_ID:
-			printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
-			adev.read_data = lis3lv02d_read_16;
-			adev.mdps_max_val = 2048;
-			break;
-		case LIS_SINGLE_ID:
-			printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
-			adev.read_data = lis3lv02d_read_8;
-			adev.mdps_max_val = 128;
-			break;
-		default:
-			printk(KERN_ERR DRIVER_NAME
-				": unknown sensor type 0x%X\n", adev.whoami);
-			return -EINVAL;
+	case LIS_DOUBLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
+		adev.read_data = lis3lv02d_read_16;
+		adev.mdps_max_val = 2048;
+		break;
+	case LIS_SINGLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+		adev.read_data = lis3lv02d_read_8;
+		adev.mdps_max_val = 128;
+		break;
+	default:
+		printk(KERN_ERR DRIVER_NAME
+			": unknown sensor type 0x%X\n", adev.whoami);
+		return -EINVAL;
 	}
 
 	/* If possible use a "standard" axes order */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vmalloc-add-__get_vm_area_caller.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
seq_file-properly-cope-with-pread.patch
timerfd-add-flags-check.patch
lis3lv02d-support-both-one-and-two-byte-sensors.patch
lis3lv02d-support-both-one-and-two-byte-sensors-checkpatch-fixes.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
kernel-auditscc-fix-warning.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
mtd-rbtx4939-add-mtd-support.patch
pci-constify-pci_bus_assign_resources.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
cciss-pci-power-management-reset-for-kexec.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
vfs-add-set_page_dirty_notag-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
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

