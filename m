From: akpm@linux-foundation.org
Subject: [merged] mm-export-various-functions-for-the-benefit-of-dax.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:01 -0700
Message-ID: <55f08bc5.L7a04/p46428pcr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export various functions for the benefit of DAX
has been removed from the -mm tree.  Its filename was
     mm-export-various-functions-for-the-benefit-of-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: export various functions for the benefit of DAX

To use the huge zero page in DAX, we need these functions exported.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 ++++++++++
 mm/huge_memory.c        |    7 +------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/huge_mm.h~mm-export-various-functions-for-the-benefit-of-dax include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-export-various-functions-for-the-benefit-of-dax
+++ a/include/linux/huge_mm.h
@@ -155,6 +155,16 @@ static inline bool is_huge_zero_page(str
 	return ACCESS_ONCE(huge_zero_page) == page;
 }
 
+static inline bool is_huge_zero_pmd(pmd_t pmd)
+{
+	return is_huge_zero_page(pmd_page(pmd));
+}
+
+struct page *get_huge_zero_page(void);
+bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long haddr,
+		pmd_t *pmd, struct page *zero_page);
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
diff -puN mm/huge_memory.c~mm-export-various-functions-for-the-benefit-of-dax mm/huge_memory.c
--- a/mm/huge_memory.c~mm-export-various-functions-for-the-benefit-of-dax
+++ a/mm/huge_memory.c
@@ -173,12 +173,7 @@ fail:
 static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 
-static inline bool is_huge_zero_pmd(pmd_t pmd)
-{
-	return is_huge_zero_page(pmd_page(pmd));
-}
