From: akpm@linux-foundation.org
Subject: + sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch added to -mm tree
Date: Tue, 27 Jan 2009 15:44:48 -0800
Message-ID: <200901272344.n0RNimk7020287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbZA0XpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 18:45:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cornelia.huck@de.ibm.com, ebiederm@aristanetworks.com, gregkh@suse.de, tj@kernel.org, viro@ZenIV.linux.org.uk


The patch titled
     sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
has been added to the -mm tree.  Its filename is
     sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch

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
Subject: sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
+++ a/fs/sysfs/inode.c
@@ -215,6 +215,13 @@ struct inode * sysfs_get_inode(struct sy
 	return inode;
 }
 
+/*
+ * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
+ * To prevent the sysfs inode numbers from being freed prematurely we take a
+ * reference to sysfs_dirent from the sysfs inode.  A
+ * super_operations.delete_inode() implementation is needed to drop that
+ * reference upon inode destruction.
+ */
 void sysfs_delete_inode(struct inode *inode)
 {
 	struct sysfs_dirent *sd  = inode->i_private;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix.patch
clocksource-pass-clocksource-to-read-callback.patch
mtd-rbtx4939-add-mtd-support-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set-checkpatch-fixes.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
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

