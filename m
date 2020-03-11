From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch added to
 -mm tree
Date: Wed, 11 Mar 2020 15:08:07 -0700
Message-ID: <20200311220807.wgJDgCJpx%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbgCKWII (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 18:08:08 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nehaagarwal@google.com, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm/hugetlb: remove unnecessary memory fetch in PageHeadHuge()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-fully-assume-capture-is-not-null-in-compact_zone_order.patch
mm-hugetlb-remove-unnecessary-memory-fetch-in-pageheadhuge.patch
