From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-hugetlbh-use-bool-instead-of-int-for-hugepage_migration_supported.patch removed from -mm tree
Date: Mon, 23 May 2016 12:46:21 -0700
Message-ID: <57435e0d.X2tq1ofQAF6ppOBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chengang@emindsoft.com.cn, gang.chen.5i5j@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/hugetlb.h: use bool instead of int for hugepage_migration_supported()
has been removed from the -mm tree.  Its filename was
     include-linux-hugetlbh-use-bool-instead-of-int-for-hugepage_migration_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <chengang@emindsoft.com.cn>
Subject: include/linux/hugetlb.h: use bool instead of int for hugepage_migration_supported()

It is used as a pure bool function within kernel source wide.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/hugetlb.h~include-linux-hugetlbh-use-bool-instead-of-int-for-hugepage_migration_supported include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~include-linux-hugetlbh-use-bool-instead-of-int-for-hugepage_migration_supported
+++ a/include/linux/hugetlb.h
@@ -452,12 +452,12 @@ static inline pgoff_t basepage_index(str
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-static inline int hugepage_migration_supported(struct hstate *h)
+static inline bool hugepage_migration_supported(struct hstate *h)
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	return huge_page_shift(h) == PMD_SHIFT;
 #else
-	return 0;
+	return false;
 #endif
 }
 
@@ -519,7 +519,7 @@ static inline pgoff_t basepage_index(str
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define hugepage_migration_supported(h)	0
+#define hugepage_migration_supported(h)	false
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
_

Patches currently in -mm which might be from chengang@emindsoft.com.cn are


