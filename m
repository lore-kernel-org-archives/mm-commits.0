From: akpm@linux-foundation.org
Subject: + hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
 added to -mm tree
Date: Thu, 21 May 2015 13:49:00 -0700
Message-ID: <555e44bc.7kkkJW9iY4zI7xyW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbEUUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 May 2015 16:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, mgorman@suse.de, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: do not account hugetlb pages as NR_FILE_PAGES
has been added to the -mm tree.  Its filename is
     hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: do not account hugetlb pages as NR_FILE_PAGES

hugetlb pages uses add_to_page_cache to track shared mappings.  This is OK
from the data structure point of view but it is less so from the
NR_FILE_PAGES accounting:

	- huge pages are accounted as 4k which is clearly wrong
	- this counter is used as the amount of the reclaimable page
	  cache which is incorrect as well because hugetlb pages are
	  special and not reclaimable
	- the counter is then exported to userspace via /proc/meminfo
	  (in Cached:), /proc/vmstat and /proc/zoneinfo as
	  nr_file_pages which is confusing at least:
	  Cached:          8883504 kB
	  HugePages_Free:     8348
	  ...
	  Cached:          8916048 kB
	  HugePages_Free:      156
	  ...
	  thats 8192 huge pages allocated which is ~16G accounted as 32M

There are usually not that many huge pages in the system for this to make
any visible difference e.g.  by fooling __vm_enough_memory or
zone_pagecache_reclaimable.

Fix this by special casing huge pages in both __delete_from_page_cache and
__add_to_page_cache_locked.  replace_page_cache_page is currently only
used by fuse and that shouldn't touch hugetlb pages AFAICS but it is more
robust to check for special casing there as well.

Hugetlb pages shouldn't get to any other paths where we do accounting:
	- migration - we have a special handling via
	  hugetlbfs_migrate_page
	- shmem - doesn't handle hugetlb pages directly even for
	  SHM_HUGETLB resp. MAP_HUGETLB
	- swapcache - hugetlb is not swapable

This has a user visible effect but I believe it is reasonable because the
previously exported number is simply bogus.

An alternative would be to account hugetlb pages with their real size and
treat them similar to shmem.  But this has some drawbacks.

First we would have to special case in kernel users of NR_FILE_PAGES and
considering how hugetlb is special we would have to do it everywhere.  We
do not want Cached exported by /proc/meminfo to include it because the
value would be even more misleading.

__vm_enough_memory and zone_pagecache_reclaimable would have to do the
same thing because those pages are simply not reclaimable.  The correction
is even not trivial because we would have to consider all active hugetlb
page sizes properly.  Users of the counter outside of the kernel would
have to do the same.

So the question is why to account something that needs to be basically
excluded for each reasonable usage.  This doesn't make much sense to me.

It seems that this has been broken since hugetlb was introduced but I
haven't checked the whole history.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages mm/filemap.c
--- a/mm/filemap.c~hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages
+++ a/mm/filemap.c
@@ -196,7 +196,9 @@ void __delete_from_page_cache(struct pag
 	page->mapping = NULL;
 	/* Leave page->index set: truncation lookup relies upon it */
 
-	__dec_zone_page_state(page, NR_FILE_PAGES);
+	/* hugetlb pages do not participate into page cache accounting. */
+	if (!PageHuge(page))
+		__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
 		__dec_zone_page_state(page, NR_SHMEM);
 	BUG_ON(page_mapped(page));
@@ -483,7 +485,13 @@ int replace_page_cache_page(struct page
 		error = radix_tree_insert(&mapping->page_tree, offset, new);
 		BUG_ON(error);
 		mapping->nrpages++;
-		__inc_zone_page_state(new, NR_FILE_PAGES);
+
+		/*
+		 * hugetlb pages do not participate into page cache
+		 * accounting.
+		 */
+		if (!PageHuge(new))
+			__inc_zone_page_state(new, NR_FILE_PAGES);
 		if (PageSwapBacked(new))
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irq(&mapping->tree_lock);
@@ -575,7 +583,10 @@ static int __add_to_page_cache_locked(st
 	radix_tree_preload_end();
 	if (unlikely(error))
 		goto err_insert;
-	__inc_zone_page_state(page, NR_FILE_PAGES);
+
+	/* hugetlb pages do not participate into page cache accounting. */
+	if (!huge)
+		__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
 	if (!huge)
 		mem_cgroup_commit_charge(page, memcg, false);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-meminit-inline-some-helper-functions-fix2.patch
mm-only-define-hashdist-variable-when-needed.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
rename-reclaim_swap-to-reclaim_unmap.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
exitstats-obey-this-comment.patch
linux-next.patch

