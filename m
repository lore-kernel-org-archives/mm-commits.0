From: akpm@linux-foundation.org
Subject: - check-privileges-before-setting-mount-propagation.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:59 -0700
Message-ID: <200705090250.l492oxLF009409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032120AbXEICvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     check privileges before setting mount propagation
has been removed from the -mm tree.  Its filename was
     check-privileges-before-setting-mount-propagation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: check privileges before setting mount propagation
From: Miklos Szeredi <mszeredi@suse.cz>

There's a missing check for CAP_SYS_ADMIN in do_change_type().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/namespace.c~check-privileges-before-setting-mount-propagation fs/namespace.c
--- a/fs/namespace.c~check-privileges-before-setting-mount-propagation
+++ a/fs/namespace.c
@@ -886,6 +886,9 @@ static int do_change_type(struct nameida
 	int recurse = flag & MS_REC;
 	int type = flag & ~MS_REC;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (nd->dentry != nd->mnt->mnt_root)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
uml-turn-build-warnings-into-comments.patch
consolidate-generic_writepages-and-mpage_writepages.patch
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
