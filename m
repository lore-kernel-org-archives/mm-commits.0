From: akpm@linux-foundation.org
Subject: [folded] memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:32:46 -0700
Message-ID: <20120731233246.AD3AFA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34356 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2GaXcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:32:47 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4819432obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:32:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaditya.kumar.30@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-kswapd-looping-forever-problem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix

fix CONFIG_MEMORY_ISOLATION=n build:

mm/page_alloc.c: In function 'free_area_init_core':
mm/page_alloc.c:4430: error: 'struct zone' has no member named 'nr_pageblock_isolate'

Is this really necessary?  Does the zone start out all-zeroes?  If not, can we
make it do so?

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix
+++ a/mm/page_alloc.c
@@ -4424,7 +4424,9 @@ static void __paginginit free_area_init_
 		lruvec_init(&zone->lruvec, zone);
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
+#ifdef CONFIG_MEMORY_ISOLATION
 		zone->nr_pageblock_isolate = 0;
+#endif
 		if (!size)
 			continue;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

