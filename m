From: akpm@linux-foundation.org
Subject: + mm-vmscan-never-isolate-more-pages-than-necessary.patch added
 to -mm tree
Date: Mon, 03 Aug 2015 14:27:28 -0700
Message-ID: <55bfdcc0.TXvVfKlSIQKSimuF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbbHCV13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2015 17:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: never isolate more pages than necessary
has been added to the -mm tree.  Its filename is
     mm-vmscan-never-isolate-more-pages-than-necessary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-never-isolate-more-pages-than-necessary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-never-isolate-more-pages-than-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -1356,7 +1356,8 @@ static unsigned long isolate_lru_pages(u
 	unsigned long nr_taken = 0;
 	unsigned long scan;
 
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
+	for (scan = 0; scan < nr_to_scan && nr_taken < nr_to_scan &&
+					!list_empty(src); scan++) {
 		struct page *page;
 		int nr_pages;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

user_ns-use-correct-check-for-single-threadedness.patch
memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-move-memcg_proto_active-from-sockh.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
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
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

