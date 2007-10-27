From: akpm@linux-foundation.org
Subject: + iget-stop-hfsplus-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:46:37 -0700
Message-ID: <200710270746.l9R7kbD0003382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXJ0Hq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, zippel@linux-m68k.org


The patch titled
     iget: stop HFSPLUS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-hfsplus-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop HFSPLUS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the HFSPLUS filesystem from using iget() and read_inode().  Replace
hfsplus_read_inode() with hfsplus_iget(), and call that instead of iget(). 
hfsplus_iget() then uses iget_locked() directly and returns a proper error
code instead of an inode in the event of an error.

hfsplus_fill_super() returns any error incurred when getting the root inode.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c      |    6 +++-
 fs/hfsplus/dir.c        |    6 ++--
 fs/hfsplus/hfsplus_fs.h |    3 ++
 fs/hfsplus/super.c      |   49 ++++++++++++++++++++++++++------------
 4 files changed, 44 insertions(+), 20 deletions(-)

diff -puN fs/hfsplus/btree.c~iget-stop-hfsplus-from-using-iget-and-read_inode fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~iget-stop-hfsplus-from-using-iget-and-read_inode
+++ a/fs/hfsplus/btree.c
@@ -22,6 +22,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	struct hfs_btree *tree;
 	struct hfs_btree_header_rec *head;
 	struct address_space *mapping;
+	struct inode *inode;
 	struct page *page;
 	unsigned int size;
 
@@ -33,9 +34,10 @@ struct hfs_btree *hfs_btree_open(struct 
 	spin_lock_init(&tree->hash_lock);
 	tree->sb = sb;
 	tree->cnid = id;
-	tree->inode = iget(sb, id);
-	if (!tree->inode)
+	inode = hfsplus_iget(sb, id);
+	if (IS_ERR(inode))
 		goto free_tree;
+	tree->inode = inode;
 
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
diff -puN fs/hfsplus/dir.c~iget-stop-hfsplus-from-using-iget-and-read_inode fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~iget-stop-hfsplus-from-using-iget-and-read_inode
+++ a/fs/hfsplus/dir.c
@@ -97,9 +97,9 @@ again:
 		goto fail;
 	}
 	hfs_find_exit(&fd);
-	inode = iget(dir->i_sb, cnid);
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	inode = hfsplus_iget(dir->i_sb, cnid);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	if (S_ISREG(inode->i_mode))
 		HFSPLUS_I(inode).dev = linkid;
 out:
diff -puN fs/hfsplus/hfsplus_fs.h~iget-stop-hfsplus-from-using-iget-and-read_inode fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~iget-stop-hfsplus-from-using-iget-and-read_inode
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -345,6 +345,9 @@ int hfsplus_parse_options(char *, struct
 void hfsplus_fill_defaults(struct hfsplus_sb_info *);
 int hfsplus_show_options(struct seq_file *, struct vfsmount *);
 
+/* super.c */
+struct inode *hfsplus_iget(struct super_block *, unsigned long);
+
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
 extern u16 hfsplus_decompose_table[];
diff -puN fs/hfsplus/super.c~iget-stop-hfsplus-from-using-iget-and-read_inode fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~iget-stop-hfsplus-from-using-iget-and-read_inode
+++ a/fs/hfsplus/super.c
@@ -20,11 +20,18 @@ static void hfsplus_destroy_inode(struct
 
 #include "hfsplus_fs.h"
 
-static void hfsplus_read_inode(struct inode *inode)
+struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 {
 	struct hfs_find_data fd;
 	struct hfsplus_vh *vhdr;
-	int err;
+	struct inode *inode;
+	long err = -EIO;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	INIT_LIST_HEAD(&HFSPLUS_I(inode).open_dir_list);
 	init_MUTEX(&HFSPLUS_I(inode).extents_lock);
@@ -41,7 +48,7 @@ static void hfsplus_read_inode(struct in
 		hfs_find_exit(&fd);
 		if (err)
 			goto bad_inode;
-		return;
+		goto done;
 	}
 	vhdr = HFSPLUS_SB(inode->i_sb).s_vhdr;
 	switch(inode->i_ino) {
@@ -70,10 +77,13 @@ static void hfsplus_read_inode(struct in
 		goto bad_inode;
 	}
 
-	return;
-
- bad_inode:
-	make_bad_inode(inode);
+done:
+	unlock_new_inode(inode);
+	return inode;
+
+bad_inode:
+	iget_failed(inode);
+	return ERR_PTR(err);
 }
 
 static int hfsplus_write_inode(struct inode *inode, int unused)
@@ -262,7 +272,6 @@ static int hfsplus_remount(struct super_
 static const struct super_operations hfsplus_sops = {
 	.alloc_inode	= hfsplus_alloc_inode,
 	.destroy_inode	= hfsplus_destroy_inode,
-	.read_inode	= hfsplus_read_inode,
 	.write_inode	= hfsplus_write_inode,
 	.clear_inode	= hfsplus_clear_inode,
 	.put_super	= hfsplus_put_super,
@@ -278,7 +287,7 @@ static int hfsplus_fill_super(struct sup
 	struct hfsplus_sb_info *sbi;
 	hfsplus_cat_entry entry;
 	struct hfs_find_data fd;
-	struct inode *root;
+	struct inode *root, *inode;
 	struct qstr str;
 	struct nls_table *nls = NULL;
 	int err = -EINVAL;
@@ -366,18 +375,25 @@ static int hfsplus_fill_super(struct sup
 		goto cleanup;
 	}
 
-	HFSPLUS_SB(sb).alloc_file = iget(sb, HFSPLUS_ALLOC_CNID);
-	if (!HFSPLUS_SB(sb).alloc_file) {
+	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
+	if (IS_ERR(inode)) {
 		printk(KERN_ERR "hfs: failed to load allocation file\n");
+		err = PTR_ERR(inode);
 		goto cleanup;
 	}
+	HFSPLUS_SB(sb).alloc_file = inode;
 
 	/* Load the root directory */
-	root = iget(sb, HFSPLUS_ROOT_CNID);
+	root = hfsplus_iget(sb, HFSPLUS_ROOT_CNID);
+	if (IS_ERR(root)) {
+		printk(KERN_ERR "hfs: failed to load root directory\n");
+		err = PTR_ERR(root);
+		goto cleanup;
+	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
-		printk(KERN_ERR "hfs: failed to load root directory\n");
 		iput(root);
+		err = -ENOMEM;
 		goto cleanup;
 	}
 	sb->s_root->d_op = &hfsplus_dentry_operations;
@@ -390,9 +406,12 @@ static int hfsplus_fill_super(struct sup
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER))
 			goto cleanup;
-		HFSPLUS_SB(sb).hidden_dir = iget(sb, be32_to_cpu(entry.folder.id));
-		if (!HFSPLUS_SB(sb).hidden_dir)
+		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
 			goto cleanup;
+		}
+		HFSPLUS_SB(sb).hidden_dir = inode;
 	} else
 		hfs_find_exit(&fd);
 
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
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
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
