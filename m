From: akpm@linux-foundation.org
Subject: - uselib-add-missing-mnt_noexec-check.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:38 -0700
Message-ID: <200705291851.l4TIpbZQ008352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508AbXE2SwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, drepper@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uselib: add missing MNT_NOEXEC check
has been removed from the -mm tree.  Its filename was
     uselib-add-missing-mnt_noexec-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uselib: add missing MNT_NOEXEC check
From: Christoph Hellwig <hch@lst.de>

We don't allow loading ELF shared library from noexec points so the
same should apply to sys_uselib aswell.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN fs/exec.c~uselib-add-missing-mnt_noexec-check fs/exec.c
--- a/fs/exec.c~uselib-add-missing-mnt_noexec-check
+++ a/fs/exec.c
@@ -134,6 +134,9 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto out;
 
+	error = -EACCES;
+	if (nd.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
 	error = -EINVAL;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
_

Patches currently in -mm which might be from hch@lst.de are

remove-odd-and-misleading-comments-from-uioh.patch
saa7134-tvaudio-kthread-conversion.patch
git-mtd.patch
git-ubi.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
git-scsi-misc.patch
git-scsi-rc-fixes.patch
git-xfs.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
vxfs-warning-fixes.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code-tidyups-update.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
