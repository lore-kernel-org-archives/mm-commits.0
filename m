From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:40 -0700
Message-ID: <520bdc0c.pLOp0kNCJf0I7kxO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab3HNTfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:40 -0700


The patch titled
     Subject: ocfs2: Revert 40bd62e to avoid regression in extended allocation
has been removed from the -mm tree.  Its filename was
     ocfs2-revert-commit-40bd62e-to-avoid-regression-in-extended-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

