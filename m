From: akpm@linux-foundation.org
Subject: + mm-__rmqueue_fallback-should-respect-pageblock-type.patch added to -mm tree
Date: Thu, 31 Oct 2013 12:08:04 -0700
Message-ID: <5272aa94.18V+czatc1KqdYs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3JaTIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 15:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com

Subject: + mm-__rmqueue_fallback-should-respect-pageblock-type.patch added to -mm tree
To: kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,mina86@mina86.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 12:08:04 -0700


The patch titled
     Subject: mm: __rmqueue_fallback() should respect pageblock type
has been added to the -mm tree.  Its filename is
     mm-__rmqueue_fallback-should-respect-pageblock-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-__rmqueue_fallback-should-respect-pageblock-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-__rmqueue_fallback-should-respect-pageblock-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: __rmqueue_fallback() should respect pageblock type

When __rmqueue_fallback() doesn't find a free block with the required size
it splits a larger page and puts the rest of the page onto the free list.

But it has one serious mistake.  When putting back, __rmqueue_fallback()
always use start_migratetype if type is not CMA.  However,
__rmqueue_fallback() is only called when all of the start_migratetype
queue is empty.  That said, __rmqueue_fallback always puts back memory to
the wrong queue except try_to_steal_freepages() changed pageblock type
(i.e.  requested size is smaller than half of page block).  The end result
is that the antifragmentation framework increases fragmenation instead of
decreasing it.

Mel's original anti fragmentation does the right thing.  But commit
47118af076 ("mm: mmzone: MIGRATE_CMA migration type added") broke it.

This patch restores sane and old behavior.  And also it remvoe an
incorrect comment which introduced at commit fef903efcf (mm/page_alloc.c:
restructure free-page stealing code and fix a bug).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-__rmqueue_fallback-should-respect-pageblock-type mm/page_alloc.c
--- a/mm/page_alloc.c~mm-__rmqueue_fallback-should-respect-pageblock-type
+++ a/mm/page_alloc.c
@@ -1027,6 +1027,10 @@ static int try_to_steal_freepages(struct
 {
 	int current_order = page_order(page);
 
+	/*
+	 * When borrowing from MIGRATE_CMA, we need to release the excess
+	 * buddy pages to CMA itself.
+	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
 
@@ -1091,17 +1095,7 @@ __rmqueue_fallback(struct zone *zone, in
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			/*
-			 * Borrow the excess buddy pages as well, irrespective
-			 * of whether we stole freepages, or took ownership of
-			 * the pageblock or not.
-			 *
-			 * Exception: When borrowing from MIGRATE_CMA, release
-			 * the excess buddy pages to CMA itself.
-			 */
-			expand(zone, page, order, current_order, area,
-			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			expand(zone, page, order, current_order, area, new_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch
mm-mempolicy-use-numa_no_node.patch
mm-fix-page_group_by_mobility_disabled-breakage.patch
mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag.patch
mm-__rmqueue_fallback-should-respect-pageblock-type.patch
linux-next.patch

