From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:53:10 -0800
Message-ID: <200702141853.l1EIrAm7005778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39417 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbXBNS43 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:56:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: kill open files traverse on remount ro
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch

This patch was dropped because an updated version will be merged

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

r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
