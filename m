From: akpm@linux-foundation.org
Subject: + unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch added to -mm tree
Date: Tue, 24 Jul 2007 02:02:16 -0700
Message-ID: <200707240902.l6O92G2o005445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759674AbXGXJCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 05:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     unprivileged-mounts-propagation-inherit-owner-from-parent: fix for git-audit
has been added to the -mm tree.  Its filename is
     unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fuse-convert-to-new-aops.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
