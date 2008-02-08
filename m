From: akpm@linux-foundation.org
Subject: - mount-options-fix-hpfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:00 -0800
Message-ID: <200802082019.m18KJfZC011077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934269AbYBHUjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix hpfs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-hpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix hpfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hpfs.

Use generic_show_options() and save the complete option string in
hpfs_fill_super() and hpfs_remount_fs().

Also add a small fix: hpfs_remount_fs() should return -EINVAL on
error, instead of 1, which is not an error value.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/hpfs/super.c~mount-options-fix-hpfs fs/hpfs/super.c
--- a/fs/hpfs/super.c~mount-options-fix-hpfs
+++ a/fs/hpfs/super.c
@@ -386,6 +386,7 @@ static int hpfs_remount_fs(struct super_
 	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
 	int o;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	char *new_opts = kstrdup(data, GFP_KERNEL);
 	
 	*flags |= MS_NOATIME;
 	
@@ -398,15 +399,15 @@ static int hpfs_remount_fs(struct super_
 	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase, &conv,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
 		printk("HPFS: bad mount options.\n");
-	    	return 1;
+		goto out_err;
 	}
 	if (o == 2) {
 		hpfs_help();
-		return 1;
+		goto out_err;
 	}
 	if (timeshift != sbi->sb_timeshift) {
 		printk("HPFS: timeshift can't be changed using remount.\n");
-		return 1;
+		goto out_err;
 	}
 
 	unmark_dirty(s);
@@ -419,7 +420,14 @@ static int hpfs_remount_fs(struct super_
 
 	if (!(*flags & MS_RDONLY)) mark_dirty(s);
 
+	kfree(s->s_options);
+	s->s_options = new_opts;
+
 	return 0;
+
+out_err:
+	kfree(new_opts);
+	return -EINVAL;
 }
 
 /* Super operations */
@@ -432,6 +440,7 @@ static const struct super_operations hpf
 	.put_super	= hpfs_put_super,
 	.statfs		= hpfs_statfs,
 	.remount_fs	= hpfs_remount_fs,
+	.show_options	= generic_show_options,
 };
 
 static int hpfs_fill_super(struct super_block *s, void *options, int silent)
@@ -454,6 +463,8 @@ static int hpfs_fill_super(struct super_
 
 	int o;
 
+	save_mount_options(s, options);
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
