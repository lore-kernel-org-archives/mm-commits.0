From: akpm@linux-foundation.org
Subject: +
 mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 12:19:42 -0700
Message-ID: <20200624191942.JRpHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTTn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, naoya.horiguchi@nec.com, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, osalvador@suse.de


The patch titled
     Subject: mm,hwpoison: unify THP handling for hard and soft offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: unify THP handling for hard and soft offline

Place the THP's page handling in a helper and use it from both hard and
soft-offline machinery, so we get rid of some duplicated code.

Link: http://lkml.kernel.org/r/20200624150137.7052-11-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

 mm/memory-failure.c |   48 +++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-unify-thp-handling-for-hard-and-soft-offline
+++ a/mm/memory-failure.c
@@ -1103,6 +1103,25 @@ static int identify_page_state(unsigned
 	return page_action(ps, p, pfn);
 }
 
+static int try_to_split_thp_page(struct page *page, const char *msg)
+{
+	lock_page(page);
+	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
+		unsigned long pfn = page_to_pfn(page);
+
+		unlock_page(page);
+		if (!PageAnon(page))
+			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
+		else
+			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+		put_page(page);
+		return -EBUSY;
+	}
+	unlock_page(page);
+
+	return 0;
+}
+
 static int memory_failure_hugetlb(unsigned long pfn, int flags)
 {
 	struct page *p = pfn_to_page(pfn);
@@ -1325,21 +1344,8 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (PageTransHuge(hpage)) {
-		lock_page(p);
-		if (!PageAnon(p) || unlikely(split_huge_page(p))) {
-			unlock_page(p);
-			if (!PageAnon(p))
-				pr_err("Memory failure: %#lx: non anonymous thp\n",
-					pfn);
-			else
-				pr_err("Memory failure: %#lx: thp split failed\n",
-					pfn);
-			if (TestClearPageHWPoison(p))
-				num_poisoned_pages_dec();
-			put_page(p);
+		if (try_to_split_thp_page(p, "Memory Failure") < 0)
 			return -EBUSY;
-		}
-		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
 
@@ -1847,19 +1853,9 @@ static int soft_offline_in_use_page(stru
 	int mt;
 	struct page *hpage = compound_head(page);
 
-	if (!PageHuge(page) && PageTransHuge(hpage)) {
-		lock_page(page);
-		if (!PageAnon(page) || unlikely(split_huge_page(page))) {
-			unlock_page(page);
-			if (!PageAnon(page))
-				pr_info("soft offline: %#lx: non anonymous thp\n", page_to_pfn(page));
-			else
-				pr_info("soft offline: %#lx: thp split failed\n", page_to_pfn(page));
-			put_page(page);
+	if (!PageHuge(page) && PageTransHuge(hpage))
+		if (try_to_split_thp_page(page, "soft offline") < 0)
 			return -EBUSY;
-		}
-		unlock_page(page);
-	}
 
 	/*
 	 * Setting MIGRATE_ISOLATE here ensures that the page will be linked
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
