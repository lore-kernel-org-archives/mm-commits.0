From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-never-isolate-more-pages-than-necessary.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:51 -0700
Message-ID: <55f08cab.cyPj/q0H5BAI+bWP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbbIITqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.cz, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: never isolate more pages than necessary
has been removed from the -mm tree.  Its filename was
     mm-vmscan-never-isolate-more-pages-than-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: never isolate more pages than necessary

If transparent huge pages are enabled, we can isolate many more pages than
we actually need to scan, because we count both single and huge pages
equally in isolate_lru_pages().

Since commit 5bc7b8aca942d ("mm: thp: add split tail pages to shrink page
list in page reclaim"), we scan all the tail pages immediately after a
huge page split (see shrink_page_list()).  As a result, we can reclaim up
to SWAP_CLUSTER_MAX * HPAGE_PMD_NR (512 MB) in one run!

This is easy to catch on memcg reclaim with zswap enabled.  The latter
makes swapout instant so that if we happen to scan an unreferenced huge
page we will evict both its head and tail pages immediately, which is
likely to result in excessive reclaim.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-never-isolate-more-pages-than-necessary mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-never-isolate-more-pages-than-necessary
+++ a/mm/vmscan.c
@@ -1359,7 +1359,8 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long scan;
 
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
+	for (scan = 0; scan < nr_to_scan && nr_taken < nr_to_scan &&
+					!list_empty(src); scan++) {
 		struct page *page;
 		int nr_pages;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
memcg-add-page_cgroup_ino-helper-fix.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
mmu-notifier-add-clear_young-callback-fix.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix.patch
proc-add-kpageidle-file-fix-2.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

