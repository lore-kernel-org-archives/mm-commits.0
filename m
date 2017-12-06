From: akpm@linux-foundation.org
Subject: + hfsplus-honor-setgid-flag-on-directories.patch added to -mm
 tree
Date: Tue, 05 Dec 2017 16:40:55 -0800
Message-ID: <5a273c97.k7hsmoDb/sItVPxr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753125AbdLFAk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 19:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ernesto.mnd.fernandez@gmail.com, slava@dubeyko.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
has been added to the -mm tree.  Its filename is
     hfsplus-honor-setgid-flag-on-directories.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-honor-setgid-flag-on-directories.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-honor-setgid-flag-on-directories.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Subject: hfsplus: honor setgid flag on directories

When creating a file inside a directory that has the setgid flag set, give
the new file the group ID of the parent, and also the setgid flag if it is
a directory itself.

Link: http://lkml.kernel.org/r/20171204192705.GA6101@debian.home
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/dir.c        |    4 ++--
 fs/hfsplus/hfsplus_fs.h |    3 ++-
 fs/hfsplus/inode.c      |    7 +++----
 fs/hfsplus/super.c      |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/hfsplus/dir.c~hfsplus-honor-setgid-flag-on-directories fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-honor-setgid-flag-on-directories
+++ a/fs/hfsplus/dir.c
@@ -444,7 +444,7 @@ static int hfsplus_symlink(struct inode
 	int res = -ENOMEM;
 
 	mutex_lock(&sbi->vh_mutex);
-	inode = hfsplus_new_inode(dir->i_sb, S_IFLNK | S_IRWXUGO);
+	inode = hfsplus_new_inode(dir->i_sb, dir, S_IFLNK | S_IRWXUGO);
 	if (!inode)
 		goto out;
 
@@ -486,7 +486,7 @@ static int hfsplus_mknod(struct inode *d
 	int res = -ENOMEM;
 
 	mutex_lock(&sbi->vh_mutex);
-	inode = hfsplus_new_inode(dir->i_sb, mode);
+	inode = hfsplus_new_inode(dir->i_sb, dir, mode);
 	if (!inode)
 		goto out;
 
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-honor-setgid-flag-on-directories fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-honor-setgid-flag-on-directories
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -478,7 +478,8 @@ extern const struct address_space_operat
 extern const struct address_space_operations hfsplus_btree_aops;
 extern const struct dentry_operations hfsplus_dentry_operations;
 
-struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode);
+struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
+				umode_t mode);
 void hfsplus_delete_inode(struct inode *inode);
 void hfsplus_inode_read_fork(struct inode *inode,
 			     struct hfsplus_fork_raw *fork);
diff -puN fs/hfsplus/inode.c~hfsplus-honor-setgid-flag-on-directories fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-honor-setgid-flag-on-directories
+++ a/fs/hfsplus/inode.c
@@ -354,7 +354,8 @@ static const struct file_operations hfsp
 	.unlocked_ioctl = hfsplus_ioctl,
 };
 
-struct inode *hfsplus_new_inode(struct super_block *sb, umode_t mode)
+struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
+				umode_t mode)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
 	struct inode *inode = new_inode(sb);
@@ -364,9 +365,7 @@ struct inode *hfsplus_new_inode(struct s
 		return NULL;
 
 	inode->i_ino = sbi->next_cnid++;
-	inode->i_mode = mode;
-	inode->i_uid = current_fsuid();
-	inode->i_gid = current_fsgid();
+	inode_init_owner(inode, dir, mode);
 	set_nlink(inode, 1);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 
diff -puN fs/hfsplus/super.c~hfsplus-honor-setgid-flag-on-directories fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-honor-setgid-flag-on-directories
+++ a/fs/hfsplus/super.c
@@ -549,7 +549,7 @@ static int hfsplus_fill_super(struct sup
 
 		if (!sbi->hidden_dir) {
 			mutex_lock(&sbi->vh_mutex);
-			sbi->hidden_dir = hfsplus_new_inode(sb, S_IFDIR);
+			sbi->hidden_dir = hfsplus_new_inode(sb, root, S_IFDIR);
 			if (!sbi->hidden_dir) {
 				mutex_unlock(&sbi->vh_mutex);
 				err = -ENOMEM;
_

Patches currently in -mm which might be from ernesto.mnd.fernandez@gmail.com are


