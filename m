From: akpm@linux-foundation.org
Subject: - mount-options-fix-befs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:42 -0800
Message-ID: <200802082019.m18KJN41011044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935364AbYBHUha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, rathamahata@php4.ru, mm-commits@vger.kernel.org


The patch titled
     mount options: fix befs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-befs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix befs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to befs.

Use generic_show_options() and save the complete option string in
befs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Sergey S. Kostyliov <rathamahata@php4.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~mount-options-fix-befs fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~mount-options-fix-befs
+++ a/fs/befs/linuxvfs.c
@@ -57,6 +57,7 @@ static const struct super_operations bef
 	.put_super	= befs_put_super,	/* uninit super */
 	.statfs		= befs_statfs,	/* statfs */
 	.remount_fs	= befs_remount,
+	.show_options	= generic_show_options,
 };
 
 /* slab cache for befs_inode_info objects */
@@ -759,10 +760,11 @@ befs_fill_super(struct super_block *sb, 
 	befs_super_block *disk_sb;
 	struct inode *root;
 	long ret = -EINVAL;
-
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
 
+	save_mount_options(sb, data);
+
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		printk(KERN_ERR
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
