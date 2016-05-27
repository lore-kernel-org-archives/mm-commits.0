From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-remove-unnecessary-else-after-return-or-break.patch removed from -mm tree
Date: Fri, 27 May 2016 11:43:10 -0700
Message-ID: <5748953e.on8BX6epKtWyAwND%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbcE0SnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove unnecessary else after return or break
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-unnecessary-else-after-return-or-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove unnecessary else after return or break

This fixes the checkpatch.pl warning that suggests else is not
generally useful after a break or return.

Link: http://lkml.kernel.org/r/1462886671-3521-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c   |   12 ++++++------
 fs/nilfs2/direct.c  |    6 +++---
 fs/nilfs2/segment.c |   26 ++++++++++++--------------
 3 files changed, 21 insertions(+), 23 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-remove-unnecessary-else-after-return-or-break fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-remove-unnecessary-else-after-return-or-break
+++ a/fs/nilfs2/btree.c
@@ -1029,12 +1029,12 @@ static __u64 nilfs_btree_find_target_v(c
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
-	else {
-		ptr = nilfs_btree_find_near(btree, path);
-		if (ptr != NILFS_BMAP_INVALID_PTR)
-			/* near */
-			return ptr;
-	}
+
+	ptr = nilfs_btree_find_near(btree, path);
+	if (ptr != NILFS_BMAP_INVALID_PTR)
+		/* near */
+		return ptr;
+
 	/* block group */
 	return nilfs_bmap_find_target_in_group(btree);
 }
diff -puN fs/nilfs2/direct.c~nilfs2-remove-unnecessary-else-after-return-or-break fs/nilfs2/direct.c
--- a/fs/nilfs2/direct.c~nilfs2-remove-unnecessary-else-after-return-or-break
+++ a/fs/nilfs2/direct.c
@@ -107,9 +107,9 @@ nilfs_direct_find_target_v(const struct
 	if (ptr != NILFS_BMAP_INVALID_PTR)
 		/* sequential access */
 		return ptr;
-	else
-		/* block group */
-		return nilfs_bmap_find_target_in_group(direct);
+
+	/* block group */
+	return nilfs_bmap_find_target_in_group(direct);
 }
 
 static int nilfs_direct_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
diff -puN fs/nilfs2/segment.c~nilfs2-remove-unnecessary-else-after-return-or-break fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-remove-unnecessary-else-after-return-or-break
+++ a/fs/nilfs2/segment.c
@@ -150,17 +150,15 @@ static int nilfs_prepare_segment_lock(st
 	if (cur_ti) {
 		if (cur_ti->ti_magic == NILFS_TI_MAGIC)
 			return ++cur_ti->ti_count;
-		else {
-			/*
-			 * If journal_info field is occupied by other FS,
-			 * it is saved and will be restored on
-			 * nilfs_transaction_commit().
-			 */
-			printk(KERN_WARNING
-			       "NILFS warning: journal info from a different "
-			       "FS\n");
-			save = current->journal_info;
-		}
+
+		/*
+		 * If journal_info field is occupied by other FS,
+		 * it is saved and will be restored on
+		 * nilfs_transaction_commit().
+		 */
+		printk(KERN_WARNING
+		       "NILFS warning: journal info from a different FS\n");
+		save = current->journal_info;
 	}
 	if (!ti) {
 		ti = kmem_cache_alloc(nilfs_transaction_cachep, GFP_NOFS);
@@ -2552,10 +2550,10 @@ static int nilfs_segctor_thread(void *ar
 
 		if (timeout || sci->sc_seq_request != sci->sc_seq_done)
 			mode = SC_LSEG_SR;
-		else if (!sci->sc_flush_request)
-			break;
-		else
+		else if (sci->sc_flush_request)
 			mode = nilfs_segctor_flush_mode(sci);
+		else
+			break;
 
 		spin_unlock(&sci->sc_state_lock);
 		nilfs_segctor_thread_construct(sci, mode);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


