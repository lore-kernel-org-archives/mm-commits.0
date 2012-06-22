From: akpm@linux-foundation.org
Subject: + mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch added to -mm tree
Date: Fri, 22 Jun 2012 13:20:21 -0700
Message-ID: <20120622202021.C1598A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:50543 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FVUUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 16:20:23 -0400
Received: by qcha6 with SMTP id a6so261578qch.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 13:20:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, rientjes@google.com


The patch titled
     Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again
has been added to the -mm tree.  Its filename is
     mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again

commit 2ff754fa8f ("mm: clear pages_scanned only if draining a pcp adds
pages to the buddy allocator again") fixed one free_pcppages_bulk()
misuse.  But two another miuse still exist.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again
+++ a/mm/page_alloc.c
@@ -1157,8 +1157,10 @@ void drain_zone_pages(struct zone *zone,
 		to_drain = pcp->batch;
 	else
 		to_drain = pcp->count;
-	free_pcppages_bulk(zone, to_drain, pcp);
-	pcp->count -= to_drain;
+	if (to_drain > 0) {
+		free_pcppages_bulk(zone, to_drain, pcp);
+		pcp->count -= to_drain;
+	}
 	local_irq_restore(flags);
 }
 #endif
@@ -3914,7 +3916,8 @@ static int __zone_pcp_update(void *data)
 		pcp = &pset->pcp;
 
 		local_irq_save(flags);
-		free_pcppages_bulk(zone, pcp->count, pcp);
+		if (pcp->count > 0)
+			free_pcppages_bulk(zone, pcp->count, pcp);
 		setup_pageset(pset, batch);
 		local_irq_restore(flags);
 	}
_
Subject: Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
mm-oom-do-not-schedule-if-current-has-been-killed.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch

