From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch added to
 -mm tree
Date: Fri, 01 May 2020 15:49:27 -0700
Message-ID: <20200501224927.jp06yYxk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAWt2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 18:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/swapfile.c: classify SWAP_MAP_XXX to make it more readable
has been added to the -mm tree.  Its filename is
     mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: classify SWAP_MAP_XXX to make it more readable

swap_info_struct->swap_map[] encodes some flag and count. And to
do some condition check, it also introduces some special values.

Currently those macros are defined with some magic order, which makes
audience hard to understand the exact meaning.

This patch split those macros into three categories:

    flag
    special value for first swap_map
    special value for continued swap_map

May this help audiences a little.

Link: http://lkml.kernel.org/r/20200501015259.32237-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable
+++ a/include/linux/swap.h
@@ -183,12 +183,17 @@ enum {
 #define SWAP_CLUSTER_MAX 32UL
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
-#define SWAP_MAP_MAX	0x3e	/* Max duplication count, in first swap_map */
-#define SWAP_MAP_BAD	0x3f	/* Note pageblock is bad, in first swap_map */
+/* Bit flag in swap_map */
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
-#define SWAP_CONT_MAX	0x7f	/* Max count, in each swap_map continuation */
-#define COUNT_CONTINUED	0x80	/* See swap_map continuation for full count */
-#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs, in first swap_map */
+#define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
+
+/* Special Value in first swap_map */
+#define SWAP_MAP_MAX	0x3e	/* Max count */
+#define SWAP_MAP_BAD	0x3f	/* Note page is bad */
+#define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
+
+/* Special Value in each swap_map continuation */
+#define SWAP_CONT_MAX	0x7f	/* Max count */
 
 /*
  * We use this to track usage of a cluster. A cluster is a block of swap disk
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-swapfilec-offset-is-only-used-when-there-is-more-slots.patch
mm-swapfilec-explicitly-show-ssd-non-ssd-is-handled-mutually-exclusive.patch
mm-swapfilec-remove-the-unnecessary-goto-for-ssd-case.patch
mm-swapfilec-simplify-the-calculation-of-n_goal.patch
mm-swapfilec-remove-the-extra-check-in-scan_swap_map_slots.patch
mm-swapfilec-found_free-could-be-represented-by-tmp-max.patch
mm-swapfilec-tmp-is-always-smaller-than-max.patch
mm-swapfilec-omit-a-duplicate-code-by-compare-tmp-and-max-first.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable.patch
mm-swapfilec-__swap_entry_free-always-free-1-entry.patch
mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-page_allocc-use-node_mask_none-in-build_zonelists.patch
mm-rename-gfpflags_to_migratetype-to-gfp_migratetype-for-same-convention.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
