From: akpm@linux-foundation.org
Subject: [merged] fs-efs-convert-printk-to-pr_foo.patch removed from -mm
 tree
Date: Thu, 05 Jun 2014 13:07:25 -0700
Message-ID: <5390cdfd.UuVTWenXMl8dzNfv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFEUH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be

Subject: [merged] fs-efs-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:25 -0700


The patch titled
     Subject: fs/efs: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-efs-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/efs: convert printk to pr_foo()

Convert all except KERN_DEBUG
(pr_debug doesn't work the same as printk(KERN_DEBUG and requires
special check)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/dir.c   |    8 ++++----
 fs/efs/file.c  |   10 ++++------
 fs/efs/inode.c |   20 ++++++++++----------
 fs/efs/namei.c |    6 +++---
 fs/efs/super.c |   23 +++++++++++------------
 5 files changed, 32 insertions(+), 35 deletions(-)

diff -puN fs/efs/dir.c~fs-efs-convert-printk-to-pr_foo fs/efs/dir.c
--- a/fs/efs/dir.c~fs-efs-convert-printk-to-pr_foo
+++ a/fs/efs/dir.c
@@ -26,7 +26,7 @@ static int efs_readdir(struct file *file
 	int			slot;
 
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		printk(KERN_WARNING "EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
 
 	/* work out where this entry can be found */
 	block = ctx->pos >> EFS_DIRBSIZE_BITS;
@@ -43,14 +43,14 @@ static int efs_readdir(struct file *file
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 
 		if (!bh) {
-			printk(KERN_ERR "EFS: readdir(): failed to read dir block %d\n", block);
+			pr_err("EFS: readdir(): failed to read dir block %d\n", block);
 			break;
 		}
 
 		dirblock = (struct efs_dir *) bh->b_data; 
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			printk(KERN_ERR "EFS: readdir(): invalid directory block\n");
+			pr_err("EFS: readdir(): invalid directory block\n");
 			brelse(bh);
 			break;
 		}
@@ -80,7 +80,7 @@ static int efs_readdir(struct file *file
 
 			/* sanity check */
 			if (nameptr - (char *) dirblock + namelen > EFS_DIRBSIZE) {
-				printk(KERN_WARNING "EFS: directory entry %d exceeds directory block\n", slot);
+				pr_warn("EFS: directory entry %d exceeds directory block\n", slot);
 				continue;
 			}
 
diff -puN fs/efs/file.c~fs-efs-convert-printk-to-pr_foo fs/efs/file.c
--- a/fs/efs/file.c~fs-efs-convert-printk-to-pr_foo
+++ a/fs/efs/file.c
@@ -22,7 +22,7 @@ int efs_get_block(struct inode *inode, s
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
+		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
 			block,
 			inode->i_blocks,
 			inode->i_size);
@@ -38,7 +38,7 @@ int efs_get_block(struct inode *inode, s
 int efs_bmap(struct inode *inode, efs_block_t block) {
 
 	if (block < 0) {
-		printk(KERN_WARNING "EFS: bmap(): block < 0\n");
+		pr_warn("EFS: bmap(): block < 0\n");
 		return 0;
 	}
 
@@ -48,10 +48,8 @@ int efs_bmap(struct inode *inode, efs_bl
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block,
-			inode->i_blocks,
-			inode->i_size);
+		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
+			block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
diff -puN fs/efs/inode.c~fs-efs-convert-printk-to-pr_foo fs/efs/inode.c
--- a/fs/efs/inode.c~fs-efs-convert-printk-to-pr_foo
+++ a/fs/efs/inode.c
@@ -89,7 +89,7 @@ struct inode *efs_iget(struct super_bloc
 
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		printk(KERN_WARNING "EFS: bread() failed at block %d\n", block);
+		pr_warn("EFS: bread() failed at block %d\n", block);
 		goto read_inode_error;
 	}
 
@@ -130,7 +130,7 @@ struct inode *efs_iget(struct super_bloc
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			printk(KERN_WARNING "EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
+			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
 		}
@@ -162,7 +162,7 @@ struct inode *efs_iget(struct super_bloc
 			init_special_inode(inode, inode->i_mode, device);
 			break;
 		default:
-			printk(KERN_WARNING "EFS: unsupported inode mode %o\n", inode->i_mode);
+			pr_warn("EFS: unsupported inode mode %o\n", inode->i_mode);
 			goto read_inode_error;
 			break;
 	}
@@ -171,7 +171,7 @@ struct inode *efs_iget(struct super_bloc
 	return inode;
         
 read_inode_error:
-	printk(KERN_WARNING "EFS: failed to read inode %lu\n", inode->i_ino);
+	pr_warn("EFS: failed to read inode %lu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }
@@ -216,7 +216,7 @@ efs_block_t efs_map_block(struct inode *
     
 		/* if we only have one extent then nothing can be found */
 		if (in->numextents == 1) {
-			printk(KERN_ERR "EFS: map_block() failed to map (1 extent)\n");
+			pr_err("EFS: map_block() failed to map (1 extent)\n");
 			return 0;
 		}
 
@@ -234,7 +234,7 @@ efs_block_t efs_map_block(struct inode *
 			}
 		}
 
-		printk(KERN_ERR "EFS: map_block() failed to map block %u (dir)\n", block);
+		pr_err("EFS: map_block() failed to map block %u (dir)\n", block);
 		return 0;
 	}
 
@@ -262,7 +262,7 @@ efs_block_t efs_map_block(struct inode *
 
 		if (dirext == direxts) {
 			/* should never happen */
-			printk(KERN_ERR "EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
+			pr_err("EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -279,7 +279,7 @@ efs_block_t efs_map_block(struct inode *
 
 			bh = sb_bread(inode->i_sb, iblock);
 			if (!bh) {
-				printk(KERN_ERR "EFS: bread() failed at block %d\n", iblock);
+				pr_err("EFS: bread() failed at block %d\n", iblock);
 				return 0;
 			}
 #ifdef DEBUG
@@ -294,7 +294,7 @@ efs_block_t efs_map_block(struct inode *
 		extent_copy(&(exts[ioffset]), &ext);
 
 		if (ext.cooked.ex_magic != 0) {
-			printk(KERN_ERR "EFS: extent %d has bad magic number in block %d\n", cur, iblock);
+			pr_err("EFS: extent %d has bad magic number in block %d\n", cur, iblock);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -306,7 +306,7 @@ efs_block_t efs_map_block(struct inode *
 		}
 	}
 	if (bh) brelse(bh);
-	printk(KERN_ERR "EFS: map_block() failed to map block %u (indir)\n", block);
+	pr_err("EFS: map_block() failed to map block %u (indir)\n", block);
 	return 0;
 }  
 
diff -puN fs/efs/namei.c~fs-efs-convert-printk-to-pr_foo fs/efs/namei.c
--- a/fs/efs/namei.c~fs-efs-convert-printk-to-pr_foo
+++ a/fs/efs/namei.c
@@ -23,20 +23,20 @@ static efs_ino_t efs_find_entry(struct i
 	efs_block_t		block;
  
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		printk(KERN_WARNING "EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
 
 	for(block = 0; block < inode->i_blocks; block++) {
 
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 		if (!bh) {
-			printk(KERN_ERR "EFS: find_entry(): failed to read dir block %d\n", block);
+			pr_err("EFS: find_entry(): failed to read dir block %d\n", block);
 			return 0;
 		}
     
 		dirblock = (struct efs_dir *) bh->b_data;
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			printk(KERN_ERR "EFS: find_entry(): invalid directory block\n");
+			pr_err("EFS: find_entry(): invalid directory block\n");
 			brelse(bh);
 			return(0);
 		}
diff -puN fs/efs/super.c~fs-efs-convert-printk-to-pr_foo fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-convert-printk-to-pr_foo
+++ a/fs/efs/super.c
@@ -134,7 +134,7 @@ static const struct export_operations ef
 
 static int __init init_efs_fs(void) {
 	int err;
-	printk("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
+	pr_info("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -179,7 +179,7 @@ static efs_block_t efs_validate_vh(struc
 		csum += be32_to_cpu(cs);
 	}
 	if (csum) {
-		printk(KERN_INFO "EFS: SGI disklabel: checksum bad, label corrupted\n");
+		pr_warn("EFS: SGI disklabel: checksum bad, label corrupted\n");
 		return 0;
 	}
 
@@ -226,11 +226,10 @@ static efs_block_t efs_validate_vh(struc
 	}
 
 	if (slice == -1) {
-		printk(KERN_NOTICE "EFS: partition table contained no EFS partitions\n");
+		pr_notice("EFS: partition table contained no EFS partitions\n");
 #ifdef DEBUG
 	} else {
-		printk(KERN_INFO "EFS: using slice %d (type %s, offset 0x%x)\n",
-			slice,
+		pr_info("EFS: using slice %d (type %s, offset 0x%x)\n", slice,
 			(pt_entry->pt_name) ? pt_entry->pt_name : "unknown",
 			sblock);
 #endif
@@ -268,7 +267,7 @@ static int efs_fill_super(struct super_b
  
 	s->s_magic		= EFS_SUPER_MAGIC;
 	if (!sb_set_blocksize(s, EFS_BLOCKSIZE)) {
-		printk(KERN_ERR "EFS: device does not support %d byte blocks\n",
+		pr_err("EFS: device does not support %d byte blocks\n",
 			EFS_BLOCKSIZE);
 		return -EINVAL;
 	}
@@ -277,7 +276,7 @@ static int efs_fill_super(struct super_b
 	bh = sb_bread(s, 0);
 
 	if (!bh) {
-		printk(KERN_ERR "EFS: cannot read volume header\n");
+		pr_err("EFS: cannot read volume header\n");
 		return -EINVAL;
 	}
 
@@ -295,13 +294,13 @@ static int efs_fill_super(struct super_b
 
 	bh = sb_bread(s, sb->fs_start + EFS_SUPER);
 	if (!bh) {
-		printk(KERN_ERR "EFS: cannot read superblock\n");
+		pr_err("EFS: cannot read superblock\n");
 		return -EINVAL;
 	}
 		
 	if (efs_validate_super(sb, (struct efs_super *) bh->b_data)) {
 #ifdef DEBUG
-		printk(KERN_WARNING "EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
+		pr_warn("EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
 #endif
 		brelse(bh);
 		return -EINVAL;
@@ -310,7 +309,7 @@ static int efs_fill_super(struct super_b
 
 	if (!(s->s_flags & MS_RDONLY)) {
 #ifdef DEBUG
-		printk(KERN_INFO "EFS: forcing read-only mode\n");
+		pr_info("EFS: forcing read-only mode\n");
 #endif
 		s->s_flags |= MS_RDONLY;
 	}
@@ -318,13 +317,13 @@ static int efs_fill_super(struct super_b
 	s->s_export_op = &efs_export_ops;
 	root = efs_iget(s, EFS_ROOTINODE);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "EFS: get root inode failed\n");
+		pr_err("EFS: get root inode failed\n");
 		return PTR_ERR(root);
 	}
 
 	s->s_root = d_make_root(root);
 	if (!(s->s_root)) {
-		printk(KERN_ERR "EFS: get root dentry failed\n");
+		pr_err("EFS: get root dentry failed\n");
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

