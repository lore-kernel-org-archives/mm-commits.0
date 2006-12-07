From: akpm@osdl.org
Subject: - memory-page-alloc-minor-cleanups.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:55:55 -0800
Message-ID: <200612072255.kB7MttZa029153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163563AbWLGWz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:55:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, clameter@sgi.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     memory page alloc minor cleanups
has been removed from the -mm tree.  Its filename was
     memory-page-alloc-minor-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: memory page alloc minor cleanups
From: Paul Jackson <pj@sgi.com>

- s/freeliest/freelist/ spelling fix

- Check for NULL *z zone seems useless - even if it could happen, so
  what?  Perhaps we should have a check later on if we are faced with an
  allocation request that is not allowed to fail - shouldn't that be a
  serious kernel error, passing an empty zonelist with a mandate to not
  fail?

- Initializing 'z' to zonelist->zones can wait until after the first
  get_page_from_freelist() fails; we only use 'z' in the wakeup_kswapd()
  loop, so let's initialize 'z' there, in a 'for' loop.  Seems clearer.

- Remove superfluous braces around a break

- Fix a couple errant spaces

- Adjust indentation on the cpuset_zone_allowed() check, to match the
  lines just before it -- seems easier to read in this case.

- Add another set of braces to the zone_watermark_ok logic


  Backout one item from a previous "memory page_alloc minor cleanups" patch.
   Until and unless we are certain that no one can ever pass an empty zonelist
  to __alloc_pages(), this check for an empty zonelist (or some BUG
  equivalent) is essential.  The code in get_page_from_freelist() blow ups if
  passed an empty zonelist.

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~memory-page-alloc-minor-cleanups mm/page_alloc.c
--- a/mm/page_alloc.c~memory-page-alloc-minor-cleanups
+++ a/mm/page_alloc.c
@@ -486,7 +486,7 @@ static void free_one_page(struct zone *z
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
-	__free_one_page(page, zone ,order);
+	__free_one_page(page, zone, order);
 	spin_unlock(&zone->lock);
 }
 
@@ -926,7 +926,7 @@ int zone_watermark_ok(struct zone *z, in
 }
 
 /*
- * get_page_from_freeliest goes through the zonelist trying to allocate
+ * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
  */
 static struct page *
@@ -948,8 +948,8 @@ get_page_from_freelist(gfp_t gfp_mask, u
 			zone->zone_pgdat != zonelist->zones[0]->zone_pgdat))
 				break;
 		if ((alloc_flags & ALLOC_CPUSET) &&
-				!cpuset_zone_allowed(zone, gfp_mask))
-			continue;
+			!cpuset_zone_allowed(zone, gfp_mask))
+				continue;
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
@@ -959,17 +959,18 @@ get_page_from_freelist(gfp_t gfp_mask, u
 				mark = zone->pages_low;
 			else
 				mark = zone->pages_high;
-			if (!zone_watermark_ok(zone , order, mark,
-				    classzone_idx, alloc_flags))
+			if (!zone_watermark_ok(zone, order, mark,
+				    classzone_idx, alloc_flags)) {
 				if (!zone_reclaim_mode ||
 				    !zone_reclaim(zone, gfp_mask, order))
 					continue;
+			}
 		}
 
 		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
-		if (page) {
+		if (page)
 			break;
-		}
+
 	} while (*(++z) != NULL);
 	return page;
 }
@@ -1005,9 +1006,8 @@ restart:
 	if (page)
 		goto got_pg;
 
-	do {
+	for (z = zonelist->zones; *z; z++)
 		wakeup_kswapd(*z, order);
-	} while (*(++z));
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
mm-fallback_alloc-cpuset_zone_allowed-irq-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch

