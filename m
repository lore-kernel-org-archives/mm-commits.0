From: akpm@linux-foundation.org
Subject: [folded] seq_file-properly-cope-with-pread-fix.patch removed from -mm tree
Date: Wed, 18 Feb 2009 13:57:30 -0800
Message-ID: <200902182157.n1ILvVA6005074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416AbZBRV6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 16:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com, pjt@google.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file-properly-cope-with-pread-fix
has been removed from the -mm tree.  Its filename was
     seq_file-properly-cope-with-pread-fix.patch

This patch was dropped because it was folded into seq_file-properly-cope-with-pread.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file-properly-cope-with-pread-fix
From: Andrew Morton <akpm@linux-foundation.org>

Restore FMODE_PWRITE.

Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/seq_file.c~seq_file-properly-cope-with-pread-fix fs/seq_file.c
--- a/fs/seq_file.c~seq_file-properly-cope-with-pread-fix
+++ a/fs/seq_file.c
@@ -48,6 +48,16 @@ int seq_open(struct file *file, const st
 	 */
 	file->f_version = 0;
 
+	/*
+	 * seq_files support lseek() and pread().  They do not implement
+	 * write() at all, but we clear FMODE_PWRITE here for historical
+	 * reasons.
+	 *
+	 * If a client of seq_files a) implements file.write() and b) wishes to
+	 * support pwrite() then that client will need to implement its own
+	 * file.open() which calls seq_open() and then sets FMODE_PWRITE.
+	 */
+	file->f_mode &= ~FMODE_PWRITE;
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vmalloc-add-__get_vm_area_caller.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
timerfd-add-flags-check-fix.patch
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

