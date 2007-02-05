From: akpm@linux-foundation.org
Subject: + ufs-restore-back-support-of-openstep.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:20:00 -0800
Message-ID: <200702052220.l15MK0Rr001029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854AbXBEWV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru, stable@kernel.org


The patch titled
     ufs: restore back support of openstep
has been added to the -mm tree.  Its filename is
     ufs-restore-back-support-of-openstep.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: restore back support of openstep
From: Evgeniy Dushistov <dushistov@mail.ru>

This is a fix of regression, which triggered by ~2.6.16.

Patch with name ufs-directory-and-page-cache-from-blocks-to-pages.patch: in
additional to conversation from block to page cache mechanism added new
checks of directory integrity, one of them that directory entry do not
across directory chunks.

But some kinds of UFS: OpenStep UFS and Apple UFS (looks like these are the
same filesystems) have different directory chunk size, then common
UFSes(BSD and Solaris UFS).

So this patch adds ability to works with variable size of directory chunks,
and set it for ufstype=openstep to right size.

Tested on darwin ufs.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c           |   21 ++++++++++++---------
 fs/ufs/super.c         |    5 ++++-
 include/linux/ufs_fs.h |    1 +
 3 files changed, 17 insertions(+), 10 deletions(-)

diff -puN fs/ufs/dir.c~ufs-restore-back-support-of-openstep fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-restore-back-support-of-openstep
+++ a/fs/ufs/dir.c
@@ -106,12 +106,13 @@ static void ufs_check_page(struct page *
 	char *kaddr = page_address(page);
 	unsigned offs, rec_len;
 	unsigned limit = PAGE_CACHE_SIZE;
+	const unsigned chunk_mask = UFS_SB(sb)->s_uspi->s_dirblksize - 1;
 	struct ufs_dir_entry *p;
 	char *error;
 
 	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
 		limit = dir->i_size & ~PAGE_CACHE_MASK;
-		if (limit & (UFS_SECTOR_SIZE - 1))
+		if (limit & chunk_mask)
 			goto Ebadsize;
 		if (!limit)
 			goto out;
@@ -126,7 +127,7 @@ static void ufs_check_page(struct page *
 			goto Ealign;
 		if (rec_len < UFS_DIR_REC_LEN(ufs_get_de_namlen(sb, p)))
 			goto Enamelen;
-		if (((offs + rec_len - 1) ^ offs) & ~(UFS_SECTOR_SIZE-1))
+		if (((offs + rec_len - 1) ^ offs) & ~chunk_mask)
 			goto Espan;
 		if (fs32_to_cpu(sb, p->d_ino) > (UFS_SB(sb)->s_uspi->s_ipg *
 						  UFS_SB(sb)->s_uspi->s_ncg))
@@ -310,6 +311,7 @@ int ufs_add_link(struct dentry *dentry, 
 	int namelen = dentry->d_name.len;
 	struct super_block *sb = dir->i_sb;
 	unsigned reclen = UFS_DIR_REC_LEN(namelen);
+	const unsigned int chunk_size = UFS_SB(sb)->s_uspi->s_dirblksize;
 	unsigned short rec_len, name_len;
 	struct page *page = NULL;
 	struct ufs_dir_entry *de;
@@ -342,8 +344,8 @@ int ufs_add_link(struct dentry *dentry, 
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
 				name_len = 0;
-				rec_len = UFS_SECTOR_SIZE;
-				de->d_reclen = cpu_to_fs16(sb, UFS_SECTOR_SIZE);
+				rec_len = chunk_size;
+				de->d_reclen = cpu_to_fs16(sb, chunk_size);
 				de->d_ino = 0;
 				goto got_it;
 			}
@@ -431,7 +433,7 @@ ufs_readdir(struct file *filp, void *dir
 	unsigned int offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
 	unsigned long npages = ufs_dir_pages(inode);
-	unsigned chunk_mask = ~(UFS_SECTOR_SIZE - 1);
+	unsigned chunk_mask = ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	int need_revalidate = filp->f_version != inode->i_version;
 	unsigned flags = UFS_SB(sb)->s_flags;
 
@@ -511,7 +513,7 @@ int ufs_delete_entry(struct inode *inode
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = page->mapping;
 	char *kaddr = page_address(page);
-	unsigned from = ((char*)dir - kaddr) & ~(UFS_SECTOR_SIZE - 1);
+	unsigned from = ((char*)dir - kaddr) & ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
 	unsigned to = ((char*)dir - kaddr) + fs16_to_cpu(sb, dir->d_reclen);
 	struct ufs_dir_entry *pde = NULL;
 	struct ufs_dir_entry *de = (struct ufs_dir_entry *) (kaddr + from);
@@ -556,6 +558,7 @@ int ufs_make_empty(struct inode * inode,
 	struct super_block * sb = dir->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page = grab_cache_page(mapping, 0);
+	const unsigned int chunk_size = UFS_SB(sb)->s_uspi->s_dirblksize;
 	struct ufs_dir_entry * de;
 	char *base;
 	int err;
@@ -563,7 +566,7 @@ int ufs_make_empty(struct inode * inode,
 	if (!page)
 		return -ENOMEM;
 	kmap(page);
-	err = mapping->a_ops->prepare_write(NULL, page, 0, UFS_SECTOR_SIZE);
+	err = mapping->a_ops->prepare_write(NULL, page, 0, chunk_size);
 	if (err) {
 		unlock_page(page);
 		goto fail;
@@ -584,11 +587,11 @@ int ufs_make_empty(struct inode * inode,
 		((char *)de + fs16_to_cpu(sb, de->d_reclen));
 	de->d_ino = cpu_to_fs32(sb, dir->i_ino);
 	ufs_set_de_type(sb, de, dir->i_mode);
-	de->d_reclen = cpu_to_fs16(sb, UFS_SECTOR_SIZE - UFS_DIR_REC_LEN(1));
+	de->d_reclen = cpu_to_fs16(sb, chunk_size - UFS_DIR_REC_LEN(1));
 	ufs_set_de_namlen(sb, de, 2);
 	strcpy (de->d_name, "..");
 
-	err = ufs_commit_chunk(page, 0, UFS_SECTOR_SIZE);
+	err = ufs_commit_chunk(page, 0, chunk_size);
 fail:
 	kunmap(page);
 	page_cache_release(page);
diff -puN fs/ufs/super.c~ufs-restore-back-support-of-openstep fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-restore-back-support-of-openstep
+++ a/fs/ufs/super.c
@@ -649,7 +649,7 @@ static int ufs_fill_super(struct super_b
 		kmalloc (sizeof(struct ufs_sb_private_info), GFP_KERNEL);
 	if (!uspi)
 		goto failed;
-
+	uspi->s_dirblksize = UFS_SECTOR_SIZE;
 	super_block_offset=UFS_SBLOCK;
 
 	/* Keep 2Gig file limit. Some UFS variants need to override 
@@ -718,6 +718,7 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP:
+		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep\n");
 		uspi->s_fsize = block_size = 1024;
 		uspi->s_fmask = ~(1024 - 1);
@@ -733,6 +734,7 @@ static int ufs_fill_super(struct super_b
 		break;
 	
 	case UFS_MOUNT_UFSTYPE_NEXTSTEP_CD:
+		/*TODO: check may be we need set special dir block size?*/
 		UFSD("ufstype=nextstep-cd\n");
 		uspi->s_fsize = block_size = 2048;
 		uspi->s_fmask = ~(2048 - 1);
@@ -754,6 +756,7 @@ static int ufs_fill_super(struct super_b
 		uspi->s_fshift = 10;
 		uspi->s_sbsize = super_block_size = 2048;
 		uspi->s_sbbase = 0;
+		uspi->s_dirblksize = 1024;
 		flags |= UFS_DE_44BSD | UFS_UID_44BSD | UFS_ST_44BSD | UFS_CG_44BSD;
 		if (!(sb->s_flags & MS_RDONLY)) {
 			if (!silent)
diff -puN include/linux/ufs_fs.h~ufs-restore-back-support-of-openstep include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~ufs-restore-back-support-of-openstep
+++ a/include/linux/ufs_fs.h
@@ -789,6 +789,7 @@ struct ufs_sb_private_info {
 
 	__u32	s_maxsymlinklen;/* upper limit on fast symlinks' size */
 	__s32	fs_magic;       /* filesystem magic */
+	unsigned int s_dirblksize;
 };
 
 /*
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-restore-back-support-of-openstep.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
