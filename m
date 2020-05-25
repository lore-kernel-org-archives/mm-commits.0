From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bitops-simplify-get_count_order_long.patch added to -mm
 tree
Date: Sun, 24 May 2020 17:06:17 -0700
Message-ID: <20200525000617.ss2ZfMBYF%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbgEYAGS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 20:06:18 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: include/linux/bitops.h: simplify get_count_order_long()
has been added to the -mm tree.  Its filename is
     bitops-simplify-get_count_order_long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitops-simplify-get_count_order_long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitops-simplify-get_count_order_long.patch

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
Subject: include/linux/bitops.h: simplify get_count_order_long()

These two cases could be unified into one.

Link: http://lkml.kernel.org/r/20200524123551.9469-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/bitops.h~bitops-simplify-get_count_order_long
+++ a/include/linux/bitops.h
@@ -206,10 +206,7 @@ static inline int get_count_order_long(u
 {
 	if (l == 0UL)
 		return -1;
-	else if (l & (l - 1UL))
-		return (int)fls_long(l);
-	else
-		return (int)fls_long(l) - 1;
+	return (int)fls_long(--l);
 }
 
 /**
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
bitops-simplify-get_count_order_long.patch
