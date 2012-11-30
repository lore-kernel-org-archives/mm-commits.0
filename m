From: akpm@linux-foundation.org
Subject: + hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch added to -mm tree
Date: Fri, 30 Nov 2012 13:56:26 -0800
Message-ID: <20121130215627.3C90482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64131 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2K3V42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:56:28 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so106832yen.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:56:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slava@dubeyko.com, hch@infradead.org, htl10@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: rework processing of hfs_btree_write() returned error
has been added to the -mm tree.  Its filename is
     hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch

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
Subject: hfsplus: rework processing of hfs_btree_write() returned error

Add to hfs_btree_write() a return of -EIO on failure of b-tree node
searching.  Also add logic ofor processing errors from hfs_btree_write()
in hfsplus_system_write_inode() with a message about b-tree writing
failure.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/btree.c      |    5 +++--
 fs/hfsplus/hfsplus_fs.h |    2 +-
 fs/hfsplus/super.c      |   12 ++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/btree.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~hfsplus-rework-processing-of-hfs_btree_write-returned-error
+++ a/fs/hfsplus/btree.c
@@ -167,7 +167,7 @@ void hfs_btree_close(struct hfs_btree *t
 	kfree(tree);
 }
 
-void hfs_btree_write(struct hfs_btree *tree)
+int hfs_btree_write(struct hfs_btree *tree)
 {
 	struct hfs_btree_header_rec *head;
 	struct hfs_bnode *node;
@@ -176,7 +176,7 @@ void hfs_btree_write(struct hfs_btree *t
 	node = hfs_bnode_find(tree, 0);
 	if (IS_ERR(node))
 		/* panic? */
-		return;
+		return -EIO;
 	/* Load the header */
 	page = node->page[0];
 	head = (struct hfs_btree_header_rec *)(kmap(page) +
@@ -194,6 +194,7 @@ void hfs_btree_write(struct hfs_btree *t
 	kunmap(page);
 	set_page_dirty(page);
 	hfs_bnode_put(node);
+	return 0;
 }
 
 static struct hfs_bnode *hfs_bmap_new_bmap(struct hfs_bnode *prev, u32 idx)
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-rework-processing-of-hfs_btree_write-returned-error fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-rework-processing-of-hfs_btree_write-returned-error
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -367,7 +367,7 @@ int hfsplus_block_free(struct super_bloc
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
@@ -100,6 +100,7 @@ static int hfsplus_system_write_inode(st
 	struct hfsplus_vh *vhdr = sbi->s_vhdr;
 	struct hfsplus_fork_raw *fork;
 	struct hfs_btree *tree = NULL;
+	int err;
 
 	switch (inode->i_ino) {
 	case HFSPLUS_EXT_CNID:
@@ -129,8 +130,15 @@ static int hfsplus_system_write_inode(st
 		hfsplus_mark_mdb_dirty(inode->i_sb);
 	}
 	hfsplus_inode_write_fork(inode, fork);
-	if (tree)
-		hfs_btree_write(tree);
+	if (tree) {
+		err = hfs_btree_write(tree);
+		if (err) {
+			printk(KERN_ERR "hfs: unable to write b-tree\n");
+			dprint(DBG_INODE, "hfsplus_system_write_inode: %lu\n",
+				inode->i_ino);
+			return err;
+		}
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-rework-processing-errors-in-hfsplus_free_extents.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch

