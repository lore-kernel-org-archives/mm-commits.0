From: akpm@linux-foundation.org
Subject: + ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
 added to -mm tree
Date: Fri, 11 Sep 2015 15:32:34 -0700
Message-ID: <55f35682.jD4BW2h+gjU0gf3I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbIKWcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:32:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: return the physical address in ocfs2_write_cluster
has been added to the -mm tree.  Its filename is
     ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: return the physical address in ocfs2_write_cluster

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Direct io needs to get the physical address from write_begin, to map the
user page.  This patch is to change the arg 'phys' of ocfs2_write_cluster
to a pointer, so it can be retrieved to write_begin.  And we can retrieve
it to the direct io procedure.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-return-the-physical-address-in-ocfs2_write_cluster fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-return-the-physical-address-in-ocfs2_write_cluster
+++ a/fs/ocfs2/aops.c
@@ -1589,7 +1589,7 @@ out:
  * Prepare a single cluster for write one cluster into the file.
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
-			       u32 phys, unsigned int new,
+			       u32 *phys, unsigned int new,
 			       unsigned int clear_unwritten,
 			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
@@ -1598,9 +1598,10 @@ static int ocfs2_write_cluster(struct ad
 			       loff_t user_pos, unsigned user_len)
 {
 	int ret, i;
-	u64 v_blkno, p_blkno;
+	u64 p_blkno;
 	struct inode *inode = mapping->host;
 	struct ocfs2_extent_tree et;
+	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
 
 	if (new) {
 		u32 tmp_pos;
@@ -1634,7 +1635,7 @@ static int ocfs2_write_cluster(struct ad
 		ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode),
 					      wc->w_di_bh);
 		ret = ocfs2_mark_extent_written(inode, &et,
-						wc->w_handle, cpos, 1, phys,
+						wc->w_handle, cpos, 1, *phys,
 						meta_ac, &wc->w_dealloc);
 		if (ret < 0) {
 			mlog_errno(ret);
@@ -1642,26 +1643,23 @@ static int ocfs2_write_cluster(struct ad
 		}
 	}
 
-	if (should_zero)
-		v_blkno = ocfs2_clusters_to_blocks(inode->i_sb, cpos);
-	else
-		v_blkno = user_pos >> inode->i_sb->s_blocksize_bits;
-
 	/*
 	 * The only reason this should fail is due to an inability to
 	 * find the extent added.
 	 */
-	ret = ocfs2_extent_map_get_blocks(inode, v_blkno, &p_blkno, NULL,
-					  NULL);
+	ret = ocfs2_get_clusters(inode, cpos, phys, NULL, NULL);
 	if (ret < 0) {
 		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
-			    "at logical block %llu",
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
-			    (unsigned long long)v_blkno);
+			    "at logical cluster %u",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos);
 		goto out;
 	}
 
-	BUG_ON(p_blkno == 0);
+	BUG_ON(*phys == 0);
+
+	p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *phys);
+	if (!should_zero)
+		p_blkno += (user_pos >> inode->i_sb->s_blocksize_bits) & (u64)(bpc - 1);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		int tmpret;
@@ -1718,7 +1716,7 @@ static int ocfs2_write_cluster_by_desc(s
 		if ((cluster_off + local_len) > osb->s_clustersize)
 			local_len = osb->s_clustersize - cluster_off;
 
-		ret = ocfs2_write_cluster(mapping, desc->c_phys,
+		ret = ocfs2_write_cluster(mapping, &desc->c_phys,
 					  desc->c_new,
 					  desc->c_clear_unwritten,
 					  desc->c_needs_zero,
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch

