From: akpm@linux-foundation.org
Subject: [patch 035/131] mm: drop migrate type checks from
 has_unmovable_pages
Date: Wed, 15 Nov 2017 17:33:22 -0800
Message-ID: <20171116013322.IQo2BLYfQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbdKPBdY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, qiuxishi@huawei.com, ran.wang_1@nxp.com, tony@atomide.com, torvalds@linux-foundation.org, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm: drop migrate type checks from has_unmovable_pages

Michael has noticed that the memory offline tries to migrate kernel code
pages when doing

 echo 0 > /sys/devices/system/memory/memory0/online

The current implementation will fail the operation after several failed
page migration attempts but we shouldn't even attempt to migrate that
memory and fail right away because this memory is clearly not migrateable.
This will become a real problem when we drop the retry loop counter resp.
timeout.

The real problem is in has_unmovable_pages in fact.  We should fail if
there are any non migrateable pages in the area.  In orther to guarantee
that remove the migrate type checks because MIGRATE_MOVABLE is not
guaranteed to contain only migrateable pages.  It is merely a heuristic. 
Similarly MIGRATE_CMA does guarantee that the page allocator doesn't
allocate any non-migrateable pages from the block but CMA allocations
themselves are unlikely to migrateable.  Therefore remove both checks.

[akpm@linux-foundation.org: remove unused local `mt']
Link: http://lkml.kernel.org/r/20171013120013.698-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ran Wang <ran.wang_1@nxp.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages
+++ a/mm/page_alloc.c
@@ -7356,7 +7356,6 @@ bool has_unmovable_pages(struct zone *zo
 			 bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, iter, found;
-	int mt;
 
 	/*
 	 * For avoiding noise data, lru_add_drain_all() should be called
@@ -7364,9 +7363,6 @@ bool has_unmovable_pages(struct zone *zo
 	 */
 	if (zone_idx(zone) == ZONE_MOVABLE)
 		return false;
-	mt = get_pageblock_migratetype(page);
-	if (mt == MIGRATE_MOVABLE || is_migrate_cma(mt))
-		return false;
 
 	pfn = page_to_pfn(page);
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
_
