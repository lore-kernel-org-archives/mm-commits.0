From: akpm@linux-foundation.org
Subject: + mm-fix-return-type-for-functions-nr_free__pages.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:08 -0800
Message-ID: <20130206224909.503E05A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:54906 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3BFWtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:11 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so211001yen.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, ericvh@gmail.com, horms@verge.net.au, ja@ssi.bg, kamezawa.hiroyu@jp.fujitsu.com, lucho@ionkov.net, mel@csn.ul.ie, minchan.kim@gmail.com, rminnich@sandia.gov


The patch titled
     Subject: mm: fix return type for functions nr_free_*_pages
has been added to the -mm tree.  Its filename is
     mm-fix-return-type-for-functions-nr_free__pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2812,13 +2812,13 @@ void free_pages_exact(void *virt, size_t
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
 
@@ -2835,7 +2835,7 @@ static unsigned int nr_free_zone_pages(i
 /*
  * Amount of free RAM allocatable within ZONE_DMA and ZONE_NORMAL
  */
-unsigned int nr_free_buffer_pages(void)
+unsigned long nr_free_buffer_pages(void)
 {
 	return nr_free_zone_pages(gfp_zone(GFP_USER));
 }
@@ -2844,7 +2844,7 @@ EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
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

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

