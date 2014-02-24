From: akpm@linux-foundation.org
Subject: + hfsplus-fix-longname-handling.patch added to -mm tree
Date: Mon, 24 Feb 2014 13:48:38 -0800
Message-ID: <530bbe36.dD8Fkjuw+38v4n7m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBXVsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 16:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, hch@lst.de, sougata@tuxera.com

Subject: + hfsplus-fix-longname-handling.patch added to -mm tree
To: sougata@tuxera.com,hch@lst.de,slava@dubeyko.com
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 13:48:38 -0800


The patch titled
     Subject: hfsplus: fix longname handling
has been added to the -mm tree.  Its filename is
     hfsplus-fix-longname-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-fix-longname-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-fix-longname-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sougata Santra <sougata@tuxera.com>
Subject: hfsplus: fix longname handling

-ENAMETOOLONG returned from hfsplus_asc2uni was not propaged to iops. 
This allowed hfsplus to create files/directories with HFSPLUS_MAX_STRLEN
and incorrect keys, leaving the FS in an inconsistent state.  This patch
fixes this issue.

Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/catalog.c    |   89 +++++++++++++++++++++++++++-----------
 fs/hfsplus/dir.c        |   11 +++-
 fs/hfsplus/hfsplus_fs.h |    4 +
 fs/hfsplus/super.c      |    4 +
 4 files changed, 79 insertions(+), 29 deletions(-)

diff -puN fs/hfsplus/catalog.c~hfsplus-fix-longname-handling fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~hfsplus-fix-longname-handling
+++ a/fs/hfsplus/catalog.c
@@ -38,21 +38,30 @@ int hfsplus_cat_bin_cmp_key(const hfsplu
 	return hfsplus_strcmp(&k1->cat.name, &k2->cat.name);
 }
 
-void hfsplus_cat_build_key(struct super_block *sb, hfsplus_btree_key *key,
-			   u32 parent, struct qstr *str)
+/* Generates key for catalog file/folders record. */
+int hfsplus_cat_build_key(struct super_block *sb,
+		hfsplus_btree_key *key, u32 parent, struct qstr *str)
 {
-	int len;
+	int len, err;
 
 	key->cat.parent = cpu_to_be32(parent);
-	if (str) {
-		hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
-					str->name, str->len);
-		len = be16_to_cpu(key->cat.name.length);
-	} else {
-		key->cat.name.length = 0;
-		len = 0;
-	}
+	err = hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
+			str->name, str->len);
+	if (unlikely(err < 0))
+		return err;
+
+	len = be16_to_cpu(key->cat.name.length);
 	key->key_len = cpu_to_be16(6 + 2 * len);
+	return 0;
+}
+
+/* Generates key for catalog thread record. */
+void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
+			hfsplus_btree_key *key, u32 parent)
+{
+	key->cat.parent = cpu_to_be32(parent);
+	key->cat.name.length = 0;
+	key->key_len = cpu_to_be16(6);
 }
 
 static void hfsplus_cat_build_key_uni(hfsplus_btree_key *key, u32 parent,
@@ -167,11 +176,16 @@ static int hfsplus_fill_cat_thread(struc
 				   hfsplus_cat_entry *entry, int type,
 				   u32 parentid, struct qstr *str)
 {
+	int err;
+
 	entry->type = cpu_to_be16(type);
 	entry->thread.reserved = 0;
 	entry->thread.parentID = cpu_to_be32(parentid);
-	hfsplus_asc2uni(sb, &entry->thread.nodeName, HFSPLUS_MAX_STRLEN,
+	err = hfsplus_asc2uni(sb, &entry->thread.nodeName, HFSPLUS_MAX_STRLEN,
 				str->name, str->len);
+	if (unlikely(err < 0))
+		return err;
+
 	return 10 + be16_to_cpu(entry->thread.nodeName.length) * 2;
 }
 
@@ -183,7 +197,7 @@ int hfsplus_find_cat(struct super_block
 	int err;
 	u16 type;
 
-	hfsplus_cat_build_key(sb, fd->search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd->search_key, cnid);
 	err = hfs_brec_read(fd, &tmp, sizeof(hfsplus_cat_entry));
 	if (err)
 		return err;
@@ -250,11 +264,16 @@ int hfsplus_create_cat(u32 cnid, struct
 	if (err)
 		return err;
 
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry,
 		S_ISDIR(inode->i_mode) ?
 			HFSPLUS_FOLDER_THREAD : HFSPLUS_FILE_THREAD,
 		dir->i_ino, str);
+	if (unlikely(entry_size < 0)) {
+		err = entry_size;
+		goto err2;
+	}
+
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
@@ -265,7 +284,10 @@ int hfsplus_create_cat(u32 cnid, struct
 	if (err)
 		goto err2;
 
-	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+	err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+	if (unlikely(err))
+		goto err1;
+
 	entry_size = hfsplus_cat_build_record(&entry, cnid, inode);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
@@ -288,7 +310,7 @@ int hfsplus_create_cat(u32 cnid, struct
 	return 0;
 
 err1:
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	if (!hfs_brec_find(&fd, hfs_find_rec_by_key))
 		hfs_brec_remove(&fd);
 err2:
@@ -313,7 +335,7 @@ int hfsplus_delete_cat(u32 cnid, struct
 	if (!str) {
 		int len;
 
-		hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+		hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 		if (err)
 			goto out;
@@ -329,7 +351,9 @@ int hfsplus_delete_cat(u32 cnid, struct
 			off + 2, len);
 		fd.search_key->key_len = cpu_to_be16(6 + len);
 	} else
-		hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+		err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
+		if (unlikely(err))
+			goto out;
 
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
@@ -360,7 +384,7 @@ int hfsplus_delete_cat(u32 cnid, struct
 	if (err)
 		goto out;
 
-	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -405,7 +429,11 @@ int hfsplus_rename_cat(u32 cnid,
 	dst_fd = src_fd;
 
 	/* find the old dir entry and read the data */
-	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
+	err = hfsplus_cat_build_key(sb, src_fd.search_key,
+			src_dir->i_ino, src_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -419,7 +447,11 @@ int hfsplus_rename_cat(u32 cnid,
 	type = be16_to_cpu(entry.type);
 
 	/* create new dir entry with the data from the old entry */
-	hfsplus_cat_build_key(sb, dst_fd.search_key, dst_dir->i_ino, dst_name);
+	err = hfsplus_cat_build_key(sb, dst_fd.search_key,
+			dst_dir->i_ino, dst_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
@@ -436,7 +468,11 @@ int hfsplus_rename_cat(u32 cnid,
 	dst_dir->i_mtime = dst_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* finally remove the old entry */
-	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
+	err = hfsplus_cat_build_key(sb, src_fd.search_key,
+			src_dir->i_ino, src_name);
+	if (unlikely(err))
+		goto out;
+
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -449,7 +485,7 @@ int hfsplus_rename_cat(u32 cnid,
 	src_dir->i_mtime = src_dir->i_ctime = CURRENT_TIME_SEC;
 
 	/* remove old thread entry */
-	hfsplus_cat_build_key(sb, src_fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, src_fd.search_key, cnid);
 	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
@@ -459,9 +495,14 @@ int hfsplus_rename_cat(u32 cnid,
 		goto out;
 
 	/* create new thread entry */
-	hfsplus_cat_build_key(sb, dst_fd.search_key, cnid, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, dst_fd.search_key, cnid);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry, type,
 		dst_dir->i_ino, dst_name);
+	if (unlikely(entry_size < 0)) {
+		err = entry_size;
+		goto out;
+	}
+
 	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
diff -puN fs/hfsplus/dir.c~hfsplus-fix-longname-handling fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-fix-longname-handling
+++ a/fs/hfsplus/dir.c
@@ -43,7 +43,10 @@ static struct dentry *hfsplus_lookup(str
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	if (err)
 		return ERR_PTR(err);
-	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, &dentry->d_name);
+	err = hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino,
+			&dentry->d_name);
+	if (unlikely(err < 0))
+		goto fail;
 again:
 	err = hfs_brec_read(&fd, &entry, sizeof(entry));
 	if (err) {
@@ -96,9 +99,11 @@ again:
 					be32_to_cpu(entry.file.permissions.dev);
 				str.len = sprintf(name, "iNode%d", linkid);
 				str.name = name;
-				hfsplus_cat_build_key(sb, fd.search_key,
+				err = hfsplus_cat_build_key(sb, fd.search_key,
 					HFSPLUS_SB(sb)->hidden_dir->i_ino,
 					&str);
+				if (unlikely(err < 0))
+					goto fail;
 				goto again;
 			}
 		} else if (!dentry->d_fsdata)
@@ -139,7 +144,7 @@ static int hfsplus_readdir(struct file *
 	err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
 	if (err)
 		return err;
-	hfsplus_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
+	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, inode->i_ino);
 	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-fix-longname-handling fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-fix-longname-handling
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -444,8 +444,10 @@ int hfsplus_cat_case_cmp_key(const hfspl
 		const hfsplus_btree_key *);
 int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
 		const hfsplus_btree_key *);
-void hfsplus_cat_build_key(struct super_block *sb,
+int hfsplus_cat_build_key(struct super_block *sb,
 		hfsplus_btree_key *, u32, struct qstr *);
+void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
+		hfsplus_btree_key *, u32);
 int hfsplus_find_cat(struct super_block *, u32, struct hfs_find_data *);
 int hfsplus_create_cat(u32, struct inode *, struct qstr *, struct inode *);
 int hfsplus_delete_cat(u32, struct inode *, struct qstr *);
diff -puN fs/hfsplus/super.c~hfsplus-fix-longname-handling fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-fix-longname-handling
+++ a/fs/hfsplus/super.c
@@ -513,7 +513,9 @@ static int hfsplus_fill_super(struct sup
 	err = hfs_find_init(sbi->cat_tree, &fd);
 	if (err)
 		goto out_put_root;
-	hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
+	err = hfsplus_cat_build_key(sb, fd.search_key, HFSPLUS_ROOT_CNID, &str);
+	if (unlikely(err < 0))
+		goto out_put_root;
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER))
_

Patches currently in -mm which might be from sougata@tuxera.com are

hfsplus-remove-unused-variable-in-hfsplus_get_block.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
hfsplus-fix-longname-handling.patch

