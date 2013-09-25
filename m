From: akpm@linux-foundation.org
Subject: + hfsplus-implement-attributes-file-creation-functionality.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 16:02:48 -0700
Message-ID: <52436b98.KXJ544r/va9cI86o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3IYXCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 19:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, htl10@users.sourceforge.net, hch@infradead.org, slava@dubeyko.com

Subject: + hfsplus-implement-attributes-file-creation-functionality.patch added to -mm tree
To: slava@dubeyko.com,hch@infradead.org,htl10@users.sourceforge.net,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 16:02:48 -0700


The patch titled
     Subject: hfsplus: implement attributes file creation functionality
has been added to the -mm tree.  Its filename is
     hfsplus-implement-attributes-file-creation-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-implement-attributes-file-creation-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-implement-attributes-file-creation-functionality.patch

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
Subject: hfsplus: implement attributes file creation functionality

Implement functionality of creation AttributesFile metadata file on HFS+
volume in the case of absence of it.

It makes trying to open AttributesFile's B-tree during mount of HFS+
volume.  If HFS+ volume hasn't AttributesFile then a pointer on
AttributesFile's B-tree keeps as NULL.  Thereby, when it is discovered
absence of AttributesFile on HFS+ volume in the begin of xattr creation
operation then AttributesFile will be created.

The creation of AttributesFile will have success in the case of
availability (2 * clump) free blocks on HFS+ volume.  Otherwise, creation
operation is ended with error (-ENOSPC).

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_fs.h |    9 ++
 fs/hfsplus/super.c      |    2 
 fs/hfsplus/xattr.c      |  128 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-implement-attributes-file-creation-functionality fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-implement-attributes-file-creation-functionality
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -127,6 +127,14 @@ struct hfs_bnode {
 #define HFS_BNODE_DELETED	4
 
 /*
+ * Attributes file states
+ */
+#define HFSPLUS_EMPTY_ATTR_TREE		0
+#define HFSPLUS_CREATING_ATTR_TREE	1
+#define HFSPLUS_VALID_ATTR_TREE		2
+#define HFSPLUS_FAILED_ATTR_TREE	3
+
+/*
  * HFS+ superblock info (built from Volume Header on disk)
  */
 
@@ -141,6 +149,7 @@ struct hfsplus_sb_info {
 	struct hfs_btree *ext_tree;
 	struct hfs_btree *cat_tree;
 	struct hfs_btree *attr_tree;
+	atomic_t attr_tree_state;
 	struct inode *alloc_file;
 	struct inode *hidden_dir;
 	struct nls_table *nls;
diff -puN fs/hfsplus/super.c~hfsplus-implement-attributes-file-creation-functionality fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-implement-attributes-file-creation-functionality
+++ a/fs/hfsplus/super.c
@@ -474,12 +474,14 @@ static int hfsplus_fill_super(struct sup
 		pr_err("failed to load catalog file\n");
 		goto out_close_ext_tree;
 	}
+	atomic_set(&sbi->attr_tree_state, HFSPLUS_EMPTY_ATTR_TREE);
 	if (vhdr->attr_file.total_blocks != 0) {
 		sbi->attr_tree = hfs_btree_open(sb, HFSPLUS_ATTR_CNID);
 		if (!sbi->attr_tree) {
 			pr_err("failed to load attributes file\n");
 			goto out_close_cat_tree;
 		}
+		atomic_set(&sbi->attr_tree_state, HFSPLUS_VALID_ATTR_TREE);
 	}
 	sb->s_xattr = hfsplus_xattr_handlers;
 
diff -puN fs/hfsplus/xattr.c~hfsplus-implement-attributes-file-creation-functionality fs/hfsplus/xattr.c
--- a/fs/hfsplus/xattr.c~hfsplus-implement-attributes-file-creation-functionality
+++ a/fs/hfsplus/xattr.c
@@ -190,6 +190,129 @@ static void hfsplus_init_header_node(str
 	SETOFFSET(buf, node_size, offset, 4);
 }
 
+static int hfsplus_create_attributes_file(struct super_block *sb)
+{
+	int err = 0;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	struct inode *attr_file;
+	struct hfsplus_inode_info *hip;
+	u32 clump_size;
+	u16 node_size = HFSPLUS_ATTR_TREE_NODE_SIZE;
+	char *buf;
+	int index, written;
+	struct address_space *mapping;
+	struct page *page;
+	int old_state = HFSPLUS_EMPTY_ATTR_TREE;
+
+	hfs_dbg(ATTR_MOD, "create_attr_file: ino %d\n", HFSPLUS_ATTR_CNID);
+
+check_attr_tree_state_again:
+	switch (atomic_read(&sbi->attr_tree_state)) {
+	case HFSPLUS_EMPTY_ATTR_TREE:
+		if (old_state != atomic_cmpxchg(&sbi->attr_tree_state,
+						old_state,
+						HFSPLUS_CREATING_ATTR_TREE))
+			goto check_attr_tree_state_again;
+		break;
+	case HFSPLUS_CREATING_ATTR_TREE:
+		schedule_timeout_uninterruptible(HZ);
+		goto check_attr_tree_state_again;
+		break;
+	case HFSPLUS_VALID_ATTR_TREE:
+		return 0;
+	case HFSPLUS_FAILED_ATTR_TREE:
+		return -EOPNOTSUPP;
+	default:
+		BUG();
+	}
+
+	attr_file = hfsplus_iget(sb, HFSPLUS_ATTR_CNID);
+	if (IS_ERR(attr_file)) {
+		pr_err("failed to load attributes file\n");
+		return PTR_ERR(attr_file);
+	}
+
+	BUG_ON(i_size_read(attr_file) != 0);
+
+	hip = HFSPLUS_I(attr_file);
+
+	clump_size = hfsplus_calc_btree_clump_size(sb->s_blocksize,
+						    node_size,
+						    sbi->sect_count,
+						    HFSPLUS_ATTR_CNID);
+
+	mutex_lock(&hip->extents_lock);
+	hip->clump_blocks = clump_size >> sbi->alloc_blksz_shift;
+	mutex_unlock(&hip->extents_lock);
+
+	if (sbi->free_blocks <= (hip->clump_blocks << 1)) {
+		err = -ENOSPC;
+		goto end_attr_file_creation;
+	}
+
+	while (hip->alloc_blocks < hip->clump_blocks) {
+		err = hfsplus_file_extend(attr_file);
+		if (unlikely(err)) {
+			pr_err("failed to extend attributes file\n");
+			goto end_attr_file_creation;
+		}
+		hip->phys_size = attr_file->i_size =
+			(loff_t)hip->alloc_blocks << sbi->alloc_blksz_shift;
+		hip->fs_blocks = hip->alloc_blocks << sbi->fs_shift;
+		inode_set_bytes(attr_file, attr_file->i_size);
+	}
+
+	buf = kzalloc(node_size, GFP_NOFS);
+	if (!buf) {
+		pr_err("failed to allocate memory for header node\n");
+		err = -ENOMEM;
+		goto end_attr_file_creation;
+	}
+
+	hfsplus_init_header_node(attr_file, clump_size, buf, node_size);
+
+	mapping = attr_file->i_mapping;
+
+	index = 0;
+	written = 0;
+	for (; written < node_size; index++, written += PAGE_CACHE_SIZE) {
+		void *kaddr;
+
+		page = read_mapping_page(mapping, index, NULL);
+		if (IS_ERR(page))
+			goto failed_header_node_init;
+
+		kaddr = kmap_atomic(page);
+		memcpy(kaddr, buf + written,
+			min_t(size_t, PAGE_CACHE_SIZE, node_size - written));
+		kunmap_atomic(kaddr);
+
+		set_page_dirty(page);
+		page_cache_release(page);
+	}
+
+	hfsplus_mark_inode_dirty(attr_file, HFSPLUS_I_ATTR_DIRTY);
+
+	sbi->attr_tree = hfs_btree_open(sb, HFSPLUS_ATTR_CNID);
+	if (!sbi->attr_tree)
+		pr_err("failed to load attributes file\n");
+
+failed_header_node_init:
+	kfree(buf);
+
+end_attr_file_creation:
+	iput(attr_file);
+
+	if (!err)
+		atomic_set(&sbi->attr_tree_state, HFSPLUS_VALID_ATTR_TREE);
+	else if (err == -ENOSPC)
+		atomic_set(&sbi->attr_tree_state, HFSPLUS_EMPTY_ATTR_TREE);
+	else
+		atomic_set(&sbi->attr_tree_state, HFSPLUS_FAILED_ATTR_TREE);
+
+	return err;
+}
+
 int __hfsplus_setxattr(struct inode *inode, const char *name,
 			const void *value, size_t size, int flags)
 {
@@ -274,8 +397,9 @@ int __hfsplus_setxattr(struct inode *ino
 	}
 
 	if (!HFSPLUS_SB(inode->i_sb)->attr_tree) {
-		err = -EOPNOTSUPP;
-		goto end_setxattr;
+		err = hfsplus_create_attributes_file(inode->i_sb);
+		if (unlikely(err))
+			goto end_setxattr;
 	}
 
 	if (hfsplus_attr_exists(inode, name)) {
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-fix-issue-with-race-condition-of-competition-between-segments-for-dirty-blocks.patch
hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-file-creation-functionality.patch

