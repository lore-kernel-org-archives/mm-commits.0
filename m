From: akpm@linux-foundation.org
Subject: - drop-obsolete-sys_ioctl-export.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:28 -0700
Message-ID: <200707162057.l6GKvSGi002192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXGPVPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     drop obsolete sys_ioctl export
has been removed from the -mm tree.  Its filename was
     drop-obsolete-sys_ioctl-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drop obsolete sys_ioctl export
From: Christoph Hellwig <hch@lst.de>

sys_ioctl() was only exported for our first version of compat ioctl
handling.  Now that the whole compat ioctl handling mess is more or less
sorted out there are no more modular users left and we can kill it.

There's one exception and that's sparc64's solaris compat module, but
sparc64 has it's own export predating the generic one by years for that
which this patch leaves untouched.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/ioctl.c~drop-obsolete-sys_ioctl-export fs/ioctl.c
--- a/fs/ioctl.c~drop-obsolete-sys_ioctl-export
+++ a/fs/ioctl.c
@@ -174,11 +174,3 @@ asmlinkage long sys_ioctl(unsigned int f
  out:
 	return error;
 }
-
-/*
- * Platforms implementing 32 bit compatibility ioctl handlers in
- * modules need this exported
- */
-#ifdef CONFIG_COMPAT
-EXPORT_SYMBOL(sys_ioctl);
-#endif
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-powerpc.patch
git-dvb.patch
git-ubi.patch
git-ocfs2.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
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
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
