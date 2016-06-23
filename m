From: akpm@linux-foundation.org
Subject: + ocfs2-improve-recovery-performance.patch added to -mm tree
Date: Thu, 23 Jun 2016 15:12:59 -0700
Message-ID: <576c5eeb.QXainRSGHTGE6Bsv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcFWWNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jun 2016 18:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: improve recovery performance
has been added to the -mm tree.  Its filename is
     ocfs2-improve-recovery-performance.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-improve-recovery-performance.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-improve-recovery-performance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: improve recovery performance

Journal replay will be run when performing recovery for a dead node.  To
avoid the stale cache impact, all blocks of dead node's journal inode were
reloaded from disk.  This hurts the performance.  Check whether one block
is cached before reloading it can improve performance a lot.  In my test
env, the time doing recovery was improved from 120s to 1s.

Link: http://lkml.kernel.org/r/1466155682-24656-1-git-send-email-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: "Gang He" <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-improve-recovery-performance fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance
+++ a/fs/ocfs2/journal.c
@@ -1159,10 +1159,8 @@ static int ocfs2_force_read_journal(stru
 	int status = 0;
 	int i;
 	u64 v_blkno, p_blkno, p_blocks, num_blocks;
-#define CONCURRENT_JOURNAL_FILL 32ULL
-	struct buffer_head *bhs[CONCURRENT_JOURNAL_FILL];
-
-	memset(bhs, 0, sizeof(struct buffer_head *) * CONCURRENT_JOURNAL_FILL);
+	struct buffer_head *bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	num_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
 	v_blkno = 0;
@@ -1174,29 +1172,34 @@ static int ocfs2_force_read_journal(stru
 			goto bail;
 		}
 
-		if (p_blocks > CONCURRENT_JOURNAL_FILL)
-			p_blocks = CONCURRENT_JOURNAL_FILL;
-
-		/* We are reading journal data which should not
-		 * be put in the uptodate cache */
-		status = ocfs2_read_blocks_sync(OCFS2_SB(inode->i_sb),
-						p_blkno, p_blocks, bhs);
-		if (status < 0) {
-			mlog_errno(status);
-			goto bail;
-		}
+		for (i = 0; i < p_blocks; i++) {
+			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
+					osb->sb->s_blocksize);
+			/* block not cached. */
+			if (!bh) {
+				p_blkno++;
+				continue;
+			}
+
+			brelse(bh);
+			bh = NULL;
+			/* We are reading journal data which should not
+			 * be put in the uptodate cache.
+			 */
+			status = ocfs2_read_blocks_sync(osb, p_blkno, 1, &bh);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
 
-		for(i = 0; i < p_blocks; i++) {
-			brelse(bhs[i]);
-			bhs[i] = NULL;
+			brelse(bh);
+			bh = NULL;
 		}
 
 		v_blkno += p_blocks;
 	}
 
 bail:
-	for(i = 0; i < CONCURRENT_JOURNAL_FILL; i++)
-		brelse(bhs[i]);
 	return status;
 }
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-improve-recovery-performance.patch

