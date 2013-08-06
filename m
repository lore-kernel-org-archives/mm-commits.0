From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch added to
 -mm tree
Date: Tue, 06 Aug 2013 14:27:10 -0700
Message-ID: <52016a2e.J4+hyF+Q9c0BvrGj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3HFV1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 17:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, younger.liu@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: + ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch added to -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,younger.liu@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 14:27:10 -0700


The patch titled
     Subject: ocfs2: fix a memory leak in __ocfs2_move_extents()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch

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
Subject: ocfs2: fix a memory leak in __ocfs2_move_extents()

The ocfs2 path is not properly freed which leads to a memory leak at
__ocfs2_move_extents().

This patch stops the leaks of the ocfs2_path structure.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Younger Liu <younger.liu@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -152,6 +152,7 @@ static int __ocfs2_move_extent(handle_t
 	}
 
 out:
+	ocfs2_free_path(path);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-using-i_size_read-to-access-i_size.patch
ocfs2-dlm_request_all_locks-should-deal-with-the-status-sent-from-target-node.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

