From: akpm@linux-foundation.org
Subject: +
 ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch added to -mm tree
Date: Thu, 08 Aug 2013 15:28:54 -0700
Message-ID: <52041ba6.CRFSEDS7p20PtxYM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab3HHW2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:28:54 -0700


The patch titled
     Subject: ocfs2: Revert 40bd62e to avoid regression in extended allocation
has been added to the -mm tree.  Its filename is
     ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch

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
Subject: ocfs2: Revert 40bd62e to avoid regression in extended allocation

Revert 40bd62eb7fb844 ("fs/ocfs2/journal.h: add bits_wanted while
calculating credits in ocfs2_calc_extend_credits").

Unfortunately this change broke fallocate even if there is insufficient
disk space for the preallocation, which is a serious problem.

# df -h
/dev/sda8        22G  1.2G   21G   6% /ocfs2
# fallocate -o 0 -l 200M /ocfs2/testfile
fallocate: /ocfs2/test: fallocate failed: No space left on device

CPU: 3 PID: 3656 Comm: fallocate Tainted: G        W  O 3.11.0-rc3 #2
Call Trace:
[<ffffffff81a5fea7>] dump_stack+0x77/0x9e
[<ffffffff81093504>] warn_slowpath_common+0xc4/0x110
[<ffffffff8109357a>] warn_slowpath_null+0x2a/0x40
[<ffffffffa00ad9dc>] start_this_handle+0x6c/0x640 [jbd2]
[<ffffffff81150f9d>] ? __module_address+0x1ad/0x270
[<ffffffff81155cee>] ? is_module_address+0x1e/0x40
[<ffffffff81135875>] ? static_obj+0x65/0xb0
[<ffffffff8113f6f7>] ? lockdep_init_map+0x147/0x280
[<ffffffffa00ae398>] jbd2__journal_start+0x138/0x300 [jbd2]
[<ffffffffa00ae583>] jbd2_journal_start+0x23/0x30 [jbd2]
[<ffffffffa0997726>] ocfs2_start_trans+0x166/0x300 [ocfs2]
[<ffffffff81022426>] ? show_stack+0x66/0x70
[<ffffffffa0985c4f>] __ocfs2_extend_allocation+0x38f/0xdb0 [ocfs2]
[<ffffffffa097e414>] ? ocfs2_get_clusters_nocache.isra.11+0x234/0x5b0
[<ffffffffa098fb53>] ? ocfs2_read_inode_block_full+0x43/0x80 [ocfs2]
[<ffffffffa0997d00>] ? ocfs2_extend_trans+0x2c0/0x2c0 [ocfs2]
[<ffffffffa098710e>] ? __ocfs2_change_file_space+0x57e/0xa60 [ocfs2]
[<ffffffffa0986a39>] ocfs2_allocate_unwritten_extents+0x3c9/0x520
[<ffffffff81a6e828>] ? down_write+0x108/0x120
[<ffffffffa0987170>] __ocfs2_change_file_space+0x5e0/0xa60 [ocfs2]
[<ffffffff812bd1ad>] ? do_fallocate+0x1ad/0x220
[<ffffffffa09876a1>] ocfs2_fallocate+0xb1/0xe0 [ocfs2]
[<ffffffff812bd1cb>] do_fallocate+0x1cb/0x220
[<ffffffff812bd28f>] SyS_fallocate+0x6f/0xb0
[<ffffffff81a83419>] system_call_fastpath+0x16/0x1b
---[ end trace 474a79e9fc2db862 ]---
[ 1683.855972] JBD2: fallocate wants too many credits (51216 > 4381)

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.h~ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation
+++ a/fs/ocfs2/journal.h
@@ -537,7 +537,7 @@ static inline int ocfs2_calc_extend_cred
 	extent_blocks = 1 + 1 + le16_to_cpu(root_el->l_tree_depth);
 
 	return bitmap_blocks + sysfile_bitmap_blocks + extent_blocks +
-	       ocfs2_quota_trans_credits(sb) + bits_wanted;
+	       ocfs2_quota_trans_credits(sb);
 }
 
 static inline int ocfs2_calc_symlink_credits(struct super_block *sb)
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch
ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch
ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-using-i_size_read-to-access-i_size.patch
ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each-fix.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
ocfs2-add-the-missing-return-value-check-of-ocfs2_xattr_get_clusters.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-dlm-force-clean-refmap-when-doing-local-cleanup.patch
ocfs2-fix-possible-double-free-in-ocfs2_reflink_xattr_rec.patch
ocfs2-free-path-in-ocfs2_remove_inode_range.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

