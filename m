From: akpm@linux-foundation.org
Subject: + memory_hotplug-zone_can_shift-returns-boolean-value.patch added to -mm tree
Date: Mon, 09 Jan 2017 15:29:12 -0800
Message-ID: <58741cc8.uda4rNEttwb7Dgia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934251AbdAIX1p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yasu.isimatu@gmail.com, arbab@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug: zone_can_shift() returns boolean value
has been added to the -mm tree.  Its filename is
     memory_hotplug-zone_can_shift-returns-boolean-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory_hotplug-zone_can_shift-returns-boolean-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory_hotplug-zone_can_shift-returns-boolean-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Subject: memory_hotplug: zone_can_shift() returns boolean value

online_{kernel|movable} is used to change the memory zone to
ZONE_{NORMAL|MOVABLE} and online the memory.

To check that memory zone can be changed, zone_can_shift() is used. 
Currently the function returns minus integer value, plus integer value and
0.  When the function returns minus or plus integer value, it means that
the memory zone can be changed to ZONE_{NORNAL|MOVABLE}.

But when the function returns 0, there is 2 meanings.

One of the meanings is that the memory zone does not need to be changed. 
For example, when memory is in ZONE_NORMAL and onlined by online_kernel
the memory zone does not need to be changed.

Another meaning is that the memory zone cannot be changed.  When memory is
in ZONE_NORMAL and onlined by online_movable, the memory zone may not be
changed to ZONE_MOVALBE due to memory online limitation(see
Documentation/memory-hotplug.txt).  In this case, memory must not be
onlined.

The patch changes the return type of zone_can_shift() so that memory is
not onlined when memory zone cannot be changed.

Fixes: df429ac03936 ("memory-hotplug: more general validation of zone during online")
Link: http://lkml.kernel.org/r/2f9c3837-33d7-b6e5-59c0-6ca4372b2d84@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    4 ++--
 include/linux/memory_hotplug.h |    4 ++--
 mm/memory_hotplug.c            |   28 +++++++++++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff -puN drivers/base/memory.c~memory_hotplug-zone_can_shift-returns-boolean-value drivers/base/memory.c
--- a/drivers/base/memory.c~memory_hotplug-zone_can_shift-returns-boolean-value
+++ a/drivers/base/memory.c
@@ -408,14 +408,14 @@ static ssize_t show_valid_zones(struct d
 	sprintf(buf, "%s", zone->name);
 
 	/* MMOP_ONLINE_KERNEL */
-	zone_shift = zone_can_shift(start_pfn, nr_pages, ZONE_NORMAL);
+	zone_can_shift(start_pfn, nr_pages, ZONE_NORMAL, &zone_shift);
 	if (zone_shift) {
 		strcat(buf, " ");
 		strcat(buf, (zone + zone_shift)->name);
 	}
 
 	/* MMOP_ONLINE_MOVABLE */
-	zone_shift = zone_can_shift(start_pfn, nr_pages, ZONE_MOVABLE);
+	zone_can_shift(start_pfn, nr_pages, ZONE_MOVABLE, &zone_shift);
 	if (zone_shift) {
 		strcat(buf, " ");
 		strcat(buf, (zone + zone_shift)->name);
diff -puN include/linux/memory_hotplug.h~memory_hotplug-zone_can_shift-returns-boolean-value include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory_hotplug-zone_can_shift-returns-boolean-value
+++ a/include/linux/memory_hotplug.h
@@ -284,7 +284,7 @@ extern void sparse_remove_one_section(st
 		unsigned long map_offset);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern int zone_can_shift(unsigned long pfn, unsigned long nr_pages,
-			  enum zone_type target);
+extern bool zone_can_shift(unsigned long pfn, unsigned long nr_pages,
+			  enum zone_type target, int *zone_shift);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN mm/memory_hotplug.c~memory_hotplug-zone_can_shift-returns-boolean-value mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-zone_can_shift-returns-boolean-value
+++ a/mm/memory_hotplug.c
@@ -1033,36 +1033,39 @@ static void node_states_set_node(int nod
 	node_set_state(node, N_MEMORY);
 }
 
-int zone_can_shift(unsigned long pfn, unsigned long nr_pages,
-		   enum zone_type target)
+bool zone_can_shift(unsigned long pfn, unsigned long nr_pages,
+		   enum zone_type target, int *zone_shift)
 {
 	struct zone *zone = page_zone(pfn_to_page(pfn));
 	enum zone_type idx = zone_idx(zone);
 	int i;
 
+	*zone_shift = 0;
+
 	if (idx < target) {
 		/* pages must be at end of current zone */
 		if (pfn + nr_pages != zone_end_pfn(zone))
-			return 0;
+			return false;
 
 		/* no zones in use between current zone and target */
 		for (i = idx + 1; i < target; i++)
 			if (zone_is_initialized(zone - idx + i))
-				return 0;
+				return false;
 	}
 
 	if (target < idx) {
 		/* pages must be at beginning of current zone */
 		if (pfn != zone->zone_start_pfn)
-			return 0;
+			return false;
 
 		/* no zones in use between current zone and target */
 		for (i = target + 1; i < idx; i++)
 			if (zone_is_initialized(zone - idx + i))
-				return 0;
+				return false;
 	}
 
-	return target - idx;
+	*zone_shift = target - idx;
+	return true;
 }
 
 /* Must be protected by mem_hotplug_begin() */
@@ -1089,10 +1092,13 @@ int __ref online_pages(unsigned long pfn
 	    !can_online_high_movable(zone))
 		return -EINVAL;
 
-	if (online_type == MMOP_ONLINE_KERNEL)
-		zone_shift = zone_can_shift(pfn, nr_pages, ZONE_NORMAL);
-	else if (online_type == MMOP_ONLINE_MOVABLE)
-		zone_shift = zone_can_shift(pfn, nr_pages, ZONE_MOVABLE);
+	if (online_type == MMOP_ONLINE_KERNEL) {
+		if (!zone_can_shift(pfn, nr_pages, ZONE_NORMAL, &zone_shift))
+			return -EINVAL;
+	} else if (online_type == MMOP_ONLINE_MOVABLE) {
+		if (!zone_can_shift(pfn, nr_pages, ZONE_MOVABLE, &zone_shift))
+			return -EINVAL;
+	}
 
 	zone = move_pfn_range(zone_shift, pfn, pfn + nr_pages);
 	if (!zone)
_

Patches currently in -mm which might be from yasu.isimatu@gmail.com are

memory_hotplug-zone_can_shift-returns-boolean-value.patch
mm-sparse-use-page_private-to-get-page-private-value.patch
mm-memory_hotplug-set-magic-number-to-page-freelsit-instead-of-page-lrunext.patch

