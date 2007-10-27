From: akpm@linux-foundation.org
Subject: + iget-stop-autofs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:44:37 -0700
Message-ID: <200710270744.l9R7ibvM003269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbXJ0Ho5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, raven@themaw.net


The patch titled
     iget: stop autofs from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-autofs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop autofs from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the autofs filesystem from using iget() and read_inode().  Replace
autofs_read_inode() with autofs_iget(), and call that instead of iget(). 
autofs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/autofs_i.h |    1 +
 fs/autofs/inode.c    |   27 ++++++++++++++++++---------
 fs/autofs/root.c     |   22 ++++++++++++++++++----
 3 files changed, 37 insertions(+), 13 deletions(-)

diff -puN fs/autofs/autofs_i.h~iget-stop-autofs-from-using-iget-and-read_inode fs/autofs/autofs_i.h
--- a/fs/autofs/autofs_i.h~iget-stop-autofs-from-using-iget-and-read_inode
+++ a/fs/autofs/autofs_i.h
@@ -150,6 +150,7 @@ extern const struct file_operations auto
 
 int autofs_fill_super(struct super_block *, void *, int);
 void autofs_kill_sb(struct super_block *sb);
+struct inode *autofs_iget(struct super_block *, unsigned long);
 
 /* Queue management functions */
 
diff -puN fs/autofs/inode.c~iget-stop-autofs-from-using-iget-and-read_inode fs/autofs/inode.c
--- a/fs/autofs/inode.c~iget-stop-autofs-from-using-iget-and-read_inode
+++ a/fs/autofs/inode.c
@@ -52,10 +52,7 @@ out_kill_sb:
 	kill_anon_super(sb);
 }
 
-static void autofs_read_inode(struct inode *inode);
-
 static const struct super_operations autofs_sops = {
-	.read_inode	= autofs_read_inode,
 	.statfs		= simple_statfs,
 };
 
@@ -164,7 +161,9 @@ int autofs_fill_super(struct super_block
 	s->s_time_gran = 1;
 	sbi->sb = s;
 
-	root_inode = iget(s, AUTOFS_ROOT_INO);
+	root_inode = autofs_iget(s, AUTOFS_ROOT_INO);
+	if (IS_ERR(root_inode))
+		goto fail_free;
 	root = d_alloc_root(root_inode);
 	pipe = NULL;
 
@@ -230,11 +229,17 @@ fail_unlock:
 	return -EINVAL;
 }
 
-static void autofs_read_inode(struct inode *inode)
+struct inode *autofs_iget(struct super_block *sb, unsigned long ino)
 {
-	ino_t ino = inode->i_ino;
 	unsigned int n;
-	struct autofs_sb_info *sbi = autofs_sbi(inode->i_sb);
+	struct autofs_sb_info *sbi = autofs_sbi(sb);
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	/* Initialize to the default case (stub directory) */
 
@@ -250,7 +255,7 @@ static void autofs_read_inode(struct ino
 		inode->i_op = &autofs_root_inode_operations;
 		inode->i_fop = &autofs_root_operations;
 		inode->i_uid = inode->i_gid = 0; /* Changed in read_super */
-		return;
+		goto done;
 	} 
 	
 	inode->i_uid = inode->i_sb->s_root->d_inode->i_uid;
@@ -263,7 +268,7 @@ static void autofs_read_inode(struct ino
 		n = ino - AUTOFS_FIRST_SYMLINK;
 		if (n >= AUTOFS_MAX_SYMLINKS || !test_bit(n,sbi->symlink_bitmap)) {
 			printk("autofs: Looking for bad symlink inode %u\n", (unsigned int) ino);
-			return;
+			goto done;
 		}
 		
 		inode->i_op = &autofs_symlink_inode_operations;
@@ -275,4 +280,8 @@ static void autofs_read_inode(struct ino
 		inode->i_size = sl->len;
 		inode->i_nlink = 1;
 	}
+
+done:
+	unlock_new_inode(inode);
+	return inode;
 }
diff -puN fs/autofs/root.c~iget-stop-autofs-from-using-iget-and-read_inode fs/autofs/root.c
--- a/fs/autofs/root.c~iget-stop-autofs-from-using-iget-and-read_inode
+++ a/fs/autofs/root.c
@@ -114,8 +114,8 @@ static int try_to_fill_dentry(struct den
 	dentry->d_time = (unsigned long) ent;
 	
 	if (!dentry->d_inode) {
-		inode = iget(sb, ent->ino);
-		if (!inode) {
+		inode = autofs_iget(sb, ent->ino);
+		if (IS_ERR(inode)) {
 			/* Failed, but leave pending for next time */
 			return 1;
 		}
@@ -274,6 +274,7 @@ static int autofs_root_symlink(struct in
 	unsigned int n;
 	int slsize;
 	struct autofs_symlink *sl;
+	struct inode *inode;
 
 	DPRINTK(("autofs_root_symlink: %s <- ", symname));
 	autofs_say(dentry->d_name.name,dentry->d_name.len);
@@ -331,7 +332,12 @@ static int autofs_root_symlink(struct in
 	ent->dentry = NULL;	/* We don't keep the dentry for symlinks */
 
 	autofs_hash_insert(dh,ent);
-	d_instantiate(dentry, iget(dir->i_sb,ent->ino));
+
+	inode = autofs_iget(dir->i_sb, ent->ino);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	d_instantiate(dentry, inode);
 	unlock_kernel();
 	return 0;
 }
@@ -428,6 +434,7 @@ static int autofs_root_mkdir(struct inod
 	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
 	struct autofs_dirhash *dh = &sbi->dirhash;
 	struct autofs_dir_ent *ent;
+	struct inode *inode;
 	ino_t ino;
 
 	lock_kernel();
@@ -469,7 +476,14 @@ static int autofs_root_mkdir(struct inod
 	autofs_hash_insert(dh,ent);
 
 	inc_nlink(dir);
-	d_instantiate(dentry, iget(dir->i_sb,ino));
+
+	inode = autofs_iget(dir->i_sb, ino);
+	if (IS_ERR(inode)) {
+		drop_nlink(dir);
+		return PTR_ERR(inode);
+	}
+
+	d_instantiate(dentry, inode);
 	unlock_kernel();
 
 	return 0;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
