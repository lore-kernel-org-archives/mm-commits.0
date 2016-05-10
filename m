From: akpm@linux-foundation.org
Subject: + nilfs2-remove-unnecessary-else-after-return-or-break.patch
 added to -mm tree
Date: Tue, 10 May 2016 12:23:49 -0700
Message-ID: <57323545.tJDaockWNiHza44y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEJTXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove unnecessary else after return or break
has been added to the -mm tree.  Its filename is
     nilfs2-remove-unnecessary-else-after-return-or-break.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-unnecessary-else-after-return-or-break.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-unnecessary-else-after-return-or-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-fix-white-space-issue-in-nilfs_mount.patch
nilfs2-remove-space-before-comma.patch
nilfs2-remove-fsf-mailing-address-from-gpl-notices.patch
nilfs2-clean-up-old-e-mail-addresses.patch
maintainers-add-web-link-for-nilfs-project.patch
nilfs2-clarify-permission-to-replicate-the-design.patch
nilfs2-get-rid-of-nilfs_mdt_mark_block_dirty.patch
nilfs2-move-cleanup-code-of-metadata-file-from-inode-routines.patch
nilfs2-replace-__attribute__packed-with-__packed.patch
nilfs2-add-missing-line-spacing.patch
nilfs2-clean-trailing-semicolons-in-macros.patch
nilfs2-clean-trailing-semicolons-in-macros-fix.patch
nilfs2-do-not-emit-extra-newline-on-nilfs_warning-and-nilfs_error.patch
nilfs2-remove-space-before-semicolon.patch
nilfs2-fix-code-indent-coding-style-issue.patch
nilfs2-avoid-bare-use-of-unsigned.patch
nilfs2-remove-unnecessary-else-after-return-or-break.patch
nilfs2-remove-loops-of-single-statement-macros.patch
nilfs2-fix-block-comments.patch

