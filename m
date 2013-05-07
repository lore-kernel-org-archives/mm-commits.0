From: akpm@linux-foundation.org
Subject: [merged] hfs-hfsplus-convert-printks-to-pr_level.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:51 -0700
Message-ID: <20130507174851.7ED355A4305@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42437 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EGRsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:52 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so85247vbe.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hch@infradead.org, htl10@users.sourceforge.net, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs/hfsplus: convert printks to pr_<level>
has been removed from the -mm tree.  Its filename was
     hfs-hfsplus-convert-printks-to-pr_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: hfs/hfsplus: convert printks to pr_<level>

Use a more current logging style.

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
hfsplus now uses "hfsplus: " for all messages.
Coalesce formats.
Prefix debugging messages too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bfind.c          |    4 +--
 fs/hfs/bnode.c          |    4 +--
 fs/hfs/brec.c           |    8 ++----
 fs/hfs/btree.c          |   29 ++++++++++++----------
 fs/hfs/catalog.c        |    4 +--
 fs/hfs/dir.c            |   12 ++++-----
 fs/hfs/hfs_fs.h         |   22 +++++++++++------
 fs/hfs/mdb.c            |   23 ++++++++----------
 fs/hfs/super.c          |   43 ++++++++++++++++------------------
 fs/hfsplus/attributes.c |   18 +++++++-------
 fs/hfsplus/bfind.c      |    2 -
 fs/hfsplus/bitmap.c     |    2 -
 fs/hfsplus/bnode.c      |    6 ++--
 fs/hfsplus/brec.c       |    4 +--
 fs/hfsplus/btree.c      |   25 +++++++++----------
 fs/hfsplus/catalog.c    |    4 +--
 fs/hfsplus/dir.c        |   14 +++++------
 fs/hfsplus/extents.c    |    6 ++--
 fs/hfsplus/hfsplus_fs.h |   22 +++++++++++------
 fs/hfsplus/inode.c      |    4 +--
 fs/hfsplus/options.c    |   22 ++++++++---------
 fs/hfsplus/super.c      |   48 ++++++++++++++------------------------
 fs/hfsplus/wrapper.c    |    8 ++----
 fs/hfsplus/xattr.c      |   41 +++++++++++++++-----------------
 24 files changed, 185 insertions(+), 190 deletions(-)

diff -puN fs/hfs/bfind.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/bfind.c
--- a/fs/hfs/bfind.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/bfind.c
@@ -137,8 +137,8 @@ int hfs_brec_find(struct hfs_find_data *
 	return res;
 
 invalid:
-	printk(KERN_ERR "hfs: inconsistency in B*Tree (%d,%d,%d,%u,%u)\n",
-		height, bnode->height, bnode->type, nidx, parent);
+	pr_err("inconsistency in B*Tree (%d,%d,%d,%u,%u)\n",
+	       height, bnode->height, bnode->type, nidx, parent);
 	res = -EIO;
 release:
 	hfs_bnode_put(bnode);
diff -puN fs/hfs/bnode.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/bnode.c
--- a/fs/hfs/bnode.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/bnode.c
@@ -221,7 +221,7 @@ struct hfs_bnode *hfs_bnode_findhash(str
 	struct hfs_bnode *node;
 
 	if (cnid >= tree->node_count) {
-		printk(KERN_ERR "hfs: request for non-existent node %d in B*Tree\n", cnid);
+		pr_err("request for non-existent node %d in B*Tree\n", cnid);
 		return NULL;
 	}
 
@@ -244,7 +244,7 @@ static struct hfs_bnode *__hfs_bnode_cre
 	loff_t off;
 
 	if (cnid >= tree->node_count) {
-		printk(KERN_ERR "hfs: request for non-existent node %d in B*Tree\n", cnid);
+		pr_err("request for non-existent node %d in B*Tree\n", cnid);
 		return NULL;
 	}
 
diff -puN fs/hfs/brec.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/brec.c
--- a/fs/hfs/brec.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/brec.c
@@ -47,15 +47,13 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 		if (node->tree->attributes & HFS_TREE_BIGKEYS) {
 			retval = hfs_bnode_read_u16(node, recoff) + 2;
 			if (retval > node->tree->max_key_len + 2) {
-				printk(KERN_ERR "hfs: keylen %d too large\n",
-					retval);
+				pr_err("keylen %d too large\n", retval);
 				retval = 0;
 			}
 		} else {
 			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
 			if (retval > node->tree->max_key_len + 1) {
-				printk(KERN_ERR "hfs: keylen %d too large\n",
-					retval);
+				pr_err("keylen %d too large\n", retval);
 				retval = 0;
 			}
 		}
@@ -388,7 +386,7 @@ again:
 		end_off = hfs_bnode_read_u16(parent, end_rec_off);
 		if (end_rec_off - end_off < diff) {
 
-			printk(KERN_DEBUG "hfs: splitting index node...\n");
+			printk(KERN_DEBUG "splitting index node...\n");
 			fd->bnode = parent;
 			new_node = hfs_bnode_split(fd);
 			if (IS_ERR(new_node))
diff -puN fs/hfs/btree.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/btree.c
@@ -48,7 +48,7 @@ struct hfs_btree *hfs_btree_open(struct
 				    mdb->drXTFlSize, be32_to_cpu(mdb->drXTClpSiz));
 		if (HFS_I(tree->inode)->alloc_blocks >
 					HFS_I(tree->inode)->first_blocks) {
-			printk(KERN_ERR "hfs: invalid btree extent records\n");
+			pr_err("invalid btree extent records\n");
 			unlock_new_inode(tree->inode);
 			goto free_inode;
 		}
@@ -60,8 +60,7 @@ struct hfs_btree *hfs_btree_open(struct
 				    mdb->drCTFlSize, be32_to_cpu(mdb->drCTClpSiz));
 
 		if (!HFS_I(tree->inode)->first_blocks) {
-			printk(KERN_ERR "hfs: invalid btree extent records "
-								"(0 size).\n");
+			pr_err("invalid btree extent records (0 size)\n");
 			unlock_new_inode(tree->inode);
 			goto free_inode;
 		}
@@ -100,15 +99,15 @@ struct hfs_btree *hfs_btree_open(struct
 	switch (id) {
 	case HFS_EXT_CNID:
 		if (tree->max_key_len != HFS_MAX_EXT_KEYLEN) {
-			printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
-				tree->max_key_len);
+			pr_err("invalid extent max_key_len %d\n",
+			       tree->max_key_len);
 			goto fail_page;
 		}
 		break;
 	case HFS_CAT_CNID:
 		if (tree->max_key_len != HFS_MAX_CAT_KEYLEN) {
-			printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
-				tree->max_key_len);
+			pr_err("invalid catalog max_key_len %d\n",
+			       tree->max_key_len);
 			goto fail_page;
 		}
 		break;
@@ -146,8 +145,9 @@ void hfs_btree_close(struct hfs_btree *t
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
 			if (atomic_read(&node->refcnt))
-				printk(KERN_ERR "hfs: node %d:%d still has %d user(s)!\n",
-					node->tree->cnid, node->this, atomic_read(&node->refcnt));
+				pr_err("node %d:%d still has %d user(s)!\n",
+				       node->tree->cnid, node->this,
+				       atomic_read(&node->refcnt));
 			hfs_bnode_free(node);
 			tree->node_hash_cnt--;
 		}
@@ -290,7 +290,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct
 		kunmap(*pagep);
 		nidx = node->next;
 		if (!nidx) {
-			printk(KERN_DEBUG "hfs: create new bmap node...\n");
+			printk(KERN_DEBUG "create new bmap node...\n");
 			next_node = hfs_bmap_new_bmap(node, idx);
 		} else
 			next_node = hfs_bnode_find(tree, nidx);
@@ -331,7 +331,8 @@ void hfs_bmap_free(struct hfs_bnode *nod
 		hfs_bnode_put(node);
 		if (!i) {
 			/* panic */;
-			printk(KERN_CRIT "hfs: unable to free bnode %u. bmap not found!\n", node->this);
+			pr_crit("unable to free bnode %u. bmap not found!\n",
+				node->this);
 			return;
 		}
 		node = hfs_bnode_find(tree, i);
@@ -339,7 +340,8 @@ void hfs_bmap_free(struct hfs_bnode *nod
 			return;
 		if (node->type != HFS_NODE_MAP) {
 			/* panic */;
-			printk(KERN_CRIT "hfs: invalid bmap found! (%u,%d)\n", node->this, node->type);
+			pr_crit("invalid bmap found! (%u,%d)\n",
+				node->this, node->type);
 			hfs_bnode_put(node);
 			return;
 		}
@@ -352,7 +354,8 @@ void hfs_bmap_free(struct hfs_bnode *nod
 	m = 1 << (~nidx & 7);
 	byte = data[off];
 	if (!(byte & m)) {
-		printk(KERN_CRIT "hfs: trying to free free bnode %u(%d)\n", node->this, node->type);
+		pr_crit("trying to free free bnode %u(%d)\n",
+			node->this, node->type);
 		kunmap(page);
 		hfs_bnode_put(node);
 		return;
diff -puN fs/hfs/catalog.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/catalog.c
--- a/fs/hfs/catalog.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/catalog.c
@@ -187,14 +187,14 @@ int hfs_cat_find_brec(struct super_block
 
 	type = rec.type;
 	if (type != HFS_CDR_THD && type != HFS_CDR_FTH) {
-		printk(KERN_ERR "hfs: found bad thread record in catalog\n");
+		pr_err("found bad thread record in catalog\n");
 		return -EIO;
 	}
 
 	fd->search_key->cat.ParID = rec.thread.ParID;
 	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
 	if (len > HFS_NAMELEN) {
-		printk(KERN_ERR "hfs: bad catalog namelength\n");
+		pr_err("bad catalog namelength\n");
 		return -EIO;
 	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
diff -puN fs/hfs/dir.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/dir.c
--- a/fs/hfs/dir.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/dir.c
@@ -88,12 +88,12 @@ static int hfs_readdir(struct file *filp
 
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		if (entry.type != HFS_CDR_THD) {
-			printk(KERN_ERR "hfs: bad catalog folder thread\n");
+			pr_err("bad catalog folder thread\n");
 			err = -EIO;
 			goto out;
 		}
 		//if (fd.entrylength < HFS_MIN_THREAD_SZ) {
-		//	printk(KERN_ERR "hfs: truncated catalog thread\n");
+		//	pr_err("truncated catalog thread\n");
 		//	err = -EIO;
 		//	goto out;
 		//}
@@ -112,7 +112,7 @@ static int hfs_readdir(struct file *filp
 
 	for (;;) {
 		if (be32_to_cpu(fd.key->cat.ParID) != inode->i_ino) {
-			printk(KERN_ERR "hfs: walked past end of dir\n");
+			pr_err("walked past end of dir\n");
 			err = -EIO;
 			goto out;
 		}
@@ -127,7 +127,7 @@ static int hfs_readdir(struct file *filp
 		len = hfs_mac2asc(sb, strbuf, &fd.key->cat.CName);
 		if (type == HFS_CDR_DIR) {
 			if (fd.entrylength < sizeof(struct hfs_cat_dir)) {
-				printk(KERN_ERR "hfs: small dir entry\n");
+				pr_err("small dir entry\n");
 				err = -EIO;
 				goto out;
 			}
@@ -136,7 +136,7 @@ static int hfs_readdir(struct file *filp
 				break;
 		} else if (type == HFS_CDR_FIL) {
 			if (fd.entrylength < sizeof(struct hfs_cat_file)) {
-				printk(KERN_ERR "hfs: small file entry\n");
+				pr_err("small file entry\n");
 				err = -EIO;
 				goto out;
 			}
@@ -144,7 +144,7 @@ static int hfs_readdir(struct file *filp
 				    be32_to_cpu(entry.file.FlNum), DT_REG))
 				break;
 		} else {
-			printk(KERN_ERR "hfs: bad catalog entry type %d\n", type);
+			pr_err("bad catalog entry type %d\n", type);
 			err = -EIO;
 			goto out;
 		}
diff -puN fs/hfs/hfs_fs.h~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/hfs_fs.h
@@ -9,6 +9,12 @@
 #ifndef _LINUX_HFS_FS_H
 #define _LINUX_HFS_FS_H
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
@@ -34,16 +40,16 @@
 //#define DBG_MASK	(DBG_CAT_MOD|DBG_BNODE_REFS|DBG_INODE|DBG_EXTENT)
 #define DBG_MASK	(0)
 
-#define hfs_dbg(flg, fmt, ...)				\
-do {							\
-	if (DBG_##flg & DBG_MASK)			\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
+#define hfs_dbg(flg, fmt, ...)					\
+do {								\
+	if (DBG_##flg & DBG_MASK)				\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
 } while (0)
 
-#define hfs_dbg_cont(flg, fmt, ...)			\
-do {							\
-	if (DBG_##flg & DBG_MASK)			\
-		printk(KERN_CONT fmt, ##__VA_ARGS__);	\
+#define hfs_dbg_cont(flg, fmt, ...)				\
+do {								\
+	if (DBG_##flg & DBG_MASK)				\
+		pr_cont(fmt, ##__VA_ARGS__);			\
 } while (0)
 
 
diff -puN fs/hfs/mdb.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/mdb.c
@@ -48,7 +48,7 @@ static int hfs_get_last_session(struct s
 			*start = (sector_t)te.cdte_addr.lba << 2;
 			return 0;
 		}
-		printk(KERN_ERR "hfs: invalid session number or type of track\n");
+		pr_err("invalid session number or type of track\n");
 		return -EINVAL;
 	}
 	ms_info.addr_format = CDROM_LBA;
@@ -101,7 +101,7 @@ int hfs_mdb_get(struct super_block *sb)
 
 	HFS_SB(sb)->alloc_blksz = size = be32_to_cpu(mdb->drAlBlkSiz);
 	if (!size || (size & (HFS_SECTOR_SIZE - 1))) {
-		printk(KERN_ERR "hfs: bad allocation block size %d\n", size);
+		pr_err("bad allocation block size %d\n", size);
 		goto out_bh;
 	}
 
@@ -118,7 +118,7 @@ int hfs_mdb_get(struct super_block *sb)
 		size >>= 1;
 	brelse(bh);
 	if (!sb_set_blocksize(sb, size)) {
-		printk(KERN_ERR "hfs: unable to set blocksize to %u\n", size);
+		pr_err("unable to set blocksize to %u\n", size);
 		goto out;
 	}
 
@@ -162,8 +162,8 @@ int hfs_mdb_get(struct super_block *sb)
 	}
 
 	if (!HFS_SB(sb)->alt_mdb) {
-		printk(KERN_WARNING "hfs: unable to locate alternate MDB\n");
-		printk(KERN_WARNING "hfs: continuing without an alternate MDB\n");
+		pr_warn("unable to locate alternate MDB\n");
+		pr_warn("continuing without an alternate MDB\n");
 	}
 
 	HFS_SB(sb)->bitmap = (__be32 *)__get_free_pages(GFP_KERNEL, PAGE_SIZE < 8192 ? 1 : 0);
@@ -178,7 +178,7 @@ int hfs_mdb_get(struct super_block *sb)
 	while (size) {
 		bh = sb_bread(sb, off >> sb->s_blocksize_bits);
 		if (!bh) {
-			printk(KERN_ERR "hfs: unable to read volume bitmap\n");
+			pr_err("unable to read volume bitmap\n");
 			goto out;
 		}
 		off2 = off & (sb->s_blocksize - 1);
@@ -192,23 +192,22 @@ int hfs_mdb_get(struct super_block *sb)
 
 	HFS_SB(sb)->ext_tree = hfs_btree_open(sb, HFS_EXT_CNID, hfs_ext_keycmp);
 	if (!HFS_SB(sb)->ext_tree) {
-		printk(KERN_ERR "hfs: unable to open extent tree\n");
+		pr_err("unable to open extent tree\n");
 		goto out;
 	}
 	HFS_SB(sb)->cat_tree = hfs_btree_open(sb, HFS_CAT_CNID, hfs_cat_keycmp);
 	if (!HFS_SB(sb)->cat_tree) {
-		printk(KERN_ERR "hfs: unable to open catalog tree\n");
+		pr_err("unable to open catalog tree\n");
 		goto out;
 	}
 
 	attrib = mdb->drAtrb;
 	if (!(attrib & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
-		printk(KERN_WARNING "hfs: filesystem was not cleanly unmounted, "
-			 "running fsck.hfs is recommended.  mounting read-only.\n");
+		pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 	if ((attrib & cpu_to_be16(HFS_SB_ATTRIB_SLOCK))) {
-		printk(KERN_WARNING "hfs: filesystem is marked locked, mounting read-only.\n");
+		pr_warn("filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -312,7 +311,7 @@ void hfs_mdb_commit(struct super_block *
 		while (size) {
 			bh = sb_bread(sb, block);
 			if (!bh) {
-				printk(KERN_ERR "hfs: unable to read volume bitmap\n");
+				pr_err("unable to read volume bitmap\n");
 				break;
 			}
 			len = min((int)sb->s_blocksize - off, size);
diff -puN fs/hfs/super.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfs/super.c
@@ -117,12 +117,11 @@ static int hfs_remount(struct super_bloc
 		return 0;
 	if (!(*flags & MS_RDONLY)) {
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
-			printk(KERN_WARNING "hfs: filesystem was not cleanly unmounted, "
-			       "running fsck.hfs is recommended.  leaving read-only.\n");
+			pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		} else if (HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_SLOCK)) {
-			printk(KERN_WARNING "hfs: filesystem is marked locked, leaving read-only.\n");
+			pr_warn("filesystem is marked locked, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		}
@@ -253,29 +252,29 @@ static int parse_options(char *options,
 		switch (token) {
 		case opt_uid:
 			if (match_int(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: uid requires an argument\n");
+				pr_err("uid requires an argument\n");
 				return 0;
 			}
 			hsb->s_uid = make_kuid(current_user_ns(), (uid_t)tmp);
 			if (!uid_valid(hsb->s_uid)) {
-				printk(KERN_ERR "hfs: invalid uid %d\n", tmp);
+				pr_err("invalid uid %d\n", tmp);
 				return 0;
 			}
 			break;
 		case opt_gid:
 			if (match_int(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: gid requires an argument\n");
+				pr_err("gid requires an argument\n");
 				return 0;
 			}
 			hsb->s_gid = make_kgid(current_user_ns(), (gid_t)tmp);
 			if (!gid_valid(hsb->s_gid)) {
-				printk(KERN_ERR "hfs: invalid gid %d\n", tmp);
+				pr_err("invalid gid %d\n", tmp);
 				return 0;
 			}
 			break;
 		case opt_umask:
 			if (match_octal(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: umask requires a value\n");
+				pr_err("umask requires a value\n");
 				return 0;
 			}
 			hsb->s_file_umask = (umode_t)tmp;
@@ -283,39 +282,39 @@ static int parse_options(char *options,
 			break;
 		case opt_file_umask:
 			if (match_octal(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: file_umask requires a value\n");
+				pr_err("file_umask requires a value\n");
 				return 0;
 			}
 			hsb->s_file_umask = (umode_t)tmp;
 			break;
 		case opt_dir_umask:
 			if (match_octal(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: dir_umask requires a value\n");
+				pr_err("dir_umask requires a value\n");
 				return 0;
 			}
 			hsb->s_dir_umask = (umode_t)tmp;
 			break;
 		case opt_part:
 			if (match_int(&args[0], &hsb->part)) {
-				printk(KERN_ERR "hfs: part requires an argument\n");
+				pr_err("part requires an argument\n");
 				return 0;
 			}
 			break;
 		case opt_session:
 			if (match_int(&args[0], &hsb->session)) {
-				printk(KERN_ERR "hfs: session requires an argument\n");
+				pr_err("session requires an argument\n");
 				return 0;
 			}
 			break;
 		case opt_type:
 			if (match_fourchar(&args[0], &hsb->s_type)) {
-				printk(KERN_ERR "hfs: type requires a 4 character value\n");
+				pr_err("type requires a 4 character value\n");
 				return 0;
 			}
 			break;
 		case opt_creator:
 			if (match_fourchar(&args[0], &hsb->s_creator)) {
-				printk(KERN_ERR "hfs: creator requires a 4 character value\n");
+				pr_err("creator requires a 4 character value\n");
 				return 0;
 			}
 			break;
@@ -324,14 +323,14 @@ static int parse_options(char *options,
 			break;
 		case opt_codepage:
 			if (hsb->nls_disk) {
-				printk(KERN_ERR "hfs: unable to change codepage\n");
+				pr_err("unable to change codepage\n");
 				return 0;
 			}
 			p = match_strdup(&args[0]);
 			if (p)
 				hsb->nls_disk = load_nls(p);
 			if (!hsb->nls_disk) {
-				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
+				pr_err("unable to load codepage \"%s\"\n", p);
 				kfree(p);
 				return 0;
 			}
@@ -339,14 +338,14 @@ static int parse_options(char *options,
 			break;
 		case opt_iocharset:
 			if (hsb->nls_io) {
-				printk(KERN_ERR "hfs: unable to change iocharset\n");
+				pr_err("unable to change iocharset\n");
 				return 0;
 			}
 			p = match_strdup(&args[0]);
 			if (p)
 				hsb->nls_io = load_nls(p);
 			if (!hsb->nls_io) {
-				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
+				pr_err("unable to load iocharset \"%s\"\n", p);
 				kfree(p);
 				return 0;
 			}
@@ -360,7 +359,7 @@ static int parse_options(char *options,
 	if (hsb->nls_disk && !hsb->nls_io) {
 		hsb->nls_io = load_nls_default();
 		if (!hsb->nls_io) {
-			printk(KERN_ERR "hfs: unable to load default iocharset\n");
+			pr_err("unable to load default iocharset\n");
 			return 0;
 		}
 	}
@@ -400,7 +399,7 @@ static int hfs_fill_super(struct super_b
 
 	res = -EINVAL;
 	if (!parse_options((char *)data, sbi)) {
-		printk(KERN_ERR "hfs: unable to parse mount options.\n");
+		pr_err("unable to parse mount options\n");
 		goto bail;
 	}
 
@@ -411,7 +410,7 @@ static int hfs_fill_super(struct super_b
 	res = hfs_mdb_get(sb);
 	if (res) {
 		if (!silent)
-			printk(KERN_WARNING "hfs: can't find a HFS filesystem on dev %s.\n",
+			pr_warn("can't find a HFS filesystem on dev %s\n",
 				hfs_mdb_name(sb));
 		res = -EINVAL;
 		goto bail;
@@ -449,7 +448,7 @@ static int hfs_fill_super(struct super_b
 	return 0;
 
 bail_no_root:
-	printk(KERN_ERR "hfs: get root inode failed.\n");
+	pr_err("get root inode failed\n");
 bail:
 	hfs_mdb_put(sb);
 	return res;
diff -puN fs/hfsplus/attributes.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/attributes.c
--- a/fs/hfsplus/attributes.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/attributes.c
@@ -56,7 +56,7 @@ int hfsplus_attr_build_key(struct super_
 	if (name) {
 		len = strlen(name);
 		if (len > HFSPLUS_ATTR_MAX_STRLEN) {
-			printk(KERN_ERR "hfs: invalid xattr name's length\n");
+			pr_err("invalid xattr name's length\n");
 			return -EINVAL;
 		}
 		hfsplus_asc2uni(sb,
@@ -169,7 +169,7 @@ int hfsplus_find_attr(struct super_block
 	hfs_dbg(ATTR_MOD, "find_attr: %s,%d\n", name ? name : NULL, cnid);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
-		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		pr_err("attributes file doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -232,7 +232,7 @@ int hfsplus_create_attr(struct inode *in
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
-		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		pr_err("attributes file doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -307,10 +307,10 @@ static int __hfsplus_delete_attr(struct
 		break;
 	case HFSPLUS_ATTR_FORK_DATA:
 	case HFSPLUS_ATTR_EXTENTS:
-		printk(KERN_ERR "hfs: only inline data xattr are supported\n");
+		pr_err("only inline data xattr are supported\n");
 		return -EOPNOTSUPP;
 	default:
-		printk(KERN_ERR "hfs: invalid extended attribute record\n");
+		pr_err("invalid extended attribute record\n");
 		return -ENOENT;
 	}
 
@@ -332,7 +332,7 @@ int hfsplus_delete_attr(struct inode *in
 		name ? name : NULL, inode->i_ino);
 
 	if (!HFSPLUS_SB(sb)->attr_tree) {
-		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		pr_err("attributes file doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -346,7 +346,7 @@ int hfsplus_delete_attr(struct inode *in
 		if (err)
 			goto out;
 	} else {
-		printk(KERN_ERR "hfs: invalid extended attribute name\n");
+		pr_err("invalid extended attribute name\n");
 		err = -EINVAL;
 		goto out;
 	}
@@ -372,7 +372,7 @@ int hfsplus_delete_all_attrs(struct inod
 	hfs_dbg(ATTR_MOD, "delete_all_attrs: %d\n", cnid);
 
 	if (!HFSPLUS_SB(dir->i_sb)->attr_tree) {
-		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		pr_err("attributes file doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -384,7 +384,7 @@ int hfsplus_delete_all_attrs(struct inod
 		err = hfsplus_find_attr(dir->i_sb, cnid, NULL, &fd);
 		if (err) {
 			if (err != -ENOENT)
-				printk(KERN_ERR "hfs: xattr search failed.\n");
+				pr_err("xattr search failed\n");
 			goto end_delete_all;
 		}
 
diff -puN fs/hfsplus/bfind.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/bfind.c
@@ -208,7 +208,7 @@ int hfs_brec_find(struct hfs_find_data *
 	return res;
 
 invalid:
-	printk(KERN_ERR "hfs: inconsistency in B*Tree (%d,%d,%d,%u,%u)\n",
+	pr_err("inconsistency in B*Tree (%d,%d,%d,%u,%u)\n",
 		height, bnode->height, bnode->type, nidx, parent);
 	res = -EIO;
 release:
diff -puN fs/hfsplus/bitmap.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/bitmap.c
@@ -238,7 +238,7 @@ out:
 	return 0;
 
 kaboom:
-	printk(KERN_CRIT "hfsplus: unable to mark blocks free: error %ld\n",
+	pr_crit("hfsplus: unable to mark blocks free: error %ld\n",
 			PTR_ERR(page));
 	mutex_unlock(&sbi->alloc_mutex);
 
diff -puN fs/hfsplus/bnode.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/bnode.c
--- a/fs/hfsplus/bnode.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/bnode.c
@@ -386,7 +386,7 @@ struct hfs_bnode *hfs_bnode_findhash(str
 	struct hfs_bnode *node;
 
 	if (cnid >= tree->node_count) {
-		printk(KERN_ERR "hfs: request for non-existent node "
+		pr_err("request for non-existent node "
 				"%d in B*Tree\n",
 			cnid);
 		return NULL;
@@ -409,7 +409,7 @@ static struct hfs_bnode *__hfs_bnode_cre
 	loff_t off;
 
 	if (cnid >= tree->node_count) {
-		printk(KERN_ERR "hfs: request for non-existent node "
+		pr_err("request for non-existent node "
 				"%d in B*Tree\n",
 			cnid);
 		return NULL;
@@ -588,7 +588,7 @@ struct hfs_bnode *hfs_bnode_create(struc
 	node = hfs_bnode_findhash(tree, num);
 	spin_unlock(&tree->hash_lock);
 	if (node) {
-		printk(KERN_CRIT "new node %u already hashed?\n", num);
+		pr_crit("new node %u already hashed?\n", num);
 		WARN_ON(1);
 		return node;
 	}
diff -puN fs/hfsplus/brec.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/brec.c
--- a/fs/hfsplus/brec.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/brec.c
@@ -45,13 +45,13 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 		if (!recoff)
 			return 0;
 		if (recoff > node->tree->node_size - 2) {
-			printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
+			pr_err("recoff %d too large\n", recoff);
 			return 0;
 		}
 
 		retval = hfs_bnode_read_u16(node, recoff) + 2;
 		if (retval > node->tree->max_key_len + 2) {
-			printk(KERN_ERR "hfs: keylen %d too large\n",
+			pr_err("keylen %d too large\n",
 				retval);
 			retval = 0;
 		}
diff -puN fs/hfsplus/btree.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/btree.c
@@ -40,8 +40,7 @@ struct hfs_btree *hfs_btree_open(struct
 	tree->inode = inode;
 
 	if (!HFSPLUS_I(tree->inode)->first_blocks) {
-		printk(KERN_ERR
-		       "hfs: invalid btree extent records (0 size).\n");
+		pr_err("invalid btree extent records (0 size)\n");
 		goto free_inode;
 	}
 
@@ -68,12 +67,12 @@ struct hfs_btree *hfs_btree_open(struct
 	switch (id) {
 	case HFSPLUS_EXT_CNID:
 		if (tree->max_key_len != HFSPLUS_EXT_KEYLEN - sizeof(u16)) {
-			printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
+			pr_err("invalid extent max_key_len %d\n",
 				tree->max_key_len);
 			goto fail_page;
 		}
 		if (tree->attributes & HFS_TREE_VARIDXKEYS) {
-			printk(KERN_ERR "hfs: invalid extent btree flag\n");
+			pr_err("invalid extent btree flag\n");
 			goto fail_page;
 		}
 
@@ -81,12 +80,12 @@ struct hfs_btree *hfs_btree_open(struct
 		break;
 	case HFSPLUS_CAT_CNID:
 		if (tree->max_key_len != HFSPLUS_CAT_KEYLEN - sizeof(u16)) {
-			printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
+			pr_err("invalid catalog max_key_len %d\n",
 				tree->max_key_len);
 			goto fail_page;
 		}
 		if (!(tree->attributes & HFS_TREE_VARIDXKEYS)) {
-			printk(KERN_ERR "hfs: invalid catalog btree flag\n");
+			pr_err("invalid catalog btree flag\n");
 			goto fail_page;
 		}
 
@@ -100,19 +99,19 @@ struct hfs_btree *hfs_btree_open(struct
 		break;
 	case HFSPLUS_ATTR_CNID:
 		if (tree->max_key_len != HFSPLUS_ATTR_KEYLEN - sizeof(u16)) {
-			printk(KERN_ERR "hfs: invalid attributes max_key_len %d\n",
+			pr_err("invalid attributes max_key_len %d\n",
 				tree->max_key_len);
 			goto fail_page;
 		}
 		tree->keycmp = hfsplus_attr_bin_cmp_key;
 		break;
 	default:
-		printk(KERN_ERR "hfs: unknown B*Tree requested\n");
+		pr_err("unknown B*Tree requested\n");
 		goto fail_page;
 	}
 
 	if (!(tree->attributes & HFS_TREE_BIGKEYS)) {
-		printk(KERN_ERR "hfs: invalid btree flag\n");
+		pr_err("invalid btree flag\n");
 		goto fail_page;
 	}
 
@@ -155,7 +154,7 @@ void hfs_btree_close(struct hfs_btree *t
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
 			if (atomic_read(&node->refcnt))
-				printk(KERN_CRIT "hfs: node %d:%d "
+				pr_crit("node %d:%d "
 						"still has %d user(s)!\n",
 					node->tree->cnid, node->this,
 					atomic_read(&node->refcnt));
@@ -345,7 +344,7 @@ void hfs_bmap_free(struct hfs_bnode *nod
 		hfs_bnode_put(node);
 		if (!i) {
 			/* panic */;
-			printk(KERN_CRIT "hfs: unable to free bnode %u. "
+			pr_crit("unable to free bnode %u. "
 					"bmap not found!\n",
 				node->this);
 			return;
@@ -355,7 +354,7 @@ void hfs_bmap_free(struct hfs_bnode *nod
 			return;
 		if (node->type != HFS_NODE_MAP) {
 			/* panic */;
-			printk(KERN_CRIT "hfs: invalid bmap found! "
+			pr_crit("invalid bmap found! "
 					"(%u,%d)\n",
 				node->this, node->type);
 			hfs_bnode_put(node);
@@ -370,7 +369,7 @@ void hfs_bmap_free(struct hfs_bnode *nod
 	m = 1 << (~nidx & 7);
 	byte = data[off];
 	if (!(byte & m)) {
-		printk(KERN_CRIT "hfs: trying to free free bnode "
+		pr_crit("trying to free free bnode "
 				"%u(%d)\n",
 			node->this, node->type);
 		kunmap(page);
diff -puN fs/hfsplus/catalog.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/catalog.c
--- a/fs/hfsplus/catalog.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/catalog.c
@@ -188,12 +188,12 @@ int hfsplus_find_cat(struct super_block
 
 	type = be16_to_cpu(tmp.type);
 	if (type != HFSPLUS_FOLDER_THREAD && type != HFSPLUS_FILE_THREAD) {
-		printk(KERN_ERR "hfs: found bad thread record in catalog\n");
+		pr_err("found bad thread record in catalog\n");
 		return -EIO;
 	}
 
 	if (be16_to_cpu(tmp.thread.nodeName.length) > 255) {
-		printk(KERN_ERR "hfs: catalog name length corrupted\n");
+		pr_err("catalog name length corrupted\n");
 		return -EIO;
 	}
 
diff -puN fs/hfsplus/dir.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/dir.c
@@ -103,7 +103,7 @@ again:
 		} else if (!dentry->d_fsdata)
 			dentry->d_fsdata = (void *)(unsigned long)cnid;
 	} else {
-		printk(KERN_ERR "hfs: invalid catalog entry type in lookup\n");
+		pr_err("invalid catalog entry type in lookup\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -159,12 +159,12 @@ static int hfsplus_readdir(struct file *
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		if (be16_to_cpu(entry.type) != HFSPLUS_FOLDER_THREAD) {
-			printk(KERN_ERR "hfs: bad catalog folder thread\n");
+			pr_err("bad catalog folder thread\n");
 			err = -EIO;
 			goto out;
 		}
 		if (fd.entrylength < HFSPLUS_MIN_THREAD_SZ) {
-			printk(KERN_ERR "hfs: truncated catalog thread\n");
+			pr_err("truncated catalog thread\n");
 			err = -EIO;
 			goto out;
 		}
@@ -183,7 +183,7 @@ static int hfsplus_readdir(struct file *
 
 	for (;;) {
 		if (be32_to_cpu(fd.key->cat.parent) != inode->i_ino) {
-			printk(KERN_ERR "hfs: walked past end of dir\n");
+			pr_err("walked past end of dir\n");
 			err = -EIO;
 			goto out;
 		}
@@ -203,7 +203,7 @@ static int hfsplus_readdir(struct file *
 		if (type == HFSPLUS_FOLDER) {
 			if (fd.entrylength <
 					sizeof(struct hfsplus_cat_folder)) {
-				printk(KERN_ERR "hfs: small dir entry\n");
+				pr_err("small dir entry\n");
 				err = -EIO;
 				goto out;
 			}
@@ -216,7 +216,7 @@ static int hfsplus_readdir(struct file *
 				break;
 		} else if (type == HFSPLUS_FILE) {
 			if (fd.entrylength < sizeof(struct hfsplus_cat_file)) {
-				printk(KERN_ERR "hfs: small file entry\n");
+				pr_err("small file entry\n");
 				err = -EIO;
 				goto out;
 			}
@@ -224,7 +224,7 @@ static int hfsplus_readdir(struct file *
 				    be32_to_cpu(entry.file.id), DT_REG))
 				break;
 		} else {
-			printk(KERN_ERR "hfs: bad catalog entry type\n");
+			pr_err("bad catalog entry type\n");
 			err = -EIO;
 			goto out;
 		}
diff -puN fs/hfsplus/extents.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/extents.c
@@ -349,7 +349,7 @@ found:
 		if (count <= block_nr) {
 			err = hfsplus_block_free(sb, start, count);
 			if (err) {
-				printk(KERN_ERR "hfs: can't free extent\n");
+				pr_err("can't free extent\n");
 				hfs_dbg(EXTENT, " start: %u count: %u\n",
 					start, count);
 			}
@@ -360,7 +360,7 @@ found:
 			count -= block_nr;
 			err = hfsplus_block_free(sb, start + count, block_nr);
 			if (err) {
-				printk(KERN_ERR "hfs: can't free extent\n");
+				pr_err("can't free extent\n");
 				hfs_dbg(EXTENT, " start: %u count: %u\n",
 					start, count);
 			}
@@ -433,7 +433,7 @@ int hfsplus_file_extend(struct inode *in
 	if (sbi->alloc_file->i_size * 8 <
 	    sbi->total_blocks - sbi->free_blocks + 8) {
 		/* extend alloc file */
-		printk(KERN_ERR "hfs: extend alloc file! "
+		pr_err("extend alloc file! "
 				"(%llu,%u,%u)\n",
 			sbi->alloc_file->i_size * 8,
 			sbi->total_blocks, sbi->free_blocks);
diff -puN fs/hfsplus/hfsplus_fs.h~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -10,6 +10,12 @@
 #ifndef _LINUX_HFSPLUS_FS_H
 #define _LINUX_HFSPLUS_FS_H
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
@@ -32,16 +38,16 @@
 #endif
 #define DBG_MASK	(0)
 
-#define hfs_dbg(flg, fmt, ...)				\
-do {							\
-	if (DBG_##flg & DBG_MASK)			\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
+#define hfs_dbg(flg, fmt, ...)					\
+do {								\
+	if (DBG_##flg & DBG_MASK)				\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
 } while (0)
 
-#define hfs_dbg_cont(flg, fmt, ...)			\
-do {							\
-	if (DBG_##flg & DBG_MASK)			\
-		printk(KERN_CONT fmt, ##__VA_ARGS__);	\
+#define hfs_dbg_cont(flg, fmt, ...)				\
+do {								\
+	if (DBG_##flg & DBG_MASK)				\
+		pr_cont(fmt, ##__VA_ARGS__);			\
 } while (0)
 
 /* Runtime config options */
diff -puN fs/hfsplus/inode.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/inode.c
@@ -357,7 +357,7 @@ int hfsplus_file_fsync(struct file *file
 			if (!error)
 				error = error2;
 		} else {
-			printk(KERN_ERR "hfs: sync non-existent attributes tree\n");
+			pr_err("sync non-existent attributes tree\n");
 		}
 	}
 
@@ -573,7 +573,7 @@ int hfsplus_cat_read_inode(struct inode
 		inode->i_ctime = hfsp_mt2ut(file->attribute_mod_date);
 		HFSPLUS_I(inode)->create_date = file->create_date;
 	} else {
-		printk(KERN_ERR "hfs: bad catalog entry used to create inode\n");
+		pr_err("bad catalog entry used to create inode\n");
 		res = -EIO;
 	}
 	return res;
diff -puN fs/hfsplus/options.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/options.c
@@ -113,67 +113,67 @@ int hfsplus_parse_options(char *input, s
 		switch (token) {
 		case opt_creator:
 			if (match_fourchar(&args[0], &sbi->creator)) {
-				printk(KERN_ERR "hfs: creator requires a 4 character value\n");
+				pr_err("creator requires a 4 character value\n");
 				return 0;
 			}
 			break;
 		case opt_type:
 			if (match_fourchar(&args[0], &sbi->type)) {
-				printk(KERN_ERR "hfs: type requires a 4 character value\n");
+				pr_err("type requires a 4 character value\n");
 				return 0;
 			}
 			break;
 		case opt_umask:
 			if (match_octal(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: umask requires a value\n");
+				pr_err("umask requires a value\n");
 				return 0;
 			}
 			sbi->umask = (umode_t)tmp;
 			break;
 		case opt_uid:
 			if (match_int(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: uid requires an argument\n");
+				pr_err("uid requires an argument\n");
 				return 0;
 			}
 			sbi->uid = make_kuid(current_user_ns(), (uid_t)tmp);
 			if (!uid_valid(sbi->uid)) {
-				printk(KERN_ERR "hfs: invalid uid specified\n");
+				pr_err("invalid uid specified\n");
 				return 0;
 			}
 			break;
 		case opt_gid:
 			if (match_int(&args[0], &tmp)) {
-				printk(KERN_ERR "hfs: gid requires an argument\n");
+				pr_err("gid requires an argument\n");
 				return 0;
 			}
 			sbi->gid = make_kgid(current_user_ns(), (gid_t)tmp);
 			if (!gid_valid(sbi->gid)) {
-				printk(KERN_ERR "hfs: invalid gid specified\n");
+				pr_err("invalid gid specified\n");
 				return 0;
 			}
 			break;
 		case opt_part:
 			if (match_int(&args[0], &sbi->part)) {
-				printk(KERN_ERR "hfs: part requires an argument\n");
+				pr_err("part requires an argument\n");
 				return 0;
 			}
 			break;
 		case opt_session:
 			if (match_int(&args[0], &sbi->session)) {
-				printk(KERN_ERR "hfs: session requires an argument\n");
+				pr_err("session requires an argument\n");
 				return 0;
 			}
 			break;
 		case opt_nls:
 			if (sbi->nls) {
-				printk(KERN_ERR "hfs: unable to change nls mapping\n");
+				pr_err("unable to change nls mapping\n");
 				return 0;
 			}
 			p = match_strdup(&args[0]);
 			if (p)
 				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
-				printk(KERN_ERR "hfs: unable to load "
+				pr_err("unable to load "
 						"nls mapping \"%s\"\n",
 					p);
 				kfree(p);
diff -puN fs/hfsplus/super.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/super.c
@@ -132,7 +132,7 @@ static int hfsplus_system_write_inode(st
 	if (tree) {
 		int err = hfs_btree_write(tree);
 		if (err) {
-			printk(KERN_ERR "hfs: b-tree write err: %d, ino %lu\n",
+			pr_err("b-tree write err: %d, ino %lu\n",
 					err, inode->i_ino);
 			return err;
 		}
@@ -251,7 +251,7 @@ static void delayed_sync_fs(struct work_
 
 	err = hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
 	if (err)
-		printk(KERN_ERR "hfs: delayed sync fs err %d\n", err);
+		pr_err("delayed sync fs err %d\n", err);
 }
 
 void hfsplus_mark_mdb_dirty(struct super_block *sb)
@@ -333,25 +333,19 @@ static int hfsplus_remount(struct super_
 			return -EINVAL;
 
 		if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
-			printk(KERN_WARNING "hfs: filesystem was "
-					"not cleanly unmounted, "
-					"running fsck.hfsplus is recommended.  "
-					"leaving read-only.\n");
+			pr_warn("filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		} else if (force) {
 			/* nothing */
 		} else if (vhdr->attributes &
 				cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
-			printk(KERN_WARNING "hfs: filesystem is marked locked, "
-					"leaving read-only.\n");
+			pr_warn("filesystem is marked locked, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		} else if (vhdr->attributes &
 				cpu_to_be32(HFSPLUS_VOL_JOURNALED)) {
-			printk(KERN_WARNING "hfs: filesystem is "
-					"marked journaled, "
-					"leaving read-only.\n");
+			pr_warn("filesystem is marked journaled, leaving read-only.\n");
 			sb->s_flags |= MS_RDONLY;
 			*flags |= MS_RDONLY;
 		}
@@ -397,7 +391,7 @@ static int hfsplus_fill_super(struct sup
 
 	err = -EINVAL;
 	if (!hfsplus_parse_options(data, sbi)) {
-		printk(KERN_ERR "hfs: unable to parse mount options\n");
+		pr_err("unable to parse mount options\n");
 		goto out_unload_nls;
 	}
 
@@ -405,14 +399,14 @@ static int hfsplus_fill_super(struct sup
 	nls = sbi->nls;
 	sbi->nls = load_nls("utf8");
 	if (!sbi->nls) {
-		printk(KERN_ERR "hfs: unable to load nls for utf8\n");
+		pr_err("unable to load nls for utf8\n");
 		goto out_unload_nls;
 	}
 
 	/* Grab the volume header */
 	if (hfsplus_read_wrapper(sb)) {
 		if (!silent)
-			printk(KERN_WARNING "hfs: unable to find HFS+ superblock\n");
+			pr_warn("unable to find HFS+ superblock\n");
 		goto out_unload_nls;
 	}
 	vhdr = sbi->s_vhdr;
@@ -421,7 +415,7 @@ static int hfsplus_fill_super(struct sup
 	sb->s_magic = HFSPLUS_VOLHEAD_SIG;
 	if (be16_to_cpu(vhdr->version) < HFSPLUS_MIN_VERSION ||
 	    be16_to_cpu(vhdr->version) > HFSPLUS_CURRENT_VERSION) {
-		printk(KERN_ERR "hfs: wrong filesystem version\n");
+		pr_err("wrong filesystem version\n");
 		goto out_free_vhdr;
 	}
 	sbi->total_blocks = be32_to_cpu(vhdr->total_blocks);
@@ -445,7 +439,7 @@ static int hfsplus_fill_super(struct sup
 
 	if ((last_fs_block > (sector_t)(~0ULL) >> (sbi->alloc_blksz_shift - 9)) ||
 	    (last_fs_page > (pgoff_t)(~0ULL))) {
-		printk(KERN_ERR "hfs: filesystem size too large.\n");
+		pr_err("filesystem size too large\n");
 		goto out_free_vhdr;
 	}
 
@@ -454,22 +448,16 @@ static int hfsplus_fill_super(struct sup
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
 	if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
-		printk(KERN_WARNING "hfs: Filesystem was "
-				"not cleanly unmounted, "
-				"running fsck.hfsplus is recommended.  "
-				"mounting read-only.\n");
+		pr_warn("Filesystem was not cleanly unmounted, running fsck.hfsplus is recommended.  mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	} else if (test_and_clear_bit(HFSPLUS_SB_FORCE, &sbi->flags)) {
 		/* nothing */
 	} else if (vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_SOFTLOCK)) {
-		printk(KERN_WARNING "hfs: Filesystem is marked locked, mounting read-only.\n");
+		pr_warn("Filesystem is marked locked, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	} else if ((vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_JOURNALED)) &&
 			!(sb->s_flags & MS_RDONLY)) {
-		printk(KERN_WARNING "hfs: write access to "
-				"a journaled filesystem is not supported, "
-				"use the force option at your own risk, "
-				"mounting read-only.\n");
+		pr_warn("write access to a journaled filesystem is not supported, use the force option at your own risk, mounting read-only.\n");
 		sb->s_flags |= MS_RDONLY;
 	}
 
@@ -478,18 +466,18 @@ static int hfsplus_fill_super(struct sup
 	/* Load metadata objects (B*Trees) */
 	sbi->ext_tree = hfs_btree_open(sb, HFSPLUS_EXT_CNID);
 	if (!sbi->ext_tree) {
-		printk(KERN_ERR "hfs: failed to load extents file\n");
+		pr_err("failed to load extents file\n");
 		goto out_free_vhdr;
 	}
 	sbi->cat_tree = hfs_btree_open(sb, HFSPLUS_CAT_CNID);
 	if (!sbi->cat_tree) {
-		printk(KERN_ERR "hfs: failed to load catalog file\n");
+		pr_err("failed to load catalog file\n");
 		goto out_close_ext_tree;
 	}
 	if (vhdr->attr_file.total_blocks != 0) {
 		sbi->attr_tree = hfs_btree_open(sb, HFSPLUS_ATTR_CNID);
 		if (!sbi->attr_tree) {
-			printk(KERN_ERR "hfs: failed to load attributes file\n");
+			pr_err("failed to load attributes file\n");
 			goto out_close_cat_tree;
 		}
 	}
@@ -497,7 +485,7 @@ static int hfsplus_fill_super(struct sup
 
 	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
 	if (IS_ERR(inode)) {
-		printk(KERN_ERR "hfs: failed to load allocation file\n");
+		pr_err("failed to load allocation file\n");
 		err = PTR_ERR(inode);
 		goto out_close_attr_tree;
 	}
@@ -506,7 +494,7 @@ static int hfsplus_fill_super(struct sup
 	/* Load the root directory */
 	root = hfsplus_iget(sb, HFSPLUS_ROOT_CNID);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "hfs: failed to load root directory\n");
+		pr_err("failed to load root directory\n");
 		err = PTR_ERR(root);
 		goto out_put_alloc_file;
 	}
diff -puN fs/hfsplus/wrapper.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/wrapper.c
@@ -156,7 +156,7 @@ static int hfsplus_get_last_session(stru
 			*start = (sector_t)te.cdte_addr.lba << 2;
 			return 0;
 		}
-		printk(KERN_ERR "hfs: invalid session number or type of track\n");
+		pr_err("invalid session number or type of track\n");
 		return -EINVAL;
 	}
 	ms_info.addr_format = CDROM_LBA;
@@ -234,8 +234,7 @@ reread:
 
 	error = -EINVAL;
 	if (sbi->s_backup_vhdr->signature != sbi->s_vhdr->signature) {
-		printk(KERN_WARNING
-			"hfs: invalid secondary volume header\n");
+		pr_warn("invalid secondary volume header\n");
 		goto out_free_backup_vhdr;
 	}
 
@@ -259,8 +258,7 @@ reread:
 		blocksize >>= 1;
 
 	if (sb_set_blocksize(sb, blocksize) != blocksize) {
-		printk(KERN_ERR "hfs: unable to set blocksize to %u!\n",
-			blocksize);
+		pr_err("unable to set blocksize to %u!\n", blocksize);
 		goto out_free_backup_vhdr;
 	}
 
diff -puN fs/hfsplus/xattr.c~hfs-hfsplus-convert-printks-to-pr_level fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfs-hfsplus-convert-printks-to-pr_level
+++ a/fs/hfsplus/xattr.c
@@ -107,19 +107,19 @@ int __hfsplus_setxattr(struct inode *ino
 
 	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
 	if (err) {
-		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		pr_err("can't init xattr find struct\n");
 		return err;
 	}
 
 	err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &cat_fd);
 	if (err) {
-		printk(KERN_ERR "hfs: catalog searching failed\n");
+		pr_err("catalog searching failed\n");
 		goto end_setxattr;
 	}
 
 	if (!strcmp_xattr_finder_info(name)) {
 		if (flags & XATTR_CREATE) {
-			printk(KERN_ERR "hfs: xattr exists yet\n");
+			pr_err("xattr exists yet\n");
 			err = -EOPNOTSUPP;
 			goto end_setxattr;
 		}
@@ -165,7 +165,7 @@ int __hfsplus_setxattr(struct inode *ino
 
 	if (hfsplus_attr_exists(inode, name)) {
 		if (flags & XATTR_CREATE) {
-			printk(KERN_ERR "hfs: xattr exists yet\n");
+			pr_err("xattr exists yet\n");
 			err = -EOPNOTSUPP;
 			goto end_setxattr;
 		}
@@ -177,7 +177,7 @@ int __hfsplus_setxattr(struct inode *ino
 			goto end_setxattr;
 	} else {
 		if (flags & XATTR_REPLACE) {
-			printk(KERN_ERR "hfs: cannot replace xattr\n");
+			pr_err("cannot replace xattr\n");
 			err = -EOPNOTSUPP;
 			goto end_setxattr;
 		}
@@ -210,7 +210,7 @@ int __hfsplus_setxattr(struct inode *ino
 				    cat_entry_flags);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
 	} else {
-		printk(KERN_ERR "hfs: invalid catalog entry type\n");
+		pr_err("invalid catalog entry type\n");
 		err = -EIO;
 		goto end_setxattr;
 	}
@@ -269,7 +269,7 @@ static ssize_t hfsplus_getxattr_finder_i
 	if (size >= record_len) {
 		res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
 		if (res) {
-			printk(KERN_ERR "hfs: can't init xattr find struct\n");
+			pr_err("can't init xattr find struct\n");
 			return res;
 		}
 		res = hfsplus_find_cat(inode->i_sb, inode->i_ino, &fd);
@@ -340,13 +340,13 @@ ssize_t hfsplus_getxattr(struct dentry *
 
 	entry = hfsplus_alloc_attr_entry();
 	if (!entry) {
-		printk(KERN_ERR "hfs: can't allocate xattr entry\n");
+		pr_err("can't allocate xattr entry\n");
 		return -ENOMEM;
 	}
 
 	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->attr_tree, &fd);
 	if (res) {
-		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		pr_err("can't init xattr find struct\n");
 		goto failed_getxattr_init;
 	}
 
@@ -355,7 +355,7 @@ ssize_t hfsplus_getxattr(struct dentry *
 		if (res == -ENOENT)
 			res = -ENODATA;
 		else
-			printk(KERN_ERR "hfs: xattr searching failed\n");
+			pr_err("xattr searching failed\n");
 		goto out;
 	}
 
@@ -368,17 +368,17 @@ ssize_t hfsplus_getxattr(struct dentry *
 				offsetof(struct hfsplus_attr_inline_data,
 				length));
 		if (record_length > HFSPLUS_MAX_INLINE_DATA_SIZE) {
-			printk(KERN_ERR "hfs: invalid xattr record size\n");
+			pr_err("invalid xattr record size\n");
 			res = -EIO;
 			goto out;
 		}
 	} else if (record_type == HFSPLUS_ATTR_FORK_DATA ||
 			record_type == HFSPLUS_ATTR_EXTENTS) {
-		printk(KERN_ERR "hfs: only inline data xattr are supported\n");
+		pr_err("only inline data xattr are supported\n");
 		res = -EOPNOTSUPP;
 		goto out;
 	} else {
-		printk(KERN_ERR "hfs: invalid xattr record\n");
+		pr_err("invalid xattr record\n");
 		res = -EIO;
 		goto out;
 	}
@@ -427,7 +427,7 @@ static ssize_t hfsplus_listxattr_finder_
 
 	res = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &fd);
 	if (res) {
-		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		pr_err("can't init xattr find struct\n");
 		return res;
 	}
 
@@ -506,7 +506,7 @@ ssize_t hfsplus_listxattr(struct dentry
 
 	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->attr_tree, &fd);
 	if (err) {
-		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		pr_err("can't init xattr find struct\n");
 		return err;
 	}
 
@@ -525,8 +525,7 @@ ssize_t hfsplus_listxattr(struct dentry
 	for (;;) {
 		key_len = hfs_bnode_read_u16(fd.bnode, fd.keyoffset);
 		if (key_len == 0 || key_len > fd.tree->max_key_len) {
-			printk(KERN_ERR "hfs: invalid xattr key length: %d\n",
-							key_len);
+			pr_err("invalid xattr key length: %d\n", key_len);
 			res = -EIO;
 			goto end_listxattr;
 		}
@@ -541,7 +540,7 @@ ssize_t hfsplus_listxattr(struct dentry
 		if (hfsplus_uni2asc(inode->i_sb,
 			(const struct hfsplus_unistr *)&fd.key->attr.key_name,
 					strbuf, &xattr_name_len)) {
-			printk(KERN_ERR "hfs: unicode conversion failed\n");
+			pr_err("unicode conversion failed\n");
 			res = -EIO;
 			goto end_listxattr;
 		}
@@ -598,13 +597,13 @@ int hfsplus_removexattr(struct dentry *d
 
 	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
 	if (err) {
-		printk(KERN_ERR "hfs: can't init xattr find struct\n");
+		pr_err("can't init xattr find struct\n");
 		return err;
 	}
 
 	err = hfsplus_find_cat(inode->i_sb, inode->i_ino, &cat_fd);
 	if (err) {
-		printk(KERN_ERR "hfs: catalog searching failed\n");
+		pr_err("catalog searching failed\n");
 		goto end_removexattr;
 	}
 
@@ -643,7 +642,7 @@ int hfsplus_removexattr(struct dentry *d
 				flags);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_CAT_DIRTY);
 	} else {
-		printk(KERN_ERR "hfs: invalid catalog entry type\n");
+		pr_err("invalid catalog entry type\n");
 		err = -EIO;
 		goto end_removexattr;
 	}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

