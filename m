From: akpm@linux-foundation.org
Subject: - mount-options-fix-affs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:34 -0800
Message-ID: <200802082019.m18KJFJZ011032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933608AbYBHUi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:38:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     mount options: fix affs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-affs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix affs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to affs.

Use generic_show_options() and save the complete option string in
affs_fill_super() and affs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/affs/super.c~mount-options-fix-affs fs/affs/super.c
--- a/fs/affs/super.c~mount-options-fix-affs
+++ a/fs/affs/super.c
@@ -122,6 +122,7 @@ static const struct super_operations aff
 	.write_super	= affs_write_super,
 	.statfs		= affs_statfs,
 	.remount_fs	= affs_remount,
+	.show_options	= generic_show_options,
 };
 
 enum {
@@ -272,6 +273,8 @@ static int affs_fill_super(struct super_
 	u8			 sig[4];
 	int			 ret = -EINVAL;
 
+	save_mount_options(sb, data);
+
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
 
 	sb->s_magic             = AFFS_SUPER_MAGIC;
@@ -487,14 +490,21 @@ affs_remount(struct super_block *sb, int
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
+	char			*new_opts = kstrdup(data, GFP_KERNEL);
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
 	*flags |= MS_NODIRATIME;
 
-	if (!parse_options(data,&uid,&gid,&mode,&reserved,&root_block,
-	    &blocksize,&sbi->s_prefix,sbi->s_volume,&mount_flags))
+	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
+			   &blocksize, &sbi->s_prefix, sbi->s_volume,
+			   &mount_flags)) {
+		kfree(new_opts);
 		return -EINVAL;
+	}
+	kfree(sb->s_options);
+	sb->s_options = new_opts;
+
 	sbi->s_flags = mount_flags;
 	sbi->s_mode  = mode;
 	sbi->s_uid   = uid;
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
