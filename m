From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch added to -mm
 tree
Date: Mon, 13 Apr 2020 17:40:30 -0700
Message-ID: <20200414004030.Qj7ejq7OB%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgDNAkb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:40:31 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: bad_flags is not necessary for bad_page()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch

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
@@ -2094,7 +2083,6 @@ static inline void expand(struct zone *z
 static void check_new_page_bad(struct page *page)
 {
 	const char *bad_reason = NULL;
-	unsigned long bad_flags = 0;
 
 	if (unlikely(page->flags & __PG_HWPOISON)) {
 		/* Don't complain about hwpoisoned pages */
@@ -2107,15 +2095,13 @@ static void check_new_page_bad(struct pa
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

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
