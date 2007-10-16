From: akpm@linux-foundation.org
Subject: - mm-clarify-__add_to_swap_cache-locking.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:22 -0700
Message-ID: <200710162031.l9GKVMi5014495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965961AbXJPVpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: clarify __add_to_swap_cache locking
has been removed from the -mm tree.  Its filename was
     mm-clarify-__add_to_swap_cache-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: clarify __add_to_swap_cache locking
From: Nick Piggin <npiggin@suse.de>

__add_to_swap_cache unconditionally sets the page locked, which can be a bit
alarming to the unsuspecting reader: in the code paths where the page is
visible to other CPUs, the page should be (and is) already locked.

Instead, just add a check to ensure the page is locked here, and teach the one
path relying on the old behaviour to call SetPageLocked itself.

[hugh@veritas.com: locking fix]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking mm/swap_state.c
--- a/mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking
+++ a/mm/swap_state.c
@@ -74,6 +74,7 @@ static int __add_to_swap_cache(struct pa
 {
 	int error;
 
+	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
 	error = radix_tree_preload(gfp_mask);
@@ -83,7 +84,6 @@ static int __add_to_swap_cache(struct pa
 						entry.val, page);
 		if (!error) {
 			page_cache_get(page);
-			SetPageLocked(page);
 			SetPageSwapCache(page);
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
@@ -99,15 +99,18 @@ static int add_to_swap_cache(struct page
 {
 	int error;
 
+	BUG_ON(PageLocked(page));
 	if (!swap_duplicate(entry)) {
 		INC_CACHE_INFO(noent_race);
 		return -ENOENT;
 	}
+	SetPageLocked(page);
 	error = __add_to_swap_cache(page, entry, GFP_KERNEL);
 	/*
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
+		ClearPageLocked(page);
 		swap_free(entry);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
