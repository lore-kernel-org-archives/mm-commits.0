From: akpm@linux-foundation.org
Subject: + mmhwpoison-remove-mf_count_increased.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 12:19:37 -0700
Message-ID: <20200624191937.SNAep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405057AbgFXTTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zeil@yandex-team.ru, tony.luck@intel.com, osalvador@suse.de, mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com, aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com


The patch titled
     Subject: mm,hwpoison: remove MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-mf_count_increased.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-mf_count_increased.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-mf_count_increased.patch

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
Subject: mm,hwpoison: remove MF_COUNT_INCREASED

Now there's no user of MF_COUNT_INCREASED, so we can safely remove it from
all calling points.

Link: http://lkml.kernel.org/r/20200624150137.7052-9-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
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

 include/linux/mm.h  |    7 +++----
 mm/memory-failure.c |   14 +++-----------
 2 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-remove-mf_count_increased
+++ a/include/linux/mm.h
@@ -2985,10 +2985,9 @@ void register_page_bootmem_memmap(unsign
 				  unsigned long nr_pages);
 
 enum mf_flags {
-	MF_COUNT_INCREASED = 1 << 0,
-	MF_ACTION_REQUIRED = 1 << 1,
-	MF_MUST_KILL = 1 << 2,
-	MF_SOFT_OFFLINE = 1 << 3,
+	MF_ACTION_REQUIRED = 1 << 0,
+	MF_MUST_KILL = 1 << 1,
+	MF_SOFT_OFFLINE = 1 << 2,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/mm/memory-failure.c~mmhwpoison-remove-mf_count_increased
+++ a/mm/memory-failure.c
@@ -1118,7 +1118,7 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		/*
 		 * Check "filter hit" and "race with other subpage."
 		 */
@@ -1314,7 +1314,7 @@ int memory_failure(unsigned long pfn, in
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
 			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 			return 0;
@@ -1354,10 +1354,7 @@ int memory_failure(unsigned long pfn, in
 	shake_page(p, 0);
 	/* shake_page could have turned it free. */
 	if (!PageLRU(p) && is_free_buddy_page(p)) {
-		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
+		action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
 		return 0;
 	}
 
@@ -1655,9 +1652,6 @@ static int __get_any_page(struct page *p
 {
 	int ret;
 
-	if (flags & MF_COUNT_INCREASED)
-		return 1;
