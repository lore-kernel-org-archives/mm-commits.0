From: akpm@linux-foundation.org
Subject: - ext2-balloc-fix-_with_rsv-freeze.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:33 -0800
Message-ID: <200703060114.l261EYRl007326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbXCFBSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: fix _with_rsv freeze
has been removed from the -mm tree.  Its filename was
     ext2-balloc-fix-_with_rsv-freeze.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: fix _with_rsv freeze
From: Hugh Dickins <hugh@veritas.com>

After several days of testing ext2 with reservations, it got caught inside
ext2_try_to_allocate_with_rsv: alloc_new_reservation repeatedly succeeding on
the window [12cff,12d0e], ext2_try_to_allocate repeatedly failing to find the
free block guaranteed to be included (unless there's contention).

Fix the range to find_next_usable_block's memscan: the scan from "here"
(0xcfe) up to (but excluding) "maxblocks" (0xd0e) needs to scan 3 bytes not 2
(the relevant bytes of bitmap in this case being f7 df ff - none 00, but the
premature cutoff implying that the last was found 00).

Is this a problem for mainline ext2?  No, because the "size" in its memscan is
always EXT2_BLOCKS_PER_GROUP(sb), which mkfs.ext2 requires to be a multiple of
8.  Is this a problem for ext3 or ext4?  No, because they have an additional
extN_test_allocatable test which rescues them from the error.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/balloc.c~ext2-balloc-fix-_with_rsv-freeze fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-fix-_with_rsv-freeze
+++ a/fs/ext2/balloc.c
@@ -570,7 +570,7 @@ find_next_usable_block(int start, struct
 		here = 0;
 
 	p = ((char *)bh->b_data) + (here >> 3);
-	r = memscan(p, 0, (maxblocks - here + 7) >> 3);
+	r = memscan(p, 0, ((maxblocks + 7) >> 3) - (here >> 3));
 	next = (r - ((char *)bh->b_data)) << 3;
 
 	if (next < maxblocks && next >= here)
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
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
