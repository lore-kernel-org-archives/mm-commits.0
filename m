From: akpm@linux-foundation.org
Subject: + ocfs2-fix-the-end-cluster-offset-of-fiemap.patch added to -mm
 tree
Date: Thu, 29 Aug 2013 13:37:47 -0700
Message-ID: <521fb11b.7XB2ixYorBp4GqdV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3H2Uhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 16:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, sunil.mushran@gmail.com, stable@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-fix-the-end-cluster-offset-of-fiemap.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,stable@vger.kernel.org,sunil.mushran@gmail.com,wb@munzinger.de
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 13:37:47 -0700


The patch titled
     Subject: ocfs2: fix the end cluster offset of FIEMAP
has been added to the -mm tree.  Its filename is
     ocfs2-fix-the-end-cluster-offset-of-fiemap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-the-end-cluster-offset-of-fiemap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-the-end-cluster-offset-of-fiemap.patch

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
Subject: ocfs2: fix the end cluster offset of FIEMAP

Call fiemap ioctl(2) with given start offset as well as an desired mapping
range should show extents if possible.  However, we somehow figure out the
end offset of mapping via 'mapping_end -= cpos' before iterating the
extent records which would cause problems if the given fiemap length is
too small to a cluster size, e.g,

Cluster size 4096:
debugfs.ocfs2 1.6.3
        Block Size Bits: 12   Cluster Size Bits: 12

The extended fiemap test utility From David:
https://gist.github.com/anonymous/6172331

# dd if=/dev/urandom of=/ocfs2/test_file bs=1M count=1000
# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 0 extents:
#	Logical          Physical         Length           Flags
	^^^^^ <-- No extent is shown

In this case, at ocfs2_fiemap(): cpos == mapping_end == 1. Hence the
loop of searching extent records was not executed at all.

This patch remove the in question 'mapping_end -= cpos', and loops
until the cpos is larger than the mapping_end as usual.

# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000056a01000 0000000006a00000 0000

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reported-by: David Weber <wb@munzinger.de>
Tested-by: David Weber <wb@munzinger.de>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fashen <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/extent_map.c~ocfs2-fix-the-end-cluster-offset-of-fiemap fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-fix-the-end-cluster-offset-of-fiemap
+++ a/fs/ocfs2/extent_map.c
@@ -781,7 +781,6 @@ int ocfs2_fiemap(struct inode *inode, st
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-using-i_size_read-to-access-i_size.patch
ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch
ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch
ocfs2-free-path-in-ocfs2_remove_inode_range.patch
ocfs2-fix-the-end-cluster-offset-of-fiemap.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch

