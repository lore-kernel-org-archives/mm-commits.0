From: akpm@linux-foundation.org
Subject: + remove-nid_lock-from-alloc_fresh_huge_page.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:04:09 -0700
Message-ID: <200707180004.l6I049xM014553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937660AbXGRAEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     Remove nid_lock from alloc_fresh_huge_page
has been added to the -mm tree.  Its filename is
     remove-nid_lock-from-alloc_fresh_huge_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~remove-nid_lock-from-alloc_fresh_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~remove-nid_lock-from-alloc_fresh_huge_page
+++ a/mm/hugetlb.c
@@ -107,15 +107,19 @@ static int alloc_fresh_huge_page(void)
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
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
remove-nid_lock-from-alloc_fresh_huge_page.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
mm-variable-length-argument-support.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch
