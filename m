From: akpm@linux-foundation.org
Subject: + add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:49:16 -0800
Message-ID: <200703022149.l22LnGY5019995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42310 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030473AbXCBVtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Add __GFP_MOVABLE for callers to flag allocations from high memory that may be migrated
has been added to the -mm tree.  Its filename is
     add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add __GFP_MOVABLE for callers to flag allocations from high memory that may be migrated
From: Mel Gorman <mel@csn.ul.ie>

It is often known at allocation time whether a page may be migrated or not. 
This patch adds a flag called __GFP_MOVABLE and a new mask called
GFP_HIGH_MOVABLE.  Allocations using the __GFP_MOVABLE can be either migrated
using the page migration mechanism or reclaimed by syncing with backing
storage and discarding.

An API function very similar to alloc_zeroed_user_highpage() is added for
__GFP_MOVABLE allocations called alloc_zeroed_user_highpage_movable().  The
flags used by alloc_zeroed_user_highpage() are not changed because it would
change the semantics of an existing API.  After this patch is applied there
are no in-kernel users of alloc_zeroed_user_highpage() so it probably should
be marked deprecated if this patch is merged.

Note that this patch includes a minor cleanup to the use of __GFP_ZERO
in shmem.c to keep all flag modifications to inode->mapping in the
shmem_dir_alloc() helper function. This clean-up suggestion is courtesy of
Hugh Dickens.

Additional credit goes to Christoph Lameter and Linus Torvalds for shaping the
concept.  Credit to Hugh Dickens for catching issues with shmem swap vector
and ramfs allocations.

[hugh@veritas.com: __GFP_ZERO cleanup]

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_prefetch.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_prefetch.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch
+++ a/mm/swap_prefetch.c
@@ -204,7 +204,7 @@ static enum trickle_return trickle_swap_
 	 * Get a new page to read from swap. We have already checked the
 	 * watermarks so __alloc_pages will not call on reclaim.
 	 */
-	page = alloc_pages_node(node, GFP_HIGHUSER & ~__GFP_WAIT, 0);
+	page = alloc_pages_node(node, GFP_HIGH_MOVABLE & ~__GFP_WAIT, 0);
 	if (unlikely(!page)) {
 		ret = TRICKLE_DELAY;
 		goto out;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
