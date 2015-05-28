From: akpm@linux-foundation.org
Subject: + ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch added to -mm tree
Date: Thu, 28 May 2015 14:13:32 -0700
Message-ID: <556784fc.IWJFUZMqvx85iy91%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbbE1VNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 17:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix wrong check in ocfs2_direct_IO_get_blocks
has been added to the -mm tree.  Its filename is
     ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix wrong check in ocfs2_direct_IO_get_blocks

contig_blocks gotten from ocfs2_extent_map_get_blocks cannot be compared
with clusters_to_alloc. So convert it to clusters first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |    8 +++++---
 fs/ocfs2/ocfs2.h |   10 ++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks
+++ a/fs/ocfs2/aops.c
@@ -523,7 +523,7 @@ static int ocfs2_direct_IO_get_blocks(st
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
 	unsigned long len = bh_result->b_size;
-	unsigned int clusters_to_alloc = 0;
+	unsigned int clusters_to_alloc = 0, contig_clusters = 0;
 
 	cpos = ocfs2_blocks_to_clusters(inode->i_sb, iblock);
 
@@ -560,8 +560,10 @@ static int ocfs2_direct_IO_get_blocks(st
 		/* fill hole, allocate blocks can't be larger than the size
 		 * of the hole */
 		clusters_to_alloc = ocfs2_clusters_for_bytes(inode->i_sb, len);
-		if (clusters_to_alloc > contig_blocks)
-			clusters_to_alloc = contig_blocks;
+		contig_clusters = ocfs2_clusters_for_blocks(inode->i_sb,
+				contig_blocks);
+		if (clusters_to_alloc > contig_clusters)
+			clusters_to_alloc = contig_clusters;
 
 		/* allocate extent and insert them into the extent tree */
 		ret = ocfs2_extend_allocation(inode, cpos,
diff -puN fs/ocfs2/ocfs2.h~ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks
+++ a/fs/ocfs2/ocfs2.h
@@ -717,6 +717,16 @@ static inline u64 ocfs2_clusters_to_bloc
 	return (u64)clusters << c_to_b_bits;
 }
 
+static inline u32 ocfs2_clusters_for_blocks(struct super_block *sb,
+		u64 blocks)
+{
+	int b_to_c_bits = OCFS2_SB(sb)->s_clustersize_bits -
+			sb->s_blocksize_bits;
+
+	blocks += (1 << b_to_c_bits) - 1;
+	return (u32)(blocks >> b_to_c_bits);
+}
+
 static inline u32 ocfs2_blocks_to_clusters(struct super_block *sb,
 					   u64 blocks)
 {
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

