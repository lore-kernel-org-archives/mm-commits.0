From: akpm@linux-foundation.org
Subject: +
 ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch
 added to -mm tree
Date: Fri, 25 Mar 2016 12:35:53 -0700
Message-ID: <56f59319.HRE35poM0y9G4S/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcCYTfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 15:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up an unused variable 'wants_rotate' in ocfs2_truncate_rec
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-clean-up-an-unused-variable-wants_rotate-in-ocfs2_truncate_rec.patch

