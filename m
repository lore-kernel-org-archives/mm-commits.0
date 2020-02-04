From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 03 Feb 2020 17:49:22 -0800
Message-ID: <20200204014922.5PqGwiZ-k%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgBDBtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:49:24 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/data.c                  |   13 -------------
 fs/jbd2/journal.c               |    3 ---
 fs/xfs/libxfs/xfs_attr_remote.c |   15 ---------------
 init/main.c                     |   10 ----------
 4 files changed, 41 deletions(-)

--- a/fs/f2fs/data.c~linux-next-git-rejects
+++ a/fs/f2fs/data.c
@@ -2815,7 +2815,6 @@ readd:
 					done = 1;
 					break;
 				}
-<<<<<<< HEAD
 
 				if (!f2fs_cluster_can_merge_page(&cc,
 								page->index)) {
@@ -2826,18 +2825,6 @@ readd:
 					goto result;
 				}
 
-=======
-
-				if (!f2fs_cluster_can_merge_page(&cc,
-								page->index)) {
-					ret = f2fs_write_multi_pages(&cc,
-						&submitted, wbc, io_type);
-					if (!ret)
-						need_readd = true;
-					goto result;
-				}
-
->>>>>>> linux-next/akpm-base
 				if (unlikely(f2fs_cp_error(sbi)))
 					goto lock_page;
 
--- a/fs/jbd2/journal.c~linux-next-git-rejects
+++ a/fs/jbd2/journal.c
@@ -806,12 +806,9 @@ int jbd2_journal_bmap(journal_t *journal
 			       __func__, blocknr, journal->j_devname);
 			err = -EIO;
 			jbd2_journal_abort(journal, err);
-<<<<<<< HEAD
-=======
 
 		} else {
 			*retp = block;
->>>>>>> linux-next/akpm-base
 		}
 
 	} else {
--- a/fs/xfs/libxfs/xfs_attr_remote.c~linux-next-git-rejects
+++ a/fs/xfs/libxfs/xfs_attr_remote.c
@@ -418,24 +418,9 @@ xfs_attr_rmtval_get(
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-<<<<<<< HEAD
-			bp = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt, 0,
-					&xfs_attr3_rmt_buf_ops);
-			if (!bp)
-				return -ENOMEM;
-			error = bp->b_error;
-			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
-				xfs_buf_relse(bp);
-
-				/* bad CRC means corrupted metadata */
-				if (error == -EFSBADCRC)
-					error = -EFSCORRUPTED;
-=======
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
 			if (error)
->>>>>>> linux-next/akpm-base
 				return error;
 			}
 
--- a/init/main.c~linux-next-git-rejects
+++ a/init/main.c
@@ -1161,17 +1161,7 @@ static const char *initcall_level_names[
 	"late",
 };
 
-<<<<<<< HEAD
-static int __init ignore_unknown_bootoption(char *param, char *val,
-			       const char *unused, void *arg)
-{
-	return 0;
-}
