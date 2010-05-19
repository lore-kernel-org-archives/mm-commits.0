From: akpm@linux-foundation.org
Subject: + mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch added to -mm tree
Date: Wed, 19 May 2010 14:51:04 -0700
Message-ID: <201005192151.o4JLp4aT008147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab0ESVvc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:51:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haicheng.li@linux.intel.com, andi.kleen@intel.com, cl@linux-foundation.org, fengguang.wu@intel.com, mel@csn.ul.ie, tj@kernel.org


The patch titled
     mem-hotplug: fix potential race while building zonelist for new populated zone
has been added to the -mm tree.  Its filename is
     mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mem-hotplug: fix potential race while building zonelist for new populated zone
From: Haicheng Li <haicheng.li@linux.intel.com>

Add global mutex zonelists_mutex to fix the possible race:

     CPU0                                  CPU1                    CPU2
(1) zone->present_pages += online_pages;
(2)                                       build_all_zonelists();
(3)                                                               alloc_page();
(4)                                                               free_page();
(5) build_all_zonelists();
(6)   __build_all_zonelists();
(7)     zone->pageset = alloc_percpu();

In step (3,4), zone->pageset still points to boot_pageset, so bad
things may happen if 2+ nodes are in this state. Even if only 1 node
is accessing the boot_pageset, (3) may still consume too much memory
to fail the memory allocations in step (7).

Besides, atomic operation ensures alloc_percpu() in step (7) will never fail
since there is a new fresh memory block added in step(6).

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Andi Kleen <andi.kleen@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/memory_hotplug.c    |   11 +++--------
 mm/page_alloc.c        |   15 ++++++++++++++-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone
+++ a/include/linux/mmzone.h
@@ -650,6 +650,7 @@ typedef struct pglist_data {
 
 #include <linux/memory_hotplug.h>
 
+extern struct mutex zonelists_mutex;
 void get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free);
 void build_all_zonelists(void *data);
diff -puN mm/memory_hotplug.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone
+++ a/mm/memory_hotplug.c
@@ -389,11 +389,6 @@ int online_pages(unsigned long pfn, unsi
 	int nid;
 	int ret;
 	struct memory_notify arg;
-	/*
-	 * mutex to protect zone->pageset when it's still shared
-	 * in onlined_pages()
-	 */
-	static DEFINE_MUTEX(zone_pageset_mutex);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -420,14 +415,14 @@ int online_pages(unsigned long pfn, unsi
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
 	 */
-	mutex_lock(&zone_pageset_mutex);
+	mutex_lock(&zonelists_mutex);
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
-		mutex_unlock(&zone_pageset_mutex);
+		mutex_unlock(&zonelists_mutex);
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
 			nr_pages, pfn);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
@@ -441,7 +436,7 @@ int online_pages(unsigned long pfn, unsi
 	else
 		zone_pcp_update(zone);
 
-	mutex_unlock(&zone_pageset_mutex);
+	mutex_unlock(&zonelists_mutex);
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
 	if (onlined_pages) {
diff -puN mm/page_alloc.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone
+++ a/mm/page_alloc.c
@@ -2571,8 +2571,11 @@ int numa_zonelist_order_handler(ctl_tabl
 			strncpy((char*)table->data, saved_string,
 				NUMA_ZONELIST_ORDER_LEN);
 			user_zonelist_order = oldval;
-		} else if (oldval != user_zonelist_order)
+		} else if (oldval != user_zonelist_order) {
+			mutex_lock(&zonelists_mutex);
 			build_all_zonelists(NULL);
+			mutex_unlock(&zonelists_mutex);
+		}
 	}
 out:
 	mutex_unlock(&zl_order_mutex);
@@ -2924,6 +2927,12 @@ static void setup_pageset(struct per_cpu
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static void setup_zone_pageset(struct zone *zone);
 
+/*
+ * Global mutex to protect against size modification of zonelists
+ * as well as to serialize pageset setup for the new populated zone.
+ */
+DEFINE_MUTEX(zonelists_mutex);
+
 /* return values int ....just for stop_machine() */
 static __init_refok int __build_all_zonelists(void *data)
 {
@@ -2967,6 +2976,10 @@ static __init_refok int __build_all_zone
 	return 0;
 }
 
+/*
+ * Called with zonelists_mutex held always
+ * unless system_state == SYSTEM_BOOTING.
+ */
 void build_all_zonelists(void *data)
 {
 	set_zonelist_order();
_

Patches currently in -mm which might be from haicheng.li@linux.intel.com are

mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch

