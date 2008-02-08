From: akpm@linux-foundation.org
Subject: - mount-options-fix-isofs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:05 -0800
Message-ID: <200802082019.m18KJkiC011083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762041AbYBHUg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix isofs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-isofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix isofs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to isofs.

Use generic_show_options() and save the complete option string in
isofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/isofs/inode.c~mount-options-fix-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~mount-options-fix-isofs
+++ a/fs/isofs/inode.c
@@ -110,6 +110,7 @@ static const struct super_operations iso
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
+	.show_options	= generic_show_options,
 };
 
 
@@ -561,6 +562,8 @@ static int isofs_fill_super(struct super
 	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
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
