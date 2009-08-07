From: akpm@linux-foundation.org
Subject: - vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch removed from -mm tree
Date: Fri, 07 Aug 2009 10:02:41 -0700
Message-ID: <200908071702.n77H2fas000305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbZHGRDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 13:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, eparis@redhat.com, esandeen@redhat.com, eteo@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: allow file truncations when both suid and write permissions set
has been removed from the -mm tree.  Its filename was
     vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch

This patch was dropped because I'm all confused

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: allow file truncations when both suid and write permissions set
From: Amerigo Wang <amwang@redhat.com>

When suid is set and the non-owner user has write permission, any writing
into this file should be allowed and suid should be removed after that.

However, the current kernel only allows writing without truncations, when
we do truncations on that file, we get EPERM.  This is a bug.

Steps to reproduce this bug:

% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h > rootdir/file1
zsh: operation not permitted: rootdir/file1
% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h >> rootdir/file1
% ls -l rootdir/file1
-rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1

This patch fixes it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c          |    8 ++++++--
 include/linux/fs.h |    1 +
 mm/filemap.c       |   12 ++++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/open.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set fs/open.c
--- a/fs/open.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set
+++ a/fs/open.c
@@ -213,11 +213,15 @@ int do_truncate(struct dentry *dentry, l
 		newattrs.ia_valid |= ATTR_FILE;
 	}
 
+	mutex_lock(&dentry->d_inode->i_mutex);
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	err = dentry_remove_suid(dentry);
+	if (err)
+		goto unlock;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	err = notify_change(dentry, &newattrs);
+
+ unlock:
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
 }
diff -puN include/linux/fs.h~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set include/linux/fs.h
--- a/include/linux/fs.h~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set
+++ a/include/linux/fs.h
@@ -2170,6 +2170,7 @@ extern void destroy_inode(struct inode *
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
+extern int dentry_remove_suid(struct dentry *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
diff -puN mm/filemap.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set mm/filemap.c
--- a/mm/filemap.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set
+++ a/mm/filemap.c
@@ -1839,9 +1839,11 @@ static int __remove_suid(struct dentry *
 	return notify_change(dentry, &newattrs);
 }
 
-int file_remove_suid(struct file *file)
+/*
+ * Note: you need to hold i_mutex before call this.
+ */
+int dentry_remove_suid(struct dentry *dentry)
 {
-	struct dentry *dentry = file->f_path.dentry;
 	int killsuid = should_remove_suid(dentry);
 	int killpriv = security_inode_need_killpriv(dentry);
 	int error = 0;
@@ -1855,6 +1857,12 @@ int file_remove_suid(struct file *file)
 
 	return error;
 }
+
+int file_remove_suid(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	return dentry_remove_suid(dentry);
+}
 EXPORT_SYMBOL(file_remove_suid);
 
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
_

Patches currently in -mm which might be from amwang@redhat.com are

ia32-use-generic-sys_pipe.patch
vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
xtensa-use-generic-sys_pipe.patch
kcore-fix-proc-kcores-statst_size.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch

