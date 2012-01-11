From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:13 -0800
Message-ID: <20120111212814.28EB4200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54553 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037Ab2AKV2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:16 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44236eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix pgoff computation when unmapping page from vma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: hugetlb: fix pgoff computation when unmapping page from vma

The computation for pgoff is incorrect, at least with

	(vma->vm_pgoff >> PAGE_SHIFT)

involved.  It is fixed with the available method if HPAGE_SIZE is
concerned in page cache lookup.

[akpm@linux-foundation.org: use vma_hugecache_offset() directly, per Michal]
Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
+	pgoff = vma_hugecache_offset(h, vma, address);
 	mapping = (struct address_space *)page_private(page);
 
 	/*
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

