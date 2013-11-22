From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch removed
 from -mm tree
Date: Fri, 22 Nov 2013 13:21:48 -0800
Message-ID: <528fcaec.TKS1hHmuxuU9JpRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3KVVVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, dhillf@gmail.com, dave.jiang@intel.com, aarcange@redhat.com, dave.hansen@linux.intel.com

Subject: [merged] mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch removed from -mm tree
To: dave.hansen@linux.intel.com,aarcange@redhat.com,dave.jiang@intel.com,dhillf@gmail.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:48 -0800


The patch titled
     Subject: mm: thp: give transparent hugepage code a separate copy_page
has been removed from the -mm tree.  Its filename was
     mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: thp: give transparent hugepage code a separate copy_page

Right now, the migration code in migrate_page_copy() uses copy_huge_page()
for hugetlbfs and thp pages:

       if (PageHuge(page) || PageTransHuge(page))
                copy_huge_page(newpage, page);

So, yay for code reuse.  But:

void copy_huge_page(struct page *dst, struct page *src)
{
        struct hstate *h = page_hstate(src);

and a non-hugetlbfs page has no page_hstate().  This works 99% of
the time because page_hstate() determines the hstate from the
page order alone.  Since the page order of a THP page matches the
default hugetlbfs page order, it works.

But, if you change the default huge page size on the boot
command-line (say default_hugepagesz=1G), then we might not even
*have* a 2MB hstate so page_hstate() returns null and
copy_huge_page() oopses pretty fast since copy_huge_page()
dereferences the hstate:

void copy_huge_page(struct page *dst, struct page *src)
{
        struct hstate *h = page_hstate(src);
        if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
...

Mel noticed that the migration code is really the only user of
these functions.  This moves all the copy code over to migrate.c
and makes copy_huge_page() work for THP by checking for it
explicitly.

I believe the bug was introduced in b32967ff101:
Author: Mel Gorman <mgorman@suse.de>
Date:   Mon Nov 19 12:35:47 2012 +0000
mm: numa: Add THP migration for the NUMA working set scanning fault case.

[akpm@linux-foundation.org: fix coding-style and comment text, per Naoya Horiguchi]
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ---
 mm/hugetlb.c            |   34 --------------------------
 mm/migrate.c            |   48 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 38 deletions(-)

diff -puN include/linux/hugetlb.h~mm-thp-give-transparent-hugepage-code-a-separate-copy_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/include/linux/hugetlb.h
@@ -69,7 +69,6 @@ int dequeue_hwpoisoned_huge_page(struct
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
 bool is_hugepage_active(struct page *page);
-void copy_huge_page(struct page *dst, struct page *src);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
@@ -140,9 +139,6 @@ static inline int dequeue_hwpoisoned_hug
 #define isolate_huge_page(p, l) false
 #define putback_active_hugepage(p)	do {} while (0)
 #define is_hugepage_active(x)	false
-static inline void copy_huge_page(struct page *dst, struct page *src)
-{
-}
 
 static inline unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
diff -puN mm/hugetlb.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/mm/hugetlb.c
@@ -476,40 +476,6 @@ static int vma_has_reserves(struct vm_ar
 	return 0;
 }
 
-static void copy_gigantic_page(struct page *dst, struct page *src)
-{
-	int i;
-	struct hstate *h = page_hstate(src);
-	struct page *dst_base = dst;
-	struct page *src_base = src;
-
-	for (i = 0; i < pages_per_huge_page(h); ) {
-		cond_resched();
-		copy_highpage(dst, src);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
-	}
-}
-
-void copy_huge_page(struct page *dst, struct page *src)
-{
-	int i;
-	struct hstate *h = page_hstate(src);
-
-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
-		copy_gigantic_page(dst, src);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		cond_resched();
-		copy_highpage(dst + i, src + i);
-	}
-}
-
 static void enqueue_huge_page(struct hstate *h, struct page *page)
 {
 	int nid = page_to_nid(page);
diff -puN mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page mm/migrate.c
--- a/mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page
+++ a/mm/migrate.c
@@ -442,6 +442,54 @@ int migrate_huge_page_move_mapping(struc
 }
 
 /*
+ * Gigantic pages are so large that we do not guarantee that page++ pointer
+ * arithmetic will work across the entire page.  We need something more
+ * specialized.
+ */
+static void __copy_gigantic_page(struct page *dst, struct page *src,
+				int nr_pages)
+{
+	int i;
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+
+	for (i = 0; i < nr_pages; ) {
+		cond_resched();
+		copy_highpage(dst, src);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
+
+static void copy_huge_page(struct page *dst, struct page *src)
+{
+	int i;
+	int nr_pages;
+
+	if (PageHuge(src)) {
+		/* hugetlbfs page */
+		struct hstate *h = page_hstate(src);
+		nr_pages = pages_per_huge_page(h);
+
+		if (unlikely(nr_pages > MAX_ORDER_NR_PAGES)) {
+			__copy_gigantic_page(dst, src, nr_pages);
+			return;
+		}
+	} else {
+		/* thp page */
+		BUG_ON(!PageTransHuge(src));
+		nr_pages = hpage_nr_pages(src);
+	}
+
+	for (i = 0; i < nr_pages; i++) {
+		cond_resched();
+		copy_highpage(dst + i, src + i);
+	}
+}
+
+/*
  * Copy the page to its new location
  */
 void migrate_page_copy(struct page *newpage, struct page *page)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

