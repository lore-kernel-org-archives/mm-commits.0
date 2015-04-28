From: akpm@linux-foundation.org
Subject: +
 extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch added to -mm tree
Date: Tue, 28 Apr 2015 14:38:35 -0700
Message-ID: <553ffddb.XZG2adwPyqwvZfGZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030960AbbD1Vig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 17:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: extend enough credits for freeing one truncate record while replaying truncate records
has been added to the -mm tree.  Its filename is
     extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

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
Subject: ocfs2: extend enough credits for freeing one truncate record while replaying truncate records

Now function ocfs2_replay_truncate_records() first modifies tl_used, then
calls ocfs2_extend_trans() to extend transactions for gd and alloc inode
used for freeing clusters.  jbd2_journal_restart() may be called and it
may happen that tl_used in truncate log is decreased but the clusters are
not freed, which means these clusters are lost.  So we should avoid
extending transactions in these two operations.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records
+++ a/fs/ocfs2/alloc.c
@@ -5975,16 +5975,6 @@ static int ocfs2_replay_truncate_records
 
 		ocfs2_journal_dirty(handle, tl_bh);
 
-		/* TODO: Perhaps we can calculate the bulk of the
-		 * credits up front rather than extending like
-		 * this. */
-		status = ocfs2_extend_trans(handle,
-					    OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
-
 		rec = tl->tl_recs[i];
 		start_blk = ocfs2_clusters_to_blocks(data_alloc_inode->i_sb,
 						    le32_to_cpu(rec.t_start));
@@ -6005,6 +5995,13 @@ static int ocfs2_replay_truncate_records
 				goto bail;
 			}
 		}
+
+		status = ocfs2_extend_trans(handle,
+				OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 		i--;
 	}
 
@@ -6063,7 +6060,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out_mutex;
 	}
 
-	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
+	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
 		mlog_errno(status);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-return-error-while-ocfs2_figure_merge_contig_type-failing.patch
ocfs2-remove-bug_onempty_extent-in-__ocfs2_rotate_tree_left.patch
ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
ocfs2-flush-inode-data-to-disk-and-free-inode-when-i_count-becomes-zero.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
ocfs2-do-not-set-fs-read-only-if-rec-is-empty-while-committing-truncate.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

