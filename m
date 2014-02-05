From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hfsplus-integrate-journal-replay-support-into-driver.patch removed from -mm tree
Date: Wed, 05 Feb 2014 15:49:27 -0800
Message-ID: <52f2ce07.WlpCmP9xXsYW0jdP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbaBEXt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Feb 2014 18:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: [to-be-updated] hfsplus-integrate-journal-replay-support-into-driver.patch removed from -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Feb 2014 15:49:27 -0800


The patch titled
     Subject: hfsplus: integrate journal replay support into driver
has been removed from the -mm tree.  Its filename was
     hfsplus-integrate-journal-replay-support-into-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: integrate journal replay support into driver

Integrate HFS+ journal replaying functionality into the file system
driver.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/Makefile     |    3 -
 fs/hfsplus/hfsplus_fs.h |    5 ++
 fs/hfsplus/super.c      |   90 +++++++++++++++++++++++++++++++-------
 3 files changed, 82 insertions(+), 16 deletions(-)

diff -puN fs/hfsplus/Makefile~hfsplus-integrate-journal-replay-support-into-driver fs/hfsplus/Makefile
--- a/fs/hfsplus/Makefile~hfsplus-integrate-journal-replay-support-into-driver
+++ a/fs/hfsplus/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
 
 hfsplus-objs := super.o options.o inode.o ioctl.o extents.o catalog.o dir.o btree.o \
 		bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o part_tbl.o \
-		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
+		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o \
+		journal.o
 
 hfsplus-$(CONFIG_HFSPLUS_FS_POSIX_ACL)	+= posix_acl.o
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-integrate-journal-replay-support-into-driver fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-integrate-journal-replay-support-into-driver
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -489,6 +489,11 @@ int hfsplus_free_fork(struct super_block
 int hfsplus_file_extend(struct inode *);
 void hfsplus_file_truncate(struct inode *);
 
+/* journal.c */
+int hfsplus_init_journal(struct super_block *sb);
+void hfsplus_destroy_journal(struct super_block *sb);
+int hfsplus_check_journal(struct super_block *sb);
+
 /* inode.c */
 extern const struct address_space_operations hfsplus_aops;
 extern const struct address_space_operations hfsplus_btree_aops;
diff -puN fs/hfsplus/super.c~hfsplus-integrate-journal-replay-support-into-driver fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-integrate-journal-replay-support-into-driver
+++ a/fs/hfsplus/super.c
@@ -280,6 +280,8 @@ static void hfsplus_put_super(struct sup
 
 	cancel_delayed_work_sync(&sbi->sync_work);
 
+	hfsplus_destroy_journal(sb);
+
 	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
 		struct hfsplus_vh *vhdr = sbi->s_vhdr;
 
@@ -325,6 +327,7 @@ static int hfsplus_statfs(struct dentry
 static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	int err;
 
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
@@ -337,20 +340,38 @@ static int hfsplus_remount(struct super_
 
 		force = test_and_clear_bit(HFSPLUS_SB_FORCE, &sbi->flags);
 
+		if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
+			err = hfsplus_check_journal(sb);
+			if (err == -EROFS) {
+				if (force)
+					pr_warn("force mount option is ignored, norecovery is requested\n");
+				sb->s_flags |= MS_RDONLY;
+				*flags |= MS_RDONLY;
+				return 0;
+			} else if (unlikely(err)) {
+				pr_err("journal replay failed, remount read-only\n");
+				if (force)
+					pr_warn("force mount option is ignored for non-empty journal\n");
+				sb->s_flags |= MS_RDONLY;
+				*flags |= MS_RDONLY;
+				return 0;
+			}
+		} else if (test_and_clear_bit(HFSPLUS_SB_NORECOVERY,
+							&sbi->flags)) {
+			/* simply complain */
+			pr_warn("norecovery mount option is ignored for HFS+ volumes w/o journal\n");
+		}
+
 		if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
-			pr_warn("filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  leaving read-only.\n");
+			pr_warn("filesystem was not cleanly unmounted, remount read-only\n");
+			pr_warn("running fsck.hfsplus is recommended\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		} else if (force) {
 			/* nothing */
 		} else if (vhdr->attributes &
 				cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
-			pr_warn("filesystem is marked locked, leaving read-only.\n");
-			sb->s_flags |= MS_RDONLY;
-			*flags |= MS_RDONLY;
-		} else if (vhdr->attributes &
-				cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
-			pr_warn("filesystem is marked journaled, leaving read-only.\n");
+			pr_warn("filesystem is marked locked, remount read-only\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		}
@@ -423,6 +444,46 @@ static int hfsplus_fill_super(struct sup
 		pr_err("wrong filesystem version\n");
 		goto out_free_vhdr;
 	}
+
+	err = hfsplus_init_journal(sb);
+	if (err == -EROFS) {
+		/*
+		 * HFSPLUS_JOURNAL_NEED_INIT + norecovery option combination.
+		 * Do nothing.
+		 * Error code is checked before hfsplus_check_journal() call.
+		 */
+	} else if (unlikely(err)) {
+		pr_err("unable to initialize journal\n");
+		goto out_free_vhdr;
+	}
+
+	if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
+		int force;
+
+		if (err != -EROFS)
+			err = hfsplus_check_journal(sb);
+		if (err == -EROFS) {
+			force = test_and_clear_bit(HFSPLUS_SB_FORCE,
+							&sbi->flags);
+			if (!silent && force)
+				pr_warn("force mount option is ignored, norecovery is requested\n");
+			sb->s_flags |= MS_RDONLY;
+		} else if (unlikely(err)) {
+			force = test_and_clear_bit(HFSPLUS_SB_FORCE,
+							&sbi->flags);
+			if (!silent) {
+				pr_err("journal replay failed, mounting read-only\n");
+				if (force)
+					pr_warn("force mount option is ignored for non-empty journal\n");
+			}
+			sb->s_flags |= MS_RDONLY;
+		} /*else if (not read-only)
+			TODO: implement journalling thread start */
+	} else if (test_and_clear_bit(HFSPLUS_SB_NORECOVERY, &sbi->flags)) {
+		/* simply complain */
+		pr_warn("norecovery mount option is ignored for HFS+ volumes w/o journal\n");
+	}
+
 	sbi->total_blocks = be32_to_cpu(vhdr->total_blocks);
 	sbi->free_blocks = be32_to_cpu(vhdr->free_blocks);
 	sbi->next_cnid = be32_to_cpu(vhdr->next_cnid);
@@ -445,7 +506,7 @@ static int hfsplus_fill_super(struct sup
 	if ((last_fs_block > (sector_t)(~0ULL) >> (sbi->alloc_blksz_shift - 9)) ||
 	    (last_fs_page > (pgoff_t)(~0ULL))) {
 		pr_err("filesystem size too large\n");
-		goto out_free_vhdr;
+		goto out_destroy_journal;
 	}
 
 	/* Set up operations so we can load metadata */
@@ -453,16 +514,13 @@ static int hfsplus_fill_super(struct sup
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
 	if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
-		pr_warn("Filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  mounting read-only.\n");
+		pr_warn("filesystem was not cleanly unmounted, mounting read-only\n");
+		pr_warn("running fsck.hfsplus is recommended\n");
 		sb->s_flags |= MS_RDONLY;
 	} else if (test_and_clear_bit(HFSPLUS_SB_FORCE, &sbi->flags)) {
 		/* nothing */
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
-		pr_warn("Filesystem is marked locked, mounting read-only.\n");
-		sb->s_flags |= MS_RDONLY;
-	} else if ((vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) &&
-			!(sb->s_flags & MS_RDONLY)) {
-		pr_warn("write access to a journaled filesystem is not supported, use the force option at your own risk, mounting read-only.\n");
+		pr_warn("filesystem is marked locked, mounting read-only\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
@@ -472,7 +530,7 @@ static int hfsplus_fill_super(struct sup
 	sbi->ext_tree = hfs_btree_open(sb, HFSPLUS_EXT_CNID);
 	if (!sbi->ext_tree) {
 		pr_err("failed to load extents file\n");
-		goto out_free_vhdr;
+		goto out_destroy_journal;
 	}
 	sbi->cat_tree = hfs_btree_open(sb, HFSPLUS_CAT_CNID);
 	if (!sbi->cat_tree) {
@@ -597,6 +655,8 @@ out_close_cat_tree:
 	hfs_btree_close(sbi->cat_tree);
 out_close_ext_tree:
 	hfs_btree_close(sbi->ext_tree);
+out_destroy_journal:
+	hfsplus_destroy_journal(sb);
 out_free_vhdr:
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
_

Patches currently in -mm which might be from slava@dubeyko.com are


