From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 24 Apr 2015 10:04:28 -0700
Message-ID: <553a779c./hxhDH8ANqYmloCM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031327AbbDXRE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Apr 2015 13:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/xattr.c  |   12 ------------
 fs/xfs/xfs_iops.c |    4 ----
 2 files changed, 16 deletions(-)

diff -puN fs/btrfs/xattr.c~linux-next-git-rejects fs/btrfs/xattr.c
--- a/fs/btrfs/xattr.c~linux-next-git-rejects
+++ a/fs/btrfs/xattr.c
@@ -411,21 +411,13 @@ ssize_t btrfs_getxattr(struct dentry *de
 	ret = btrfs_is_valid_xattr(name);
 	if (ret)
 		return ret;
-<<<<<<< HEAD
-	return __btrfs_getxattr(dentry->d_inode, name, buffer, size);
-=======
 	return __btrfs_getxattr(d_inode(dentry), name, buffer, size);
->>>>>>> linux-next/akpm-base
 }
 
 int btrfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		   size_t size, int flags)
 {
-<<<<<<< HEAD
-	struct btrfs_root *root = BTRFS_I(dentry->d_inode)->root;
-=======
 	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
->>>>>>> linux-next/akpm-base
 	int ret;
 
 	/*
@@ -460,11 +452,7 @@ int btrfs_setxattr(struct dentry *dentry
 
 int btrfs_removexattr(struct dentry *dentry, const char *name)
 {
-<<<<<<< HEAD
-	struct btrfs_root *root = BTRFS_I(dentry->d_inode)->root;
-=======
 	struct btrfs_root *root = BTRFS_I(d_inode(dentry))->root;
->>>>>>> linux-next/akpm-base
 	int ret;
 
 	/*
diff -puN fs/xfs/xfs_iops.c~linux-next-git-rejects fs/xfs/xfs_iops.c
--- a/fs/xfs/xfs_iops.c~linux-next-git-rejects
+++ a/fs/xfs/xfs_iops.c
@@ -953,11 +953,7 @@ xfs_vn_setattr(
 		uint		iolock = XFS_IOLOCK_EXCL;
 
 		xfs_ilock(ip, iolock);
-<<<<<<< HEAD
-		error = xfs_break_layouts(dentry->d_inode, &iolock, true);
-=======
 		error = xfs_break_layouts(d_inode(dentry), &iolock, true);
->>>>>>> linux-next/akpm-base
 		if (!error) {
 			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 			iolock |= XFS_MMAPLOCK_EXCL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

