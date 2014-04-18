From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch added to -mm tree
Date: Fri, 18 Apr 2014 15:10:51 -0700
Message-ID: <5351a2eb.7WHFkRe3kMTKCN72%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbaDRWKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ytk.lee@samsung.com, riel@redhat.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, m.szyprowski@samsung.com, kosaki.motohiro@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hughd@google.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: + mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch added to -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,hughd@google.com,iamjoonsoo.kim@lge.com,kosaki.motohiro@jp.fujitsu.com,m.szyprowski@samsung.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,riel@redhat.com,ytk.lee@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:10:51 -0700


The patch titled
     Subject: mm/page_alloc: DEBUG_VM checks for free_list placement of CMA and RESERVE pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

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
Subject: mm/page_alloc: DEBUG_VM checks for free_list placement of CMA and RESERVE pages

For the MIGRATE_RESERVE pages, it is important they do not get misplaced
on free_list of other migratetype, otherwise the whole MIGRATE_RESERVE
pageblock might be changed to other migratetype in
try_to_steal_freepages().  For MIGRATE_CMA, the pages also must not go to
a different free_list, otherwise they could get allocated as unmovable and
result in CMA failure.

This is ensured by setting the freepage_migratetype appropriately when
placing pages on pcp lists, and using the information when releasing them
back to free_list.  It is also assumed that CMA and RESERVE pageblocks are
created only in the init phase.  This patch adds DEBUG_VM checks to catch
any regressions introduced for this invariant.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 +++++++++++++++++++
 mm/page_alloc.c    |    3 +++
 2 files changed, 22 insertions(+)

diff -puN include/linux/mm.h~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages
+++ a/include/linux/mm.h
@@ -288,6 +288,25 @@ static inline int get_freepage_migratety
 }
 
 /*
+ * Check that a freepage cannot end up on a wrong free_list for "sensitive"
+ * migratetypes. Return false if it could. Useful for VM_BUG_ON checks.
+ */
+static inline bool check_freepage_migratetype(struct page *page)
+{
+	int pageblock_mt = get_pageblock_migratetype(page);
+	int freepage_mt = get_freepage_migratetype(page);
+
+	/*
+	 * For RESERVE and CMA pageblocks, the freepage_migratetype must
+	 * match their migratetype. For other pageblocks, we don't care.
+	 */
+	if (pageblock_mt != MIGRATE_RESERVE && !is_migrate_cma(pageblock_mt))
+		return true;
+
+	return (freepage_mt == pageblock_mt);
+}
+
+/*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
  */
diff -puN mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages
+++ a/mm/page_alloc.c
@@ -698,6 +698,8 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
+
+			VM_BUG_ON(!check_freepage_migratetype(page));
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
@@ -1191,6 +1193,7 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
+		VM_BUG_ON(!check_freepage_migratetype(page));
 
 		/*
 		 * Split buddy pages returned by expand() are received here
_

Patches currently in -mm which might be from vbabka@suse.cz are

thp-close-race-between-split-and-zap-huge-pages.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch

