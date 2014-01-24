From: akpm@linux-foundation.org
Subject: [nacked] ocfs2-code-cleanup-remove-unused-functions.patch removed from -mm tree
Date: Fri, 24 Jan 2014 14:13:02 -0800
Message-ID: <52e2e56e.ieh+8NWiDkE7bx9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaAXWND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 17:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: [nacked] ocfs2-code-cleanup-remove-unused-functions.patch removed from -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 14:13:02 -0800


The patch titled
     Subject: ocfs2: code cleanup: remove unused functions
has been removed from the -mm tree.  Its filename was
     ocfs2-code-cleanup-remove-unused-functions.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: ocfs2: code cleanup: remove unused functions

These functions are either coded in individual files as static or not used
at all.  Remove them.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-code-cleanup-remove-unused-functions fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-code-cleanup-remove-unused-functions
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -1325,16 +1325,6 @@ static inline int ocfs2_extent_recs_per_
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
-static inline int ocfs2_chain_recs_per_inode(struct super_block *sb)
-{
-	int size;
-
-	size = sb->s_blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_chain.cl_recs);
-
-	return size / sizeof(struct ocfs2_chain_rec);
-}
-
 static inline u16 ocfs2_extent_recs_per_eb(struct super_block *sb)
 {
 	int size;
@@ -1493,16 +1483,6 @@ static inline int ocfs2_extent_recs_per_
 	return size / sizeof(struct ocfs2_extent_rec);
 }
 
-static inline int ocfs2_chain_recs_per_inode(int blocksize)
-{
-	int size;
-
-	size = blocksize -
-		offsetof(struct ocfs2_dinode, id2.i_chain.cl_recs);
-
-	return size / sizeof(struct ocfs2_chain_rec);
-}
-
 static inline int ocfs2_extent_recs_per_eb(int blocksize)
 {
 	int size;
@@ -1589,12 +1569,6 @@ static inline int ocfs2_xattr_recs_per_x
 #endif  /* __KERNEL__ */
 
 
-static inline int ocfs2_system_inode_is_global(int type)
-{
-	return ((type >= 0) &&
-		(type <= OCFS2_LAST_GLOBAL_SYSTEM_INODE));
-}
-
 static inline int ocfs2_sprintf_system_inode_name(char *buf, int len,
 						  int type, int slot)
 {
@@ -1622,19 +1596,5 @@ static inline void ocfs2_set_de_type(str
 	de->file_type = ocfs2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
 }
 
-static inline int ocfs2_gd_is_discontig(struct ocfs2_group_desc *gd)
-{
-	if ((offsetof(struct ocfs2_group_desc, bg_bitmap) +
-	     le16_to_cpu(gd->bg_size)) !=
-	    offsetof(struct ocfs2_group_desc, bg_list))
-		return 0;
-	/*
-	 * Only valid to check l_next_free_rec if
-	 * bg_bitmap + bg_size == bg_list.
-	 */
-	if (!gd->bg_list.l_next_free_rec)
-		return 0;
-	return 1;
-}
 #endif  /* _OCFS2_FS_H */
 
_

Patches currently in -mm which might be from rgoldwyn@suse.de are

origin.patch

