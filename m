From: akpm@linux-foundation.org
Subject: +
 mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 12:19:53 -0700
Message-ID: <20200624191953.O39wQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTT4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, naoya.horiguchi@nec.com, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, osalvador@suse.de


The patch titled
     Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

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
Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline

Currently, there is an inconsistency when calling soft-offline from
different paths on a page that is already poisoned.

1) madvise:

        madvise_inject_error skips any poisoned page and continues
        the loop.
        If that was the only page to madvise, it returns 0.

2) /sys/devices/system/memory/:

        When calling soft_offline_page_store()->soft_offline_page(),
        we return -EBUSY in case the page is already poisoned.
        This is inconsistent with a) the above example and b)
        memory_failure, where we return 0 if the page was poisoned.

Fix this by dropping the PageHWPoison() check in madvise_inject_error,
and let soft_offline_page return 0 if it finds the page already poisoned.

Please, note that this represents a user-api change, since now the
return error when calling soft_offline_page_store()->soft_offline_page()
will be different.

Link: http://lkml.kernel.org/r/20200624150137.7052-15-nao.horiguchi@gmail.com
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

 mm/madvise.c        |    3 ---
 mm/memory-failure.c |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/madvise.c
@@ -902,9 +902,6 @@ static int madvise_inject_error(int beha
 		 */
 		put_page(page);
 
-		if (PageHWPoison(page))
-			continue;
-
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/memory-failure.c
@@ -1800,7 +1800,7 @@ static int __soft_offline_page(struct pa
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	if (!PageHuge(page))
@@ -1901,7 +1901,7 @@ int soft_offline_page(unsigned long pfn)
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	get_online_mems();
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
