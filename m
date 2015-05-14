From: akpm@linux-foundation.org
Subject: +
 mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch added to -mm tree
Date: Thu, 14 May 2015 14:06:46 -0700
Message-ID: <55550e66.KhE7dcICeLnzCO/J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422731AbbENVGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 17:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2
has been added to the -mm tree.  Its filename is
     mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch

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
Subject: mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2
+++ a/mm/memory-failure.c
@@ -1099,12 +1099,12 @@ int memory_failure(unsigned long pfn, in
 
 	if (!PageHuge(p) && PageTransHuge(hpage)) {
 		if (!PageAnon(hpage)) {
-			pr_info("MCE: %#lx: non anonymous thp", pfn);
+			pr_err("MCE: %#lx: non anonymous thp\n", pfn);
 			put_page(p);
 			return -EBUSY;
 		}
 		if (unlikely(split_huge_page(hpage))) {
-			pr_info("MCE: %#lx: thp split failed", pfn);
+			pr_err("MCE: %#lx: thp split failed\n", pfn);
 			put_page(p);
 			return -EBUSY;
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
mm-memory-failure-split-thp-earlier-in-memory-error-handling-v2.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-v2.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
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

