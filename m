From: akpm@linux-foundation.org
Subject: - ext2-balloc-fix-off-by-one-against-rsv_end.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:47 -0800
Message-ID: <200703060114.l261Elbn007352@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXCFBPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:15:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: fix off-by-one against rsv_end
has been removed from the -mm tree.  Its filename was
     ext2-balloc-fix-off-by-one-against-rsv_end.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: fix off-by-one against rsv_end
From: Hugh Dickins <hugh@veritas.com>

rsv_end is the last block within the reservation, so alloc_new_reservation
should accept start_block == rsv_end as success.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/balloc.c~ext2-balloc-fix-off-by-one-against-rsv_end fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-fix-off-by-one-against-rsv_end
+++ a/fs/ext2/balloc.c
@@ -950,7 +950,7 @@ retry:
 	 * check if the first free block is within the
 	 * free space we just reserved
 	 */
-	if (start_block >= my_rsv->rsv_start && start_block < my_rsv->rsv_end)
+	if (start_block >= my_rsv->rsv_start && start_block <= my_rsv->rsv_end)
 		return 0;		/* success */
 	/*
 	 * if the first free bit we found is out of the reservable space
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
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
