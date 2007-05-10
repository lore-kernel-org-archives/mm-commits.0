From: akpm@linux-foundation.org
Subject: + change-zonelist-order-v6-zonelist-fix-2.patch added to -mm tree
Date: Thu, 10 May 2007 02:21:29 -0700
Message-ID: <200705100921.l4A9LTFq017030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669AbXEJJWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 05:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.co


The patch titled
     change-zonelist-order-v6-zonelist-fix-2
has been added to the -mm tree.  Its filename is
     change-zonelist-order-v6-zonelist-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: change-zonelist-order-v6-zonelist-fix-2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.co

Fixes section mismatch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~change-zonelist-order-v6-zonelist-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~change-zonelist-order-v6-zonelist-fix-2
+++ a/mm/page_alloc.c
@@ -1636,9 +1636,8 @@ void show_free_areas(void)
  *
  * Add all populated zones of a node to the zonelist.
  */
-static int __meminit build_zonelists_node(pg_data_t *pgdat,
-		struct zonelist *zonelist, int nr_zones,
-		enum zone_type zone_type)
+static int build_zonelists_node(pg_data_t *pgdat, struct zonelist *zonelist,
+				int nr_zones, enum zone_type zone_type)
 {
 	struct zone *zone;
 
@@ -1937,7 +1936,7 @@ static void build_zonelists(pg_data_t *p
 }
 
 /* Construct the zonelist performance cache - see further mmzone.h */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
@@ -1962,7 +1961,7 @@ static void set_zonelist_order(void)
 	current_zonelist_order = ZONELIST_ORDER_ZONE;
 }
 
-static void __meminit build_zonelists(pg_data_t *pgdat)
+static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
 	enum zone_type i,j;
@@ -1998,7 +1997,7 @@ static void __meminit build_zonelists(pg
 }
 
 /* non-NUMA variant of zonelist performance cache - just NULL zlcache_ptr */
-static void __meminit build_zonelist_cache(pg_data_t *pgdat)
+static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	int i;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.co are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
