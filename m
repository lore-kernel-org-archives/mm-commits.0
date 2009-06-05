From: akpm@linux-foundation.org
Subject: + mm-remove-file-argument-from-swap_readpage.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:31:06 -0700
Message-ID: <200906052031.n55KV7Yn001401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503AbZFEUbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk, riel@redhat.com


The patch titled
     mm: remove file argument from swap_readpage()
has been added to the -mm tree.  Its filename is
     mm-remove-file-argument-from-swap_readpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
page-allocator-reset-wmark_min-and-inactive-ratio-of-zone-when-hotplug-happens.patch
mm-remove-config_unevictable_lru-config-option.patch
mm-remove-annotation-of-gfp_mask-in-add_to_swap.patch
mm-remove-file-argument-from-swap_readpage.patch
use-printk_once-in-several-places.patch
use-printk_once-in-several-places-clean-up-printk_once-of-get_cpu_vendor.patch

