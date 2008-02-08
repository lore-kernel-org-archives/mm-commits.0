From: akpm@linux-foundation.org
Subject: - mount-options-fix-autofs4.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:38 -0800
Message-ID: <200802082019.m18KJJjF011038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935308AbYBHUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     mount options: fix autofs4
has been removed from the -mm tree.  Its filename was
     mount-options-fix-autofs4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix autofs4
From: Miklos Szeredi <mszeredi@suse.cz>

Add uid= and gid= options to /proc/mounts for autofs4 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/autofs4/inode.c~mount-options-fix-autofs4 fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~mount-options-fix-autofs4
+++ a/fs/autofs4/inode.c
@@ -176,11 +176,16 @@ out_kill_sb:
 static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
+	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
 
 	if (!sbi)
 		return 0;
 
 	seq_printf(m, ",fd=%d", sbi->pipefd);
+	if (root_inode->i_uid != 0)
+		seq_printf(m, ",uid=%u", root_inode->i_uid);
+	if (root_inode->i_gid != 0)
+		seq_printf(m, ",gid=%u", root_inode->i_gid);
 	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
