From: akpm@linux-foundation.org
Subject: - mount-options-fix-autofs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:40 -0800
Message-ID: <200802082019.m18KJL6a011041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933312AbYBHUgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:36:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     mount options: fix autofs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-autofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix autofs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to autofs.

Use generic_show_options() and save the complete option string in
autofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/autofs/inode.c~mount-options-fix-autofs fs/autofs/inode.c
--- a/fs/autofs/inode.c~mount-options-fix-autofs
+++ a/fs/autofs/inode.c
@@ -54,6 +54,7 @@ out_kill_sb:
 
 static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
+	.show_options	= generic_show_options,
 };
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
@@ -140,6 +141,8 @@ int autofs_fill_super(struct super_block
 	int minproto, maxproto;
 	pid_t pgid;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
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
