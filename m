From: akpm@linux-foundation.org
Subject: [merged] hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:28 -0800
Message-ID: <201111072026.pA7KQSR8009980@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5259 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab1KGU0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: plougher@redhat.com, clement.lecigne@netasq.com, hch@lst.de, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops
has been removed from the -mm tree.  Its filename was
     hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Phillip Lougher <plougher@redhat.com>
Subject: hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Clement Lecigne reports a filesystem which causes a kernel oops in
hfs_find_init() trying to dereference sb->ext_tree which is NULL.

This proves to be because the filesystem has a corrupted MDB extent
record, where the extents file does not fit into the first three extents
in the file record (the first blocks).

In hfs_get_block() when looking up the blocks for the extent file
(HFS_EXT_CNID), it fails the first blocks special case, and falls through
to the extent code (which ultimately calls hfs_find_init()) which is in
the process of being initialised.

Hfs avoids this scenario by always having the extents b-tree fitting into
the first blocks (the extents B-tree can't have overflow extents).

The fix is to check at mount time that the B-tree fits into first blocks,
i.e.  fail if HFS_I(inode)->alloc_blocks >= HFS_I(inode)->first_blocks

Note, the existing commit 47f365eb57573 ("hfs: fix oops on mount with
corrupted btree extent records") becomes subsumed into this as a special
case, but only for the extents B-tree (HFS_EXT_CNID), it is perfectly
acceptable for the catalog B-Tree file to grow beyond three extents, with
the remaining extent descriptors in the extents overfow.

This fixes CVE-2011-2203

Reported-by: Clement LECIGNE <clement.lecigne@netasq.com>
Signed-off-by: Phillip Lougher <plougher@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN fs/hfs/btree.c~hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops
+++ a/fs/hfs/btree.c
@@ -46,11 +46,26 @@ struct hfs_btree *hfs_btree_open(struct 
 	case HFS_EXT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->drXTFlSize,
 				    mdb->drXTFlSize, be32_to_cpu(mdb->drXTClpSiz));
+		if (HFS_I(tree->inode)->alloc_blocks >
+					HFS_I(tree->inode)->first_blocks) {
+			printk(KERN_ERR "hfs: invalid btree extent records\n");
+			unlock_new_inode(tree->inode);
+			goto free_inode;
+		}
+
 		tree->inode->i_mapping->a_ops = &hfs_btree_aops;
 		break;
 	case HFS_CAT_CNID:
 		hfs_inode_read_fork(tree->inode, mdb->drCTExtRec, mdb->drCTFlSize,
 				    mdb->drCTFlSize, be32_to_cpu(mdb->drCTClpSiz));
+
+		if (!HFS_I(tree->inode)->first_blocks) {
+			printk(KERN_ERR "hfs: invalid btree extent records "
+								"(0 size).\n");
+			unlock_new_inode(tree->inode);
+			goto free_inode;
+		}
+
 		tree->inode->i_mapping->a_ops = &hfs_btree_aops;
 		break;
 	default:
@@ -59,11 +74,6 @@ struct hfs_btree *hfs_btree_open(struct 
 	}
 	unlock_new_inode(tree->inode);
 
-	if (!HFS_I(tree->inode)->first_blocks) {
-		printk(KERN_ERR "hfs: invalid btree extent records (0 size).\n");
-		goto free_inode;
-	}
