From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:45 -0700
Message-ID: <5591ac5d.dfh6eUdrpSOwNqDy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbF2Ugq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix NULL pointer dereference in function ocfs2_abort_trigger()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: fix NULL pointer dereference in function ocfs2_abort_trigger()

ocfs2_abort_trigger() use bh->b_assoc_map to get sb.  But there's no
function to set bh->b_assoc_map in ocfs2, it will trigger NULL pointer
dereference while calling this function.  We can get sb from
bh->b_bdev->bd_super instead of b_assoc_map.

[akpm@linux-foundation.org: update comment, per Joseph]
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger
+++ a/fs/ocfs2/journal.c
@@ -571,9 +571,7 @@ static void ocfs2_abort_trigger(struct j
 	     (unsigned long)bh,
 	     (unsigned long long)bh->b_blocknr);
 
-	/* We aren't guaranteed to have the superblock here - but if we
-	 * don't, it'll just crash. */
-	ocfs2_error(bh->b_assoc_map->host->i_sb,
+	ocfs2_error(bh->b_bdev->bd_super,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

