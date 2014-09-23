From: akpm@linux-foundation.org
Subject: + ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch added to -mm tree
Date: Tue, 23 Sep 2014 15:15:20 -0700
Message-ID: <5421f0f8.CrrVo+0OKQ+L1kNY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbaIWWPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks
has been added to the -mm tree.  Its filename is
     ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch

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
Subject: ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks

Allocate blocks in ocfs2_direct_IO_get_blocks, so in append direct-io
write and fill holes write situation, direct-io write doesn't need
fallback to buffer I/O any more.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN fs/ocfs2/aops.c~ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks
+++ a/fs/ocfs2/aops.c
@@ -517,10 +517,17 @@ static int ocfs2_direct_IO_get_blocks(st
 				     struct buffer_head *bh_result, int create)
 {
 	int ret;
+	u32 cpos = 0;
+	int alloc_locked = 0;
 	u64 p_blkno, inode_blocks, contig_blocks;
 	unsigned int ext_flags;
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
+	unsigned long len = bh_result->b_size;
+	struct buffer_head *di_bh = NULL;
+	unsigned int clusters_to_alloc = 0;
+
+	cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);
 
 	/* This function won't even be called if the request isn't all
 	 * nicely aligned and of the right size, so there's no need
@@ -542,6 +549,39 @@ static int ocfs2_direct_IO_get_blocks(st
 	/* We should already CoW the refcounted extent in case of create. */
 	BUG_ON(create && (ext_flags & OCFS2_EXT_REFCOUNTED));
 
+	/* allocate blocks if no p_blkno is found, and create==1 */
+	if (!p_blkno && create) {
+		ret = ocfs2_inode_lock(inode, &di_bh, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto bail;
+		}
+		alloc_locked = 1;
+
+		/* fill hole, allocate blocks can't be larger than the size
+		 * of the hole */
+		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
+		if (clusters_to_alloc > contig_blocks)
+			clusters_to_alloc = contig_blocks;
+
+		/* allocate extent and insert them into the extent tree */
+		ret = __ocfs2_extend_allocation(inode, cpos,
+						clusters_to_alloc, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto bail;
+		}
+
+		ret = ocfs2_extent_map_get_blocks(inode, iblock, &p_blkno,
+					  &contig_blocks, &ext_flags);
+		if (ret) {
+			mlog(ML_ERROR, "get_blocks() failed iblock=%llu\n",
+			     (unsigned long long)iblock);
+			ret = -EIO;
+			goto bail;
+		}
+	}
+
 	/*
 	 * get_more_blocks() expects us to describe a hole by clearing
 	 * the mapped bit on bh_result().
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

