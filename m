From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:13:28 -0800
Message-ID: <200702130513.l1D5DSwZ022340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161033AbXBMFOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:14:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: kill open files traverse on remount ro
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: kill open files traverse on remount ro
From: Dave Hansen <hansendc@us.ibm.com>

Now that we have the sb writer count, and all of the writers marked with
mnt_want_write(), we don't need to go looking at all of the individual open
files.

Kill the open files walk, and use the sb writer count.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   25 -------------------------
 fs/super.c         |   13 ++++++++++++-
 include/linux/fs.h |    2 --
 3 files changed, 12 insertions(+), 28 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro
+++ a/fs/file_table.c
@@ -306,31 +306,6 @@ void file_kill(struct file *file)
 	}
 }
 
-int fs_may_remount_ro(struct super_block *sb)
-{
-	struct list_head *p;
-
-	/* Check that no files are currently opened for writing. */
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *file = list_entry(p, struct file, f_u.fu_list);
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/* File with pending delete? */
-		if (inode->i_nlink == 0)
-			goto too_bad;
-
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
-			goto too_bad;
-	}
-	file_list_unlock();
-	return 1; /* Tis' cool bro. */
-too_bad:
-	file_list_unlock();
-	return 0;
-}
-
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
diff -puN fs/super.c~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro fs/super.c
--- a/fs/super.c~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro
+++ a/fs/super.c
@@ -580,7 +580,18 @@ static void mark_files_ro(struct super_b
 
 static int sb_remount_ro(struct super_block *sb)
 {
-	return fs_may_remount_ro(sb);
+	int ret = 0;
+
+	/*
+	 * The r/o flag actually gets set
+	 * by the caller.
+	 */
+	spin_lock(&sb->s_mnt_writers_lock);
+	if (sb->s_writers)
+		ret = -EBUSY;
+	spin_unlock(&sb->s_mnt_writers_lock);
+
+	return ret;
 }
 
 /**
diff -puN include/linux/fs.h~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-kill-open-files-traverse-on-remount-ro
+++ a/include/linux/fs.h
@@ -1655,8 +1655,6 @@ extern const struct file_operations read
 extern const struct file_operations write_fifo_fops;
 extern const struct file_operations rdwr_fifo_fops;
 
-extern int fs_may_remount_ro(struct super_block *);
-
 #ifdef CONFIG_BLOCK
 /*
  * return READ, READA, or WRITE
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-add-vfsmount-writer-counts.patch
r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
