From: akpm@linux-foundation.org
Subject: [merged] hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:46 -0800
Message-ID: <20121221203947.21A3920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:63985 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2LUUjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:49 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so272761eaa.0
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: rework processing of hfs_btree_write() returned error
has been removed from the -mm tree.  Its filename was
     hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: rework processing of hfs_btree_write() returned error

Add to hfs_btree_write() a return of -EIO on failure of b-tree node
searching.  Also add logic ofor processing errors from hfs_btree_write()
in hfsplus_system_write_inode() with a message about b-tree writing
failure.

[akpm@linux-foundation.org: reduce scope of `err', print errno on error]
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c      |    5 +++--
 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/super.c      |   10 ++++++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/btree.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error
+++ a/fs/hfsplus/btree.c
@@ -159,7 +159,7 @@ void hfs_btree_close(struct hfs_btree *t
 	kfree(tree);
 }
 
-void hfs_btree_write(struct hfs_btree *tree)
+int hfs_btree_write(struct hfs_btree *tree)
 {
 	struct hfs_btree_header_rec *head;
 	struct hfs_bnode *node;
@@ -168,7 +168,7 @@ void hfs_btree_write(struct hfs_btree *t
 	node = hfs_bnode_find(tree, 0);
 	if (IS_ERR(node))
 		/* panic? */
-		return;
+		return -EIO;
 	/* Load the header */
 	page = node->page[0];
 	head = (struct hfs_btree_header_rec *)(kmap(page) +
@@ -186,6 +186,7 @@ void hfs_btree_write(struct hfs_btree *t
 	kunmap(page);
 	set_page_dirty(page);
 	hfs_bnode_put(node);
+	return 0;
 }
 
 static struct hfs_bnode *hfs_bmap_new_bmap(struct hfs_bnode *prev, u32 idx)
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-rework-processing-of-hfs_btree_write-returned-error fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-rework-processing-of-hfs_btree_write-returned-error
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -335,7 +335,7 @@ int hfsplus_block_free(struct super_bloc
 /* btree.c */
 struct hfs_btree *hfs_btree_open(struct super_block *, u32);
 void hfs_btree_close(struct hfs_btree *);
-void hfs_btree_write(struct hfs_btree *);
+int hfs_btree_write(struct hfs_btree *);
 struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *);
 void hfs_bmap_free(struct hfs_bnode *);
 
diff -puN fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error
+++ a/fs/hfsplus/super.c
@@ -127,8 +127,14 @@ static int hfsplus_system_write_inode(st
 		hfsplus_mark_mdb_dirty(inode->i_sb);
 	}
 	hfsplus_inode_write_fork(inode, fork);
-	if (tree)
-		hfs_btree_write(tree);
+	if (tree) {
+		int err = hfs_btree_write(tree);
+		if (err) {
+			printk(KERN_ERR "hfs: b-tree write err: %d, ino %lu\n",
+					err, inode->i_ino);
+			return err;
+		}
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch

