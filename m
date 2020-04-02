From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 152/155] mm/hugetlb: remove unnecessary memory
 fetch in PageHeadHuge()
Date: Wed, 01 Apr 2020 21:11:48 -0700
Message-ID: <20200402041148.jDH6duv6H%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:49 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nehaagarwal@google.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/hugetlb: remove unnecessary memory fetch in PageHeadHuge()

Commit f1e61557f023 ("mm: pack compound_dtor and compound_order into one
word in struct page") changed compound_dtor from a pointer to an array
index in order to pack it.  To check if page has the hugeltbfs
compound_dtor, we can just compare the index directly without fetching the
function pointer.  Said commit did that with PageHuge() and we can do the
same with PageHeadHuge() to make the code a bit smaller and faster.

Link: http://lkml.kernel.org/r/20200311172440.6988-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Neha Agarwal <nehaagarwal@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge
+++ a/mm/hugetlb.c
@@ -1528,7 +1528,7 @@ int PageHeadHuge(struct page *page_head)
 	if (!PageHead(page_head))
 		return 0;
 
-	return get_compound_page_dtor(page_head) == free_huge_page;
+	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
 
 /*
_
