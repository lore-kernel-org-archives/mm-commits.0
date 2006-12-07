From: akpm@osdl.org
Subject: - fuse-add-blksize-option.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:43 -0800
Message-ID: <200612072301.kB7N1hYX029790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163694AbWLGXCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: add blksize option
has been removed from the -mm tree.  Its filename was
     fuse-add-blksize-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: add blksize option
From: Miklos Szeredi <miklos@szeredi.hu>

Add 'blksize' option for block device based filesystems.  During
initialization this is used to set the block size on the device and the super
block.  The default block size is 512bytes.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/fuse.txt |    5 +++++
 fs/fuse/inode.c                    |   24 ++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/fuse.txt~fuse-add-blksize-option Documentation/filesystems/fuse.txt
--- a/Documentation/filesystems/fuse.txt~fuse-add-blksize-option
+++ a/Documentation/filesystems/fuse.txt
@@ -110,6 +110,11 @@ Mount options
   The default is infinite.  Note that the size of read requests is
   limited anyway to 32 pages (which is 128kbyte on i386).
 
+'blksize=N'
+
+  Set the block size for the filesystem.  The default is 512.  This
+  option is only valid for 'fuseblk' type mounts.
+
 Control filesystem
 ~~~~~~~~~~~~~~~~~~
 
diff -puN fs/fuse/inode.c~fuse-add-blksize-option fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-add-blksize-option
+++ a/fs/fuse/inode.c
@@ -39,6 +39,7 @@ struct fuse_mount_data {
 	unsigned group_id_present : 1;
 	unsigned flags;
 	unsigned max_read;
+	unsigned blksize;
 };
 
 static struct inode *fuse_alloc_inode(struct super_block *sb)
@@ -274,6 +275,7 @@ enum {
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_ALLOW_OTHER,
 	OPT_MAX_READ,
+	OPT_BLKSIZE,
 	OPT_ERR
 };
 
@@ -285,14 +287,16 @@ static match_table_t tokens = {
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_ALLOW_OTHER,		"allow_other"},
 	{OPT_MAX_READ,			"max_read=%u"},
+	{OPT_BLKSIZE,			"blksize=%u"},
 	{OPT_ERR,			NULL}
 };
 
-static int parse_fuse_opt(char *opt, struct fuse_mount_data *d)
+static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
 {
 	char *p;
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
+	d->blksize = 512;
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -345,6 +349,12 @@ static int parse_fuse_opt(char *opt, str
 			d->max_read = value;
 			break;
 
+		case OPT_BLKSIZE:
+			if (!is_bdev || match_int(&args[0], &value))
+				return 0;
+			d->blksize = value;
+			break;
+
 		default:
 			return 0;
 		}
@@ -500,15 +510,21 @@ static int fuse_fill_super(struct super_
 	struct dentry *root_dentry;
 	struct fuse_req *init_req;
 	int err;
+	int is_bdev = sb->s_bdev != NULL;
 
 	if (sb->s_flags & MS_MANDLOCK)
 		return -EINVAL;
 
-	if (!parse_fuse_opt((char *) data, &d))
+	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		return -EINVAL;
 
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	if (is_bdev) {
+		if (!sb_set_blocksize(sb, d.blksize))
+			return -EINVAL;
+	} else {
+		sb->s_blocksize = PAGE_CACHE_SIZE;
+		sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	}
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

