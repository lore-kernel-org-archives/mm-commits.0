From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 034/131] mm/page_alloc.c: rename
 free_pages_check_bad() to check_free_page_bad()
Date: Wed, 03 Jun 2020 15:58:33 -0700
Message-ID: <20200603225833.0jl0SyKZ4%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCW6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:58:34 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com, torvalds@linux-foundation.org

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
