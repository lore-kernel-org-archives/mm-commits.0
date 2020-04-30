From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch removed
 from -mm tree
Date: Thu, 30 Apr 2020 14:13:52 -0700
Message-ID: <20200430211352.g6UAYAi_x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgD3VNx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: khugepaged: don't have to put being freed page back to lru
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: khugepaged: don't have to put being freed page back to lru

When khugepaged successfully isolated and copied data from base page to
collapsed THP, the base page is about to be freed.  So putting the page
back to lru sounds not that productive since the page might be isolated by
vmscan but it can't be reclaimed by vmscan since it can't be unmapped by
try_to_unmap() at all.

Actually khugepaged is the last user of this page so it can be freed
directly.  So clear active and unevictable flags, unlock and drop refcount
from isolate instead of calling putback_lru_page().

Link: http://lkml.kernel.org/r/1588200982-69492-2-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru
+++ a/mm/khugepaged.c
@@ -559,6 +559,17 @@ void __khugepaged_exit(struct mm_struct
 static void release_pte_page(struct page *page)
 {
 	mod_node_page_state(page_pgdat(page),
+		NR_ISOLATED_ANON + page_is_file_lru(page), -compound_nr(page));
+	ClearPageActive(page);
+	ClearPageUnevictable(page);
+	unlock_page(page);
+	/* Drop refcount from isolate */
+	put_page(page);
+}
+
+static void release_pte_page_to_lru(struct page *page)
+{
+	mod_node_page_state(page_pgdat(page),
 			NR_ISOLATED_ANON + page_is_file_lru(page),
 			-compound_nr(page));
 	unlock_page(page);
@@ -576,12 +587,12 @@ static void release_pte_pages(pte_t *pte
 		page = pte_page(pteval);
 		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)) &&
 				!PageCompound(page))
-			release_pte_page(page);
+			release_pte_page_to_lru(page);
 	}
 
 	list_for_each_entry_safe(page, tmp, compound_pagelist, lru) {
 		list_del(&page->lru);
-		release_pte_page(page);
+		release_pte_page_to_lru(page);
 	}
 }
 
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-khugepaged-add-exceed_max_ptes_-helpers.patch
mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
