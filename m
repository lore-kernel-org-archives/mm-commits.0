From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
 added to -mm tree
Date: Fri, 22 May 2015 12:27:07 -0700
Message-ID: <555f830b.Zqr+zyPOh9YFvASi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbbEVT1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix NULL pointer dereference in function ocfs2_abort_trigger()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix NULL pointer dereference in function ocfs2_abort_trigger()

ocfs2_abort_trigger() use bh->b_assoc_map to get sb.  But there's no
function to set bh->b_assoc_map in ocfs2, it will trigger NULL pointer
dereference while calling this function.  We can get sb from
bh->b_bdev->bd_super instead of b_assoc_map.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger
+++ a/fs/ocfs2/journal.c
@@ -573,7 +573,7 @@ static void ocfs2_abort_trigger(struct j
 
 	/* We aren't guaranteed to have the superblock here - but if we
 	 * don't, it'll just crash. */
-	ocfs2_error(bh->b_assoc_map->host->i_sb,
+	ocfs2_error(bh->b_bdev->bd_super,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch
ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

