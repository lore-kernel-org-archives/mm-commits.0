From: akpm@linux-foundation.org
Subject: +
 ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch added to -mm tree
Date: Tue, 10 Dec 2013 16:18:04 -0800
Message-ID: <52a7af3c.TSI1Wwy3LyUEaGUz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3LKASF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 19:18:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 16:18:04 -0800


The patch titled
     Subject: ocfs2: return EINVAL if the given range to discard is less than block size
has been added to the -mm tree.  Its filename is
     ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7292,14 +7292,8 @@ int ocfs2_trim_fs(struct super_block *sb
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
@@ -7325,6 +7319,7 @@ int ocfs2_trim_fs(struct super_block *sb
 		goto out_unlock;
 	}
 
+	len = range->len >> osb->s_clustersize_bits;
 	if (start + len > le32_to_cpu(main_bm->i_clusters))
 		len = le32_to_cpu(main_bm->i_clusters) - start;
 
@@ -7339,6 +7334,7 @@ int ocfs2_trim_fs(struct super_block *sb
 	last_group = ocfs2_which_cluster_group(main_bm_inode, start + len - 1);
 	last_bit = osb->bitmap_cpg;
 
+	trimmed = 0;
 	for (group = first_group; group <= last_group;) {
 		if (first_bit + len >= osb->bitmap_cpg)
 			last_bit = osb->bitmap_cpg;
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

ocfs2-return-eopnotsupp-if-the-device-does-not-support-discard.patch
ocfs2-return-einval-if-the-given-range-to-discard-is-less-than-block-size.patch
ocfs2-adjust-minlen-with-discard_granularity-in-the-fitrim-ioctl.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

