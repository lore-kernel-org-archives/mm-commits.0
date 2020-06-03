From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 036/131] mm/page_alloc.c: extract
 check_[new|free]_page_bad() common part to page_bad_reason()
Date: Wed, 03 Jun 2020 15:58:39 -0700
Message-ID: <20200603225839.VBaO8dOxy%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:40 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com, torvalds@linux-foundation.org

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
@@ -2083,26 +2093,14 @@ static inline void expand(struct zone *z
 
 static void check_new_page_bad(struct page *page)
 {
-	const char *bad_reason = NULL;
