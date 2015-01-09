From: akpm@linux-foundation.org
Subject: + mm-microoptimize-zonelist-operations.patch added to -mm tree
Date: Fri, 09 Jan 2015 15:46:59 -0800
Message-ID: <54b06873.so+p6hl3gcBIrJrw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbbAIXrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:47:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: microoptimize zonelist operations
has been added to the -mm tree.  Its filename is
     mm-microoptimize-zonelist-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-microoptimize-zonelist-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-microoptimize-zonelist-operations.patch

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
Subject: mm: microoptimize zonelist operations

next_zones_zonelist() returns a zoneref pointer, as well as a zone pointer
via extra parameter.  Since the latter can be trivially obtained by
dereferencing the former, the overhead of the extra parameter is
unjustified.

This patch thus removes the zone parameter from next_zones_zonelist(). 
Both callers happen to be in the same header file, so it's simple to add
the zoneref dereference inline.  We save some bytes of code size.

add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-105 (-105)
function                                     old     new   delta
nr_free_zone_pages                           129     115     -14
__alloc_pages_nodemask                      2300    2285     -15
get_page_from_freelist                      2652    2576     -76

add/remove: 0/0 grow/shrink: 1/0 up/down: 10/0 (10)
function                                     old     new   delta
try_to_compact_pages                         569     579     +10

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +++++++------
 mm/mmzone.c            |    4 +---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~mm-microoptimize-zonelist-operations include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-microoptimize-zonelist-operations
+++ a/include/linux/mmzone.h
@@ -970,7 +970,6 @@ static inline int zonelist_node_idx(stru
  * @z - The cursor used as a starting point for the search
  * @highest_zoneidx - The zone index of the highest zone to return
  * @nodes - An optional nodemask to filter the zonelist with
- * @zone - The first suitable zone found is returned via this parameter
  *
  * This function returns the next zone at or below a given zone index that is
  * within the allowed nodemask using a cursor as the starting point for the
@@ -980,8 +979,7 @@ static inline int zonelist_node_idx(stru
  */
 struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes,
-					struct zone **zone);
+					nodemask_t *nodes);
 
 /**
  * first_zones_zonelist - Returns the first zone at or below highest_zoneidx within the allowed nodemask in a zonelist
@@ -1000,8 +998,10 @@ static inline struct zoneref *first_zone
 					nodemask_t *nodes,
 					struct zone **zone)
 {
-	return next_zones_zonelist(zonelist->_zonerefs, highest_zoneidx, nodes,
-								zone);
+	struct zoneref *z = next_zones_zonelist(zonelist->_zonerefs,
+							highest_zoneidx, nodes);
+	*zone = zonelist_zone(z);
+	return z;
 }
 
 /**
@@ -1018,7 +1018,8 @@ static inline struct zoneref *first_zone
 #define for_each_zone_zonelist_nodemask(zone, z, zlist, highidx, nodemask) \
 	for (z = first_zones_zonelist(zlist, highidx, nodemask, &zone);	\
 		zone;							\
-		z = next_zones_zonelist(++z, highidx, nodemask, &zone))	\
+		z = next_zones_zonelist(++z, highidx, nodemask),	\
+			zone = zonelist_zone(z))			\
 
 /**
  * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
diff -puN mm/mmzone.c~mm-microoptimize-zonelist-operations mm/mmzone.c
--- a/mm/mmzone.c~mm-microoptimize-zonelist-operations
+++ a/mm/mmzone.c
@@ -54,8 +54,7 @@ static inline int zref_in_nodemask(struc
 /* Returns the next zone at or below highest_zoneidx in a zonelist */
 struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes,
-					struct zone **zone)
+					nodemask_t *nodes)
 {
 	/*
 	 * Find the next suitable zone to use for the allocation.
@@ -69,7 +68,6 @@ struct zoneref *next_zones_zonelist(stru
 				(z->zone && !zref_in_nodemask(z, nodes)))
 			z++;
 
-	*zone = zonelist_zone(z);
 	return z;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch

