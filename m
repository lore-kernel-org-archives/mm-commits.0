From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:03:01 -0700
Message-ID: <573f7b85.TZkotymiq2xNynMs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec

Clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec
+++ a/fs/ocfs2/alloc.c
@@ -5351,7 +5351,7 @@ static int ocfs2_truncate_rec(handle_t *
 {
 	int ret;
 	u32 left_cpos, rec_range, trunc_range;
-	int wants_rotate = 0, is_rightmost_tree_rec = 0;
+	int is_rightmost_tree_rec = 0;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(et->et_ci);
 	struct ocfs2_path *left_path = NULL;
 	struct ocfs2_extent_list *el = path_leaf_el(path);
@@ -5457,7 +5457,6 @@ static int ocfs2_truncate_rec(handle_t *
 
 		memset(rec, 0, sizeof(*rec));
 		ocfs2_cleanup_merge(el, index);
-		wants_rotate = 1;
 
 		next_free = le16_to_cpu(el->l_next_free_rec);
 		if (is_rightmost_tree_rec && next_free > 1) {
_

Patches currently in -mm which might be from piaojun@huawei.com are


