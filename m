From: akpm@linux-foundation.org
Subject: - ext2-balloc-fix-off-by-one-against-grp_goal.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:53 -0800
Message-ID: <200703060114.l261Er2i007363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757AbXCFBS0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: fix off-by-one against grp_goal
has been removed from the -mm tree.  Its filename was
     ext2-balloc-fix-off-by-one-against-grp_goal.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: fix off-by-one against grp_goal
From: Hugh Dickins <hugh@veritas.com>

grp_goal 0 is a genuine goal (unlike -1), so ext2_try_to_allocate_with_rsv
should treat it as such.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-balloc-fix-off-by-one-against-grp_goal fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-fix-off-by-one-against-grp_goal
+++ a/fs/ext2/balloc.c
@@ -1053,7 +1053,7 @@ ext2_try_to_allocate_with_rsv(struct sup
 	}
 	/*
 	 * grp_goal is a group relative block number (if there is a goal)
-	 * 0 < grp_goal < EXT2_BLOCKS_PER_GROUP(sb)
+	 * 0 <= grp_goal < EXT2_BLOCKS_PER_GROUP(sb)
 	 * first block is a filesystem wide block number
 	 * first block is the block number of the first block in this group
 	 */
@@ -1089,7 +1089,7 @@ ext2_try_to_allocate_with_rsv(struct sup
 			if (!goal_in_my_reservation(&my_rsv->rsv_window,
 							grp_goal, group, sb))
 				grp_goal = -1;
-		} else if (grp_goal > 0) {
+		} else if (grp_goal >= 0) {
 			int curr = my_rsv->rsv_end -
 					(grp_goal + group_first_block) + 1;
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
free-swap-space-of-reactivated-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
ext2-reservations.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
