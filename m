From: akpm@google.com
Subject: + hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops.patch added to -mm tree
Date: Thu, 06 Oct 2011 15:54:10 -0700
Message-ID: <201110062254.p96MsATu003098@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:6564 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1JFWyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 18:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clement.lecigne@netasq.com, hch@lst.de, jeffm@suse.com, plougher@redhat.com


The patch titled
     From: plougher@redhat.com (Phillip Lougher)
has been added to the -mm tree.  Its filename is
     hfs-fix-hfs_find_init-sb-ext_tree-null-ptr-oops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: plougher@redhat.com (Phillip Lougher)
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
Signed-off-by: Andrew Morton <akpm@google.com>
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
