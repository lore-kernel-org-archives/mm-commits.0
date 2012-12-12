From: akpm@linux-foundation.org
Subject: [folded-merged] mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:40:43 -0800
Message-ID: <20121212214044.1A63F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48810 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LLVkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:40:45 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so129950ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:40:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris2553@googlemail.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, liuj97@gmail.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix
has been removed from the -mm tree.  Its filename was
     mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch

This patch was dropped because it was folded into mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix

mark calc_memmap_size __paging_init

Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix
+++ a/mm/page_alloc.c
@@ -4542,8 +4542,8 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-static unsigned long calc_memmap_size(unsigned long spanned_pages,
-				      unsigned long present_pages)
+static unsigned long __paginginit calc_memmap_size(unsigned long spanned_pages,
+						   unsigned long present_pages)
 {
 	unsigned long pages = spanned_pages;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

