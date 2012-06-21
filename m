From: akpm@linux-foundation.org
Subject: + mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch added to -mm tree
Date: Thu, 21 Jun 2012 13:58:20 -0700
Message-ID: <20120621205821.0369DA04A3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40001 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab2FUU6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 16:58:22 -0400
Received: by qabg24 with SMTP id g24so262982qab.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 13:58:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: mm, thp: abort compaction if migration page cannot be charged to memcg
has been added to the -mm tree.  Its filename is
     mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: abort compaction if migration page cannot be charged to memcg

If page migration cannot charge the temporary page to the memcg,
migrate_pages() will return -ENOMEM.  This isn't considered in memory
compaction however, and the loop continues to iterate over all pageblocks
trying to isolate and migrate pages.  If a small number of very large
memcgs happen to be oom, however, these attempts will mostly be futile
leading to an enormous amout of cpu consumption due to the page migration
failures.  

This patch will short circuit and fail memory compaction if
migrate_pages() returns -ENOMEM.  COMPACT_PARTIAL is returned in case some
migrations were successful so that the page allocator will retry.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg mm/compaction.c
--- a/mm/compaction.c~mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg
+++ a/mm/compaction.c
@@ -701,8 +701,11 @@ static int compact_zone(struct zone *zon
 		if (err) {
 			putback_lru_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
+			if (err == -ENOMEM) {
+				ret = COMPACT_PARTIAL;
+				goto out;
+			}
 		}
-
 	}
 
 out:
_
Subject: Subject: mm, thp: abort compaction if migration page cannot be charged to memcg

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
slab-move-full-state-transition-to-an-initcall.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
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
mm-buddy-get-the-allownodes-for-dump-at-once.patch

