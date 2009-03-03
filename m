From: akpm@linux-foundation.org
Subject: - lm90-support-the-max6648-6692-chips-fix.patch removed from -mm tree
Date: Tue, 03 Mar 2009 01:15:31 -0800
Message-ID: <200903030915.n239FVcT013365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbZCCJPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 04:15:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     lm90-support-the-max6648-6692-chips-fix
has been removed from the -mm tree.  Its filename was
     lm90-support-the-max6648-6692-chips-fix.patch

This patch was dropped because im-too-old-for-this-shit

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lm90-support-the-max6648-6692-chips-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm90.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips-fix drivers/hwmon/lm90.c
--- a/drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips-fix
+++ a/drivers/hwmon/lm90.c
@@ -776,12 +776,14 @@ static int lm90_detect(struct i2c_client
 			 && (reg_config1 & 0x3f) == 0x00
 			 && reg_convrate <= 0x07) {
 				kind = max6646;
-			} else
-			/* The MAX6648/6692 chips have a working man/chip id
-			 * and the same register set as the 6657.
-			 */
-			if (chip_id == 0x59 && address == 0x4C)
+			} else if (chip_id == 0x59 && address == 0x4C) {
+				/*
+				 * The MAX6648/6692 chips have a working
+				 * man/chip id and the same register set as the
+				 * 6657.
+				 */
 				kind = max6657;
+			}
 		}
 
 		if (kind <= 0) { /* identification failed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
oprofile-dont-set-counter-width-from-cpuid-on-core2-checkpatch-fixes.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files-warning-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-rbtx4939-add-mtd-support.patch
misdn-l1oip-reduce-stack-memory-footprint-cleanup.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
lm90-support-the-max6648-6692-chips-fix.patch
drivers-hwmon-lm90c-fix-coding-style.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics-checkpatch-fixes.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
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
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
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
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
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
nilfs2-segment-buffer-fix.patch
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

