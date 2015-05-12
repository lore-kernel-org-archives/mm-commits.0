From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch added to -mm tree
Date: Tue, 12 May 2015 16:15:19 -0700
Message-ID: <55528987.uEOvIBAAMtcTL7M0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbbELXPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 19:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: initialize order with UINT_MAX in dissolve_free_huge_pages()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: initialize order with UINT_MAX in dissolve_free_huge_pages()

Currently the initial value of order in dissolve_free_huge_page is 64 or
32, which leads to the following warning in static checker:

  mm/hugetlb.c:1203 dissolve_free_huge_pages()
  warn: potential right shift more than type allows '9,18,64'

This is a potential risk of infinite loop, because 1 << order (== 0)
is used in for-loop like this:

  for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D 1 << order)
      ...

So this patch simply avoids the risk by initializing with UINT_MAX.

Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages
+++ a/mm/hugetlb.c
@@ -1188,7 +1188,7 @@ static void dissolve_free_huge_page(stru
  */
 void dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned int order = 8 * sizeof(void *);
+	unsigned int order = UINT_MAX;
 	unsigned long pfn;
 	struct hstate *h;
 
@@ -1200,6 +1200,7 @@ void dissolve_free_huge_pages(unsigned l
 		if (order > huge_page_order(h))
 			order = huge_page_order(h);
 	VM_BUG_ON(!IS_ALIGNED(start_pfn, 1 << order));
+	VM_BUG_ON(order == UINT_MAX);
 	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << order)
 		dissolve_free_huge_page(pfn_to_page(pfn));
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-fix-page-flags-build.patch
mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
mm-hugetlb-initialize-order-with-uint_max-in-dissolve_free_huge_pages.patch
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

