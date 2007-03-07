From: akpm@linux-foundation.org
Subject: + add-filesystem-subtype-support.patch added to -mm tree
Date: Wed, 07 Mar 2007 12:47:05 -0800
Message-ID: <200703072047.l27Kl80s008213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992551AbXCGUrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 15:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     add filesystem subtype support
has been added to the -mm tree.  Its filename is
     add-filesystem-subtype-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add filesystem subtype support
From: Miklos Szeredi <mszeredi@suse.cz>

There's a slight problem with filesystem type representation in fuse
based filesystems.

From the kernel's view, there are just two filesystem types: fuse and
fuseblk.  From the user's view there are lots of different filesystem
types.  The user is not even much concerned if the filesystem is fuse based
or not.  So there's a conflict of interest in how this should be
represented in fstab, mtab and /proc/mounts.

The current scheme is to encode the real filesystem type in the mount
source.  So an sshfs mount looks like this:

  sshfs#user@server:/   /mnt/server    fuse   rw,nosuid,nodev,...

This url-ish syntax works OK for sshfs and similar filesystems.  However
for block device based filesystems (ntfs-3g, zfs) it doesn't work, since
the kernel expects the mount source to be a real device name.

A possibly better scheme would be to encode the real type in the type
field as "type.subtype".  So fuse mounts would look like this:

  /dev/hda1       /mnt/windows   fuseblk.ntfs-3g   rw,...
  user@server:/   /mnt/server    fuse.sshfs        rw,nosuid,nodev,...

This patch adds the necessary code to the kernel so that this can be
correctly displayed in /proc/mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/filesystems.c   |   21 +++++++++++++++------
 fs/fuse/inode.c    |    2 ++
 fs/namespace.c     |    4 ++++
 fs/super.c         |   27 +++++++++++++++++++++++++++
 include/linux/fs.h |    7 +++++++
 5 files changed, 55 insertions(+), 6 deletions(-)

diff -puN fs/filesystems.c~add-filesystem-subtype-support fs/filesystems.c
--- a/fs/filesystems.c~add-filesystem-subtype-support
+++ a/fs/filesystems.c
@@ -41,11 +41,12 @@ void put_filesystem(struct file_system_t
 	module_put(fs->owner);
 }
 
-static struct file_system_type **find_filesystem(const char *name)
+static struct file_system_type **find_filesystem(const char *name, unsigned len)
 {
 	struct file_system_type **p;
 	for (p=&file_systems; *p; p=&(*p)->next)
-		if (strcmp((*p)->name,name) == 0)
+		if (strlen((*p)->name) == len &&
+		    strncmp((*p)->name, name, len) == 0)
 			break;
 	return p;
 }
@@ -68,11 +69,12 @@ int register_filesystem(struct file_syst
 	int res = 0;
 	struct file_system_type ** p;
 
+	BUG_ON(strchr(fs->name, '.'));
 	if (fs->next)
 		return -EBUSY;
 	INIT_LIST_HEAD(&fs->fs_supers);
 	write_lock(&file_systems_lock);
-	p = find_filesystem(fs->name);
+	p = find_filesystem(fs->name, strlen(fs->name));
 	if (*p)
 		res = -EBUSY;
 	else
@@ -215,19 +217,26 @@ int get_filesystem_list(char * buf)
 struct file_system_type *get_fs_type(const char *name)
 {
 	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	unsigned len = dot ? dot - name : strlen(name);
 
 	read_lock(&file_systems_lock);
-	fs = *(find_filesystem(name));
+	fs = *(find_filesystem(name, len));
 	if (fs && !try_module_get(fs->owner))
 		fs = NULL;
 	read_unlock(&file_systems_lock);
-	if (!fs && (request_module("%s", name) == 0)) {
+	if (!fs && (request_module("%.*s", len, name) == 0)) {
 		read_lock(&file_systems_lock);
-		fs = *(find_filesystem(name));
+		fs = *(find_filesystem(name, len));
 		if (fs && !try_module_get(fs->owner))
 			fs = NULL;
 		read_unlock(&file_systems_lock);
 	}
+
+	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
+		put_filesystem(fs);
+		fs = NULL;
+	}
 	return fs;
 }
 
diff -puN fs/fuse/inode.c~add-filesystem-subtype-support fs/fuse/inode.c
--- a/fs/fuse/inode.c~add-filesystem-subtype-support
+++ a/fs/fuse/inode.c
@@ -634,6 +634,7 @@ static int fuse_get_sb(struct file_syste
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
+	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
 };
@@ -650,6 +651,7 @@ static int fuse_get_sb_blk(struct file_s
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
+	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
diff -puN fs/namespace.c~add-filesystem-subtype-support fs/namespace.c
--- a/fs/namespace.c~add-filesystem-subtype-support
+++ a/fs/namespace.c
@@ -390,6 +390,10 @@ static int show_vfsmnt(struct seq_file *
 	mangle(m, path);
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
+	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
+		seq_putc(m, '.');
+		mangle(m, mnt->mnt_sb->s_subtype);
+	}
 	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
diff -puN fs/super.c~add-filesystem-subtype-support fs/super.c
--- a/fs/super.c~add-filesystem-subtype-support
+++ a/fs/super.c
@@ -107,6 +107,7 @@ out:
 static inline void destroy_super(struct super_block *s)
 {
 	security_sb_free(s);
+	kfree(s->s_subtype);
 	kfree(s);
 }
 
@@ -919,6 +920,29 @@ out:
 
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
+static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
+{
+	int err;
+	const char *subtype = strchr(fstype, '.');
+	if (subtype) {
+		subtype++;
+		err = -EINVAL;
+		if (!subtype[0])
+			goto err;
+	} else
+		subtype = "";
+
+	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
+	err = -ENOMEM;
+	if (!mnt->mnt_sb->s_subtype)
+		goto err;
+	return mnt;
+
+ err:
+	mntput(mnt);
+	return ERR_PTR(err);
+}
+
 struct vfsmount *
 do_kern_mount(const char *fstype, int flags, const char *name, void *data)
 {
@@ -927,6 +951,9 @@ do_kern_mount(const char *fstype, int fl
 	if (!type)
 		return ERR_PTR(-ENODEV);
 	mnt = vfs_kern_mount(type, flags, name, data);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
+	    !mnt->mnt_sb->s_subtype)
+		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	return mnt;
 }
diff -puN include/linux/fs.h~add-filesystem-subtype-support include/linux/fs.h
--- a/include/linux/fs.h~add-filesystem-subtype-support
+++ a/include/linux/fs.h
@@ -92,6 +92,7 @@ extern int dir_notify_enable;
 /* public flags for file_system_type */
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
+#define FS_HAS_SUBTYPE 4
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -953,6 +954,12 @@ struct super_block {
 	/* Granularity of c/m/atime in ns.
 	   Cannot be worse than a second */
 	u32		   s_time_gran;
+
+	/*
+	 * Filesystem subtype.  If non-empty the filesystem type field
+	 * in /proc/mounts will be "type.subtype"
+	 */
+	char *s_subtype;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
consolidate-generic_writepages-and-mpage_writepages.patch
