From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch removed
 from -mm tree
Date: Mon, 18 Nov 2013 16:06:20 -0800
Message-ID: <528aab7c.ym4tUXZH9ep00SyY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3KSAGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 19:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, dhillf@gmail.com, dave.hansen@linux.intel.com

Subject: [to-be-updated] mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch removed from -mm tree
To: dave.hansen@linux.intel.com,dhillf@gmail.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 16:06:20 -0800


The patch titled
     Subject: mm: thp: give transparent hugepage code a separate copy_page()
has been removed from the -mm tree.  Its filename was
     mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: thp: give transparent hugepage code a separate copy_page()

Right now, the migration code in migrate_page_copy() uses copy_huge_page()
for hugetlbfs and thp pages:

       if (PageHuge(page) || PageTransHuge(page))
                copy_huge_page(newpage, page);

So, yay for code reuse.  But:

void copy_huge_page(struct page *dst, struct page *src)
{
        struct hstate *h = page_hstate(src);

and a non-hugetlbfs page has no page_hstate().  This works 99% of the time
because page_hstate() determines the hstate from the page order alone. 
Since the page order of a THP page matches the default hugetlbfs page
order, it works.

But, if you change the default huge page size on the boot command-line
(say default_hugepagesz=1G), then we might not even *have* a 2MB hstate so
page_hstate() returns null and copy_huge_page() oopses pretty fast since
copy_huge_page() dereferences the hstate:

void copy_huge_page(struct page *dst, struct page *src)
{
        struct hstate *h = page_hstate(src);
        if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
...

This patch creates a copy_high_order_page() which can
be used on THP pages.

I believe the bug was introduced in b32967ff101:

Author: Mel Gorman <mgorman@suse.de>
Date:   Mon Nov 19 12:35:47 2012 +0000
mm: numa: Add THP migration for the NUMA working set scanning fault case.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   16 ++++++++++++++++
 mm/huge_memory.c        |   12 ++++++++++++
 mm/migrate.c            |    6 ++++--
 3 files changed, 32 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-give-transparent-hugepage-code-a-separate-copy_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/include/linux/huge_mm.h
@@ -178,6 +178,10 @@ static inline struct page *compound_tran
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
+extern void copy_high_order_page(struct page *newpage,
+				 struct page *oldpage,
+				 int order);
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -228,6 +232,18 @@ static inline int do_huge_pmd_numa_page(
 	return 0;
 }
 
+/*
+ * The non-stub version of this code is probably usable
+ * generically but its only user is thp at the moment,
+ * so enforce that with a BUG()
+ */
+static inline  void copy_high_order_page(struct page *newpage,
+					 struct page *oldpage,
+					 int order)
+{
+	BUG();
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/huge_memory.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/mm/huge_memory.c
@@ -2927,3 +2927,15 @@ void __vma_adjust_trans_huge(struct vm_a
 			split_huge_page_address(next->vm_mm, nstart);
 	}
 }
+
+void copy_high_order_page(struct page *newpage,
+			  struct page *oldpage,
+			  int order)
+{
+	int i;
+
+	for (i = 0; i < (1<<order); i++) {
+		cond_resched();
+		copy_highpage(newpage + i, oldpage + i);
+	}
+}
diff -puN mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page mm/migrate.c
--- a/mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/mm/migrate.c
@@ -448,8 +448,10 @@ void migrate_page_copy(struct page *newp
 {
 	int cpupid;
 
-	if (PageHuge(page) || PageTransHuge(page))
-		copy_huge_page(newpage, page);
+	if (PageHuge(page))
+ 		copy_huge_page(newpage, page);
+	else if(PageTransHuge(page))
+		copy_high_order_page(newpage, page, HPAGE_PMD_ORDER);
 	else
 		copy_highpage(newpage, page);
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

