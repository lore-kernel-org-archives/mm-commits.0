From: akpm@linux-foundation.org
Subject: - iget-stop-jffs2-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:52 -0800
Message-ID: <200802080807.m1887XUn014561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761473AbYBHIVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dwmw2@infradead.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop JFFS2 from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-jffs2-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop JFFS2 from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the JFFS2 filesystem from using iget() and read_inode().  Replace
jffs2_read_inode() with jffs2_iget(), and call that instead of iget(). 
jffs2_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

jffs2_do_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/dir.c      |    6 ++--
 fs/jffs2/fs.c       |   56 ++++++++++++++++++++++++++----------------
 fs/jffs2/os-linux.h |    2 -
 fs/jffs2/super.c    |    1 
 4 files changed, 39 insertions(+), 26 deletions(-)

diff -puN fs/jffs2/dir.c~iget-stop-jffs2-from-using-iget-and-read_inode fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~iget-stop-jffs2-from-using-iget-and-read_inode
+++ a/fs/jffs2/dir.c
@@ -101,10 +101,10 @@ static struct dentry *jffs2_lookup(struc
 		ino = fd->ino;
 	up(&dir_f->sem);
 	if (ino) {
-		inode = iget(dir_i->i_sb, ino);
-		if (!inode) {
+		inode = jffs2_iget(dir_i->i_sb, ino);
+		if (IS_ERR(inode)) {
 			printk(KERN_WARNING "iget() failed for ino #%u\n", ino);
-			return (ERR_PTR(-EIO));
+			return ERR_CAST(inode);
 		}
 	}
 
diff -puN fs/jffs2/fs.c~iget-stop-jffs2-from-using-iget-and-read_inode fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~iget-stop-jffs2-from-using-iget-and-read_inode
+++ a/fs/jffs2/fs.c
@@ -230,16 +230,23 @@ void jffs2_clear_inode (struct inode *in
 	jffs2_do_clear_inode(c, f);
 }
 
-void jffs2_read_inode (struct inode *inode)
+struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 {
 	struct jffs2_inode_info *f;
 	struct jffs2_sb_info *c;
 	struct jffs2_raw_inode latest_node;
 	union jffs2_device_node jdev;
+	struct inode *inode;
 	dev_t rdev = 0;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_read_inode(): inode->i_ino == %lu\n", inode->i_ino));
+	D1(printk(KERN_DEBUG "jffs2_iget(): ino == %lu\n", ino));
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	f = JFFS2_INODE_INFO(inode);
 	c = JFFS2_SB_INFO(inode->i_sb);
@@ -250,9 +257,9 @@ void jffs2_read_inode (struct inode *ino
 	ret = jffs2_do_read_inode(c, f, inode->i_ino, &latest_node);
 
 	if (ret) {
-		make_bad_inode(inode);
 		up(&f->sem);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(ret);
 	}
 	inode->i_mode = jemode_to_cpu(latest_node.mode);
 	inode->i_uid = je16_to_cpu(latest_node.uid);
@@ -303,19 +310,14 @@ void jffs2_read_inode (struct inode *ino
 		if (f->metadata->size != sizeof(jdev.old) &&
 		    f->metadata->size != sizeof(jdev.new)) {
 			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
-			up(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			make_bad_inode(inode);
-			return;
+			goto error_io;
 		}
 		D1(printk(KERN_DEBUG "Reading device numbers from flash\n"));
-		if (jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size) < 0) {
+		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
+		if (ret < 0) {
 			/* Eep */
 			printk(KERN_NOTICE "Read device numbers for inode %lu failed\n", (unsigned long)inode->i_ino);
-			up(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			make_bad_inode(inode);
-			return;
+			goto error;
 		}
 		if (f->metadata->size == sizeof(jdev.old))
 			rdev = old_decode_dev(je16_to_cpu(jdev.old));
@@ -335,6 +337,16 @@ void jffs2_read_inode (struct inode *ino
 	up(&f->sem);
 
 	D1(printk(KERN_DEBUG "jffs2_read_inode() returning\n"));
+	unlock_new_inode(inode);
+	return inode;
+
+error_io:
+	ret = -EIO;
+error:
+	up(&f->sem);
+	jffs2_do_clear_inode(c, f);
+	iget_failed(inode);
+	return ERR_PTR(ret);
 }
 
 void jffs2_dirty_inode(struct inode *inode)
@@ -522,15 +534,16 @@ int jffs2_do_fill_super(struct super_blo
 	if ((ret = jffs2_do_mount_fs(c)))
 		goto out_inohash;
 
-	ret = -EINVAL;
-
 	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): Getting root inode\n"));
-	root_i = iget(sb, 1);
-	if (is_bad_inode(root_i)) {
+	root_i = jffs2_iget(sb, 1);
+	if (IS_ERR(root_i)) {
 		D1(printk(KERN_WARNING "get root inode failed\n"));
-		goto out_root_i;
+		ret = PTR_ERR(root_i);
+		goto out_root;
 	}
 
+	ret = -ENOMEM;
+
 	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): d_alloc_root()\n"));
 	sb->s_root = d_alloc_root(root_i);
 	if (!sb->s_root)
@@ -546,6 +559,7 @@ int jffs2_do_fill_super(struct super_blo
 
  out_root_i:
 	iput(root_i);
+out_root:
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
 	if (jffs2_blocks_use_vmalloc(c))
@@ -615,9 +629,9 @@ struct jffs2_inode_info *jffs2_gc_fetch_
 		   jffs2_do_unlink() would need the alloc_sem and we have it.
 		   Just iget() it, and if read_inode() is necessary that's OK.
 		*/
-		inode = iget(OFNI_BS_2SFFJ(c), inum);
-		if (!inode)
-			return ERR_PTR(-ENOMEM);
+		inode = jffs2_iget(OFNI_BS_2SFFJ(c), inum);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	if (is_bad_inode(inode)) {
 		printk(KERN_NOTICE "Eep. read_inode() failed for ino #%u. nlink %d\n",
diff -puN fs/jffs2/os-linux.h~iget-stop-jffs2-from-using-iget-and-read_inode fs/jffs2/os-linux.h
--- a/fs/jffs2/os-linux.h~iget-stop-jffs2-from-using-iget-and-read_inode
+++ a/fs/jffs2/os-linux.h
@@ -175,7 +175,7 @@ extern const struct inode_operations jff
 /* fs.c */
 int jffs2_setattr (struct dentry *, struct iattr *);
 int jffs2_do_setattr (struct inode *, struct iattr *);
-void jffs2_read_inode (struct inode *);
+struct inode *jffs2_iget(struct super_block *, unsigned long);
 void jffs2_clear_inode (struct inode *);
 void jffs2_dirty_inode(struct inode *inode);
 struct inode *jffs2_new_inode (struct inode *dir_i, int mode,
diff -puN fs/jffs2/super.c~iget-stop-jffs2-from-using-iget-and-read_inode fs/jffs2/super.c
--- a/fs/jffs2/super.c~iget-stop-jffs2-from-using-iget-and-read_inode
+++ a/fs/jffs2/super.c
@@ -65,7 +65,6 @@ static const struct super_operations jff
 {
 	.alloc_inode =	jffs2_alloc_inode,
 	.destroy_inode =jffs2_destroy_inode,
-	.read_inode =	jffs2_read_inode,
 	.put_super =	jffs2_put_super,
 	.write_super =	jffs2_write_super,
 	.statfs =	jffs2_statfs,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
