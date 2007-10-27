From: akpm@linux-foundation.org
Subject: + iget-stop-isofs-from-using-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:46:40 -0700
Message-ID: <200710270746.l9R7kefR003386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbXJ0Hq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jack@ucw.cz


The patch titled
     iget: stop ISOFS from using read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-isofs-from-using-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop ISOFS from using read_inode()
From: David Howells <dhowells@redhat.com>

Stop the ISOFS filesystem from using read_inode().  Make isofs_read_inode()
return an error code, and make isofs_iget() pass it on.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode
+++ a/fs/isofs/inode.c
@@ -54,7 +54,7 @@ static void isofs_put_super(struct super
 	return;
 }
 
-static void isofs_read_inode(struct inode *);
+static int isofs_read_inode(struct inode *);
 static int isofs_statfs (struct dentry *, struct kstatfs *);
 
 static struct kmem_cache *isofs_inode_cachep;
@@ -107,7 +107,6 @@ static int isofs_remount(struct super_bl
 static const struct super_operations isofs_sops = {
 	.alloc_inode	= isofs_alloc_inode,
 	.destroy_inode	= isofs_destroy_inode,
-	.read_inode	= isofs_read_inode,
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
@@ -1186,7 +1185,7 @@ out_toomany:
 	goto out;
 }
 
-static void isofs_read_inode(struct inode *inode)
+static int isofs_read_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
@@ -1199,6 +1198,7 @@ static void isofs_read_inode(struct inod
 	unsigned int de_len;
 	unsigned long offset;
 	struct iso_inode_info *ei = ISOFS_I(inode);
+	int ret = -EIO;
 
 	block = ei->i_iget5_block;
 	bh = sb_bread(inode->i_sb, block);
@@ -1216,6 +1216,7 @@ static void isofs_read_inode(struct inod
 		tmpde = kmalloc(de_len, GFP_KERNEL);
 		if (tmpde == NULL) {
 			printk(KERN_INFO "%s: out of memory\n", __func__);
+			ret = -ENOMEM;
 			goto fail;
 		}
 		memcpy(tmpde, bh->b_data + offset, frag1);
@@ -1259,8 +1260,10 @@ static void isofs_read_inode(struct inod
 
 	ei->i_section_size = isonum_733(de->size);
 	if (de->flags[-high_sierra] & 0x80) {
-		if(isofs_read_level3_size(inode))
+		ret = isofs_read_level3_size(inode);
+		if (ret < 0)
 			goto fail;
+		ret = -EIO;
 	} else {
 		ei->i_next_section_block = 0;
 		ei->i_next_section_offset = 0;
@@ -1346,16 +1349,16 @@ static void isofs_read_inode(struct inod
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 
+	ret = 0;
 out:
 	kfree(tmpde);
 	if (bh)
 		brelse(bh);
-	return;
+	return ret;
 
 out_badread:
 	printk(KERN_WARNING "ISOFS: unable to read i-node block\n");
 fail:
-	make_bad_inode(inode);
 	goto out;
 }
 
@@ -1394,6 +1397,7 @@ struct inode *isofs_iget(struct super_bl
 	unsigned long hashval;
 	struct inode *inode;
 	struct isofs_iget5_callback_data data;
+	long ret;
 
 	if (offset >= 1ul << sb->s_blocksize_bits)
 		return NULL;
@@ -1407,8 +1411,13 @@ struct inode *isofs_iget(struct super_bl
 				&isofs_iget5_set, &data);
 
 	if (inode && (inode->i_state & I_NEW)) {
-		sb->s_op->read_inode(inode);
-		unlock_new_inode(inode);
+		ret = isofs_read_inode(inode);
+		if (ret < 0) {
+			iget_failed(inode);
+			inode = ERR_PTR(ret);
+		} else {
+			unlock_new_inode(inode);
+		}
 	}
 
 	return inode;
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
