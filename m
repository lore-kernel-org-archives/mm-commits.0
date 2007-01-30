From: akpm@osdl.org
Subject: + ufs2-write-inodes-write.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:56:45 -0800
Message-ID: <200701300056.l0U0uji5004727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35861 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXA3A4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     ufs2 write: inodes write
has been added to the -mm tree.  Its filename is
     ufs2-write-inodes-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs2 write: inodes write
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch adds into write inode path function to write UFS2 inode, and
modifys allocate inode path to allocate and init additional inode chunks.

Also some cleanups:
- remove not used parameters in some functions
- remove i_gen field from ufs_inode_info structure,
there is i_generation in inode structure with same purposes.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/ialloc.c          |  116 ++++++++++++++++++++++++++++++++-----
 fs/ufs/inode.c           |  111 +++++++++++++++++++++++++----------
 fs/ufs/super.c           |   36 +++++++----
 include/linux/ufs_fs.h   |    4 -
 include/linux/ufs_fs_i.h |    1 
 5 files changed, 208 insertions(+), 60 deletions(-)

diff -puN fs/ufs/ialloc.c~ufs2-write-inodes-write fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~ufs2-write-inodes-write
+++ a/fs/ufs/ialloc.c
@@ -18,6 +18,9 @@
  *  Stephen Tweedie (sct@dcs.ed.ac.uk), 1993
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
+ *
+ * UFS2 write support added by
+ * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
 
 #include <linux/fs.h>
@@ -126,6 +129,47 @@ void ufs_free_inode (struct inode * inod
 }
 
 /*
+ * Nullify new chunk of inodes,
+ * BSD people also set ui_gen field of inode
+ * during nullification, but we not care about
+ * that because of linux ufs do not support NFS
+ */
+static void ufs2_init_inodes_chunk(struct super_block *sb,
+				   struct ufs_cg_private_info *ucpi,
+				   struct ufs_cylinder_group *ucg)
+{
+	struct buffer_head *bh;
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
+	sector_t beg = uspi->s_sbbase +
+		ufs_inotofsba(ucpi->c_cgx * uspi->s_ipg +
+			      fs32_to_cpu(sb, ucg->cg_u.cg_u2.cg_initediblk));
+	sector_t end = beg + uspi->s_fpb;
+
+	UFSD("ENTER cgno %d\n", ucpi->c_cgx);
+
+	for (; beg < end; ++beg) {
+		bh = sb_getblk(sb, beg);
+		lock_buffer(bh);
+		memset(bh->b_data, 0, sb->s_blocksize);
+		set_buffer_uptodate(bh);
+		mark_buffer_dirty(bh);
+		unlock_buffer(bh);
+		if (sb->s_flags & MS_SYNCHRONOUS)
+			sync_dirty_buffer(bh);
+		brelse(bh);
+	}
+
+	fs32_add(sb, &ucg->cg_u.cg_u2.cg_initediblk, uspi->s_inopb);
+	ubh_mark_buffer_dirty(UCPI_UBH(ucpi));
+	if (sb->s_flags & MS_SYNCHRONOUS) {
+		ubh_ll_rw_block(SWRITE, UCPI_UBH(ucpi));
+		ubh_wait_on_buffer(UCPI_UBH(ucpi));
+	}
+
+	UFSD("EXIT\n");
+}
+
+/*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
  * free space and a low directory-to-inode ratio; if that fails, then of
@@ -146,6 +190,7 @@ struct inode * ufs_new_inode(struct inod
 	struct inode * inode;
 	unsigned cg, bit, i, j, start;
 	struct ufs_inode_info *ufsi;
+	int err = -ENOSPC;
 
 	UFSD("ENTER\n");
 	
@@ -198,13 +243,15 @@ struct inode * ufs_new_inode(struct inod
 			goto cg_found;
 		}
 	}
-	
+
 	goto failed;
 
 cg_found:
 	ucpi = ufs_load_cylinder (sb, cg);
-	if (!ucpi)
+	if (!ucpi) {
+		err = -EIO;
 		goto failed;
+	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
 	if (!ufs_cg_chkmagic(sb, ucg)) 
 		ufs_panic (sb, "ufs_new_inode", "internal error, bad cg magic number");
@@ -216,6 +263,7 @@ cg_found:
 		if (!(bit < start)) {
 			ufs_error (sb, "ufs_new_inode",
 			    "cylinder group %u corrupted - error in inode bitmap\n", cg);
+			err = -EIO;
 			goto failed;
 		}
 	}
@@ -224,9 +272,18 @@ cg_found:
 		ubh_setbit (UCPI_UBH(ucpi), ucpi->c_iusedoff, bit);
 	else {
 		ufs_panic (sb, "ufs_new_inode", "internal error");
+		err = -EIO;
 		goto failed;
 	}
-	
+
+	if (uspi->fs_magic == UFS2_MAGIC) {
+		u32 initediblk = fs32_to_cpu(sb, ucg->cg_u.cg_u2.cg_initediblk);
+
+		if (bit + uspi->s_inopb > initediblk &&
+		    initediblk < fs32_to_cpu(sb, ucg->cg_u.cg_u2.cg_niblk))
+			ufs2_init_inodes_chunk(sb, ucpi, ucg);
+	}
+
 	fs32_sub(sb, &ucg->cg_cs.cs_nifree, 1);
 	uspi->cs_total.cs_nifree--;
 	fs32_sub(sb, &sbi->fs_cs(cg).cs_nifree, 1);
@@ -236,7 +293,6 @@ cg_found:
 		uspi->cs_total.cs_ndir++;
 		fs32_add(sb, &sbi->fs_cs(cg).cs_ndir, 1);
 	}
-
 	ubh_mark_buffer_dirty (USPI_UBH(uspi));
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS) {
@@ -245,6 +301,7 @@ cg_found:
 	}
 	sb->s_dirt = 1;
 
+	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_mode = mode;
 	inode->i_uid = current->fsuid;
 	if (dir->i_mode & S_ISGID) {
@@ -254,39 +311,72 @@ cg_found:
 	} else
 		inode->i_gid = current->fsgid;
 
-	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode->i_blocks = 0;
+	inode->i_generation = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	ufsi->i_flags = UFS_I(dir)->i_flags;
 	ufsi->i_lastfrag = 0;
-	ufsi->i_gen = 0;
 	ufsi->i_shadow = 0;
 	ufsi->i_osync = 0;
 	ufsi->i_oeftflag = 0;
 	ufsi->i_dir_start_lookup = 0;
 	memset(&ufsi->i_u1, 0, sizeof(ufsi->i_u1));
-
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 
+	if (uspi->fs_magic == UFS2_MAGIC) {
+		struct buffer_head *bh;
+		struct ufs2_inode *ufs2_inode;
+
+		/*
+		 * setup birth date, we do it here because of there is no sense
+		 * to hold it in struct ufs_inode_info, and lose 64 bit
+		 */
+		bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
+		if (!bh) {
+			ufs_warning(sb, "ufs_read_inode",
+				    "unable to read inode %lu\n",
+				    inode->i_ino);
+			err = -EIO;
+			goto fail_remove_inode;
+		}
+		lock_buffer(bh);
+		ufs2_inode = (struct ufs2_inode *)bh->b_data;
+		ufs2_inode += ufs_inotofsbo(inode->i_ino);
+		ufs2_inode->ui_birthtime.tv_sec =
+			cpu_to_fs32(sb, CURRENT_TIME_SEC.tv_sec);
+		ufs2_inode->ui_birthtime.tv_usec = 0;
+		mark_buffer_dirty(bh);
+		unlock_buffer(bh);
+		if (sb->s_flags & MS_SYNCHRONOUS)
+			sync_dirty_buffer(bh);
+		brelse(bh);
+	}
+
 	unlock_super (sb);
 
 	if (DQUOT_ALLOC_INODE(inode)) {
 		DQUOT_DROP(inode);
-		inode->i_flags |= S_NOQUOTA;
-		inode->i_nlink = 0;
-		iput(inode);
-		return ERR_PTR(-EDQUOT);
+		err = -EDQUOT;
+		goto fail_without_unlock;
 	}
 
 	UFSD("allocating inode %lu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
+fail_remove_inode:
+	unlock_super(sb);
+fail_without_unlock:
+	inode->i_flags |= S_NOQUOTA;
+	inode->i_nlink = 0;
+	iput(inode);
+	UFSD("EXIT (FAILED): err %d\n", err);
+	return ERR_PTR(err);
 failed:
 	unlock_super (sb);
 	make_bad_inode(inode);
 	iput (inode);
-	UFSD("EXIT (FAILED)\n");
-	return ERR_PTR(-ENOSPC);
+	UFSD("EXIT (FAILED): err %d\n", err);
+	return ERR_PTR(err);
 }
diff -puN fs/ufs/inode.c~ufs2-write-inodes-write fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs2-write-inodes-write
+++ a/fs/ufs/inode.c
@@ -615,8 +615,8 @@ static void ufs1_read_inode(struct inode
 	inode->i_atime.tv_nsec = 0;
 	inode->i_ctime.tv_nsec = 0;
 	inode->i_blocks = fs32_to_cpu(sb, ufs_inode->ui_blocks);
+	inode->i_generation = fs32_to_cpu(sb, ufs_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs_inode->ui_flags);
-	ufsi->i_gen = fs32_to_cpu(sb, ufs_inode->ui_gen);
 	ufsi->i_shadow = fs32_to_cpu(sb, ufs_inode->ui_u3.ui_sun.ui_shadow);
 	ufsi->i_oeftflag = fs32_to_cpu(sb, ufs_inode->ui_u3.ui_sun.ui_oeftflag);
 
@@ -660,8 +660,8 @@ static void ufs2_read_inode(struct inode
 	inode->i_atime.tv_nsec = 0;
 	inode->i_ctime.tv_nsec = 0;
 	inode->i_blocks = fs64_to_cpu(sb, ufs2_inode->ui_blocks);
+	inode->i_generation = fs32_to_cpu(sb, ufs2_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs2_inode->ui_flags);
-	ufsi->i_gen = fs32_to_cpu(sb, ufs2_inode->ui_gen);
 	/*
 	ufsi->i_shadow = fs32_to_cpu(sb, ufs_inode->ui_u3.ui_sun.ui_shadow);
 	ufsi->i_oeftflag = fs32_to_cpu(sb, ufs_inode->ui_u3.ui_sun.ui_oeftflag);
@@ -730,34 +730,11 @@ bad_inode:
 	make_bad_inode(inode);
 }
 
-static int ufs_update_inode(struct inode * inode, int do_sync)
+static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
 {
-	struct ufs_inode_info *ufsi = UFS_I(inode);
-	struct super_block * sb;
-	struct ufs_sb_private_info * uspi;
-	struct buffer_head * bh;
-	struct ufs_inode * ufs_inode;
-	unsigned i;
-	unsigned flags;
-
-	UFSD("ENTER, ino %lu\n", inode->i_ino);
-
-	sb = inode->i_sb;
-	uspi = UFS_SB(sb)->s_uspi;
-	flags = UFS_SB(sb)->s_flags;
-
-	if (inode->i_ino < UFS_ROOTINO || 
-	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
-		ufs_warning (sb, "ufs_read_inode", "bad inode number (%lu)\n", inode->i_ino);
-		return -1;
-	}
-
-	bh = sb_bread(sb, ufs_inotofsba(inode->i_ino));
-	if (!bh) {
-		ufs_warning (sb, "ufs_read_inode", "unable to read inode %lu\n", inode->i_ino);
-		return -1;
-	}
-	ufs_inode = (struct ufs_inode *) (bh->b_data + ufs_inotofsbo(inode->i_ino) * sizeof(struct ufs_inode));
+	struct super_block *sb = inode->i_sb;
+ 	struct ufs_inode_info *ufsi = UFS_I(inode);
+ 	unsigned i;
 
 	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
 	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
@@ -774,9 +751,9 @@ static int ufs_update_inode(struct inode
 	ufs_inode->ui_mtime.tv_usec = 0;
 	ufs_inode->ui_blocks = cpu_to_fs32(sb, inode->i_blocks);
 	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
-	ufs_inode->ui_gen = cpu_to_fs32(sb, ufsi->i_gen);
+	ufs_inode->ui_gen = cpu_to_fs32(sb, inode->i_generation);
 
-	if ((flags & UFS_UID_MASK) == UFS_UID_EFT) {
+	if ((UFS_SB(sb)->s_flags & UFS_UID_MASK) == UFS_UID_EFT) {
 		ufs_inode->ui_u3.ui_sun.ui_shadow = cpu_to_fs32(sb, ufsi->i_shadow);
 		ufs_inode->ui_u3.ui_sun.ui_oeftflag = cpu_to_fs32(sb, ufsi->i_oeftflag);
 	}
@@ -795,6 +772,78 @@ static int ufs_update_inode(struct inode
 
 	if (!inode->i_nlink)
 		memset (ufs_inode, 0, sizeof(struct ufs_inode));
+}
+
+static void ufs2_update_inode(struct inode *inode, struct ufs2_inode *ufs_inode)
+{
+	struct super_block *sb = inode->i_sb;
+ 	struct ufs_inode_info *ufsi = UFS_I(inode);
+ 	unsigned i;
+
+	UFSD("ENTER\n");
+	ufs_inode->ui_mode = cpu_to_fs16(sb, inode->i_mode);
+	ufs_inode->ui_nlink = cpu_to_fs16(sb, inode->i_nlink);
+
+	ufs_inode->ui_uid = cpu_to_fs32(sb, inode->i_uid);
+	ufs_inode->ui_gid = cpu_to_fs32(sb, inode->i_gid);
+
+	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
+	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb, inode->i_atime.tv_sec);
+	ufs_inode->ui_atime.tv_usec = 0;
+	ufs_inode->ui_ctime.tv_sec = cpu_to_fs32(sb, inode->i_ctime.tv_sec);
+	ufs_inode->ui_ctime.tv_usec = 0;
+	ufs_inode->ui_mtime.tv_sec = cpu_to_fs32(sb, inode->i_mtime.tv_sec);
+	ufs_inode->ui_mtime.tv_usec = 0;
+
+	ufs_inode->ui_blocks = cpu_to_fs64(sb, inode->i_blocks);
+	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
+	ufs_inode->ui_gen = cpu_to_fs32(sb, inode->i_generation);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
+		/* ufs_inode->ui_u2.ui_addr.ui_db[0] = cpu_to_fs32(sb, inode->i_rdev); */
+		ufs_inode->ui_u2.ui_addr.ui_db[0] = ufsi->i_u1.u2_i_data[0];
+	} else if (inode->i_blocks) {
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
+			ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.u2_i_data[i];
+	} else {
+		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
+			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];
+ 	}
+
+	if (!inode->i_nlink)
+		memset (ufs_inode, 0, sizeof(struct ufs2_inode));
+	UFSD("EXIT\n");
+}
+
+static int ufs_update_inode(struct inode * inode, int do_sync)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
+	struct buffer_head * bh;
+
+	UFSD("ENTER, ino %lu\n", inode->i_ino);
+
+	if (inode->i_ino < UFS_ROOTINO ||
+	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
+		ufs_warning (sb, "ufs_read_inode", "bad inode number (%lu)\n", inode->i_ino);
+		return -1;
+	}
+
+	bh = sb_bread(sb, ufs_inotofsba(inode->i_ino));
+	if (!bh) {
+		ufs_warning (sb, "ufs_read_inode", "unable to read inode %lu\n", inode->i_ino);
+		return -1;
+	}
+	if (uspi->fs_magic == UFS2_MAGIC) {
+		struct ufs2_inode *ufs2_inode = (struct ufs2_inode *)bh->b_data;
+
+		ufs2_update_inode(inode,
+				  ufs2_inode + ufs_inotofsbo(inode->i_ino));
+	} else {
+		struct ufs_inode *ufs_inode = (struct ufs_inode *) bh->b_data;
+
+		ufs1_update_inode(inode, ufs_inode + ufs_inotofsbo(inode->i_ino));
+	}
 		
 	mark_buffer_dirty(bh);
 	if (do_sync)
diff -puN fs/ufs/super.c~ufs2-write-inodes-write fs/ufs/super.c
--- a/fs/ufs/super.c~ufs2-write-inodes-write
+++ a/fs/ufs/super.c
@@ -95,14 +95,16 @@
 /*
  * Print contents of ufs_super_block, useful for debugging
  */
-static void ufs_print_super_stuff(struct super_block *sb, unsigned flags,
+static void ufs_print_super_stuff(struct super_block *sb,
 				  struct ufs_super_block_first *usb1,
 				  struct ufs_super_block_second *usb2,
 				  struct ufs_super_block_third *usb3)
 {
+	u32 magic = fs32_to_cpu(sb, usb3->fs_magic);
+
 	printk("ufs_print_super_stuff\n");
-	printk("  magic:     0x%x\n", fs32_to_cpu(sb, usb3->fs_magic));
-	if ((flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2) {
+	printk("  magic:     0x%x\n", magic);
+	if (fs32_to_cpu(sb, usb3->fs_magic) == UFS2_MAGIC) {
 		printk("  fs_size:   %llu\n", (unsigned long long)
 		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_size));
 		printk("  fs_dsize:  %llu\n", (unsigned long long)
@@ -119,6 +121,12 @@ static void ufs_print_super_stuff(struct
 		printk("  cs_nbfree(No of free blocks):  %llu\n",
 		       (unsigned long long)
 		       fs64_to_cpu(sb, usb2->fs_un.fs_u2.cs_nbfree));
+		printk(KERN_INFO"  cs_nifree(Num of free inodes): %llu\n",
+		       (unsigned long long)
+		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nifree));
+		printk(KERN_INFO"  cs_nffree(Num of free frags): %llu\n",
+		       (unsigned long long)
+		       fs64_to_cpu(sb, usb3->fs_un1.fs_u2.cs_nffree));
 	} else {
 		printk(" sblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_sblkno));
 		printk(" cblkno:      %u\n", fs32_to_cpu(sb, usb1->fs_cblkno));
@@ -201,7 +209,7 @@ static void ufs_print_cylinder_stuff(str
 	printk("\n");
 }
 #else
-#  define ufs_print_super_stuff(sb, flags, usb1, usb2, usb3) /**/
+#  define ufs_print_super_stuff(sb, usb1, usb2, usb3) /**/
 #  define ufs_print_cylinder_stuff(sb, cg) /**/
 #endif /* CONFIG_UFS_DEBUG */
 
@@ -424,7 +432,6 @@ static int ufs_read_cylinder_structures(
 {
 	struct ufs_sb_info *sbi = UFS_SB(sb);
 	struct ufs_sb_private_info *uspi = sbi->s_uspi;
-	unsigned flags = sbi->s_flags;
 	struct ufs_buffer_head * ubh;
 	unsigned char * base, * space;
 	unsigned size, blks, i;
@@ -448,11 +455,7 @@ static int ufs_read_cylinder_structures(
 		if (i + uspi->s_fpb > blks)
 			size = (blks - i) * uspi->s_fsize;
 
-		if ((flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2) 
-			ubh = ubh_bread(sb,
-				fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_csaddr) + i, size);
-		else 
-			ubh = ubh_bread(sb, uspi->s_csaddr + i, size);
+		ubh = ubh_bread(sb, uspi->s_csaddr + i, size);
 		
 		if (!ubh)
 			goto failed;
@@ -547,6 +550,7 @@ static void ufs_put_cstotal(struct super
 			cpu_to_fs32(sb, uspi->cs_total.cs_nffree);
 	}
 	ubh_mark_buffer_dirty(USPI_UBH(uspi));
+	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 	UFSD("EXIT\n");
 }
 
@@ -574,7 +578,9 @@ static void ufs_put_super_internal(struc
 		size = uspi->s_bsize;
 		if (i + uspi->s_fpb > blks)
 			size = (blks - i) * uspi->s_fsize;
+
 		ubh = ubh_bread(sb, uspi->s_csaddr + i, size);
+
 		ubh_memcpyubh (ubh, space, size);
 		space += size;
 		ubh_mark_buffer_uptodate (ubh, 1);
@@ -885,7 +891,7 @@ magic_found:
 	}
 
 
-	ufs_print_super_stuff(sb, flags, usb1, usb2, usb3);
+	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
 	 * Check, if file system was correctly unmounted.
@@ -968,7 +974,12 @@ magic_found:
 	uspi->s_npsect = ufs_get_fs_npsect(sb, usb1, usb3);
 	uspi->s_interleave = fs32_to_cpu(sb, usb1->fs_interleave);
 	uspi->s_trackskew = fs32_to_cpu(sb, usb1->fs_trackskew);
-	uspi->s_csaddr = fs32_to_cpu(sb, usb1->fs_csaddr);
+
+	if (uspi->fs_magic == UFS2_MAGIC)
+		uspi->s_csaddr = fs64_to_cpu(sb, usb3->fs_un1.fs_u2.fs_csaddr);
+	else
+		uspi->s_csaddr = fs32_to_cpu(sb, usb1->fs_csaddr);
+
 	uspi->s_cssize = fs32_to_cpu(sb, usb1->fs_cssize);
 	uspi->s_cgsize = fs32_to_cpu(sb, usb1->fs_cgsize);
 	uspi->s_ntrak = fs32_to_cpu(sb, usb1->fs_ntrak);
@@ -1055,7 +1066,6 @@ static void ufs_write_super(struct super
 	unsigned flags;
 
 	lock_kernel();
-
 	UFSD("ENTER\n");
 	flags = UFS_SB(sb)->s_flags;
 	uspi = UFS_SB(sb)->s_uspi;
diff -puN include/linux/ufs_fs.h~ufs2-write-inodes-write include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~ufs2-write-inodes-write
+++ a/include/linux/ufs_fs.h
@@ -261,7 +261,7 @@ typedef __u16 __bitwise __fs16;
  */
 #define	ufs_inotocg(x)		((x) / uspi->s_ipg)
 #define	ufs_inotocgoff(x)	((x) % uspi->s_ipg)
-#define	ufs_inotofsba(x)	(ufs_cgimin(ufs_inotocg(x)) + ufs_inotocgoff(x) / uspi->s_inopf)
+#define	ufs_inotofsba(x)	(((u64)ufs_cgimin(ufs_inotocg(x))) + ufs_inotocgoff(x) / uspi->s_inopf)
 #define	ufs_inotofsbo(x)	((x) % uspi->s_inopf)
 
 /*
@@ -754,7 +754,7 @@ struct ufs_sb_private_info {
 	__u32	s_npsect;	/* # sectors/track including spares */
 	__u32	s_interleave;	/* hardware sector interleave */
 	__u32	s_trackskew;	/* sector 0 skew, per track */
-	__u32	s_csaddr;	/* blk addr of cyl grp summary area */
+	__u64	s_csaddr;	/* blk addr of cyl grp summary area */
 	__u32	s_cssize;	/* size of cyl grp summary area */
 	__u32	s_cgsize;	/* cylinder group size */
 	__u32	s_ntrak;	/* tracks per cylinder */
diff -puN include/linux/ufs_fs_i.h~ufs2-write-inodes-write include/linux/ufs_fs_i.h
--- a/include/linux/ufs_fs_i.h~ufs2-write-inodes-write
+++ a/include/linux/ufs_fs_i.h
@@ -20,7 +20,6 @@ struct ufs_inode_info {
 		__fs64	u2_i_data[15];
 	} i_u1;
 	__u32	i_flags;
-	__u32	i_gen;
 	__u32	i_shadow;
 	__u32	i_unused1;
 	__u32	i_unused2;
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-alloc-metadata-null-page-fix.patch
ufs-truncate-negative-to-unsigned-fix.patch
ufs-rellocation-fix.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
