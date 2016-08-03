From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-hide-function-name-argument-from-nilfs_error.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 11:12:58 -0700
Message-ID: <57a2342a.g8ICj3HuQg0X3em0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbcHCSNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: hide function name argument from nilfs_error()
has been removed from the -mm tree.  Its filename was
     nilfs2-hide-function-name-argument-from-nilfs_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: hide function name argument from nilfs_error()

Simplify nilfs_error(), an output function used to report critical issues
in file system.  This renames the original nilfs_error() function to
__nilfs_error() and redefines it as a macro to hide its function name
argument within the macro.

Every call site of nilfs_error() is changed to strip __func__ argument
except nilfs_bmap_convert_error(); nilfs_bmap_convert_error() directly
calls __nilfs_error() because it inherits caller's function name.

Link: http://lkml.kernel.org/r/1464875891-5443-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c  |    4 ++--
 fs/nilfs2/dir.c   |   38 +++++++++++++++++---------------------
 fs/nilfs2/ifile.c |    3 +--
 fs/nilfs2/nilfs.h |   20 +++++++++++++++++++-
 fs/nilfs2/super.c |   22 ++++++++++++----------
 5 files changed, 51 insertions(+), 36 deletions(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-hide-function-name-argument-from-nilfs_error fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-hide-function-name-argument-from-nilfs_error
+++ a/fs/nilfs2/bmap.c
@@ -41,8 +41,8 @@ static int nilfs_bmap_convert_error(stru
 	struct inode *inode = bmap->b_inode;
 
 	if (err == -EINVAL) {
-		nilfs_error(inode->i_sb, fname,
-			    "broken bmap (inode number=%lu)", inode->i_ino);
+		__nilfs_error(inode->i_sb, fname,
+			      "broken bmap (inode number=%lu)", inode->i_ino);
 		err = -EIO;
 	}
 	return err;
diff -puN fs/nilfs2/dir.c~nilfs2-hide-function-name-argument-from-nilfs_error fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c~nilfs2-hide-function-name-argument-from-nilfs_error
+++ a/fs/nilfs2/dir.c
@@ -140,10 +140,9 @@ out:
 	/* Too bad, we had an error */
 
 Ebadsize:
-	nilfs_error(sb, "nilfs_check_page",
+	nilfs_error(sb,
 		    "size of directory #%lu is not a multiple of chunk size",
-		    dir->i_ino
-	);
+		    dir->i_ino);
 	goto fail;
 Eshort:
 	error = "rec_len is smaller than minimal";
@@ -157,19 +156,18 @@ Enamelen:
 Espan:
 	error = "directory entry across blocks";
 bad_entry:
-	nilfs_error(sb, "nilfs_check_page", "bad entry in directory #%lu: %s - "
-		    "offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		    dir->i_ino, error, (page->index<<PAGE_SHIFT)+offs,
-		    (unsigned long) le64_to_cpu(p->inode),
+	nilfs_error(sb,
+		    "bad entry in directory #%lu: %s - offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
+		    dir->i_ino, error, (page->index << PAGE_SHIFT) + offs,
+		    (unsigned long)le64_to_cpu(p->inode),
 		    rec_len, p->name_len);
 	goto fail;
 Eend:
 	p = (struct nilfs_dir_entry *)(kaddr + offs);
-	nilfs_error(sb, "nilfs_check_page",
-		    "entry in directory #%lu spans the page boundary"
-		    "offset=%lu, inode=%lu",
-		    dir->i_ino, (page->index<<PAGE_SHIFT)+offs,
-		    (unsigned long) le64_to_cpu(p->inode));
+	nilfs_error(sb,
+		    "entry in directory #%lu spans the page boundary offset=%lu, inode=%lu",
+		    dir->i_ino, (page->index << PAGE_SHIFT) + offs,
+		    (unsigned long)le64_to_cpu(p->inode));
 fail:
 	SetPageError(page);
 	return false;
@@ -267,8 +265,7 @@ static int nilfs_readdir(struct file *fi
 		struct page *page = nilfs_get_page(inode, n);
 
 		if (IS_ERR(page)) {
-			nilfs_error(sb, __func__, "bad page in #%lu",
-				    inode->i_ino);
+			nilfs_error(sb, "bad page in #%lu", inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
 			return -EIO;
 		}
@@ -278,8 +275,7 @@ static int nilfs_readdir(struct file *fi
 			NILFS_DIR_REC_LEN(1);
 		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
 			if (de->rec_len == 0) {
-				nilfs_error(sb, __func__,
-					    "zero-length directory entry");
+				nilfs_error(sb, "zero-length directory entry");
 				nilfs_put_page(page);
 				return -EIO;
 			}
@@ -345,7 +341,7 @@ nilfs_find_entry(struct inode *dir, cons
 			kaddr += nilfs_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (de->rec_len == 0) {
-					nilfs_error(dir->i_sb, __func__,
+					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
 					nilfs_put_page(page);
 					goto out;
@@ -360,7 +356,7 @@ nilfs_find_entry(struct inode *dir, cons
 			n = 0;
 		/* next page is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
-			nilfs_error(dir->i_sb, __func__,
+			nilfs_error(dir->i_sb,
 			       "dir %lu size %lld exceeds block count %llu",
 			       dir->i_ino, dir->i_size,
 			       (unsigned long long)dir->i_blocks);
@@ -469,7 +465,7 @@ int nilfs_add_link(struct dentry *dentry
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
-				nilfs_error(dir->i_sb, __func__,
+				nilfs_error(dir->i_sb,
 					    "zero-length directory entry");
 				err = -EIO;
 				goto out_unlock;
@@ -541,7 +537,7 @@ int nilfs_delete_entry(struct nilfs_dir_
 
 	while ((char *)de < (char *)dir) {
 		if (de->rec_len == 0) {
-			nilfs_error(inode->i_sb, __func__,
+			nilfs_error(inode->i_sb,
 				    "zero-length directory entry");
 			err = -EIO;
 			goto out;
@@ -628,7 +624,7 @@ int nilfs_empty_dir(struct inode *inode)
 
 		while ((char *)de <= kaddr) {
 			if (de->rec_len == 0) {
-				nilfs_error(inode->i_sb, __func__,
+				nilfs_error(inode->i_sb,
 					    "zero-length directory entry (kaddr=%p, de=%p)",
 					    kaddr, de);
 				goto not_empty;
diff -puN fs/nilfs2/ifile.c~nilfs2-hide-function-name-argument-from-nilfs_error fs/nilfs2/ifile.c
--- a/fs/nilfs2/ifile.c~nilfs2-hide-function-name-argument-from-nilfs_error
+++ a/fs/nilfs2/ifile.c
@@ -145,8 +145,7 @@ int nilfs_ifile_get_inode_block(struct i
 	int err;
 
 	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
-		nilfs_error(sb, __func__, "bad inode number: %lu",
-			    (unsigned long) ino);
+		nilfs_error(sb, "bad inode number: %lu", (unsigned long)ino);
 		return -EINVAL;
 	}
 
diff -puN fs/nilfs2/nilfs.h~nilfs2-hide-function-name-argument-from-nilfs_error fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-hide-function-name-argument-from-nilfs_error
+++ a/fs/nilfs2/nilfs.h
@@ -299,10 +299,28 @@ static inline int nilfs_mark_inode_dirty
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 extern void nilfs_destroy_inode(struct inode *);
+
 extern __printf(3, 4)
-void nilfs_error(struct super_block *, const char *, const char *, ...);
+void __nilfs_error(struct super_block *sb, const char *function,
+		   const char *fmt, ...);
 extern __printf(3, 4)
 void nilfs_warning(struct super_block *, const char *, const char *, ...);
+
+#ifdef CONFIG_PRINTK
+
+#define nilfs_error(sb, fmt, ...)					\
+	__nilfs_error(sb, __func__, fmt, ##__VA_ARGS__)
+
+#else
+
+#define nilfs_error(sb, fmt, ...)					\
+	do {								\
+		no_printk(fmt, ##__VA_ARGS__);				\
+		__nilfs_error(sb, "", " ");				\
+	} while (0)
+
+#endif /* CONFIG_PRINTK */
+
 extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
diff -puN fs/nilfs2/super.c~nilfs2-hide-function-name-argument-from-nilfs_error fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-hide-function-name-argument-from-nilfs_error
+++ a/fs/nilfs2/super.c
@@ -91,19 +91,21 @@ static void nilfs_set_error(struct super
 }
 
 /**
- * nilfs_error() - report failure condition on a filesystem
+ * __nilfs_error() - report failure condition on a filesystem
  *
- * nilfs_error() sets an ERROR_FS flag on the superblock as well as
- * reporting an error message.  It should be called when NILFS detects
- * incoherences or defects of meta data on disk.  As for sustainable
- * errors such as a single-shot I/O error, nilfs_warning() or the printk()
- * function should be used instead.
+ * __nilfs_error() sets an ERROR_FS flag on the superblock as well as
+ * reporting an error message.  This function should be called when
+ * NILFS detects incoherences or defects of meta data on disk.
  *
- * The segment constructor must not call this function because it can
- * kill itself.
+ * This implements the body of nilfs_error() macro.  Normally,
+ * nilfs_error() should be used.  As for sustainable errors such as a
+ * single-shot I/O error, nilfs_warning() or printk() should be used
+ * instead.
+ *
+ * Callers should not add a trailing newline since this will do it.
  */
-void nilfs_error(struct super_block *sb, const char *function,
-		 const char *fmt, ...)
+void __nilfs_error(struct super_block *sb, const char *function,
+		   const char *fmt, ...)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct va_format vaf;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


