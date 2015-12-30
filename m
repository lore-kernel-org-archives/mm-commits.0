From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-fix-overflow-in-mod_zone_page_state.patch
 removed from -mm tree
Date: Wed, 30 Dec 2015 12:40:30 -0800
Message-ID: <5684413e.FQhiaio+l3yUyoSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbL3Ukb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 15:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: fix overflow in mod_zone_page_state()
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-overflow-in-mod_zone_page_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm/vmstat: fix overflow in mod_zone_page_state()

mod_zone_page_state() takes a "delta" integer argument.  delta contains
the number of pages that should be added or subtracted from a struct
zone's vm_stat field.

If a zone is larger than 8TB this will cause overflows.  E.g.  for a zone
with a size slightly larger than 8TB the line

	mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);

in mm/page_alloc.c:free_area_init_core() will result in a negative result
for the NR_ALLOC_BATCH entry within the zone's vm_stat, since 8TB contain
0x8xxxxxxx pages which will be sign extended to a negative value.

Fix this by changing the delta argument to long type.

This could fix an early boot problem seen on s390, where we have a 9TB
system with only one node.  ZONE_DMA contains 2GB and ZONE_NORMAL the
rest.  The system is trying to allocate a GFP_DMA page but ZONE_DMA is
completely empty, so it tries to reclaim pages in an endless loop.

This was seen on a heavily patched 3.10 kernel.  One possible explaination
seem to be the overflows caused by mod_zone_page_state().  Unfortunately I
did not have the chance to verify that this patch actually fixes the
problem, since I don't have access to the system right now.  However the
overflow problem does exist anyway.

Given the description that a system with slightly less than 8TB does work,
this seems to be a candidate for the observed problem.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 +++---
 mm/vmstat.c            |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-fix-overflow-in-mod_zone_page_state include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-fix-overflow-in-mod_zone_page_state
+++ a/include/linux/vmstat.h
@@ -176,11 +176,11 @@ extern void zone_statistics(struct zone
 #define sub_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, -(__d))
 
 #ifdef CONFIG_SMP
-void __mod_zone_page_state(struct zone *, enum zone_stat_item item, int);
+void __mod_zone_page_state(struct zone *, enum zone_stat_item item, long);
 void __inc_zone_page_state(struct page *, enum zone_stat_item);
 void __dec_zone_page_state(struct page *, enum zone_stat_item);
 
-void mod_zone_page_state(struct zone *, enum zone_stat_item, int);
+void mod_zone_page_state(struct zone *, enum zone_stat_item, long);
 void inc_zone_page_state(struct page *, enum zone_stat_item);
 void dec_zone_page_state(struct page *, enum zone_stat_item);
 
@@ -205,7 +205,7 @@ void set_pgdat_percpu_threshold(pg_data_
  * The functions directly modify the zone and global counters.
  */
 static inline void __mod_zone_page_state(struct zone *zone,
-			enum zone_stat_item item, int delta)
+			enum zone_stat_item item, long delta)
 {
 	zone_page_state_add(delta, zone, item);
 }
diff -puN mm/vmstat.c~mm-vmstat-fix-overflow-in-mod_zone_page_state mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-fix-overflow-in-mod_zone_page_state
+++ a/mm/vmstat.c
@@ -219,7 +219,7 @@ void set_pgdat_percpu_threshold(pg_data_
  * particular counter cannot be updated from interrupt context.
  */
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-				int delta)
+			   long delta)
 {
 	struct per_cpu_pageset __percpu *pcp = zone->pageset;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
@@ -318,8 +318,8 @@ EXPORT_SYMBOL(__dec_zone_page_state);
  *     1       Overstepping half of threshold
  *     -1      Overstepping minus half of threshold
 */
-static inline void mod_state(struct zone *zone,
-       enum zone_stat_item item, int delta, int overstep_mode)
+static inline void mod_state(struct zone *zone, enum zone_stat_item item,
+			     long delta, int overstep_mode)
 {
 	struct per_cpu_pageset __percpu *pcp = zone->pageset;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
@@ -357,7 +357,7 @@ static inline void mod_state(struct zone
 }
 
 void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-					int delta)
+			 long delta)
 {
 	mod_state(zone, item, delta, 0);
 }
@@ -384,7 +384,7 @@ EXPORT_SYMBOL(dec_zone_page_state);
  * Use interrupt disable to serialize counter updates
  */
 void mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
-					int delta)
+			 long delta)
 {
 	unsigned long flags;
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are


