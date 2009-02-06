From: akpm@linux-foundation.org
Subject: [merged] revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:49 -0800
Message-ID: <200902061937.n16Jbn6l011360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728AbZBFTiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mtk.manpages@googlemail.com, stable@kernel.org, torvalds@linux-foundation.org, vonsch@gmail.com, weasel@debian.org, mm-commits@vger.kernel.org


The patch titled
     revert "rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY"
has been removed from the -mm tree.  Its filename was
     revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

  commit 0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f
  Author:     Adam Tkac <vonsch@gmail.com>
  AuthorDate: Wed Oct 15 22:01:45 2008 -0700
  Commit:     Linus Torvalds <torvalds@linux-foundation.org>
  CommitDate: Thu Oct 16 11:21:31 2008 -0700

    rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY

because it causes (arguably poorly designed) existing userspace to spend
interminable periods closing billions of not-open file descriptors.

We could bring this back, with some sort of opt-in tunable in /proc, which
defaults to "off".

Peter's alanysis follows:

: I spent several hours trying to get to the bottom of a serious
: performance issue that appeared on one of our servers after upgrading to
: 2.6.28.  In the end it's what could be considered a userspace bug that
: was triggered by a change in 2.6.28.  Since this might also affect other
: people I figured I'd at least document what I found here, and maybe we
: can even do something about it:
: 
: 
: So, I upgraded some of debian.org's machines to 2.6.28.1 and immediately
: the team maintaining our ftp archive complained that one of their
: scripts that previously ran in a few minutes still hadn't even come
: close to being done after an hour or so.  Downgrading to 2.6.27 fixed
: that.
: 
: Turns out that script is forking a lot and something in it or python or
: whereever closes all the file descriptors it doesn't want to pass on.
: That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
: closes them all with a few exceptions.
: 
: Turns out that takes a long time when your limit -n is now 2^20 (1048576).
: 
: With 2.6.27.* the ulimit -n was the standard 1024, but with 2.6.28 it is
: now a thousand times that.
: 
: 2.6.28 included a patch titled "rlimit: permit setting RLIMIT_NOFILE to
: RLIM_INFINITY" (0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f)[1] that
: allows, as the title implies, to set the limit for number of files to
: infinity.
: 
: Closer investigation showed that the broken default ulimit did not apply
: to "system" processes (like stuff started from init).  In the end I
: could establish that all processes that passed through pam_limit at one
: point had the bad resource limit.
: 
: Apparently the pam library in Debian etch (4.0) initializes the limits
: to some default values when it doesn't have any settings in limit.conf
: to override them.  Turns out that for nofiles this is RLIM_INFINITY.
: Commenting out "case RLIMIT_NOFILE" in pam_limit.c:267 of our pam
: package version 0.79-5 fixes that - tho I'm not sure what side effects
: that has.
: 
: Debian lenny (the upcoming 5.0 version) doesn't have this issue as it
: uses a different pam (version).

Reported-by: Peter Palfrader <weasel@debian.org>
Cc: Adam Tkac <vonsch@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN kernel/sys.c~revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
--- a/kernel/sys.c~revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
+++ a/kernel/sys.c
@@ -1525,22 +1525,14 @@ SYSCALL_DEFINE2(setrlimit, unsigned int,
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
 	old_rlim = current->signal->rlim + resource;
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-
-	if (resource == RLIMIT_NOFILE) {
-		if (new_rlim.rlim_max == RLIM_INFINITY)
-			new_rlim.rlim_max = sysctl_nr_open;
-		if (new_rlim.rlim_cur == RLIM_INFINITY)
-			new_rlim.rlim_cur = sysctl_nr_open;
-		if (new_rlim.rlim_max > sysctl_nr_open)
-			return -EPERM;
-	}
-
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
+	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+		return -EPERM;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread-fix.patch
i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
next-git-rejects.patch
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
pci-constify-pci_bus_assign_resources-fix.patch
pci-constify-pci_bus_add_devices.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void-fix.patch
ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-ata-sata_silc-needs-dmih.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
8250-fix-boot-hang-with-serial-console-when-using-with-serial-over-lan-port-fix.patch
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
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
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

