From: akpm@linux-foundation.org
Subject: [merged] mm-remove-file-argument-from-swap_readpage.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:10 -0700
Message-ID: <200906171836.n5HIaAiV002157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759452AbZFQSqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove file argument from swap_readpage()
has been removed from the -mm tree.  Its filename was
     mm-remove-file-argument-from-swap_readpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove file argument from swap_readpage()
From: Minchan Kim <minchan.kim@gmail.com>

The file argument resulted from address_space's readpage long time ago.

We don't use it any more.  Let's remove unnecessary argement.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/page_io.c         |    2 +-
 mm/swap_state.c      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~mm-remove-file-argument-from-swap_readpage include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-file-argument-from-swap_readpage
+++ a/include/linux/swap.h
@@ -256,7 +256,7 @@ extern void swap_unplug_io_fn(struct bac
 
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
-extern int swap_readpage(struct file *, struct page *);
+extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
diff -puN mm/page_io.c~mm-remove-file-argument-from-swap_readpage mm/page_io.c
--- a/mm/page_io.c~mm-remove-file-argument-from-swap_readpage
+++ a/mm/page_io.c
@@ -120,7 +120,7 @@ out:
 	return ret;
 }
 
-int swap_readpage(struct file *file, struct page *page)
+int swap_readpage(struct page *page)
 {
 	struct bio *bio;
 	int ret = 0;
diff -puN mm/swap_state.c~mm-remove-file-argument-from-swap_readpage mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-file-argument-from-swap_readpage
+++ a/mm/swap_state.c
@@ -313,7 +313,7 @@ struct page *read_swap_cache_async(swp_e
 			 * Initiate read into locked page and return.
 			 */
 			lru_cache_add_anon(new_page);
-			swap_readpage(NULL, new_page);
+			swap_readpage(new_page);
 			return new_page;
 		}
 		ClearPageSwapBacked(new_page);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

