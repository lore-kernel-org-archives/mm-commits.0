From: akpm@linux-foundation.org
Subject: - change-zonelist-order-v6-zonelist-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:34:51 -0700
Message-ID: <200707092034.l69KYpQx009730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbXGIUe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.co, mm-commits@vger.kernel.org


The patch titled
     change-zonelist-order-v6-zonelist-fix-2
has been removed from the -mm tree.  Its filename was
     change-zonelist-order-v6-zonelist-fix-2.patch

This patch was dropped because it was folded into change-zonelist-order-zonelist-order-selection-logic.patch

------------------------------------------------------
Subject: change-zonelist-order-v6-zonelist-fix-2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.co

Fixes section mismatch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~change-zonelist-order-v6-zonelist-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-v6-zonelist-fix-2
+++ a/mm/page_alloc.c
@@ -1621,8 +1621,8 @@ void show_free_areas(void)
  *
  * Add all populated zones of a node to the zonelist.
  */
-static int __meminit build_zonelists_node(pg_data_t *pgdat,
-			struct zonelist *zonelist, int nr_zones, enum zone_type zone_type)
+static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
+				int nr_zones, enum zone_type zone_type)
 {
 	struct zone *zone;
 
@@ -1923,7 +1923,7 @@ static void build_zonelists(pg_data_t *p
 }
 
 /* Construct the zonelist performance cache - see further mmzone.h */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
@@ -1948,7 +1948,7 @@ static void set_zonelist_order(void)
 	current_zonelist_order = ZONELIST_ORDER_ZONE;
 }
 
-static void __meminit build_zonelists(pg_data_t *pgdat)
+static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
 	enum zone_type i,j;
@@ -1984,7 +1984,7 @@ static void __meminit build_zonelists(pg
 }
 
 /* non-NUMA variant of zonelist performance cache - just NULL zlcache_ptr */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.co are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
