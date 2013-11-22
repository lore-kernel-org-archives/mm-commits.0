From: akpm@linux-foundation.org
Subject: [merged] mm-place-page-pmd_huge_pte-to-right-union.patch removed
 from -mm tree
Date: Fri, 22 Nov 2013 13:22:07 -0800
Message-ID: <528fcaff.cqu9hEF4yOjZRrcX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3KVVWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-place-page-pmd_huge_pte-to-right-union.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:22:07 -0800


The patch titled
     Subject: mm: place page->pmd_huge_pte to right union
has been removed from the -mm tree.  Its filename was
     mm-place-page-pmd_huge_pte-to-right-union.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: place page->pmd_huge_pte to right union

I don't know what went wrong, mis-merge or something, but ->pmd_huge_pte
placed in wrong union within struct page.

In original patch[1] it's placed to union with ->lru and ->slab, but in
commit e009bb30c8df it's in union with ->index and ->freelist.

That union seems also unused for pages with table tables and safe to
re-use, but it's not what I've tested.

Let's move it to original place. It fixes indentation at least. :)

[1] https://lkml.org/lkml/2013/10/7/288

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm_types.h~mm-place-page-pmd_huge_pte-to-right-union include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-place-page-pmd_huge_pte-to-right-union
+++ a/include/linux/mm_types.h
@@ -65,9 +65,6 @@ struct page {
 						 * this page is only used to
 						 * free other pages.
 						 */
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
-		pgtable_t pmd_huge_pte; /* protected by page->ptl */
-#endif
 		};
 
 		union {
@@ -135,6 +132,9 @@ struct page {
 
 		struct list_head list;	/* slobs list of pages */
 		struct slab *slab_page; /* slab fields */
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
+		pgtable_t pmd_huge_pte; /* protected by page->ptl */
+#endif
 	};
 
 	/* Remainder is not double word aligned */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch

