From: akpm@linux-foundation.org
Subject: +
 mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 19:14:36 -0700
Message-ID: <20200701021436.x4q_T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGACOi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, osalvador@suse.de, naresh.kamboju@linaro.org, naoya.horiguchi@nec.com, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, nao.horiguchi@gmail.com


The patch titled
     Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix

fix arm64 build

page_handle_poison() is now defined in #ifdef CONFIG_HWPOISON_INJECT block,
which is not correct because this function is used in non-injection code
path.  I'd like to move this function out of the block and it affects
multiple patches in this series, so maybe I have to update/resend the whole
series, but I like to wait for a few days for other reviews, so for quick
fix for linux-next I suggest the following one.

Link: http://lkml.kernel.org/r/20200628065409.GA546944@u2004
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   64 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
+++ a/mm/memory-failure.c
@@ -78,38 +78,6 @@ EXPORT_SYMBOL_GPL(hwpoison_filter_dev_mi
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
 EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
 
-static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
-{
-	if (release) {
-		put_page(page);
-		drain_all_pages(page_zone(page));
-	}
-
-	if (hugepage_or_freepage) {
-		/*
-		 * Doing this check for free pages is also fine since dissolve_free_huge_page
-		 * returns 0 for non-hugetlb pages as well.
-		 */
-		if (dissolve_free_huge_page(page) || !take_page_off_buddy(page))
-		/*
-		 * The hugetlb page can end up being enqueued back into
-		 * the freelists by means of:
-		 * unmap_and_move_huge_page
-		 *  putback_active_hugepage
-		 *   put_page->free_huge_page
-		 *    enqueue_huge_page
-		 * If this happens, we might lose the race against an allocation.
-		 */
-			return false;
-	}
-
-	SetPageHWPoison(page);
-	page_ref_inc(page);
-	num_poisoned_pages_inc();
-
-	return true;
-}
-
 static int hwpoison_filter_dev(struct page *p)
 {
 	struct address_space *mapping;
@@ -209,6 +177,38 @@ static bool page_handle_poison(struct pa
 
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
+static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
+{
+	if (release) {
+		put_page(page);
+		drain_all_pages(page_zone(page));
+	}
+
+	if (hugepage_or_freepage) {
+		/*
+		 * Doing this check for free pages is also fine since dissolve_free_huge_page
+		 * returns 0 for non-hugetlb pages as well.
+		 */
+		if (dissolve_free_huge_page(page) || !take_page_off_buddy(page))
+		/*
+		 * The hugetlb page can end up being enqueued back into
+		 * the freelists by means of:
+		 * unmap_and_move_huge_page
+		 *  putback_active_hugepage
+		 *   put_page->free_huge_page
+		 *    enqueue_huge_page
+		 * If this happens, we might lose the race against an allocation.
+		 */
+			return false;
+	}
+
+	SetPageHWPoison(page);
+	page_ref_inc(page);
+	num_poisoned_pages_inc();
+
+	return true;
+}
+
 /*
  * Kill all processes that have a poisoned page mapped and then isolate
  * the page.
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
