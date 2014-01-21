From: akpm@linux-foundation.org
Subject: + ocfs2-code-cleanup-remove-unused-functions.patch added to -mm
 tree
Date: Tue, 21 Jan 2014 12:05:06 -0800
Message-ID: <52ded2f2.JOt6X7VJufC3BjxI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaAUUFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 15:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@suse.de

Subject: + ocfs2-code-cleanup-remove-unused-functions.patch added to -mm tree
To: rgoldwyn@suse.de,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 12:05:06 -0800


The patch titled
     Subject: ocfs2: code cleanup: remove unused functions
has been added to the -mm tree.  Its filename is
     ocfs2-code-cleanup-remove-unused-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-code-cleanup-remove-unused-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-code-cleanup-remove-unused-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-remove-versioning-information.patch
ocfs2-add-clustername-to-cluster-connection.patch
ocfs2-add-dlm-recovery-callbacks.patch
ocfs2-shift-allocation-ocfs2_live_connection-to-user_connect.patch
ocfs2-pass-ocfs2_cluster_connection-to-ocfs2_this_node.patch
ocfs2-framework-for-version-lvb.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace.patch
ocfs2-use-the-new-dlm-operation-callbacks-while-requesting-new-lockspace-fix.patch
ocfs2-code-cleanup-remove-unused-functions.patch

