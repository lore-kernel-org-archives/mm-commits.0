From: akpm@linux-foundation.org
Subject: - mount-options-fix-fuse.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:55 -0800
Message-ID: <200802082019.m18KJaEf011071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760933AbYBHUaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:30:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix fuse
has been removed from the -mm tree.  Its filename was
     mount-options-fix-fuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix fuse
From: Miklos Szeredi <mszeredi@suse.cz>

Add blksize= option to /proc/mounts for fuseblk filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/fuse/inode.c~mount-options-fix-fuse fs/fuse/inode.c
--- a/fs/fuse/inode.c~mount-options-fix-fuse
+++ a/fs/fuse/inode.c
@@ -29,6 +29,8 @@ DEFINE_MUTEX(fuse_mutex);
 
 #define FUSE_SUPER_MAGIC 0x65735546
 
+#define FUSE_DEFAULT_BLKSIZE 512
+
 struct fuse_mount_data {
 	int fd;
 	unsigned rootmode;
@@ -355,7 +357,7 @@ static int parse_fuse_opt(char *opt, str
 	char *p;
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
-	d->blksize = 512;
+	d->blksize = FUSE_DEFAULT_BLKSIZE;
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -440,6 +442,9 @@ static int fuse_show_options(struct seq_
 		seq_puts(m, ",allow_other");
 	if (fc->max_read != ~0)
 		seq_printf(m, ",max_read=%u", fc->max_read);
+	if (mnt->mnt_sb->s_bdev &&
+	    mnt->mnt_sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
+		seq_printf(m, ",blksize=%lu", mnt->mnt_sb->s_blocksize);
 	return 0;
 }
 
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
