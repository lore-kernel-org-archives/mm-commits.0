From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 033/131] mm/page_alloc.c: bad_flags is not
 necessary for bad_page()
Date: Wed, 03 Jun 2020 15:58:29 -0700
Message-ID: <20200603225829.1qsxpkO9U%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:32 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc.c: bad_flags is not necessary for bad_page()

After commit 5b57b8f22709 ("mm/debug.c: always print flags in
dump_page()"), page->flags is always printed for a bad page.  It is not
necessary to have bad_flags any more.

Link: http://lkml.kernel.org/r/20200411220357.9636-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-bad_flags-is-not-necessary-for-bad_page
+++ a/mm/page_alloc.c
@@ -607,8 +607,7 @@ static inline int __maybe_unused bad_ran
 }
 #endif
 
-static void bad_page(struct page *page, const char *reason,
-		unsigned long bad_flags)
+static void bad_page(struct page *page, const char *reason)
 {
 	static unsigned long resume;
 	static unsigned long nr_shown;
@@ -637,10 +636,6 @@ static void bad_page(struct page *page,
 	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
 	__dump_page(page, reason);
-	bad_flags &= page->flags;
-	if (bad_flags)
-		pr_alert("bad because of flags: %#lx(%pGp)\n",
-						bad_flags, &bad_flags);
 	dump_page_owner(page);
 
 	print_modules();
@@ -1077,11 +1072,7 @@ static inline bool page_expected_state(s
 
 static void free_pages_check_bad(struct page *page)
 {
-	const char *bad_reason;
-	unsigned long bad_flags;
-
-	bad_reason = NULL;
-	bad_flags = 0;
+	const char *bad_reason = NULL;
 
 	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
@@ -1089,15 +1080,13 @@ static void free_pages_check_bad(struct
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
 		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_FREE)) {
+	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_FREE))
 		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
-		bad_flags = PAGE_FLAGS_CHECK_AT_FREE;
-	}
 #ifdef CONFIG_MEMCG
 	if (unlikely(page->mem_cgroup))
 		bad_reason = "page still charged to cgroup";
 #endif
-	bad_page(page, bad_reason, bad_flags);
+	bad_page(page, bad_reason);
 }
 
 static inline int free_pages_check(struct page *page)
@@ -1128,7 +1117,7 @@ static int free_tail_pages_check(struct
 	case 1:
 		/* the first tail page: ->mapping may be compound_mapcount() */
 		if (unlikely(compound_mapcount(page))) {
-			bad_page(page, "nonzero compound_mapcount", 0);
+			bad_page(page, "nonzero compound_mapcount");
 			goto out;
 		}
 		break;
@@ -1140,17 +1129,17 @@ static int free_tail_pages_check(struct
 		break;
 	default:
 		if (page->mapping != TAIL_MAPPING) {
-			bad_page(page, "corrupted mapping in tail page", 0);
+			bad_page(page, "corrupted mapping in tail page");
 			goto out;
 		}
 		break;
 	}
 	if (unlikely(!PageTail(page))) {
-		bad_page(page, "PageTail not set", 0);
+		bad_page(page, "PageTail not set");
 		goto out;
 	}
 	if (unlikely(compound_head(page) != head_page)) {
-		bad_page(page, "compound_head not consistent", 0);
+		bad_page(page, "compound_head not consistent");
 		goto out;
 	}
 	ret = 0;
@@ -2095,7 +2084,6 @@ static inline void expand(struct zone *z
 static void check_new_page_bad(struct page *page)
 {
 	const char *bad_reason = NULL;
-	unsigned long bad_flags = 0;
 
 	if (unlikely(page->flags & __PG_HWPOISON)) {
 		/* Don't complain about hwpoisoned pages */
@@ -2108,15 +2096,13 @@ static void check_new_page_bad(struct pa
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
 		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP)) {
+	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP))
 		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
-		bad_flags = PAGE_FLAGS_CHECK_AT_PREP;
-	}
 #ifdef CONFIG_MEMCG
 	if (unlikely(page->mem_cgroup))
 		bad_reason = "page still charged to cgroup";
 #endif
-	bad_page(page, bad_reason, bad_flags);
+	bad_page(page, bad_reason);
 }
 
 /*
_
