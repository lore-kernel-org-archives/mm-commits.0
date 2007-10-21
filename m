From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:50:02 -0700
Message-ID: <200710212350.l9LNo2Ub000858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbXJUXug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged-mounts-propagation-inherit-owner-from-parent: fix for git-audit
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch

This patch was dropped because it was folded into unprivileged-mounts-propagation-inherit-owner-from-parent.patch

------------------------------------------------------
Subject: unprivileged-mounts-propagation-inherit-owner-from-parent: fix for git-audit
From: Miklos Szeredi <mszeredi@suse.cz>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit
+++ a/fs/namespace.c
@@ -856,7 +856,7 @@ struct vfsmount *collect_mounts(struct v
 {
 	struct vfsmount *tree;
 	down_read(&namespace_sem);
-	tree = copy_tree(mnt, dentry, CL_COPY_ALL | CL_PRIVATE);
+	tree = copy_tree(mnt, dentry, CL_COPY_ALL | CL_PRIVATE, 0);
 	up_read(&namespace_sem);
 	return tree;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
