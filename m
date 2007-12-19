From: akpm@linux-foundation.org
Subject: + iget-stop-isofs-from-using-read_inode-fix-2.patch added to -mm tree
Date: Tue, 18 Dec 2007 17:17:49 -0800
Message-ID: <200712190117.lBJ1HnFX031580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbXLSBSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 20:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, Valdis.Kletnieks@vt.edu, hch@lst.de, hidave.darkstar@gmail.com, jack@ucw.cz


The patch titled
     IGET: handle errors in ISOFS correctly
has been added to the -mm tree.  Its filename is
     iget-stop-isofs-from-using-read_inode-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IGET: handle errors in ISOFS correctly
From: David Howells <dhowells@redhat.com>

Handle errors in ISOFS correctly.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2 fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-2
+++ a/fs/isofs/inode.c
@@ -841,7 +841,7 @@ root_found:
 	sbi->s_joliet_level = joliet_level;
 
 	/* check the root inode */
-	if (!inode)
+	if (IS_ERR(inode))
 		goto out_no_root;
 	if (!inode->i_op)
 		goto out_bad_root;
@@ -875,11 +875,12 @@ root_found:
 	 */
 out_bad_root:
 	printk(KERN_WARNING "%s: root inode not initialized\n", __func__);
-	goto out_iput;
-out_no_root:
-	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
 out_iput:
 	iput(inode);
+	goto out_no_inode;
+out_no_root:
+	printk(KERN_WARNING "%s: get root inode failed\n", __func__);
+out_no_inode:
 #ifdef CONFIG_JOLIET
 	if (sbi->s_nls_iocharset)
 		unload_nls(sbi->s_nls_iocharset);
@@ -929,7 +930,7 @@ static int isofs_statfs (struct dentry *
 /*
  * Get a set of blocks; filling in buffer_heads if already allocated
  * or getblk() if they are not.  Returns the number of blocks inserted
- * (0 == error.)
+ * (-ve == error.)
  */
 int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 		     struct buffer_head **bh, unsigned long nblocks)
@@ -939,11 +940,12 @@ int isofs_get_blocks(struct inode *inode
 	unsigned int firstext;
 	unsigned long nextblk, nextoff;
 	long iblock = (long)iblock_s;
-	int section, rv;
+	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	lock_kernel();
 
+	error = -EIO;
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
 		printk(KERN_DEBUG "%s: block number too large\n", __func__);
@@ -982,8 +984,10 @@ int isofs_get_blocks(struct inode *inode
 
 			offset += sect_size;
 			ninode = isofs_iget(inode->i_sb, nextblk, nextoff);
-			if (!ninode)
+			if (IS_ERR(ninode)) {
+				error = PTR_ERR(ninode);
 				goto abort;
+			}
 			firstext  = ISOFS_I(ninode)->i_first_extent;
 			sect_size = ISOFS_I(ninode)->i_section_size >> ISOFS_BUFFER_BITS(ninode);
 			nextblk   = ISOFS_I(ninode)->i_next_section_block;
@@ -1016,7 +1020,7 @@ int isofs_get_blocks(struct inode *inode
 
 abort:
 	unlock_kernel();
-	return rv;
+	return rv != 0 ? rv : error;
 }
 
 /*
@@ -1030,7 +1034,7 @@ static int isofs_get_block(struct inode 
 		return -EROFS;
 	}
 
-	return isofs_get_blocks(inode, iblock, &bh_result, 1) ? 0 : -EIO;
+	return isofs_get_blocks(inode, iblock, &bh_result, 1);
 }
 
 static int isofs_bmap(struct inode *inode, sector_t block)
_

Patches currently in -mm which might be from dhowells@redhat.com are

git-mtd.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
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
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
mutex-subsystem-synchro-test-module.patch
