From: akpm@linux-foundation.org
Subject: + fs-efs-add-pr_fmt-use-__func__.patch added to -mm tree
Date: Wed, 14 May 2014 12:30:16 -0700
Message-ID: <5373c448.VRbzj0gjuUyLL5zu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaENTaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 15:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, fabf@skynet.be

Subject: + fs-efs-add-pr_fmt-use-__func__.patch added to -mm tree
To: fabf@skynet.be,joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 12:30:16 -0700


The patch titled
     Subject: fs/efs: add pr_fmt / use __func__
has been added to the -mm tree.  Its filename is
     fs-efs-add-pr_fmt-use-__func__.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-efs-add-pr_fmt-use-__func__.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-efs-add-pr_fmt-use-__func__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/efs: add pr_fmt / use __func__

Also uniformize function arguments.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/dir.c   |   11 +++++++----
 fs/efs/efs.h   |    6 ++++++
 fs/efs/file.c  |   12 +++++-------
 fs/efs/inode.c |   24 ++++++++++++++----------
 fs/efs/namei.c |    8 +++++---
 fs/efs/super.c |   23 ++++++++++++-----------
 6 files changed, 49 insertions(+), 35 deletions(-)

diff -puN fs/efs/dir.c~fs-efs-add-pr_fmt-use-__func__ fs/efs/dir.c
--- a/fs/efs/dir.c~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/dir.c
@@ -26,7 +26,8 @@ static int efs_readdir(struct file *file
 	int			slot;
 
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		pr_warn("EFS: WARNING: readdir(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("%s(): directory size not a multiple of EFS_DIRBSIZE\n",
+			__func__);
 
 	/* work out where this entry can be found */
 	block = ctx->pos >> EFS_DIRBSIZE_BITS;
@@ -43,14 +44,15 @@ static int efs_readdir(struct file *file
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 
 		if (!bh) {
-			pr_err("EFS: readdir(): failed to read dir block %d\n", block);
+			pr_err("%s(): failed to read dir block %d\n",
+			       __func__, block);
 			break;
 		}
 
 		dirblock = (struct efs_dir *) bh->b_data; 
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			pr_err("EFS: readdir(): invalid directory block\n");
+			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
 			break;
 		}
@@ -80,7 +82,8 @@ static int efs_readdir(struct file *file
 
 			/* sanity check */
 			if (nameptr - (char *) dirblock + namelen > EFS_DIRBSIZE) {
-				pr_warn("EFS: directory entry %d exceeds directory block\n", slot);
+				pr_warn("directory entry %d exceeds directory block\n",
+					slot);
 				continue;
 			}
 
diff -puN fs/efs/efs.h~fs-efs-add-pr_fmt-use-__func__ fs/efs/efs.h
--- a/fs/efs/efs.h~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/efs.h
@@ -7,6 +7,12 @@
 #ifndef _EFS_EFS_H_
 #define _EFS_EFS_H_
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <asm/uaccess.h>
 
diff -puN fs/efs/file.c~fs-efs-add-pr_fmt-use-__func__ fs/efs/file.c
--- a/fs/efs/file.c~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/file.c
@@ -22,10 +22,8 @@ int efs_get_block(struct inode *inode, s
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block,
-			inode->i_blocks,
-			inode->i_size);
+		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
+			__func__, block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
@@ -38,7 +36,7 @@ int efs_get_block(struct inode *inode, s
 int efs_bmap(struct inode *inode, efs_block_t block) {
 
 	if (block < 0) {
-		pr_warn("EFS: bmap(): block < 0\n");
+		pr_warn("%s(): block < 0\n", __func__);
 		return 0;
 	}
 
@@ -48,8 +46,8 @@ int efs_bmap(struct inode *inode, efs_bl
 		/*
 		 * i have no idea why this happens as often as it does
 		 */
-		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
-			block, inode->i_blocks, inode->i_size);
+		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
+			__func__, block, inode->i_blocks, inode->i_size);
 #endif
 		return 0;
 	}
diff -puN fs/efs/inode.c~fs-efs-add-pr_fmt-use-__func__ fs/efs/inode.c
--- a/fs/efs/inode.c~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/inode.c
@@ -89,7 +89,7 @@ struct inode *efs_iget(struct super_bloc
 
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		pr_warn("EFS: bread() failed at block %d\n", block);
+		pr_warn("%s() failed at block %d\n", __func__, block);
 		goto read_inode_error;
 	}
 
@@ -130,7 +130,8 @@ struct inode *efs_iget(struct super_bloc
 	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
 		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
 		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
-			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
+			pr_warn("extent %d has bad magic number in inode %lu\n",
+				i, inode->i_ino);
 			brelse(bh);
 			goto read_inode_error;
 		}
@@ -162,7 +163,7 @@ struct inode *efs_iget(struct super_bloc
 			init_special_inode(inode, inode->i_mode, device);
 			break;
 		default:
-			pr_warn("EFS: unsupported inode mode %o\n", inode->i_mode);
+			pr_warn("unsupported inode mode %o\n", inode->i_mode);
 			goto read_inode_error;
 			break;
 	}
@@ -171,7 +172,7 @@ struct inode *efs_iget(struct super_bloc
 	return inode;
         
 read_inode_error:
-	pr_warn("EFS: failed to read inode %lu\n", inode->i_ino);
+	pr_warn("failed to read inode %lu\n", inode->i_ino);
 	iget_failed(inode);
 	return ERR_PTR(-EIO);
 }
@@ -216,7 +217,7 @@ efs_block_t efs_map_block(struct inode *
     
 		/* if we only have one extent then nothing can be found */
 		if (in->numextents == 1) {
-			pr_err("EFS: map_block() failed to map (1 extent)\n");
+			pr_err("%s() failed to map (1 extent)\n", __func__);
 			return 0;
 		}
 
@@ -234,7 +235,7 @@ efs_block_t efs_map_block(struct inode *
 			}
 		}
 
-		pr_err("EFS: map_block() failed to map block %u (dir)\n", block);
+		pr_err("%s() failed to map block %u (dir)\n", __func__, block);
 		return 0;
 	}
 
@@ -262,7 +263,8 @@ efs_block_t efs_map_block(struct inode *
 
 		if (dirext == direxts) {
 			/* should never happen */
-			pr_err("EFS: couldn't find direct extent for indirect extent %d (block %u)\n", cur, block);
+			pr_err("couldn't find direct extent for indirect extent %d (block %u)\n",
+			       cur, block);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -279,7 +281,8 @@ efs_block_t efs_map_block(struct inode *
 
 			bh = sb_bread(inode->i_sb, iblock);
 			if (!bh) {
-				pr_err("EFS: bread() failed at block %d\n", iblock);
+				pr_err("%s() failed at block %d\n",
+				       __func__, iblock);
 				return 0;
 			}
 #ifdef DEBUG
@@ -294,7 +297,8 @@ efs_block_t efs_map_block(struct inode *
 		extent_copy(&(exts[ioffset]), &ext);
 
 		if (ext.cooked.ex_magic != 0) {
-			pr_err("EFS: extent %d has bad magic number in block %d\n", cur, iblock);
+			pr_err("extent %d has bad magic number in block %d\n",
+			       cur, iblock);
 			if (bh) brelse(bh);
 			return 0;
 		}
@@ -306,7 +310,7 @@ efs_block_t efs_map_block(struct inode *
 		}
 	}
 	if (bh) brelse(bh);
-	pr_err("EFS: map_block() failed to map block %u (indir)\n", block);
+	pr_err("%s() failed to map block %u (indir)\n", __func__, block);
 	return 0;
 }  
 
diff -puN fs/efs/namei.c~fs-efs-add-pr_fmt-use-__func__ fs/efs/namei.c
--- a/fs/efs/namei.c~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/namei.c
@@ -23,20 +23,22 @@ static efs_ino_t efs_find_entry(struct i
 	efs_block_t		block;
  
 	if (inode->i_size & (EFS_DIRBSIZE-1))
-		pr_warn("EFS: WARNING: find_entry(): directory size not a multiple of EFS_DIRBSIZE\n");
+		pr_warn("%s(): directory size not a multiple of EFS_DIRBSIZE\n",
+			__func__);
 
 	for(block = 0; block < inode->i_blocks; block++) {
 
 		bh = sb_bread(inode->i_sb, efs_bmap(inode, block));
 		if (!bh) {
-			pr_err("EFS: find_entry(): failed to read dir block %d\n", block);
+			pr_err("%s(): failed to read dir block %d\n",
+			       __func__, block);
 			return 0;
 		}
     
 		dirblock = (struct efs_dir *) bh->b_data;
 
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
-			pr_err("EFS: find_entry(): invalid directory block\n");
+			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
 			return(0);
 		}
diff -puN fs/efs/super.c~fs-efs-add-pr_fmt-use-__func__ fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-add-pr_fmt-use-__func__
+++ a/fs/efs/super.c
@@ -134,7 +134,7 @@ static const struct export_operations ef
 
 static int __init init_efs_fs(void) {
 	int err;
-	pr_info("EFS: "EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
+	pr_info(EFS_VERSION" - http://aeschi.ch.eu.org/efs/\n");
 	err = init_inodecache();
 	if (err)
 		goto out1;
@@ -179,7 +179,7 @@ static efs_block_t efs_validate_vh(struc
 		csum += be32_to_cpu(cs);
 	}
 	if (csum) {
-		pr_warn("EFS: SGI disklabel: checksum bad, label corrupted\n");
+		pr_warn("SGI disklabel: checksum bad, label corrupted\n");
 		return 0;
 	}
 
@@ -226,10 +226,10 @@ static efs_block_t efs_validate_vh(struc
 	}
 
 	if (slice == -1) {
-		pr_notice("EFS: partition table contained no EFS partitions\n");
+		pr_notice("partition table contained no EFS partitions\n");
 #ifdef DEBUG
 	} else {
-		pr_info("EFS: using slice %d (type %s, offset 0x%x)\n", slice,
+		pr_info("using slice %d (type %s, offset 0x%x)\n", slice,
 			(pt_entry->pt_name) ? pt_entry->pt_name : "unknown",
 			sblock);
 #endif
@@ -267,7 +267,7 @@ static int efs_fill_super(struct super_b
  
 	s->s_magic		= EFS_SUPER_MAGIC;
 	if (!sb_set_blocksize(s, EFS_BLOCKSIZE)) {
-		pr_err("EFS: device does not support %d byte blocks\n",
+		pr_err("device does not support %d byte blocks\n",
 			EFS_BLOCKSIZE);
 		return -EINVAL;
 	}
@@ -276,7 +276,7 @@ static int efs_fill_super(struct super_b
 	bh = sb_bread(s, 0);
 
 	if (!bh) {
-		pr_err("EFS: cannot read volume header\n");
+		pr_err("cannot read volume header\n");
 		return -EINVAL;
 	}
 
@@ -294,13 +294,14 @@ static int efs_fill_super(struct super_b
 
 	bh = sb_bread(s, sb->fs_start + EFS_SUPER);
 	if (!bh) {
-		pr_err("EFS: cannot read superblock\n");
+		pr_err("cannot read superblock\n");
 		return -EINVAL;
 	}
 		
 	if (efs_validate_super(sb, (struct efs_super *) bh->b_data)) {
 #ifdef DEBUG
-		pr_warn("EFS: invalid superblock at block %u\n", sb->fs_start + EFS_SUPER);
+		pr_warn("invalid superblock at block %u\n",
+			sb->fs_start + EFS_SUPER);
 #endif
 		brelse(bh);
 		return -EINVAL;
@@ -309,7 +310,7 @@ static int efs_fill_super(struct super_b
 
 	if (!(s->s_flags & MS_RDONLY)) {
 #ifdef DEBUG
-		pr_info("EFS: forcing read-only mode\n");
+		pr_info("forcing read-only mode\n");
 #endif
 		s->s_flags |= MS_RDONLY;
 	}
@@ -317,13 +318,13 @@ static int efs_fill_super(struct super_b
 	s->s_export_op = &efs_export_ops;
 	root = efs_iget(s, EFS_ROOTINODE);
 	if (IS_ERR(root)) {
-		pr_err("EFS: get root inode failed\n");
+		pr_err("get root inode failed\n");
 		return PTR_ERR(root);
 	}
 
 	s->s_root = d_make_root(root);
 	if (!(s->s_root)) {
-		pr_err("EFS: get root dentry failed\n");
+		pr_err("get root dentry failed\n");
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-time-ntpc-convert-simple_strtol-to-kstrtol.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
fs-configfs-convert-printk-to-pr_foo.patch
fs-configfs-use-pr_fmt.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
kernel-rebootc-convert-simple_strtoul-to-kstrtoint.patch
kernel-utsname_sysctlc-replace-obsolete-__initcall-by-device_initcall.patch
kernel-hung_taskc-convert-simple_strtoul-to-kstrtouint.patch
documentation-expand-clarify-debug-documentation.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
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
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

