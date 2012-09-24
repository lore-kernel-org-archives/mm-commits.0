From: akpm@linux-foundation.org
Subject: + hfsplus-add-support-of-manipulation-by-attributes-file.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:49:28 -0700
Message-ID: <20120924224929.CE9F920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57443 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2IXWtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:49:33 -0400
Received: by faet1 with SMTP id t1so394199fae.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:49:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@lst.de, htl10@users.sourceforge.net, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: add support of manipulation by attributes file
has been added to the -mm tree.  Its filename is
     hfsplus-add-support-of-manipulation-by-attributes-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: add support of manipulation by attributes file

Add support of manipulation by attributes file.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c      |   79 ++++++++++++++++++++++++++++++++------
 fs/hfsplus/bnode.c      |    6 +-
 fs/hfsplus/brec.c       |   23 ++++++-----
 fs/hfsplus/btree.c      |    8 +++
 fs/hfsplus/catalog.c    |   36 ++++++++++-------
 fs/hfsplus/dir.c        |    6 ++
 fs/hfsplus/extents.c    |    4 -
 fs/hfsplus/hfsplus_fs.h |   41 +++++++++++++++++--
 fs/hfsplus/inode.c      |   13 ++++++
 fs/hfsplus/super.c      |   35 +++++++++++++++-
 fs/hfsplus/unicode.c    |    7 +--
 11 files changed, 208 insertions(+), 50 deletions(-)

diff -puN fs/hfsplus/bfind.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/bfind.c
@@ -38,15 +38,73 @@ void hfs_find_exit(struct hfs_find_data 
 	fd->tree = NULL;
 }
 
-/* Find the record in bnode that best matches key (not greater than...)*/
-int __hfs_brec_find(struct hfs_bnode *bnode, struct hfs_find_data *fd)
+int hfs_find_1st_rec_by_cnid(struct hfs_bnode *bnode,
+				struct hfs_find_data *fd,
+				int *begin,
+				int *end,
+				int *cur_rec)
+{
+	__be32 cur_cnid, search_cnid;
+
+	if (bnode->tree->cnid == HFSPLUS_EXT_CNID) {
+		cur_cnid = fd->key->ext.cnid;
+		search_cnid = fd->search_key->ext.cnid;
+	} else if (bnode->tree->cnid == HFSPLUS_CAT_CNID) {
+		cur_cnid = fd->key->cat.parent;
+		search_cnid = fd->search_key->cat.parent;
+	} else if (bnode->tree->cnid == HFSPLUS_ATTR_CNID) {
+		cur_cnid = fd->key->attr.cnid;
+		search_cnid = fd->search_key->attr.cnid;
+	} else
+		BUG();
+
+	if (cur_cnid == search_cnid) {
+		(*end) = (*cur_rec);
+		if ((*begin) == (*end))
+			return 1;
+	} else {
+		if (be32_to_cpu(cur_cnid) < be32_to_cpu(search_cnid))
+			(*begin) = (*cur_rec) + 1;
+		else
+			(*end) = (*cur_rec) - 1;
+	}
+
+	return 0;
+}
+
+int hfs_find_rec_by_key(struct hfs_bnode *bnode,
+				struct hfs_find_data *fd,
+				int *begin,
+				int *end,
+				int *cur_rec)
 {
 	int cmpval;
+
+	cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
+	if (!cmpval) {
+		(*end) = (*cur_rec);
+		return 1;
+	}
+	if (cmpval < 0)
+		(*begin) = (*cur_rec) + 1;
+	else
+		*(end) = (*cur_rec) - 1;
+
+	return 0;
+}
+
+/* Find the record in bnode that best matches key (not greater than...)*/
+int __hfs_brec_find(struct hfs_bnode *bnode, struct hfs_find_data *fd,
+					search_strategy_t rec_found)
+{
 	u16 off, len, keylen;
 	int rec;
 	int b, e;
 	int res;
 
+	if (!rec_found)
+		BUG();
+
 	b = 0;
 	e = bnode->num_recs - 1;
 	res = -ENOENT;
@@ -59,17 +117,12 @@ int __hfs_brec_find(struct hfs_bnode *bn
 			goto fail;
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
-		cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
-		if (!cmpval) {
-			e = rec;
+		if (rec_found(bnode, fd, &b, &e, &rec)) {
 			res = 0;
 			goto done;
 		}
-		if (cmpval < 0)
-			b = rec + 1;
-		else
-			e = rec - 1;
 	} while (b <= e);
+
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
@@ -79,19 +132,21 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 	}
+
 done:
 	fd->record = e;
 	fd->keyoffset = off;
 	fd->keylength = keylen;
 	fd->entryoffset = off + keylen;
 	fd->entrylength = len - keylen;
+
 fail:
 	return res;
 }
 
 /* Traverse a B*Tree from the root to a leaf finding best fit to key */
 /* Return allocated copy of node found, set recnum to best record */
-int hfs_brec_find(struct hfs_find_data *fd)
+int hfs_brec_find(struct hfs_find_data *fd, search_strategy_t do_key_compare)
 {
 	struct hfs_btree *tree;
 	struct hfs_bnode *bnode;
@@ -122,7 +177,7 @@ int hfs_brec_find(struct hfs_find_data *
 			goto invalid;
 		bnode->parent = parent;
 
-		res = __hfs_brec_find(bnode, fd);
+		res = __hfs_brec_find(bnode, fd, do_key_compare);
 		if (!height)
 			break;
 		if (fd->record < 0)
@@ -149,7 +204,7 @@ int hfs_brec_read(struct hfs_find_data *
 {
 	int res;
 
-	res = hfs_brec_find(fd);
+	res = hfs_brec_find(fd, hfs_find_rec_by_key);
 	if (res)
 		return res;
 	if (fd->entrylength > rec_len)
diff -puN fs/hfsplus/bnode.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/bnode.c
@@ -62,7 +62,8 @@ void hfs_bnode_read_key(struct hfs_bnode
 
 	tree = node->tree;
 	if (node->type == HFS_NODE_LEAF ||
-	    tree->attributes & HFS_TREE_VARIDXKEYS)
+	    tree->attributes & HFS_TREE_VARIDXKEYS ||
+	    node->tree->cnid == HFSPLUS_ATTR_CNID)
 		key_len = hfs_bnode_read_u16(node, off) + 2;
 	else
 		key_len = tree->max_key_len + 2;
@@ -314,7 +315,8 @@ void hfs_bnode_dump(struct hfs_bnode *no
 		if (i && node->type == HFS_NODE_INDEX) {
 			int tmp;
 
-			if (node->tree->attributes & HFS_TREE_VARIDXKEYS)
+			if (node->tree->attributes & HFS_TREE_VARIDXKEYS ||
+					node->tree->cnid == HFSPLUS_ATTR_CNID)
 				tmp = hfs_bnode_read_u16(node, key_off) + 2;
 			else
 				tmp = node->tree->max_key_len + 2;
diff -puN fs/hfsplus/brec.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/brec.c
--- a/fs/hfsplus/brec.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/brec.c
@@ -36,7 +36,8 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 		return 0;
 
 	if ((node->type == HFS_NODE_INDEX) &&
-	   !(node->tree->attributes & HFS_TREE_VARIDXKEYS)) {
+	   !(node->tree->attributes & HFS_TREE_VARIDXKEYS) &&
+	   (node->tree->cnid != HFSPLUS_ATTR_CNID)) {
 		retval = node->tree->max_key_len + 2;
 	} else {
 		recoff = hfs_bnode_read_u16(node,
@@ -151,12 +152,13 @@ skip:
 
 		/* get index key */
 		hfs_bnode_read_key(new_node, fd->search_key, 14);
-		__hfs_brec_find(fd->bnode, fd);
+		__hfs_brec_find(fd->bnode, fd, hfs_find_rec_by_key);
 
 		hfs_bnode_put(new_node);
 		new_node = NULL;
 
-		if (tree->attributes & HFS_TREE_VARIDXKEYS)
+		if ((tree->attributes & HFS_TREE_VARIDXKEYS) ||
+				(tree->cnid == HFSPLUS_ATTR_CNID))
 			key_len = be16_to_cpu(fd->search_key->key_len) + 2;
 		else {
 			fd->search_key->key_len =
@@ -201,7 +203,7 @@ again:
 		hfs_bnode_put(node);
 		node = fd->bnode = parent;
 
-		__hfs_brec_find(node, fd);
+		__hfs_brec_find(node, fd, hfs_find_rec_by_key);
 		goto again;
 	}
 	hfs_bnode_write_u16(node,
@@ -367,12 +369,13 @@ again:
 	parent = hfs_bnode_find(tree, node->parent);
 	if (IS_ERR(parent))
 		return PTR_ERR(parent);
-	__hfs_brec_find(parent, fd);
+	__hfs_brec_find(parent, fd, hfs_find_rec_by_key);
 	hfs_bnode_dump(parent);
 	rec = fd->record;
 
 	/* size difference between old and new key */
-	if (tree->attributes & HFS_TREE_VARIDXKEYS)
+	if ((tree->attributes & HFS_TREE_VARIDXKEYS) ||
+				(tree->cnid == HFSPLUS_ATTR_CNID))
 		newkeylen = hfs_bnode_read_u16(node, 14) + 2;
 	else
 		fd->keylength = newkeylen = tree->max_key_len + 2;
@@ -427,7 +430,7 @@ skip:
 		hfs_bnode_read_key(new_node, fd->search_key, 14);
 		cnid = cpu_to_be32(new_node->this);
 
-		__hfs_brec_find(fd->bnode, fd);
+		__hfs_brec_find(fd->bnode, fd, hfs_find_rec_by_key);
 		hfs_brec_insert(fd, &cnid, sizeof(cnid));
 		hfs_bnode_put(fd->bnode);
 		hfs_bnode_put(new_node);
@@ -495,13 +498,15 @@ static int hfs_btree_inc_height(struct h
 		/* insert old root idx into new root */
 		node->parent = tree->root;
 		if (node->type == HFS_NODE_LEAF ||
-		    tree->attributes & HFS_TREE_VARIDXKEYS)
+				tree->attributes & HFS_TREE_VARIDXKEYS ||
+				tree->cnid == HFSPLUS_ATTR_CNID)
 			key_size = hfs_bnode_read_u16(node, 14) + 2;
 		else
 			key_size = tree->max_key_len + 2;
 		hfs_bnode_copy(new_node, 14, node, 14, key_size);
 
-		if (!(tree->attributes & HFS_TREE_VARIDXKEYS)) {
+		if (!(tree->attributes & HFS_TREE_VARIDXKEYS) &&
+				(tree->cnid != HFSPLUS_ATTR_CNID)) {
 			key_size = tree->max_key_len + 2;
 			hfs_bnode_write_u16(new_node, 14, tree->max_key_len);
 		}
diff -puN fs/hfsplus/btree.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/btree.c
@@ -98,6 +98,14 @@ struct hfs_btree *hfs_btree_open(struct 
 			set_bit(HFSPLUS_SB_CASEFOLD, &HFSPLUS_SB(sb)->flags);
 		}
 		break;
+	case HFSPLUS_ATTR_CNID:
+		if (tree->max_key_len != HFSPLUS_ATTR_KEYLEN - sizeof(u16)) {
+			printk(KERN_ERR "hfs: invalid attributes max_key_len %d\n",
+				tree->max_key_len);
+			goto fail_page;
+		}
+		tree->keycmp = hfsplus_attr_bin_cmp_key;
+		break;
 	default:
 		printk(KERN_ERR "hfs: unknown B*Tree requested\n");
 		goto fail_page;
diff -puN fs/hfsplus/catalog.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/catalog.c
@@ -45,7 +45,8 @@ void hfsplus_cat_build_key(struct super_
 
 	key->cat.parent = cpu_to_be32(parent);
 	if (str) {
-		hfsplus_asc2uni(sb, &key->cat.name, str->name, str->len);
+		hfsplus_asc2uni(sb, &key->cat.name, HFSPLUS_MAX_STRLEN,
+					str->name, str->len);
 		len = be16_to_cpu(key->cat.name.length);
 	} else {
 		key->cat.name.length = 0;
@@ -167,7 +168,8 @@ static int hfsplus_fill_cat_thread(struc
 	entry->type = cpu_to_be16(type);
 	entry->thread.reserved = 0;
 	entry->thread.parentID = cpu_to_be32(parentid);
-	hfsplus_asc2uni(sb, &entry->thread.nodeName, str->name, str->len);
+	hfsplus_asc2uni(sb, &entry->thread.nodeName, HFSPLUS_MAX_STRLEN,
+				str->name, str->len);
 	return 10 + be16_to_cpu(entry->thread.nodeName.length) * 2;
 }
 
@@ -198,7 +200,7 @@ int hfsplus_find_cat(struct super_block 
 	hfsplus_cat_build_key_uni(fd->search_key,
 		be32_to_cpu(tmp.thread.parentID),
 		&tmp.thread.nodeName);
-	return hfs_brec_find(fd);
+	return hfs_brec_find(fd, hfs_find_rec_by_key);
 }
 
 int hfsplus_create_cat(u32 cnid, struct inode *dir,
@@ -221,7 +223,7 @@ int hfsplus_create_cat(u32 cnid, struct 
 		S_ISDIR(inode->i_mode) ?
 			HFSPLUS_FOLDER_THREAD : HFSPLUS_FILE_THREAD,
 		dir->i_ino, str);
-	err = hfs_brec_find(&fd);
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
 			err = -EEXIST;
@@ -233,7 +235,7 @@ int hfsplus_create_cat(u32 cnid, struct 
 
 	hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
 	entry_size = hfsplus_cat_build_record(&entry, cnid, inode);
-	err = hfs_brec_find(&fd);
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		/* panic? */
 		if (!err)
@@ -253,7 +255,7 @@ int hfsplus_create_cat(u32 cnid, struct 
 
 err1:
 	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
-	if (!hfs_brec_find(&fd))
+	if (!hfs_brec_find(&fd, hfs_find_rec_by_key))
 		hfs_brec_remove(&fd);
 err2:
 	hfs_find_exit(&fd);
@@ -279,7 +281,7 @@ int hfsplus_delete_cat(u32 cnid, struct 
 		int len;
 
 		hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
-		err = hfs_brec_find(&fd);
+		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 		if (err)
 			goto out;
 
@@ -296,7 +298,7 @@ int hfsplus_delete_cat(u32 cnid, struct 
 	} else
 		hfsplus_cat_build_key(sb, fd.search_key, dir->i_ino, str);
 
-	err = hfs_brec_find(&fd);
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 
@@ -326,7 +328,7 @@ int hfsplus_delete_cat(u32 cnid, struct 
 		goto out;
 
 	hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
-	err = hfs_brec_find(&fd);
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 
@@ -337,6 +339,12 @@ int hfsplus_delete_cat(u32 cnid, struct 
 	dir->i_size--;
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	hfsplus_mark_inode_dirty(dir, HFSPLUS_I_CAT_DIRTY);
+
+	if (type == HFSPLUS_FILE || type == HFSPLUS_FOLDER) {
+		if (HFSPLUS_SB(sb)->attr_tree)
+			hfsplus_delete_all_attrs(dir, cnid);
+	}
+
 out:
 	hfs_find_exit(&fd);
 
@@ -363,7 +371,7 @@ int hfsplus_rename_cat(u32 cnid,
 
 	/* find the old dir entry and read the data */
 	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
-	err = hfs_brec_find(&src_fd);
+	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
@@ -376,7 +384,7 @@ int hfsplus_rename_cat(u32 cnid,
 
 	/* create new dir entry with the data from the old entry */
 	hfsplus_cat_build_key(sb, dst_fd.search_key, dst_dir->i_ino, dst_name);
-	err = hfs_brec_find(&dst_fd);
+	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
 			err = -EEXIST;
@@ -391,7 +399,7 @@ int hfsplus_rename_cat(u32 cnid,
 
 	/* finally remove the old entry */
 	hfsplus_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
-	err = hfs_brec_find(&src_fd);
+	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 	err = hfs_brec_remove(&src_fd);
@@ -402,7 +410,7 @@ int hfsplus_rename_cat(u32 cnid,
 
 	/* remove old thread entry */
 	hfsplus_cat_build_key(sb, src_fd.search_key, cnid, NULL);
-	err = hfs_brec_find(&src_fd);
+	err = hfs_brec_find(&src_fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 	type = hfs_bnode_read_u16(src_fd.bnode, src_fd.entryoffset);
@@ -414,7 +422,7 @@ int hfsplus_rename_cat(u32 cnid,
 	hfsplus_cat_build_key(sb, dst_fd.search_key, cnid, NULL);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry, type,
 		dst_dir->i_ino, dst_name);
-	err = hfs_brec_find(&dst_fd);
+	err = hfs_brec_find(&dst_fd, hfs_find_rec_by_key);
 	if (err != -ENOENT) {
 		if (!err)
 			err = -EEXIST;
diff -puN fs/hfsplus/dir.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/dir.c
@@ -138,7 +138,7 @@ static int hfsplus_readdir(struct file *
 	if (err)
 		return err;
 	hfsplus_cat_build_key(sb, fd.search_key, inode->i_ino, NULL);
-	err = hfs_brec_find(&fd);
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
 	if (err)
 		goto out;
 
@@ -508,6 +508,10 @@ const struct inode_operations hfsplus_di
 	.symlink	= hfsplus_symlink,
 	.mknod		= hfsplus_mknod,
 	.rename		= hfsplus_rename,
+	.setxattr	= hfsplus_setxattr,
+	.getxattr	= hfsplus_getxattr,
+	.listxattr	= hfsplus_listxattr,
+	.removexattr	= hfsplus_removexattr,
 };
 
 const struct file_operations hfsplus_dir_operations = {
diff -puN fs/hfsplus/extents.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/extents.c
@@ -95,7 +95,7 @@ static void __hfsplus_ext_write_extent(s
 			      HFSPLUS_IS_RSRC(inode) ?
 				HFSPLUS_TYPE_RSRC : HFSPLUS_TYPE_DATA);
 
-	res = hfs_brec_find(fd);
+	res = hfs_brec_find(fd, hfs_find_rec_by_key);
 	if (hip->extent_state & HFSPLUS_EXT_NEW) {
 		if (res != -ENOENT)
 			return;
@@ -154,7 +154,7 @@ static inline int __hfsplus_ext_read_ext
 
 	hfsplus_ext_build_key(fd->search_key, cnid, block, type);
 	fd->key->ext.cnid = 0;
-	res = hfs_brec_find(fd);
+	res = hfs_brec_find(fd, hfs_find_rec_by_key);
 	if (res && res != -ENOENT)
 		return res;
 	if (fd->key->ext.cnid != fd->search_key->ext.cnid ||
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -23,6 +23,7 @@
 #define DBG_SUPER	0x00000010
 #define DBG_EXTENT	0x00000020
 #define DBG_BITMAP	0x00000040
+#define DBG_ATTR_MOD	0x00000080
 
 #if 0
 #define DBG_MASK	(DBG_EXTENT|DBG_INODE|DBG_BNODE_MOD)
@@ -223,6 +224,7 @@ struct hfsplus_inode_info {
 #define HFSPLUS_I_CAT_DIRTY	1	/* has changes in the catalog tree */
 #define HFSPLUS_I_EXT_DIRTY	2	/* has changes in the extent tree */
 #define HFSPLUS_I_ALLOC_DIRTY	3	/* has changes in the allocation file */
+#define HFSPLUS_I_ATTR_DIRTY	4	/* has changes in the attributes tree */
 
 #define HFSPLUS_IS_RSRC(inode) \
 	test_bit(HFSPLUS_I_RSRC, &HFSPLUS_I(inode)->flags)
@@ -302,7 +304,7 @@ static inline unsigned short hfsplus_min
 #define hfs_brec_remove hfsplus_brec_remove
 #define hfs_find_init hfsplus_find_init
 #define hfs_find_exit hfsplus_find_exit
-#define __hfs_brec_find __hplusfs_brec_find
+#define __hfs_brec_find __hfsplus_brec_find
 #define hfs_brec_find hfsplus_brec_find
 #define hfs_brec_read hfsplus_brec_read
 #define hfs_brec_goto hfsplus_brec_goto
@@ -324,10 +326,33 @@ static inline unsigned short hfsplus_min
  */
 #define HFSPLUS_IOC_BLESS _IO('h', 0x80)
 
+typedef int (*search_strategy_t)(struct hfs_bnode *,
+				struct hfs_find_data *,
+				int *, int *, int *);
+
 /*
  * Functions in any *.c used in other files
  */
 
+/* attributes.c */
+int hfsplus_create_attr_tree_cache(void);
+void hfsplus_destroy_attr_tree_cache(void);
+hfsplus_attr_entry *hfsplus_alloc_attr_entry(void);
+void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry_p);
+int hfsplus_attr_bin_cmp_key(const hfsplus_btree_key *,
+		const hfsplus_btree_key *);
+int hfsplus_attr_build_key(struct super_block *, hfsplus_btree_key *,
+			u32, const char *);
+void hfsplus_attr_build_key_uni(hfsplus_btree_key *key,
+					u32 cnid,
+					struct hfsplus_attr_unistr *name);
+int hfsplus_find_attr(struct super_block *, u32,
+			const char *, struct hfs_find_data *);
+int hfsplus_attr_exists(struct inode *inode, const char *name);
+int hfsplus_create_attr(struct inode *, const char *, const void *, size_t);
+int hfsplus_delete_attr(struct inode *, const char *);
+int hfsplus_delete_all_attrs(struct inode *dir, u32 cnid);
+
 /* bitmap.c */
 int hfsplus_block_allocate(struct super_block *, u32, u32, u32 *);
 int hfsplus_block_free(struct super_block *, u32, u32);
@@ -369,8 +394,15 @@ int hfs_brec_remove(struct hfs_find_data
 /* bfind.c */
 int hfs_find_init(struct hfs_btree *, struct hfs_find_data *);
 void hfs_find_exit(struct hfs_find_data *);
-int __hfs_brec_find(struct hfs_bnode *, struct hfs_find_data *);
-int hfs_brec_find(struct hfs_find_data *);
+int hfs_find_1st_rec_by_cnid(struct hfs_bnode *,
+				struct hfs_find_data *,
+				int *, int *, int *);
+int hfs_find_rec_by_key(struct hfs_bnode *,
+				struct hfs_find_data *,
+				int *, int *, int *);
+int __hfs_brec_find(struct hfs_bnode *, struct hfs_find_data *,
+				search_strategy_t);
+int hfs_brec_find(struct hfs_find_data *, search_strategy_t);
 int hfs_brec_read(struct hfs_find_data *, void *, int);
 int hfs_brec_goto(struct hfs_find_data *, int);
 
@@ -422,6 +454,7 @@ int hfsplus_setxattr(struct dentry *dent
 ssize_t hfsplus_getxattr(struct dentry *dentry, const char *name,
 			 void *value, size_t size);
 ssize_t hfsplus_listxattr(struct dentry *dentry, char *buffer, size_t size);
+int hfsplus_removexattr(struct dentry *dentry, const char *name);
 
 /* options.c */
 int hfsplus_parse_options(char *, struct hfsplus_sb_info *);
@@ -446,7 +479,7 @@ int hfsplus_strcmp(const struct hfsplus_
 int hfsplus_uni2asc(struct super_block *,
 		const struct hfsplus_unistr *, char *, int *);
 int hfsplus_asc2uni(struct super_block *,
-		struct hfsplus_unistr *, const char *, int);
+		struct hfsplus_unistr *, int, const char *, int);
 int hfsplus_hash_dentry(const struct dentry *dentry,
 		const struct inode *inode, struct qstr *str);
 int hfsplus_compare_dentry(const struct dentry *parent,
diff -puN fs/hfsplus/inode.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/inode.c
@@ -342,6 +342,18 @@ int hfsplus_file_fsync(struct file *file
 			error = error2;
 	}
 
+	if (test_and_clear_bit(HFSPLUS_I_ATTR_DIRTY, &hip->flags)) {
+		if (sbi->attr_tree) {
+			error2 =
+				filemap_write_and_wait(
+					    sbi->attr_tree->inode->i_mapping);
+			if (!error)
+				error = error2;
+		} else {
+			printk(KERN_ERR "hfs: sync non-existent attributes tree\n");
+		}
+	}
+
 	if (test_and_clear_bit(HFSPLUS_I_ALLOC_DIRTY, &hip->flags)) {
 		error2 = filemap_write_and_wait(sbi->alloc_file->i_mapping);
 		if (!error)
@@ -363,6 +375,7 @@ static const struct inode_operations hfs
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
 	.listxattr	= hfsplus_listxattr,
+	.removexattr	= hfsplus_removexattr,
 };
 
 static const struct file_operations hfsplus_file_operations = {
diff -puN fs/hfsplus/super.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/super.c
@@ -118,6 +118,7 @@ static int hfsplus_system_write_inode(st
 	case HFSPLUS_ATTR_CNID:
 		fork = &vhdr->attr_file;
 		tree = sbi->attr_tree;
+		break;
 	default:
 		return -EIO;
 	}
@@ -185,6 +186,12 @@ static int hfsplus_sync_fs(struct super_
 	error2 = filemap_write_and_wait(sbi->ext_tree->inode->i_mapping);
 	if (!error)
 		error = error2;
+	if (sbi->attr_tree) {
+		error2 =
+		    filemap_write_and_wait(sbi->attr_tree->inode->i_mapping);
+		if (!error)
+			error = error2;
+	}
 	error2 = filemap_write_and_wait(sbi->alloc_file->i_mapping);
 	if (!error)
 		error = error2;
@@ -272,6 +279,7 @@ static void hfsplus_put_super(struct sup
 		hfsplus_sync_fs(sb, 1);
 	}
 
+	hfs_btree_close(sbi->attr_tree);
 	hfs_btree_close(sbi->cat_tree);
 	hfs_btree_close(sbi->ext_tree);
 	iput(sbi->alloc_file);
@@ -468,12 +476,19 @@ static int hfsplus_fill_super(struct sup
 		printk(KERN_ERR "hfs: failed to load catalog file\n");
 		goto out_close_ext_tree;
 	}
+	if (vhdr->attr_file.total_blocks != 0) {
+		sbi->attr_tree = hfs_btree_open(sb, HFSPLUS_ATTR_CNID);
+		if (!sbi->attr_tree) {
+			printk(KERN_ERR "hfs: failed to load attributes file\n");
+			goto out_close_cat_tree;
+		}
+	}
 
 	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
 	if (IS_ERR(inode)) {
 		printk(KERN_ERR "hfs: failed to load allocation file\n");
 		err = PTR_ERR(inode);
-		goto out_close_cat_tree;
+		goto out_close_attr_tree;
 	}
 	sbi->alloc_file = inode;
 
@@ -553,6 +568,8 @@ out_put_root:
 	sb->s_root = NULL;
 out_put_alloc_file:
 	iput(sbi->alloc_file);
+out_close_attr_tree:
+	hfs_btree_close(sbi->attr_tree);
 out_close_cat_tree:
 	hfs_btree_close(sbi->cat_tree);
 out_close_ext_tree:
@@ -626,15 +643,27 @@ static int __init init_hfsplus_fs(void)
 		hfsplus_init_once);
 	if (!hfsplus_inode_cachep)
 		return -ENOMEM;
+	err = hfsplus_create_attr_tree_cache();
+	if (err)
+		goto destroy_inode_cache;
 	err = register_filesystem(&hfsplus_fs_type);
 	if (err)
-		kmem_cache_destroy(hfsplus_inode_cachep);
-	return err;
+		goto destroy_attr_tree_cache;
+	return 0;
+
+destroy_attr_tree_cache:
+	hfsplus_destroy_attr_tree_cache();
+
+destroy_inode_cache:
+	kmem_cache_destroy(hfsplus_inode_cachep);
+
+ 	return err;
 }
 
 static void __exit exit_hfsplus_fs(void)
 {
 	unregister_filesystem(&hfsplus_fs_type);
+	hfsplus_destroy_attr_tree_cache();
 
 	/*
 	 * Make sure all delayed rcu free inodes are flushed before we
diff -puN fs/hfsplus/unicode.c~hfsplus-add-support-of-manipulation-by-attributes-file fs/hfsplus/unicode.c
--- a/fs/hfsplus/unicode.c~hfsplus-add-support-of-manipulation-by-attributes-file
+++ a/fs/hfsplus/unicode.c
@@ -295,7 +295,8 @@ static inline u16 *decompose_unichar(wch
 	return hfsplus_decompose_table + (off / 4);
 }
 
-int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
+int hfsplus_asc2uni(struct super_block *sb,
+		    struct hfsplus_unistr *ustr, int max_unistr_len,
 		    const char *astr, int len)
 {
 	int size, dsize, decompose;
@@ -303,7 +304,7 @@ int hfsplus_asc2uni(struct super_block *
 	wchar_t c;
 
 	decompose = !test_bit(HFSPLUS_SB_NODECOMPOSE, &HFSPLUS_SB(sb)->flags);
-	while (outlen < HFSPLUS_MAX_STRLEN && len > 0) {
+	while (outlen < max_unistr_len && len > 0) {
 		size = asc2unichar(sb, astr, len, &c);
 
 		if (decompose)
@@ -311,7 +312,7 @@ int hfsplus_asc2uni(struct super_block *
 		else
 			dstr = NULL;
 		if (dstr) {
-			if (outlen + dsize > HFSPLUS_MAX_STRLEN)
+			if (outlen + dsize > max_unistr_len)
 				break;
 			do {
 				ustr->unicode[outlen++] = cpu_to_be16(*dstr++);
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

