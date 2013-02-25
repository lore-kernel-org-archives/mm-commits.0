From: akpm@linux-foundation.org
Subject: [merged] mm-fix-return-type-for-functions-nr_free__pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:12 -0800
Message-ID: <20130225205512.E099C5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38603 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3BYUzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:14 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so347653vch.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, ericvh@gmail.com, horms@verge.net.au, ja@ssi.bg, kamezawa.hiroyu@jp.fujitsu.com, lucho@ionkov.net, mel@csn.ul.ie, minchan.kim@gmail.com, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix return type for functions nr_free_*_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-return-type-for-functions-nr_free__pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: fix return type for functions nr_free_*_pages

Currently, the amount of RAM that functions nr_free_*_pages return
is held in unsigned int. But in machines with big memory (exceeding
16TB), the amount may be incorrect because of overflow, so fix it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 mm/page_alloc.c      |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-fix-return-type-for-functions-nr_free__pages include/linux/swap.h
--- a/include/linux/swap.h~mm-fix-return-type-for-functions-nr_free__pages
+++ a/include/linux/swap.h
@@ -225,8 +225,8 @@ struct swap_list_t {
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
 extern unsigned long dirty_balance_reserve;
-extern unsigned int nr_free_buffer_pages(void);
-extern unsigned int nr_free_pagecache_pages(void);
+extern unsigned long nr_free_buffer_pages(void);
+extern unsigned long nr_free_pagecache_pages(void);
 
 /* Definition of global_page_state not available yet */
 #define nr_free_pages() global_page_state(NR_FREE_PAGES)
diff -puN mm/page_alloc.c~mm-fix-return-type-for-functions-nr_free__pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-return-type-for-functions-nr_free__pages
+++ a/mm/page_alloc.c
@@ -2813,13 +2813,13 @@ void free_pages_exact(void *virt, size_t
 }
 EXPORT_SYMBOL(free_pages_exact);
 
-static unsigned int nr_free_zone_pages(int offset)
+static unsigned long nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	/* Just pick one node, since fallback list is circular */
-	unsigned int sum = 0;
+	unsigned long sum = 0;
 
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), GFP_KERNEL);
 
@@ -2836,7 +2836,7 @@ static unsigned int nr_free_zone_pages(i
 /*
  * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
  */
-unsigned int nr_free_buffer_pages(void)
+unsigned long nr_free_buffer_pages(void)
 {
 	return nr_free_zone_pages(gfp_zone(GFP_USER));
 }
@@ -2845,7 +2845,7 @@ EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 /*
  * Amount of free RAM allocatable within all zones
  */
-unsigned int nr_free_pagecache_pages(void)
+unsigned long nr_free_pagecache_pages(void)
 {
 	return nr_free_zone_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
 }
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch

