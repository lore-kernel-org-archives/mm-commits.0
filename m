From: akpm@linux-foundation.org
Subject: + mmhwpoison-cleanup-unused-pagehuge-check.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 12:19:22 -0700
Message-ID: <20200624191922.J1r-M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, osalvador@suse.de, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com


The patch titled
     Subject: mm,hwpoison: cleanup unused PageHuge() check
has been added to the -mm tree.  Its filename is
     mmhwpoison-cleanup-unused-pagehuge-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-cleanup-unused-pagehuge-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: cleanup unused PageHuge() check

Patch series "HWPOISON: soft offline rework", v3.


This patch (of 15):

Drop the PageHuge check, which is dead code since memory_failure() forks
into memory_failure_hugetlb() for hugetlb pages.

memory_failure() and memory_failure_hugetlb() shares some functions like
hwpoison_user_mappings() and identify_page_state(), so they should
properly handle 4kB page, thp, and hugetlb.

Link: http://lkml.kernel.org/r/20200624150137.7052-1-nao.horiguchi@gmail.com
Link: http://lkml.kernel.org/r/20200624150137.7052-2-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-cleanup-unused-pagehuge-check
+++ a/mm/memory-failure.c
@@ -1382,10 +1382,7 @@ int memory_failure(unsigned long pfn, in
 	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
 	 * correctly, we save a copy of the page flags at this time.
 	 */
-	if (PageHuge(p))
-		page_flags = hpage->flags;
-	else
-		page_flags = p->flags;
+	page_flags = p->flags;
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
