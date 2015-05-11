From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch
 added to -mm tree
Date: Mon, 11 May 2015 15:37:51 -0700
Message-ID: <55512f3f.VWymjAwMw01qkb20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbEKWhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 May 2015 18:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add ip_alloc_sem in direct IO to protect allocation changes
has been added to the -mm tree.  Its filename is
     ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mfasheh@suse.com>
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
@@ -567,6 +573,7 @@ static int ocfs2_direct_IO_get_blocks(st
 		ret = ocfs2_extend_allocation(inode, cpos,
 				clusters_to_alloc, 0);
 		if (ret < 0) {
+			up_write(&OCFS2_I(inode)->ip_alloc_sem);
 			mlog_errno(ret);
 			goto bail;
 		}
@@ -574,11 +581,13 @@ static int ocfs2_direct_IO_get_blocks(st
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
@@ -833,12 +842,17 @@ static ssize_t ocfs2_direct_IO_write(str
 
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

ocfs2-add-ip_alloc_sem-in-direct-io-to-protect-allocation-changes.patch

