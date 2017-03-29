From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-thp-add-can_split_huge_page.patch removed from -mm tree
Date: Wed, 29 Mar 2017 13:59:37 -0700
Message-ID: <58dc2039.2DGn7/ObWNjEiqxT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932437AbdC2U7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 16:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP: add can_split_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-thp-add-can_split_huge_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP: add can_split_huge_page()

Separates checking whether we can split the huge page from
split_huge_page_to_list() into a function.  This will help to check that
before splitting the THP (Transparent Huge Page) really.

This will be used for delaying splitting THP during swapping out.  Where
for a THP, we will allocate a swap cluster, add the THP into the swap
cache, then split the THP.  To avoid the unnecessary operations for the
un-splittable THP, we will check that firstly.

There is no functionality change in this patch.

Link: http://lkml.kernel.org/r/20170328053209.25876-8-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@tarantool.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 +++++++
 mm/huge_memory.c        |   17 ++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-add-can_split_huge_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-add-can_split_huge_page
+++ a/include/linux/huge_mm.h
@@ -113,6 +113,7 @@ extern unsigned long thp_get_unmapped_ar
 extern void prep_transhuge_page(struct page *page);
 extern void free_transhuge_page(struct page *page);
 
+bool can_split_huge_page(struct page *page, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
@@ -231,6 +232,12 @@ static inline void prep_transhuge_page(s
 
 #define thp_get_unmapped_area	NULL
 
+static inline bool
+can_split_huge_page(struct page *page, int *pextra_pins)
+{
+	BUILD_BUG();
+	return false;
+}
 static inline int
 split_huge_page_to_list(struct page *page, struct list_head *list)
 {
diff -puN mm/huge_memory.c~mm-thp-add-can_split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-add-can_split_huge_page
+++ a/mm/huge_memory.c
@@ -2367,6 +2367,19 @@ int page_trans_huge_mapcount(struct page
 	return ret;
 }
 
+/* Racy check whether the huge page can be split */
+bool can_split_huge_page(struct page *page, int *pextra_pins)
+{
+	int extra_pins = 0;
+
+	/* Additional pins from radix tree */
+	if (!PageAnon(page))
+		extra_pins = HPAGE_PMD_NR;
+	if (pextra_pins)
+		*pextra_pins = extra_pins;
+	return total_mapcount(page) == page_count(page) - extra_pins - 1;
+}
+
 /*
  * This function splits huge page into normal pages. @page can point to any
  * subpage of huge page to split. Split doesn't change the position of @page.
@@ -2426,8 +2439,6 @@ int split_huge_page_to_list(struct page
 			goto out;
 		}
 
-		/* Addidional pins from radix tree */
-		extra_pins = HPAGE_PMD_NR;
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
 	}
@@ -2436,7 +2447,7 @@ int split_huge_page_to_list(struct page
 	 * Racy check if we can split the page, before freeze_page() will
 	 * split PMDs
 	 */
-	if (total_mapcount(head) != page_count(head) - extra_pins - 1) {
+	if (!can_split_huge_page(head, &extra_pins)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

