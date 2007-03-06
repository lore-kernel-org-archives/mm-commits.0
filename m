From: akpm@linux-foundation.org
Subject: - ext2-balloc-reset-windowsz-when-full.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:41 -0800
Message-ID: <200703060114.l261Ef92007330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbXCFBSL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: reset windowsz when full
has been removed from the -mm tree.  Its filename was
     ext2-balloc-reset-windowsz-when-full.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: reset windowsz when full
From: Hugh Dickins <hugh@veritas.com>

ext2_new_blocks should reset the reservation window size to 0 when squeezing
the last blocks out of an almost full filesystem, so the retry doesn't skip
any groups with less than half that free, reporting ENOSPC too soon.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/ext2/balloc.c~ext2-balloc-reset-windowsz-when-full fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-reset-windowsz-when-full
+++ a/fs/ext2/balloc.c
@@ -1292,6 +1292,7 @@ retry_alloc:
 	 */
 	if (my_rsv) {
 		my_rsv = NULL;
+		windowsz = 0;
 		group_no = goal_group;
 		goto retry_alloc;
 	}
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
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
