From: akpm@linux-foundation.org
Subject: + vfs-simple_set_mnt-should-return-void-fix.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:57:42 -0800
Message-ID: <200902052314.n15NEixe011623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbZBEXP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 18:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs-simple_set_mnt-should-return-void-fix
has been added to the -mm tree.  Its filename is
     vfs-simple_set_mnt-should-return-void-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-simple_set_mnt-should-return-void-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/proc/proc_net.c: In function 'proc_net_get_sb':
fs/proc/proc_net.c:296: error: void value not ignored as it ought to be

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/proc_net.c~vfs-simple_set_mnt-should-return-void-fix fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~vfs-simple_set_mnt-should-return-void-fix
+++ a/fs/proc/proc_net.c
@@ -293,7 +293,8 @@ static int proc_net_get_sb(struct file_s
 		sb->s_flags |= MS_ACTIVE;
 	}
 
-	return simple_set_mnt(mnt, sb);
+	simple_set_mnt(mnt, sb);
+	return 0;
 }
 
 static struct file_system_type proc_net_fs_type = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-asyncc-fix-printk-warnings.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
hp-wmi-fix-error-path-in-hp_wmi_bios_setup.patch
wait-prevent-exclusive-waiter-starvation.patch
sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
revert-x86-prevent-kprobes-from-catching-spurious-page-faults.patch
linux-next.patch
next-remove-localversion.patch
fix-sparseirq-use-kstat_irqs_cpu-on-non-x86-architectures-too.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
kernel-auditscc-fix-warning.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
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
vfs-simple_set_mnt-should-return-void-fix.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
x86-allow-intel_iommu-support-to-be-disabled-by-default-fix.patch
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
fbdev-uninline-lock_fb_info.patch
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
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
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

