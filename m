From: akpm@linux-foundation.org
Subject: +
 mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch added to
 -mm tree
Date: Thu, 30 Apr 2020 14:14:34 -0700
Message-ID: <20200430211434.yPqsBu00P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgD3VOf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: khugepaged: don't have to put being freed page back to lru
has been added to the -mm tree.  Its filename is
     mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: khugepaged: don't have to put being freed page back to lru

When khugepaged successfully isolated and copied data from old page to
collapsed THP, the old page is about to be freed if its last mapcount is
gone.  So putting the page back to lru sounds not that productive in this
case since the page might be isolated by vmscan but it can't be reclaimed
by vmscan since it can't be unmapped by try_to_unmap() at all.

Actually if khugepaged is the last user of this page so it can be freed
directly.  So, clearing active and unevictable flags, unlocking and
dropping refcount from isolate instead of calling putback_lru_page().

Link: http://lkml.kernel.org/r/1588279279-61908-2-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru
+++ a/mm/khugepaged.c
@@ -559,10 +559,18 @@ void __khugepaged_exit(struct mm_struct
 static void release_pte_page(struct page *page)
 {
 	mod_node_page_state(page_pgdat(page),
-			NR_ISOLATED_ANON + page_is_file_lru(page),
-			-compound_nr(page));
-	unlock_page(page);
-	putback_lru_page(page);
+		NR_ISOLATED_ANON + page_is_file_lru(page), -compound_nr(page));
+
+	if (total_mapcount(page)) {
+		unlock_page(page);
+		putback_lru_page(page);
+	} else {
+		ClearPageActive(page);
+		ClearPageUnevictable(page);
+		unlock_page(page);
+		/* Drop refcount from isolate */
+		put_page(page);
+	}
 }
 
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
@@ -771,8 +779,6 @@ static void __collapse_huge_page_copy(pt
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
-			if (!PageCompound(src_page))
-				release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
@@ -786,6 +792,8 @@ static void __collapse_huge_page_copy(pt
 			pte_clear(vma->vm_mm, address, _pte);
 			page_remove_rmap(src_page, false);
 			spin_unlock(ptl);
+			if (!PageCompound(src_page))
+				release_pte_page(src_page);
 			free_page_and_swap_cache(src_page);
 		}
 	}
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-khugepaged-add-exceed_max_ptes_-helpers.patch
mm-khugepaged-dont-have-to-put-being-freed-page-back-to-lru.patch
mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
