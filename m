From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:17:47 -0700
Message-ID: <20200604171747.Yp0gZ0xZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFDRRs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: rename free_pages_check_bad() to check_free_page_bad()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc.c: rename free_pages_check_bad() to check_free_page_bad()

free_pages_check_bad() is the counterpart of check_new_page_bad().  Rename
it to use the same naming convention.

Link: http://lkml.kernel.org/r/20200411220357.9636-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad
+++ a/mm/page_alloc.c
@@ -1070,7 +1070,7 @@ static inline bool page_expected_state(s
 	return true;
 }
 
-static void free_pages_check_bad(struct page *page)
+static void check_free_page_bad(struct page *page)
 {
 	const char *bad_reason = NULL;
 
@@ -1095,7 +1095,7 @@ static inline int free_pages_check(struc
 		return 0;
 
 	/* Something has gone sideways, find it */
-	free_pages_check_bad(page);
+	check_free_page_bad(page);
 	return 1;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-test-get_count_order-long-in-test_bitopsc.patch
