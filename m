From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_allocc-rename-free_pages_check-to-check_free_page.patch added to
 -mm tree
Date: Mon, 13 Apr 2020 17:40:36 -0700
Message-ID: <20200414004036.D3NtO-6Gn%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgDNAkh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:40:37 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: rename free_pages_check() to check_free_page()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-rename-free_pages_check-to-check_free_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-rename-free_pages_check-to-check_free_page.patch

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
Subject: mm/page_alloc.c: rename free_pages_check() to check_free_page()

free_pages_check() is the counterpart of check_new_page().  Rename it to
use the same naming convention.

Link: http://lkml.kernel.org/r/20200411220357.9636-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-rename-free_pages_check-to-check_free_page
+++ a/mm/page_alloc.c
@@ -1089,7 +1089,7 @@ static void check_free_page_bad(struct p
 	bad_page(page, bad_reason);
 }
 
-static inline int free_pages_check(struct page *page)
+static inline int check_free_page(struct page *page)
 {
 	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
 		return 0;
@@ -1181,7 +1181,7 @@ static __always_inline bool free_pages_p
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			if (unlikely(free_pages_check(page + i))) {
+			if (unlikely(check_free_page(page + i))) {
 				bad++;
 				continue;
 			}
@@ -1193,7 +1193,7 @@ static __always_inline bool free_pages_p
 	if (memcg_kmem_enabled() && PageKmemcg(page))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
-		bad += free_pages_check(page);
+		bad += check_free_page(page);
 	if (bad)
 		return false;
 
@@ -1240,7 +1240,7 @@ static bool free_pcp_prepare(struct page
 static bool bulkfree_pcp_prepare(struct page *page)
 {
 	if (debug_pagealloc_enabled_static())
-		return free_pages_check(page);
+		return check_free_page(page);
 	else
 		return false;
 }
@@ -1261,7 +1261,7 @@ static bool free_pcp_prepare(struct page
 
 static bool bulkfree_pcp_prepare(struct page *page)
 {
-	return free_pages_check(page);
+	return check_free_page(page);
 }
 #endif /* CONFIG_DEBUG_VM */
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
