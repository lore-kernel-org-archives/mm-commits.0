From: akpm@linux-foundation.org
Subject: [merged] mm-clarify-the-radix_tree-exceptional-cases.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:28 -0700
Message-ID: <201108161848.p7GImZjO015348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab1HPSw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: clarify the radix_tree exceptional cases
has been removed from the -mm tree.  Its filename was
     mm-clarify-the-radix_tree-exceptional-cases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clarify the radix_tree exceptional cases
From: Hugh Dickins <hughd@google.com>

Make the radix_tree exceptional cases, mostly in filemap.c, clearer.

It's hard to devise a suitable snappy name that illuminates the use by
shmem/tmpfs for swap, while keeping filemap/pagecache/radix_tree
generality.  And akpm points out that /* radix_tree_deref_retry(page) */
comments look like calls that have been commented out for unknown reason.

Skirt the naming difficulty by rearranging these blocks to handle the
transient radix_tree_deref_retry(page) case first; then just explain the
remaining shmem/tmpfs swap case in a comment.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   66 ++++++++++++++++++++++++++++++++-----------------
 mm/mincore.c |    1 
 mm/shmem.c   |   12 +++++---
 3 files changed, 53 insertions(+), 26 deletions(-)

diff -puN mm/filemap.c~mm-clarify-the-radix_tree-exceptional-cases mm/filemap.c
--- a/mm/filemap.c~mm-clarify-the-radix_tree-exceptional-cases
+++ a/mm/filemap.c
@@ -700,10 +700,14 @@ repeat:
 		if (unlikely(!page))
 			goto out;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				goto out;
-			/* radix_tree_deref_retry(page) */
-			goto repeat;
+			if (radix_tree_deref_retry(page))
+				goto repeat;
+			/*
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so return it without
+			 * attempting to raise page count.
+			 */
+			goto out;
 		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -838,15 +842,21 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				continue;
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				WARN_ON(start | i);
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so skip over it -
+			 * we only reach this from invalidate_mapping_pages().
 			 */
-			WARN_ON(start | i);
-			goto restart;
+			continue;
 		}
 
 		if (!page_cache_get_speculative(page))
@@ -904,14 +914,20 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				break;
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so stop looking for
+			 * contiguous pages.
 			 */
-			goto restart;
+			break;
 		}
 
 		if (!page_cache_get_speculative(page))
@@ -973,13 +989,19 @@ repeat:
 			continue;
 
 		if (radix_tree_exception(page)) {
-			BUG_ON(radix_tree_exceptional_entry(page));
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				goto restart;
+			}
 			/*
-			 * radix_tree_deref_retry(page):
-			 * can only trigger when entry at index 0 moves out of
-			 * or back to root: none yet gotten, safe to restart.
+			 * This function is never used on a shmem/tmpfs
+			 * mapping, so a swap entry won't be found here.
 			 */
-			goto restart;
+			BUG();
 		}
 
 		if (!page_cache_get_speculative(page))
diff -puN mm/mincore.c~mm-clarify-the-radix_tree-exceptional-cases mm/mincore.c
--- a/mm/mincore.c~mm-clarify-the-radix_tree-exceptional-cases
+++ a/mm/mincore.c
@@ -72,6 +72,7 @@ static unsigned char mincore_page(struct
 	 */
 	page = find_get_page(mapping, pgoff);
 #ifdef CONFIG_SWAP
+	/* shmem/tmpfs may return swap: account for swapcache page too. */
 	if (radix_tree_exceptional_entry(page)) {
 		swp_entry_t swap = radix_to_swp_entry(page);
 		page = find_get_page(&swapper_space, swap.val);
diff -puN mm/shmem.c~mm-clarify-the-radix_tree-exceptional-cases mm/shmem.c
--- a/mm/shmem.c~mm-clarify-the-radix_tree-exceptional-cases
+++ a/mm/shmem.c
@@ -332,10 +332,14 @@ repeat:
 		if (unlikely(!page))
 			continue;
 		if (radix_tree_exception(page)) {
-			if (radix_tree_exceptional_entry(page))
-				goto export;
-			/* radix_tree_deref_retry(page) */
-			goto restart;
+			if (radix_tree_deref_retry(page))
+				goto restart;
+			/*
+			 * Otherwise, we must be storing a swap entry
+			 * here as an exceptional entry: so return it
+			 * without attempting to raise page count.
+			 */
+			goto export;
 		}
 		if (!page_cache_get_speculative(page))
 			goto repeat;
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch
prio_tree-debugging-patch.patch

