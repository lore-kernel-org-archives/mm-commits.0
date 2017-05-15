From: akpm@linux-foundation.org
Subject: + mm-thp-swap-check-whether-thp-can-be-split-firstly.patch added
 to -mm tree
Date: Mon, 15 May 2017 13:18:16 -0700
Message-ID: <591a0d08.5Ko1WkFGjCKMl1dZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965496AbdEOUSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: check whether THP can be split firstly
has been added to the -mm tree.  Its filename is
     mm-thp-swap-check-whether-thp-can-be-split-firstly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-check-whether-thp-can-be-split-firstly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-check-whether-thp-can-be-split-firstly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: check whether THP can be split firstly

To swap out THP (Transparent Huage Page), before splitting the THP, the
swap cluster will be allocated and the THP will be added into the swap
cache.  But it is possible that the THP cannot be split, so that we must
delete the THP from the swap cache and free the swap cluster.  To avoid
that, in this patch, whether the THP can be split is checked firstly.  The
check can only be done racy, but it is good enough for most cases.

With the patch, the swap out throughput improves 3.6% (from about 4.16GB/s
to about 4.31GB/s) in the vm-scalability swap-w-seq test case with 8
processes.  The test is done on a Xeon E5 v3 system.  The swap device used
is a RAM simulated PMEM (persistent memory) device.  To test the
sequential swapping out, the test case creates 8 processes, which
sequentially allocate and write to the anonymous pages until the RAM and
part of the swap device is used up.

Link: http://lkml.kernel.org/r/20170515112522.32457-5-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com> [for can_split_huge_page()]
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 +++++++
 mm/huge_memory.c        |   20 ++++++++++++++++----
 mm/vmscan.c             |    4 ++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-swap-check-whether-thp-can-be-split-firstly include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-swap-check-whether-thp-can-be-split-firstly
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
diff -puN mm/huge_memory.c~mm-thp-swap-check-whether-thp-can-be-split-firstly mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-swap-check-whether-thp-can-be-split-firstly
+++ a/mm/huge_memory.c
@@ -2384,6 +2384,21 @@ int page_trans_huge_mapcount(struct page
 	return ret;
 }
 
+/* Racy check whether the huge page can be split */
+bool can_split_huge_page(struct page *page, int *pextra_pins)
+{
+	int extra_pins;
+
+	/* Additional pins from radix tree */
+	if (PageAnon(page))
+		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
+	else
+		extra_pins = HPAGE_PMD_NR;
+	if (pextra_pins)
+		*pextra_pins = extra_pins;
+	return total_mapcount(page) == page_count(page) - extra_pins - 1;
+}
+
 /*
  * This function splits huge page into normal pages. @page can point to any
  * subpage of huge page to split. Split doesn't change the position of @page.
@@ -2431,7 +2446,6 @@ int split_huge_page_to_list(struct page
 			ret = -EBUSY;
 			goto out;
 		}
-		extra_pins = PageSwapCache(page) ? HPAGE_PMD_NR : 0;
 		mapping = NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
@@ -2443,8 +2457,6 @@ int split_huge_page_to_list(struct page
 			goto out;
 		}
 
-		/* Addidional pins from radix tree */
-		extra_pins = HPAGE_PMD_NR;
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
 	}
@@ -2453,7 +2465,7 @@ int split_huge_page_to_list(struct page
 	 * Racy check if we can split the page, before freeze_page() will
 	 * split PMDs
 	 */
-	if (total_mapcount(head) != page_count(head) - extra_pins - 1) {
+	if (!can_split_huge_page(head, &extra_pins)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
diff -puN mm/vmscan.c~mm-thp-swap-check-whether-thp-can-be-split-firstly mm/vmscan.c
--- a/mm/vmscan.c~mm-thp-swap-check-whether-thp-can-be-split-firstly
+++ a/mm/vmscan.c
@@ -1125,6 +1125,10 @@ static unsigned long shrink_page_list(st
 		    !PageSwapCache(page)) {
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
+			/* cannot split THP, skip it */
+			if (PageTransHuge(page) &&
+			    !can_split_huge_page(page, NULL))
+				goto activate_locked;
 			if (!add_to_swap(page)) {
 				if (!PageTransHuge(page))
 					goto activate_locked;
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-delay-splitting-thp-during-swap-out.patch
mm-thp-swap-check-whether-thp-can-be-split-firstly.patch
mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch

