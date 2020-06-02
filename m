From: akpm@linux-foundation.org
Subject: + bitops-use-the-same-mechanism-for-get_count_order.patch
 added to -mm tree
Date: Mon, 01 Jun 2020 18:01:49 -0700
Message-ID: <20200602010149.SLwhb6K-k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBBBu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 21:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: bitops: use the same mechanism for get_count_order[_long]
has been added to the -mm tree.  Its filename is
     bitops-use-the-same-mechanism-for-get_count_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitops-use-the-same-mechanism-for-get_count_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitops-use-the-same-mechanism-for-get_count_order.patch

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
Subject: bitops: use the same mechanism for get_count_order[_long]

These two functions share the same logic.

Link: http://lkml.kernel.org/r/20200525215958.21653-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/include/linux/bitops.h~bitops-use-the-same-mechanism-for-get_count_order
+++ a/include/linux/bitops.h
@@ -188,12 +188,10 @@ static inline unsigned fls_long(unsigned
 
 static inline int get_count_order(unsigned int count)
 {
-	int order;
+	if (count == 0)
+		return -1;
 
-	order = fls(count) - 1;
-	if (count & (count - 1))
-		order++;
-	return order;
+	return fls(--count);
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
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-make-a-test-module-with-get_count_order-long.patch
