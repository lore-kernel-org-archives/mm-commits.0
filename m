From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch added to -mm tree
Date: Tue, 27 Dec 2011 15:43:57 -0800
Message-ID: <20111227234357.A73FC1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:41000 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1L0XoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 18:44:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix non-atomic enqueue of huge page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: fix non-atomic enqueue of huge page

If a huge page is enqueued under the protection of hugetlb_lock, then the
operation is atomic and safe.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>		[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-non-atomic-enqueue-of-huge-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-non-atomic-enqueue-of-huge-page
+++ a/mm/hugetlb.c
@@ -901,7 +901,6 @@ retry:
 	h->resv_huge_pages += delta;
 	ret = 0;
 
-	spin_unlock(&hugetlb_lock);
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
@@ -915,6 +914,7 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+	spin_unlock(&hugetlb_lock);
 
 	/* Free unnecessary surplus pages to the buddy allocator */
 free:
_
Subject: Subject: mm: hugetlb: fix non-atomic enqueue of huge page

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch

