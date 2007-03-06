From: akpm@linux-foundation.org
Subject: - ext2-balloc-say-rb_entry-not-list_entry.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:14:58 -0800
Message-ID: <200703060114.l261EwsV007366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXCFBPR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:15:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, cmm@us.ibm.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     ext2 balloc: say rb_entry not list_entry
has been removed from the -mm tree.  Its filename was
     ext2-balloc-say-rb_entry-not-list_entry.patch

This patch was dropped because it was folded into ext2-reservations.patch

------------------------------------------------------
Subject: ext2 balloc: say rb_entry not list_entry
From: Hugh Dickins <hugh@veritas.com>

The reservations tree is an rb_tree not a list, so it's less confusing to use
rb_entry() than list_entry() - though they're both just container_of().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/balloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-balloc-say-rb_entry-not-list_entry fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-balloc-say-rb_entry-not-list_entry
+++ a/fs/ext2/balloc.c
@@ -156,7 +156,7 @@ restart:
 
 	printk("Block Allocation Reservation Windows Map (%s):\n", fn);
 	while (n) {
-		rsv = list_entry(n, struct ext2_reserve_window_node, rsv_node);
+		rsv = rb_entry(n, struct ext2_reserve_window_node, rsv_node);
 		if (verbose)
 			printk("reservation window 0x%p "
 				"start: %lu, end: %lu\n",
@@ -753,7 +753,7 @@ static int find_next_reservable_window(
 
 		prev = rsv;
 		next = rb_next(&rsv->rsv_node);
-		rsv = list_entry(next,struct ext2_reserve_window_node,rsv_node);
+		rsv = rb_entry(next,struct ext2_reserve_window_node,rsv_node);
 
 		/*
 		 * Reached the last reservation, we can just append to the
@@ -995,7 +995,7 @@ static void try_to_extend_reservation(st
 	if (!next)
 		my_rsv->rsv_end += size;
 	else {
-		next_rsv = list_entry(next, struct ext2_reserve_window_node, rsv_node);
+		next_rsv = rb_entry(next, struct ext2_reserve_window_node, rsv_node);
 
 		if ((next_rsv->rsv_start - my_rsv->rsv_end - 1) >= size)
 			my_rsv->rsv_end += size;
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
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
