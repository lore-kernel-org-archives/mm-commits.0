From: akpm@linux-foundation.org
Subject: + memcg-prevent-oom-with-too-many-dirty-pages.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:12:00 -0700
Message-ID: <20120620211200.C6A64A0123@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:46615 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2FTVMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:12:03 -0400
Received: by wibhn6 with SMTP id hn6so269918wib.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:12:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, fengguang.wu@intel.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujtisu.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: memcg: prevent OOM with too many dirty pages
has been added to the -mm tree.  Its filename is
     memcg-prevent-oom-with-too-many-dirty-pages.patch

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
Subject: memcg: prevent OOM with too many dirty pages

The current implementation of dirty pages throttling is not memcg aware
which makes it easy to have memcg LRUs full of dirty pages.  Without
throttling, these LRUs can be scanned faster than the rate of writeback,
leading to memcg OOM conditions when the hard limit is small.

This patch fixes the problem by throttling the allocating process
(possibly a writer) during the hard limit reclaim by waiting on
PageReclaim pages.  We are waiting only for PageReclaim pages because
those are the pages that made one full round over LRU and that means that
the writeback is much slower than scanning.

The solution is far from being ideal - long term solution is memcg aware
dirty throttling - but it is meant to be a band aid until we have a real
fix.  We are seeing this happening during nightly backups which are placed
into containers to prevent from eviction of the real working set.

The change affects only memcg reclaim and only when we encounter
PageReclaim pages which is a signal that the reclaim doesn't catch up on
with the writers so somebody should be throttled.  This could be
potentially unfair because it could be somebody else from the group who
gets throttled on behalf of the writer but as writers need to allocate as
well and they allocate in higher rate the probability that only innocent
processes would be penalized is not that high.

I have tested this change by a simple dd copying /dev/zero to tmpfs or
ext3 running under small memcg (1G copy under 5M, 60M, 300M and 2G
containers) and dd got killed by OOM killer every time.  With the patch I
could run the dd with the same size under 5M controller without any OOM. 
The issue is more visible with slower devices for output.

* With the patch
================
* tmpfs size=2G
---------------
$ vim cgroup_cache_oom_test.sh
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 30.4049 s, 34.5 MB/s
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 31.4561 s, 33.3 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 20.4618 s, 51.2 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 1.42172 s, 738 MB/s

* ext3
------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 27.9547 s, 37.5 MB/s
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 30.3221 s, 34.6 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 24.5764 s, 42.7 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 3.35828 s, 312 MB/s

* Without the patch
===================
* tmpfs size=2G
---------------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
./cgroup_cache_oom_test.sh: line 46:  4668 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 25.4989 s, 41.1 MB/s
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 24.3928 s, 43.0 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 1.49797 s, 700 MB/s

* ext3
------
$ ./cgroup_cache_oom_test.sh 5M
using Limit 5M for group
./cgroup_cache_oom_test.sh: line 46:  4689 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 60M
using Limit 60M for group
./cgroup_cache_oom_test.sh: line 46:  4692 Killed                  dd if=/dev/zero of=$OUT/zero bs=1M count=$count
$ ./cgroup_cache_oom_test.sh 300M
using Limit 300M for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 20.248 s, 51.8 MB/s
$ ./cgroup_cache_oom_test.sh 2G
using Limit 2G for group
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 2.85201 s, 368 MB/s

[akpm@linux-foundation.org: tweak changelog, reordered the test to optimize for CONFIG_CGROUP_MEM_RES_CTLR=n]
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~memcg-prevent-from-oom-with-too-many-dirty-pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-prevent-from-oom-with-too-many-dirty-pages
+++ a/mm/vmscan.c
@@ -720,9 +720,19 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		if (PageWriteback(page)) {
-			nr_writeback++;
-			unlock_page(page);
-			goto keep;
+			/*
+			 * memcg doesn't have any dirty pages throttling so we
+			 * could easily OOM just because too many pages are in
+			 * writeback from reclaim and there is nothing else to
+			 * reclaim.
+			 */
+			if (!global_reclaim(sc) && PageReclaim(page))
+				wait_on_page_writeback(page);
+			else {
+				nr_writeback++;
+				unlock_page(page);
+				goto keep;
+			}
 		}
 
 		references = page_check_references(page, sc);
_
Subject: Subject: memcg: prevent OOM with too many dirty pages

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
memcg-remove-check-for-signal_pending-during-rmdir.patch
memcg-clean-up-force_empty_list-return-value-check.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch

