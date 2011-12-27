From: akpm@linux-foundation.org
Subject: + mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch added to -mm tree
Date: Tue, 27 Dec 2011 15:49:44 -0800
Message-ID: <20111227234945.1E24520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51539 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1L0Xtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 18:49:47 -0500
Received: by eaak10 with SMTP id k10so154776eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 15:49:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, schwidefsky@de.ibm.com


The patch titled
     Subject: mm/hugetlb.c: avoid bogus counter of surplus huge page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch

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
Subject: mm/hugetlb.c: avoid bogus counter of surplus huge page

If we have to hand back the newly allocated huge page to page allocator,
for any reason, the changed counter should be recovered.

This affects only s390 at present.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page
+++ a/mm/hugetlb.c
@@ -800,7 +800,7 @@ static struct page *alloc_buddy_huge_pag
 
 	if (page && arch_prepare_hugepage(page)) {
 		__free_pages(page, huge_page_order(h));
-		return NULL;
+		page = NULL;
 	}
 
 	spin_lock(&hugetlb_lock);
_
Subject: Subject: mm/hugetlb.c: avoid bogus counter of surplus huge page

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch

