From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:53 -0800
Message-ID: <52e02609.mdtwtUISIDhEB8Ih%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaAVULy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:53 -0800


The patch titled
     Subject: ocfs2: return EINVAL if the given range to discard is less than block size
has been removed from the -mm tree.  Its filename was
     ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: return EINVAL if the given range to discard is less than block size

For FITRIM ioctl(2), we should not keep silence if the given range length
ls less than a block size as there is no data blocks would be discareded. 
Hence it should return EINVAL instead.  This issue can be verified via
xfstests/generic/288 which is used for FITRIM argument handling tests.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size
+++ a/fs/ocfs2/alloc.c
@@ -7260,14 +7260,8 @@ int ocfs2_trim_fs(struct super_block *sb
 	start = range->start >> osb->s_clustersize_bits;
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
-	trimmed = 0;
-
-	if (!len) {
-		range->len = 0;
-		return 0;
-	}
 
-	if (minlen >= osb->bitmap_cpg)
+	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
 		return -EINVAL;
 
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
@@ -7293,6 +7287,7 @@ int ocfs2_trim_fs(struct super_block *sb
 		goto out_unlock;
 	}
 
+	len = range->len >> osb->s_clustersize_bits;
 	if (start + len > le32_to_cpu(main_bm->i_clusters))
 		len = le32_to_cpu(main_bm->i_clusters) - start;
 
@@ -7307,6 +7302,7 @@ int ocfs2_trim_fs(struct super_block *sb
 	last_group = ocfs2_which_cluster_group(main_bm_inode, start + len - 1);
 	last_bit = osb->bitmap_cpg;
 
+	trimmed = 0;
 	for (group = first_group; group <= last_group;) {
 		if (first_bit + len >= osb->bitmap_cpg)
 			last_bit = osb->bitmap_cpg;
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

