From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks.patch
 added to -mm tree
Date: Wed, 23 Mar 2016 14:14:42 -0700
Message-ID: <56f30742.I21n0XAHq5UQJcUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbcCWVOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 17:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, guohanjun@huawei.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, kirill@shutemov.name, labbott@redhat.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: prevent merging between isolated and other pageblocks
has been added to the -mm tree.  Its filename is
     mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/page_alloc: prevent merging between isolated and other pageblocks

Hanjun Guo has reported that a CMA stress test causes broken accounting of
CMA and free pages:

> Before the test, I got:
> -bash-4.3# cat /proc/meminfo | grep Cma
> CmaTotal:         204800 kB
> CmaFree:          195044 kB
>
>
> After running the test:
> -bash-4.3# cat /proc/meminfo | grep Cma
> CmaTotal:         204800 kB
> CmaFree:         6602584 kB
>
> So the freed CMA memory is more than total..
>
> Also the the MemFree is more than mem total:
>
> -bash-4.3# cat /proc/meminfo
> MemTotal:       16342016 kB
> MemFree:        22367268 kB
> MemAvailable:   22370528 kB

Laura Abbott has confirmed the issue and suspected the freepage accounting
rewrite around 3.18/4.0 by Joonsoo Kim.  Joonsoo had a theory that this is
caused by unexpected merging between MIGRATE_ISOLATE and MIGRATE_CMA
pageblocks:

> CMA isolates MAX_ORDER aligned blocks, but, during the process,
> partialy isolated block exists. If MAX_ORDER is 11 and
> pageblock_order is 9, two pageblocks make up MAX_ORDER
> aligned block and I can think following scenario because pageblock
> (un)isolation would be done one by one.
>
> (each character means one pageblock. 'C', 'I' means MIGRATE_CMA,
> MIGRATE_ISOLATE, respectively.
>
> CC -> IC -> II (Isolation)
> II -> CI -> CC (Un-isolation)
>
> If some pages are freed at this intermediate state such as IC or CI,
> that page could be merged to the other page that is resident on
> different type of pageblock and it will cause wrong freepage count.

This was supposed to be prevented by CMA operating on MAX_ORDER blocks,
but since it doesn't hold the zone->lock between pageblocks, a race window
does exist.

It's also likely that unexpected merging can occur between MIGRATE_ISOLATE
and non-CMA pageblocks.  This should be prevented in __free_one_page()
since commit 3c605096d315 ("mm/page_alloc: restrict max order of merging
on isolated pageblock").  However, we only check the migratetype of the
pageblock where buddy merging has been initiated, not the migratetype of
the buddy pageblock (or group of pageblocks) which can be MIGRATE_ISOLATE.

Joonsoo has suggested checking for buddy migratetype as part of
page_is_buddy(), but that would add extra checks in allocator hotpath and
bloat-o-meter has shown significant code bloat (the function is inline).

This patch reduces the bloat at some expense of more complicated code. 
The buddy-merging while-loop in __free_one_page() is initially bounded to
pageblock_border and without any migratetype checks.  The checks are
placed outside, bumping the max_order if merging is allowed, and returning
to the while-loop with a statement which can't be possibly considered
harmful.

This fixes the accounting bug and also removes the arguably weird state in
the original commit 3c605096d315 where buddies could be left unmerged.

Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Link: https://lkml.org/lkml/2016/3/2/280
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Debugged-by: Laura Abbott <labbott@redhat.com>
Debugged-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>	[3.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks
+++ a/mm/page_alloc.c
@@ -692,34 +692,28 @@ static inline void __free_one_page(struc
 	unsigned long combined_idx;
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
-	unsigned int max_order = MAX_ORDER;
+	unsigned int max_order;
+
+	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
 
 	VM_BUG_ON(migratetype == -1);
-	if (is_migrate_isolate(migratetype)) {
-		/*
-		 * We restrict max order of merging to prevent merge
-		 * between freepages on isolate pageblock and normal
-		 * pageblock. Without this, pageblock isolation
-		 * could cause incorrect freepage accounting.
-		 */
-		max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
-	} else {
+	if (likely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
-	}
 
-	page_idx = pfn & ((1 << max_order) - 1);
+	page_idx = pfn & ((1 << MAX_ORDER) - 1);
 
 	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
+continue_merging:
 	while (order < max_order - 1) {
 		buddy_idx = __find_buddy_index(page_idx, order);
 		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
-			break;
+			goto done_merging;
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -736,6 +730,32 @@ static inline void __free_one_page(struc
 		page_idx = combined_idx;
 		order++;
 	}
+	if (max_order < MAX_ORDER) {
+		/* If we are here, it means order is >= pageblock_order.
+		 * We want to prevent merge between freepages on isolate
+		 * pageblock and normal pageblock. Without this, pageblock
+		 * isolation could cause incorrect freepage or CMA accounting.
+		 *
+		 * We don't want to hit this code for the more frequent
+		 * low-order merging.
+		 */
+		if (unlikely(has_isolate_pageblock(zone))) {
+			int buddy_mt;
+
+			buddy_idx = __find_buddy_index(page_idx, order);
+			buddy = page + (buddy_idx - page_idx);
+			buddy_mt = get_pageblock_migratetype(buddy);
+
+			if (migratetype != buddy_mt
+					&& (is_migrate_isolate(migratetype) ||
+						is_migrate_isolate(buddy_mt)))
+				goto done_merging;
+		}
+		max_order++;
+		goto continue_merging;
+	}
+
+done_merging:
 	set_page_order(page, order);
 
 	/*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-prevent-merging-between-isolated-and-other-pageblocks.patch

