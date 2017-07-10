From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch removed from -mm tree
Date: Mon, 10 Jul 2017 15:30:07 -0700
Message-ID: <5963ffef.IFgv2kAREO5bgAZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdGJWaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: replace some macros with inline functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch

This patch was dropped because it was folded into mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: hugetlb: replace some macros with inline functions

All users of dissolve_free_huge_page() that ignore the result cause a
warning when CONFIG_HUGETLB_PAGE is disabled:

mm/memory-failure.c: In function 'me_huge_page':
include/linux/hugetlb.h:556:36: error: statement with no effect [-Werror=unused-value]
 #define dissolve_free_huge_page(p) 0

We can avoid this by using an inline function instead of the macro, and I
decided to do the same change for the related helpers as well.

Fixes: mmotm ("mm: hugetlb: soft-offline: dissolve source hugepage after successful migration")
Link: http://lkml.kernel.org/r/20170609102544.2947326-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix
+++ a/include/linux/hugetlb.h
@@ -551,16 +551,37 @@ static inline unsigned int pages_per_hug
 {
 	return 1;
 }
-#define hstate_index_to_shift(index) 0
-#define hstate_index(h) 0
+
+static inline unsigned hstate_index_to_shift(unsigned index)
+{
+	return 0;
+}
+
+static inline int hstate_index(struct hstate *h)
+{
+	return 0;
+}
 
 static inline pgoff_t basepage_index(struct page *page)
 {
 	return page->index;
 }
-#define dissolve_free_huge_page(p)	0
-#define dissolve_free_huge_pages(s, e)	0
-#define hugepage_migration_supported(h)	false
+
+static inline int dissolve_free_huge_page(struct page *page)
+{
+	return 0;
+}
+
+static inline int dissolve_free_huge_pages(unsigned long start_pfn,
+					   unsigned long end_pfn)
+{
+	return 0;
+}
+
+static inline bool hugepage_migration_supported(struct hstate *h)
+{
+	return false;
+}
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration.patch
bitmap-use-memcmp-optimisation-in-more-situations-fix.patch

