From: akpm@linux-foundation.org
Subject: + mm-memory-failure-me_huge_page-does-nothing-for-thp.patch added to -mm tree
Date: Tue, 12 May 2015 15:00:46 -0700
Message-ID: <5552780e.ddKdFjRrKnpoNo70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbbELWAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 18:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: me_huge_page() does nothing for thp
has been added to the -mm tree.  Its filename is
     mm-memory-failure-me_huge_page-does-nothing-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-me_huge_page-does-nothing-for-thp.patch

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
Subject: mm/memory-failure: me_huge_page() does nothing for thp

memory_failure() is supposed not to handle thp itself, but to split it. 
But if something were wrong and page_action() were called on thp,
me_huge_page() (action routine for hugepages) should be better to take no
action, rather than to take wrong action prepared for hugetlb (which
triggers BUG_ON().)

This change is for potential problems, but makes sense to me because thp
is an actively developing feature and this code path can be open in the
future.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory-failure.c~mm-memory-failure-me_huge_page-does-nothing-for-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-me_huge_page-does-nothing-for-thp
+++ a/mm/memory-failure.c
@@ -744,6 +744,10 @@ static int me_huge_page(struct page *p,
 {
 	int res = 0;
 	struct page *hpage = compound_head(p);
+
+	if (!PageHuge(hpage))
+		return MF_DELAYED;
+
 	/*
 	 * We can safely recover from error on free or reserved (i.e.
 	 * not in-use) hugepage by dequeuing it from freelist.
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

