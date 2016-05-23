From: akpm@linux-foundation.org
Subject: [patch 21/84] nilfs2: move cleanup code of metadata file from
 inode routines
Date: Mon, 23 May 2016 16:23:20 -0700
Message-ID: <574390e8.54VfaENiWzjItPgR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: move cleanup code of metadata file from inode routines

Refactor nilfs_clear_inode() and nilfs_i_callback() so that cleanup
code or resource deallocation related to metadata file will be moved
out to mdt.c.

Link: http://lkml.kernel.org/r/1461935747-10380-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    5 ++---
 fs/nilfs2/mdt.c   |   25 +++++++++++++++++++++++++
 fs/nilfs2/mdt.h   |    8 ++++++++
 fs/nilfs2/super.c |    8 +++-----
 4 files changed, 38 insertions(+), 8 deletions(-)

diff -puN fs/nilfs2/inode.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines
+++ a/fs/nilfs2/inode.c
@@ -755,7 +755,6 @@ void nilfs_truncate(struct inode *inode)
 static void nilfs_clear_inode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
 	/*
 	 * Free resources allocated in nilfs_read_inode(), here.
@@ -764,8 +763,8 @@ static void nilfs_clear_inode(struct ino
 	brelse(ii->i_bh);
 	ii->i_bh = NULL;
 
-	if (mdi && mdi->mi_palloc_cache)
-		nilfs_palloc_destroy_cache(inode);
+	if (nilfs_is_metadata_file_inode(inode))
+		nilfs_mdt_clear(inode);
 
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
diff -puN fs/nilfs2/mdt.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines
+++ a/fs/nilfs2/mdt.c
@@ -28,6 +28,7 @@
 #include "segment.h"
 #include "page.h"
 #include "mdt.h"
+#include "alloc.h"		/* nilfs_palloc_destroy_cache() */
 
 #include <trace/events/nilfs2.h>
 
@@ -465,6 +466,30 @@ int nilfs_mdt_init(struct inode *inode,
 	return 0;
 }
 
+/**
+ * nilfs_mdt_clear - do cleanup for the metadata file
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_clear(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	if (mdi->mi_palloc_cache)
+		nilfs_palloc_destroy_cache(inode);
+}
+
+/**
+ * nilfs_mdt_destroy - release resources used by the metadata file
+ * @inode: inode of the metadata file
+ */
+void nilfs_mdt_destroy(struct inode *inode)
+{
+	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+
+	kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
+	kfree(mdi);
+}
+
 void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
 			      unsigned header_size)
 {
diff -puN fs/nilfs2/mdt.h~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines fs/nilfs2/mdt.h
--- a/fs/nilfs2/mdt.h~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines
+++ a/fs/nilfs2/mdt.h
@@ -67,6 +67,11 @@ static inline struct nilfs_mdt_info *NIL
 	return inode->i_private;
 }
 
+static inline int nilfs_is_metadata_file_inode(const struct inode *inode)
+{
+	return inode->i_private != NULL;
+}
+
 /* Default GFP flags using highmem */
 #define NILFS_MDT_GFP      (__GFP_RECLAIM | __GFP_IO | __GFP_HIGHMEM)
 
@@ -82,6 +87,9 @@ int nilfs_mdt_forget_block(struct inode
 int nilfs_mdt_fetch_dirty(struct inode *);
 
 int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz);
+void nilfs_mdt_clear(struct inode *inode);
+void nilfs_mdt_destroy(struct inode *inode);
+
 void nilfs_mdt_set_entry_size(struct inode *, unsigned, unsigned);
 
 int nilfs_mdt_setup_shadow_map(struct inode *inode,
diff -puN fs/nilfs2/super.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines
+++ a/fs/nilfs2/super.c
@@ -169,12 +169,10 @@ struct inode *nilfs_alloc_inode(struct s
 static void nilfs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
 
-	if (mdi) {
-		kfree(mdi->mi_bgl); /* kfree(NULL) is safe */
-		kfree(mdi);
-	}
+	if (nilfs_is_metadata_file_inode(inode))
+		nilfs_mdt_destroy(inode);
+
 	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
 }
 
_
