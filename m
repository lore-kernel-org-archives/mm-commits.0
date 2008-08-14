From: akpm@linux-foundation.org
Subject: + next-git-rejects.patch added to -mm tree
Date: Thu, 14 Aug 2008 16:44:41 -0700
Message-ID: <200808142344.m7ENifkK003509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYHNXoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:44:44 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7ENifr1030474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2008 16:44:42 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     next-git-rejects
has been added to the -mm tree.  Its filename is
     next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci.h      |    3 --
 fs/xfs/linux-2.6/xfs_linux.h |    3 --
 fs/xfs/xfs_inode.c           |    5 ----
 fs/xfs/xfs_vnodeops.c        |   16 --------------
 include/linux/cred.h         |   36 ---------------------------------
 5 files changed, 63 deletions(-)

diff -puN drivers/usb/host/ohci.h~next-git-rejects drivers/usb/host/ohci.h
--- a/drivers/usb/host/ohci.h~next-git-rejects
+++ a/drivers/usb/host/ohci.h
@@ -400,11 +400,8 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_ZFMICRO	0x20			/* Compaq ZFMicro chipset*/
 #define	OHCI_QUIRK_NEC		0x40			/* lost interrupts */
 #define	OHCI_QUIRK_FRAME_NO	0x80			/* no big endian frame_no shift */
-<<<<<<< HEAD:drivers/usb/host/ohci.h
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
-=======
 #define OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
->>>>>>> FETCH_HEAD:drivers/usb/host/ohci.h
 #define	OHCI_QUIRK_AMD_ISO	0x200			/* ISO transfers*/
 	// there are also chip quirks/bugs in init logic
 
diff -puN fs/xfs/linux-2.6/xfs_linux.h~next-git-rejects fs/xfs/linux-2.6/xfs_linux.h
--- a/fs/xfs/linux-2.6/xfs_linux.h~next-git-rejects
+++ a/fs/xfs/linux-2.6/xfs_linux.h
@@ -126,11 +126,8 @@
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
-<<<<<<< HEAD:fs/xfs/linux-2.6/xfs_linux.h
-=======
 #define this_fsuid(cred)	(current_fsuid())
 #define this_fsgid(cred)	(current_fsgid())
->>>>>>> FETCH_HEAD:fs/xfs/linux-2.6/xfs_linux.h
 #define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
diff -puN fs/xfs/xfs_inode.c~next-git-rejects fs/xfs/xfs_inode.c
--- a/fs/xfs/xfs_inode.c~next-git-rejects
+++ a/fs/xfs/xfs_inode.c
@@ -1081,13 +1081,8 @@ xfs_ialloc(
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
-<<<<<<< HEAD:fs/xfs/xfs_inode.c
-	ip->i_d.di_uid = current_fsuid();
-	ip->i_d.di_gid = current_fsgid();
-=======
 	ip->i_d.di_uid = this_fsuid(cr);
 	ip->i_d.di_gid = this_fsgid(cr);
->>>>>>> FETCH_HEAD:fs/xfs/xfs_inode.c
 	ip->i_d.di_projid = prid;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
diff -puN fs/xfs/xfs_vnodeops.c~next-git-rejects fs/xfs/xfs_vnodeops.c
--- a/fs/xfs/xfs_vnodeops.c~next-git-rejects
+++ a/fs/xfs/xfs_vnodeops.c
@@ -182,11 +182,7 @@ xfs_setattr(
 	xfs_ilock(ip, lock_flags);
 
 	/* boolean: are we the file owner? */
-<<<<<<< HEAD:fs/xfs/xfs_vnodeops.c
-	file_owner = (current_fsuid() == ip->i_d.di_uid);
-=======
 	file_owner = (this_fsuid(credp) == ip->i_d.di_uid);
->>>>>>> FETCH_HEAD:fs/xfs/xfs_vnodeops.c
 
 	/*
 	 * Change various properties of a file.
@@ -1537,11 +1533,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-<<<<<<< HEAD:fs/xfs/xfs_vnodeops.c
-			current_fsuid(), current_fsgid(), prid,
-=======
 			this_fsuid(credp), this_fsgid(credp), prid,
->>>>>>> FETCH_HEAD:fs/xfs/xfs_vnodeops.c
 			XFS_QMOPT_QUOTALL|XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2277,11 +2269,7 @@ xfs_mkdir(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-<<<<<<< HEAD:fs/xfs/xfs_vnodeops.c
-			current_fsuid(), current_fsgid(), prid,
-=======
 			this_fsuid(credp), this_fsgid(credp), prid,
->>>>>>> FETCH_HEAD:fs/xfs/xfs_vnodeops.c
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
@@ -2507,11 +2495,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = XFS_QM_DQVOPALLOC(mp, dp,
-<<<<<<< HEAD:fs/xfs/xfs_vnodeops.c
-			current_fsuid(), current_fsgid(), prid,
-=======
 			this_fsuid(credp), this_fsgid(credp), prid,
->>>>>>> FETCH_HEAD:fs/xfs/xfs_vnodeops.c
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
 	if (error)
 		goto std_return;
diff -puN include/linux/cred.h~next-git-rejects include/linux/cred.h
--- a/include/linux/cred.h~next-git-rejects
+++ a/include/linux/cred.h
@@ -12,41 +12,6 @@
 #ifndef _LINUX_CRED_H
 #define _LINUX_CRED_H
 
-<<<<<<< HEAD:include/linux/cred.h
-#define get_current_user()	(get_uid(current->user))
-
-#define task_uid(task)		((task)->uid)
-#define task_gid(task)		((task)->gid)
-#define task_euid(task)		((task)->euid)
-#define task_egid(task)		((task)->egid)
-
-#define current_uid()		(current->uid)
-#define current_gid()		(current->gid)
-#define current_euid()		(current->euid)
-#define current_egid()		(current->egid)
-#define current_suid()		(current->suid)
-#define current_sgid()		(current->sgid)
-#define current_fsuid()		(current->fsuid)
-#define current_fsgid()		(current->fsgid)
-#define current_cap()		(current->cap_effective)
-
-#define current_uid_gid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->uid;			\
-	*(_gid) = current->gid;			\
-} while(0)
-
-#define current_euid_egid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->euid;		\
-	*(_gid) = current->egid;		\
-} while(0)
-
-#define current_fsuid_fsgid(_uid, _gid)		\
-do {						\
-	*(_uid) = current->fsuid;		\
-	*(_gid) = current->fsgid;		\
-=======
 #include <linux/capability.h>
 #include <linux/key.h>
 #include <asm/atomic.h>
@@ -364,7 +329,6 @@ do {						\
 	__cred = current_cred();		\
 	*(_fsuid) = __cred->fsuid;		\
 	*(_fsgid) = __cred->fsgid;		\
->>>>>>> FETCH_HEAD:include/linux/cred.h
 } while(0)
 
 #endif /* _LINUX_CRED_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kexec-jump-check-code-size-in-control-page-fix.patch
kexec-use-a-bitop-for-locking-rather-than-xchg.patch
hwmon-adc124s501-generic-driver.patch
spi-bugfix-spi_add_device-with-duplicate-chipselects-cleanup.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
next-git-rejects.patch
acpi-trivial-cleanups-fix.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-microcode-patch-loader-style-corrections-fix.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
git-drm.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
git-kvm.patch
drivers-ata-pata_it821xc-fix-warning.patch
git-mtd.patch
git-ubi-git-rejects.patch
git-net.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes.patch
power-support-for-texas-instruments-bq27x00-battery-managers-tweaks.patch
git-nfsd.patch
ftrace-printk-formatting-infrastructure-fix-fix.patch
git-scsi-rc-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-watchdog.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
h8300-generic_bug-support-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

