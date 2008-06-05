From: akpm@linux-foundation.org
Subject: + autofs4-leave-rehashed-dentry-positive.patch added to -mm tree
Date: Thu, 05 Jun 2008 15:30:34 -0700
Message-ID: <200806052230.m55MUYtR000489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbYFEWbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 18:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jesper.juhl@gmail.com, jmoyer@redhat.com, miklos@szeredi.hu, viro@ZenIV.linux.org.uk


The patch titled
     autofs4 - leave rehashed dentry positive
has been added to the -mm tree.  Its filename is
     autofs4-leave-rehashed-dentry-positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4 - leave rehashed dentry positive
From: Ian Kent <raven@themaw.net>

Correct the error of making a positive dentry negative after it has
been instantiated.

This involves removing the code in autofs4_lookup_unhashed() that makes
the dentry negative and updating autofs4_dir_symlink() and
autofs4_dir_mkdir() to recognise they have been given a postive dentry
(previously the dentry was always negative) and deal with it.  In
addition the dentry info struct initialization, autofs4_init_ino(), and
the symlink free function, ino_lnkfree(), have been made aware of this
possible re-use.  This is needed because the current case re-uses a
dentry in order to preserve it's flags as described in commit
f50b6f8691cae2e0064c499dd3ef3f31142987f0.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |   23 +++++-----
 fs/autofs4/root.c  |   95 ++++++++++++++++++++++++-------------------
 2 files changed, 67 insertions(+), 51 deletions(-)

diff -puN fs/autofs4/inode.c~autofs4-leave-rehashed-dentry-positive fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-leave-rehashed-dentry-positive
+++ a/fs/autofs4/inode.c
@@ -24,8 +24,10 @@
 
 static void ino_lnkfree(struct autofs_info *ino)
 {
-	kfree(ino->u.symlink);
-	ino->u.symlink = NULL;
+	if (ino->u.symlink) {
+		kfree(ino->u.symlink);
+		ino->u.symlink = NULL;
+	}
 }
 
 struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
@@ -41,16 +43,17 @@ struct autofs_info *autofs4_init_ino(str
 	if (ino == NULL)
 		return NULL;
 
-	ino->flags = 0;
-	ino->mode = mode;
-	ino->inode = NULL;
-	ino->dentry = NULL;
-	ino->size = 0;
-
-	INIT_LIST_HEAD(&ino->rehash);
+	if (!reinit) {
+		ino->flags = 0;
+		ino->mode = mode;
+		ino->inode = NULL;
+		ino->dentry = NULL;
+		ino->size = 0;
+		INIT_LIST_HEAD(&ino->rehash);
+		atomic_set(&ino->count, 0);
+	}
 
 	ino->last_used = jiffies;
-	atomic_set(&ino->count, 0);
 
 	ino->sbi = sbi;
 
diff -puN fs/autofs4/root.c~autofs4-leave-rehashed-dentry-positive fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-leave-rehashed-dentry-positive
+++ a/fs/autofs4/root.c
@@ -555,24 +555,8 @@ static struct dentry *autofs4_lookup_unh
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct inode *inode = dentry->d_inode;
-
-			ino = autofs4_dentry_ino(dentry);
 			list_del_init(&ino->rehash);
 			dget(dentry);
-			/*
-			 * Make the rehashed dentry negative so the VFS
-			 * behaves as it should.
-			 */
-			if (inode) {
-				dentry->d_inode = NULL;
-				list_del_init(&dentry->d_alias);
-				spin_unlock(&dentry->d_lock);
-				spin_unlock(&sbi->rehash_lock);
-				spin_unlock(&dcache_lock);
-				iput(inode);
-				return dentry;
-			}
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->rehash_lock);
 			spin_unlock(&dcache_lock);
@@ -728,35 +712,50 @@ static int autofs4_dir_symlink(struct in
 		return -EACCES;
 
 	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
-	if (ino == NULL)
+	if (!ino)
 		return -ENOSPC;
 
-	ino->size = strlen(symname);
-	ino->u.symlink = cp = kmalloc(ino->size + 1, GFP_KERNEL);
-
-	if (cp == NULL) {
-		kfree(ino);
+	cp = kmalloc(ino->size + 1, GFP_KERNEL);
+	if (!cp) {
+		if (!dentry->d_fsdata)
+			kfree(ino);
 		return -ENOSPC;
 	}
 
 	strcpy(cp, symname);
 
-	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_add(dentry, inode);
+	inode = dentry->d_inode;
+	if (inode)
+		d_rehash(dentry);
+	else {
+		inode = autofs4_get_inode(dir->i_sb, ino);
+		if (!inode) {
+			kfree(cp);
+			if (!dentry->d_fsdata)
+				kfree(ino);
+			return -ENOSPC;
+		}
+
+		d_add(dentry, inode);
 
-	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
-	else
-		dentry->d_op = &autofs4_dentry_operations;
+		if (dir == dir->i_sb->s_root->d_inode)
+			dentry->d_op = &autofs4_root_dentry_operations;
+		else
+			dentry->d_op = &autofs4_dentry_operations;
+
+		dentry->d_fsdata = ino;
+		ino->dentry = dentry;
+		ino->inode = inode;
+	}
+	dget(dentry);
 
-	dentry->d_fsdata = ino;
-	ino->dentry = dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
-	ino->inode = inode;
 
+	ino->u.symlink = cp;
+	ino->size = strlen(symname);
 	dir->i_mtime = CURRENT_TIME;
 
 	return 0;
@@ -866,24 +865,38 @@ static int autofs4_dir_mkdir(struct inod
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
-	if (ino == NULL)
+	if (!ino)
 		return -ENOSPC;
 
-	inode = autofs4_get_inode(dir->i_sb, ino);
-	d_add(dentry, inode);
+	inode = dentry->d_inode;
+	if (inode)
+		d_rehash(dentry);
+	else {
+		inode = autofs4_get_inode(dir->i_sb, ino);
+		if (!inode) {
+			if (!dentry->d_fsdata)
+				kfree(ino);
+			return -ENOSPC;
+		}
 
-	if (dir == dir->i_sb->s_root->d_inode)
-		dentry->d_op = &autofs4_root_dentry_operations;
-	else
-		dentry->d_op = &autofs4_dentry_operations;
+		d_add(dentry, inode);
+
+		if (dir == dir->i_sb->s_root->d_inode)
+			dentry->d_op = &autofs4_root_dentry_operations;
+		else
+			dentry->d_op = &autofs4_dentry_operations;
+
+		dentry->d_fsdata = ino;
+		ino->dentry = dentry;
+		ino->inode = inode;
+	}
+	dget(dentry);
 
-	dentry->d_fsdata = ino;
-	ino->dentry = dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
 	if (p_ino && dentry->d_parent != dentry)
 		atomic_inc(&p_ino->count);
-	ino->inode = inode;
+
 	inc_nlink(dir);
 	dir->i_mtime = CURRENT_TIME;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-leave-rehashed-dentry-positive.patch

