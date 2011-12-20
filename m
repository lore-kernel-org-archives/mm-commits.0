From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:17:11 -0800
Message-ID: <20111220231712.B59C720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:32815 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LTXRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:17:15 -0500
Received: by eaad1 with SMTP id d1so204076eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:17:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: hugetlb: fix pgoff computation when unmapping page from vma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: fix pgoff computation when unmapping page from vma

The computation for pgoff is incorrect, at least with

	(vma->vm_pgoff >> PAGE_SHIFT)

involved.  It is fixed with the available method if HPAGE_SIZE is
concerned in page cache lookup.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma
+++ a/mm/hugetlb.c
@@ -2315,8 +2315,7 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
-		+ (vma->vm_pgoff >> PAGE_SHIFT);
+	pgoff = linear_hugepage_index(vma, address);
 	mapping = (struct address_space *)page_private(page);
 
 	/*
_
Subject: Subject: mm: hugetlb: fix pgoff computation when unmapping page from vma

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch

