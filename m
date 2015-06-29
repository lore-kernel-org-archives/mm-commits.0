From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:36:37 -0700
Message-ID: <5591ac55.WI415S0SP2jbZFpP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbbF2Ugi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove BUG_ON(!empty_extent) in __ocfs2_rotate_tree_left()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: remove BUG_ON(!empty_extent) in __ocfs2_rotate_tree_left()

ocfs2_rotate_tree_left() calls __ocfs2_rotate_tree_left() for left
rotation while non-rightmost path containing an empty extent in the leaf
block.  __ocfs2_rotate_tree_left() returns -EAGAIN if right subtree having an
empty extent and pass the empty_extent_path to caller.  The caller
ocfs2_rotate_tree_left() will restart rotation from the returned path.

It will trigger the BUG_ON(!ocfs2_is_empty_extent) when the et on disk
is as follows:

eb0 is the leaf block of path(say path_a) passed to
ocfs2_rotate_tree_left, which has an empty rec[0].

eb1 is the leaf block of path(say path_b) that just right to path_a, which
has no empty record.

eb2 is the leaf block of path(say path_c) that just right to path_b, which
has an empty rec[0].  And path_c is also the rightmost path.

Now we want to remove the empty rec[0] in eb0:

ocfs2_rotate_tree_left:
  -> call __ocfs2_rotate_tree_left with path_a as its input *path*
    -> call ocfs2_rotate_subtree_left with path_a as its input
       *left_path* and path_b as its input *right_path*. it will move
       rec[0] in eb1 to eb0, and rec[0] in eb0 is not empty now.
    -> continue to call ocfs2_rotate_subtree_left with path_b as its
       input *left_path* and path_c as its input *right_path*, and
       return -EAGAIN because eb2 has an empty rec[0]
  -> call __ocfs2_rotate_tree_left with path_c as it input, rotate all
     records in eb2 to left and return 0.
  -> call __ocfs2_rotate_tree_left with path_a as its input, and triggers
     the BUG_ON(!ocfs2_is_empty_extent) as the rec[0] in eb0 is not empty.

So the BUG_ON() should be removed and return 0 if rec[0] is no longer an
empty extent.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left
+++ a/fs/ocfs2/alloc.c
@@ -2925,7 +2925,8 @@ static int __ocfs2_rotate_tree_left(hand
 	struct ocfs2_path *right_path = NULL;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 
-	BUG_ON(!ocfs2_is_empty_extent(&(path_leaf_el(path)->l_recs[0])));
+	if (!ocfs2_is_empty_extent(&(path_leaf_el(path)->l_recs[0])))
+		return 0;
 
 	*empty_extent_path = NULL;
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

