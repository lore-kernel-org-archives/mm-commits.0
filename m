From: akpm@linux-foundation.org
Subject: + vmscan-fix-comments-related-to-shrink_list.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:55:26 -0700
Message-ID: <200706041855.l54ItQZ5010964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbXFDS4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: briglia.anderson@gmail.com, anderson.briglia@indt.org.br


The patch titled
     vmscan: fix comments related to shrink_list()
has been added to the -mm tree.  Its filename is
     vmscan-fix-comments-related-to-shrink_list.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmscan: fix comments related to shrink_list()
From: "Anderson Briglia" <briglia.anderson@gmail.com>

Fix the shrink_list name on some files under mm/ directory.

Signed-off-by: Anderson Briglia <anderson.briglia@indt.org.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 mm/swapfile.c   |    2 +-
 mm/truncate.c   |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swap_state.c~vmscan-fix-comments-related-to-shrink_list mm/swap_state.c
--- a/mm/swap_state.c~vmscan-fix-comments-related-to-shrink_list
+++ a/mm/swap_state.c
@@ -21,7 +21,7 @@
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
- * vmscan's shrink_list, to make sync_page look nicer, and to allow
+ * vmscan's shrink_page_list, to make sync_page look nicer, and to allow
  * future use of radix_tree tags in the swap cache.
  */
 static const struct address_space_operations swap_aops = {
diff -puN mm/swapfile.c~vmscan-fix-comments-related-to-shrink_list mm/swapfile.c
--- a/mm/swapfile.c~vmscan-fix-comments-related-to-shrink_list
+++ a/mm/swapfile.c
@@ -885,7 +885,7 @@ static int try_to_unuse(unsigned int typ
 		/*
 		 * So we could skip searching mms once swap count went
 		 * to 1, we did not mark any present ptes as dirty: must
-		 * mark page dirty so shrink_list will preserve it.
+		 * mark page dirty so shrink_page_list will preserve it.
 		 */
 		SetPageDirty(page);
 		unlock_page(page);
diff -puN mm/truncate.c~vmscan-fix-comments-related-to-shrink_list mm/truncate.c
--- a/mm/truncate.c~vmscan-fix-comments-related-to-shrink_list
+++ a/mm/truncate.c
@@ -335,8 +335,8 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * This is like invalidate_complete_page(), except it ignores the page's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
  * invalidation guarantees, and cannot afford to leave pages behind because
- * shrink_list() has a temp ref on them, or because they're transiently sitting
- * in the lru_cache_add() pagevecs.
+ * shrink_page_list() has a temp ref on them, or because they're transiently
+ * sitting in the lru_cache_add() pagevecs.
  */
 static int
 invalidate_complete_page2(struct address_space *mapping, struct page *page)
_

Patches currently in -mm which might be from briglia.anderson@gmail.com are

vmscan-fix-comments-related-to-shrink_list.patch
