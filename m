From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:40:39 -0700
Message-ID: <20200414004039.N9qa2N2i4%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgDNAkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:40:41 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: extract check_[new|free]_page_bad() common part to page_bad_reason()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch

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
Subject: mm/page_alloc.c: extract check_[new|free]_page_bad() common part to page_bad_reason()

We share similar code in check_[new|free]_page_bad() to get the page's bad
reason.

Let's extract it and reduce code duplication.

Link: http://lkml.kernel.org/r/20200411220357.9636-6-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason
+++ a/mm/page_alloc.c
@@ -1070,7 +1070,7 @@ static inline bool page_expected_state(s
 	return true;
 }
 
-static void check_free_page_bad(struct page *page)
+static const char *page_bad_reason(struct page *page, unsigned long flags)
 {
 	const char *bad_reason = NULL;
 
@@ -1080,13 +1080,23 @@ static void check_free_page_bad(struct p
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
 		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_FREE))
-		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
+	if (unlikely(page->flags & flags)) {
+		if (flags == PAGE_FLAGS_CHECK_AT_PREP)
+			bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag(s) set";
+		else
+			bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
+	}
 #ifdef CONFIG_MEMCG
 	if (unlikely(page->mem_cgroup))
 		bad_reason = "page still charged to cgroup";
 #endif
-	bad_page(page, bad_reason);
+	return bad_reason;
+}
+
+static void check_free_page_bad(struct page *page)
+{
+	bad_page(page,
+		 page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
 }
 
 static inline int check_free_page(struct page *page)
@@ -2082,26 +2092,14 @@ static inline void expand(struct zone *z
 
 static void check_new_page_bad(struct page *page)
 {
-	const char *bad_reason = NULL;
-
 	if (unlikely(page->flags & __PG_HWPOISON)) {
 		/* Don't complain about hwpoisoned pages */
 		page_mapcount_reset(page); /* remove PageBuddy */
 		return;
 	}
-	if (unlikely(atomic_read(&page->_mapcount) != -1))
-		bad_reason = "nonzero mapcount";
-	if (unlikely(page->mapping != NULL))
-		bad_reason = "non-NULL mapping";
-	if (unlikely(page_ref_count(page) != 0))
-		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP))
-		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
-#ifdef CONFIG_MEMCG
-	if (unlikely(page->mem_cgroup))
-		bad_reason = "page still charged to cgroup";
-#endif
-	bad_page(page, bad_reason);
+
+	bad_page(page,
+		 page_bad_reason(page, PAGE_FLAGS_CHECK_AT_PREP));
 }
 
 /*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
