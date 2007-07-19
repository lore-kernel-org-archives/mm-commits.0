From: akpm@linux-foundation.org
Subject: - remove-nid_lock-from-alloc_fresh_huge_page.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:15 -0700
Message-ID: <200707192004.l6JK4FvW019933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759993AbXGSUQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     Remove nid_lock from alloc_fresh_huge_page
has been removed from the -mm tree.  Its filename was
     remove-nid_lock-from-alloc_fresh_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove nid_lock from alloc_fresh_huge_page
From: Hugh Dickins <hugh@veritas.com>

The fix to that race in alloc_fresh_huge_page() which could give an illegal
node ID did not need nid_lock at all: the fix was to replace static int nid
by static int prev_nid and do the work on local int nid.  nid_lock did make
sure that racers strictly roundrobin the nodes, but that's not something we
need to enforce strictly.  Kill nid_lock.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~remove-nid_lock-from-alloc_fresh_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~remove-nid_lock-from-alloc_fresh_huge_page
+++ a/mm/hugetlb.c
@@ -104,15 +104,19 @@ static int alloc_fresh_huge_page(void)
 {
 	static int prev_nid;
 	struct page *page;
-	static DEFINE_SPINLOCK(nid_lock);
 	int nid;
 
-	spin_lock(&nid_lock);
+	/*
+	 * Copy static prev_nid to local nid, work on that, then copy it
+	 * back to prev_nid afterwards: otherwise there's a window in which
+	 * a racer might pass invalid nid MAX_NUMNODES to alloc_pages_node.
+	 * But we don't need to use a spin_lock here: it really doesn't
+	 * matter if occasionally a racer chooses the same nid as we do.
+	 */
 	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
 	prev_nid = nid;
-	spin_unlock(&nid_lock);
 
 	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch
