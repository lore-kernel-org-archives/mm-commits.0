From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-improve-recovery-performance-v2-fix.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 14:47:42 -0700
Message-ID: <5797da7e.F1S07KcmM3QRqFu4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbcGZVrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-improve-recovery-performance-v2-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-improve-recovery-performance-v2-fix.patch

This patch was dropped because it was folded into ocfs2-improve-recovery-performance.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-improve-recovery-performance-v2-fix

clean up the for loop p_blkno handling

Cc: "Gang He" <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2-fix
+++ a/fs/ocfs2/journal.c
@@ -1172,14 +1172,12 @@ static int ocfs2_force_read_journal(stru
 			goto bail;
 		}
 
-		for (i = 0; i < p_blocks; i++) {
+		for (i = 0; i < p_blocks; i++, p_blkno++) {
 			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
-			if (!bh) {
-				p_blkno++;
+			if (!bh)
 				continue;
-			}
 
 			brelse(bh);
 			bh = NULL;
@@ -1194,7 +1192,6 @@ static int ocfs2_force_read_journal(stru
 
 			brelse(bh);
 			bh = NULL;
-			p_blkno++;
 		}
 
 		v_blkno += p_blocks;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-improve-recovery-performance.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch

