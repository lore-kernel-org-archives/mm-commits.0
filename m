From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:30 -0700
Message-ID: <55ef22b6.tnzumlCqoA8a3yWW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbbIHSCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add ip_alloc_sem in direct IO to protect allocation changes
has been removed from the -mm tree.  Its filename was
     ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ocfs2: add ip_alloc_sem in direct IO to protect allocation changes

In ocfs2, ip_alloc_sem is used to protect allocation changes on the node. 
In direct IO, we add ip_alloc_sem to protect date consistent between
direct-io and ocfs2_truncate_file race (buffer io use ip_alloc_sem
already).  Although inode->i_mutex lock is used to avoid concurrency of
above situation, i think ip_alloc_sem is still needed because protect
allocation changes is significant.

Other filesystem like ext4 also uses rw_semaphore to protect data
consistent between get_block-vs-truncate race by other means, So
ip_alloc_sem in ocfs2 direct io is needed.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes
+++ a/fs/ocfs2/aops.c
@@ -533,10 +533,14 @@ static int ocfs2_direct_IO_get_blocks(st
 
 	inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+
 	/* This figures out the size of the next contiguous block, and
 	 * our logical offset */
 	ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
 					  &contig_blocks, &ext_flags);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+
 	if (ret) {
 		mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
 		     (unsigned long long)iblock);
@@ -557,6 +561,8 @@ static int ocfs2_direct_IO_get_blocks(st
 
 		alloc_locked = 1;
 
+		down_write(&OCFS2_I(inode)->ip_alloc_sem);
+
 		/* fill hole, allocate blocks can't be larger than the size
 		 * of the hole */
 		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
@@ -569,6 +575,7 @@ static int ocfs2_direct_IO_get_blocks(st
 		ret = ocfs2_extend_allocation(inode, cpos,
 				clusters_to_alloc, 0);
 		if (ret < 0) {
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
 			mlog_errno(ret);
 			goto bail;
 		}
@@ -576,11 +583,13 @@ static int ocfs2_direct_IO_get_blocks(st
 		ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
 				&contig_blocks, &ext_flags);
 		if (ret < 0) {
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
 			mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
 					(unsigned long long)iblock);
 			ret = -EIO;
 			goto bail;
 		}
+		up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	}
 
 	/*
@@ -835,12 +844,17 @@ static ssize_t ocfs2_direct_IO_write(str
 
 		/* zeroing out the previously allocated cluster tail
 		 * that but not zeroed */
-		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)))
+		if (ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb))) {
+			down_read(&OCFS2_I(inode)->ip_alloc_sem);
 			ret = ocfs2_direct_IO_zero_extend(osb, inode, offset,
 					zero_len_tail, cluster_align_tail);
-		else
+			up_read(&OCFS2_I(inode)->ip_alloc_sem);
+		} else {
+			down_write(&OCFS2_I(inode)->ip_alloc_sem);
 			ret = ocfs2_direct_IO_extend_no_holes(osb, inode,
 					offset);
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
+		}
 		if (ret < 0) {
 			mlog_errno(ret);
 			ocfs2_inode_unlock(inode, 1);
_

Patches currently in -mm which might be from wangww631@huawei.com are


