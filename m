From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-introduce-minimum-hugepage-order.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:06 -0700
Message-ID: <5591acae.+cre3zr6FwjheYZH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbbF2UiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: introduce minimum hugepage order
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-minimum-hugepage-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: introduce minimum hugepage order

Currently the initial value of order in dissolve_free_huge_page is 64 or
32, which leads to the following warning in static checker:

  mm/hugetlb.c:1203 dissolve_free_huge_pages()
  warn: potential right shift more than type allows '9,18,64'

This is a potential risk of infinite loop, because 1 << order (== 0) is used
in for-loop like this:

  for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D 1 << order)
      ...

So this patch fixes it by using global minimum_order calculated at boot time.

    text    data     bss     dec     hex filename
   28313     469   84236  113018   1b97a mm/hugetlb.o
   28256     473   84236  112965   1b945 mm/hugetlb.o (patched)

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-introduce-minimum-hugepage-order mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-minimum-hugepage-order
+++ a/mm/hugetlb.c
@@ -40,6 +40,11 @@ int hugepages_treat_as_movable;
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
+/*
+ * Minimum page order among possible hugepage sizes, set to a proper value
+ * at boot time.
+ */
+static unsigned int minimum_order __read_mostly = UINT_MAX;
 
 __initdata LIST_HEAD(huge_boot_pages);
 
@@ -1188,19 +1193,13 @@ static void dissolve_free_huge_page(stru
  */
 void dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned int order = 8 * sizeof(void *);
 	unsigned long pfn;
-	struct hstate *h;
 
 	if (!hugepages_supported())
 		return;
 
-	/* Set scan step to minimum hugepage size */
-	for_each_hstate(h)
-		if (order > huge_page_order(h))
-			order = huge_page_order(h);
-	VM_BUG_ON(!IS_ALIGNED(start_pfn, 1 << order));
-	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order)
+	VM_BUG_ON(!IS_ALIGNED(start_pfn, 1 << minimum_order));
+	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order)
 		dissolve_free_huge_page(pfn_to_page(pfn));
 }
 
@@ -1627,10 +1626,14 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h;
 
 	for_each_hstate(h) {
+		if (minimum_order > huge_page_order(h))
+			minimum_order = huge_page_order(h);
+
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
+	VM_BUG_ON(minimum_order == UINT_MAX);
 }
 
 static char * __init memfmt(char *buf, unsigned long n)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

