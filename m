From: akpm@linux-foundation.org
Subject: - mm-mark-the-correct-zone-as-full-when-scanning-zonelists.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:05 -0700
Message-ID: <200809182056.m8IKu5Aa019164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYIRU40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: mark the correct zone as full when scanning zonelists
has been removed from the -mm tree.  Its filename was
     mm-mark-the-correct-zone-as-full-when-scanning-zonelists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: mark the correct zone as full when scanning zonelists
From: Mel Gorman <mel@csn.ul.ie>

The iterator for_each_zone_zonelist() uses a struct zoneref *z cursor when
scanning zonelists to keep track of where in the zonelist it is.  The
zoneref that is returned corresponds to the the next zone that is to be
scanned, not the current one.  It was intended to be treated as an opaque
list.

When the page allocator is scanning a zonelist, it marks elements in the
zonelist corresponding to zones that are temporarily full.  As the
zonelist is being updated, it uses the cursor here;

  if (NUMA_BUILD)
        zlc_mark_zone_full(zonelist, z);

This is intended to prevent rescanning in the near future but the zoneref
cursor does not correspond to the zone that has been found to be full. 
This is an easy misunderstanding to make so this patch corrects the
problem by changing zoneref cursor to be the current zone being scanned
instead of the next one.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++------
 mm/mmzone.c            |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~mm-mark-the-correct-zone-as-full-when-scanning-zonelists include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-mark-the-correct-zone-as-full-when-scanning-zonelists
+++ a/include/linux/mmzone.h
@@ -751,8 +751,9 @@ static inline int zonelist_node_idx(stru
  *
  * This function returns the next zone at or below a given zone index that is
  * within the allowed nodemask using a cursor as the starting point for the
- * search. The zoneref returned is a cursor that is used as the next starting
- * point for future calls to next_zones_zonelist().
+ * search. The zoneref returned is a cursor that represents the current zone
+ * being examined. It should be advanced by one before calling
+ * next_zones_zonelist again.
  */
 struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
@@ -768,9 +769,8 @@ struct zoneref *next_zones_zonelist(stru
  *
  * This function returns the first zone at or below a given zone index that is
  * within the allowed nodemask. The zoneref returned is a cursor that can be
- * used to iterate the zonelist with next_zones_zonelist. The cursor should
- * not be used by the caller as it does not match the value of the zone
- * returned.
+ * used to iterate the zonelist with next_zones_zonelist by advancing it by
+ * one before calling.
  */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
@@ -795,7 +795,7 @@ static inline struct zoneref *first_zone
 #define for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
 	for (z = first_zones_zonelist(zlist, highidx, nodemask, &zone);	\
 		zone;							\
-		z = next_zones_zonelist(z, highidx, nodemask, &zone))	\
+		z = next_zones_zonelist(++z, highidx, nodemask, &zone))	\
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
diff -puN mm/mmzone.c~mm-mark-the-correct-zone-as-full-when-scanning-zonelists mm/mmzone.c
--- a/mm/mmzone.c~mm-mark-the-correct-zone-as-full-when-scanning-zonelists
+++ a/mm/mmzone.c
@@ -69,6 +69,6 @@ struct zoneref *next_zones_zonelist(stru
 				(z->zone && !zref_in_nodemask(z, nodes)))
 			z++;
 
-	*zone = zonelist_zone(z++);
+	*zone = zonelist_zone(z);
 	return z;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-make-do_move_pages-complexity-linear.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

