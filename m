From: akpm@linux-foundation.org
Subject: + mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch added to -mm tree
Date: Wed, 19 May 2010 14:50:57 -0700
Message-ID: <201005192150.o4JLoveG008072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab0ESVvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi.kleen@intel.com, cl@linux-foundation.org, haicheng.li@linux.intel.com, mel@csn.ul.ie, tj@kernel.org


The patch titled
     mem-hotplug: separate setup_per_cpu_pageset() into separate functions
has been added to the -mm tree.  Its filename is
     mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch

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
Subject: mem-hotplug: separate setup_per_cpu_pageset() into separate functions
From: Wu Fengguang <fengguang.wu@intel.com>

No behavior change here.

Move some of setup_per_cpu_pageset() code into a new function
setup_zone_pageset() that will be useful for memory hotplug.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Reviewed-by: Andi Kleen <andi.kleen@intel.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff -puN mm/page_alloc.c~mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions
+++ a/mm/page_alloc.c
@@ -3292,31 +3292,34 @@ static void setup_pagelist_highmark(stru
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
+static __meminit void setup_zone_pageset(struct zone *zone)
+{
+	int cpu;
+
+	zone->pageset = alloc_percpu(struct per_cpu_pageset);
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+		setup_pageset(pcp, zone_batchsize(zone));
+
+		if (percpu_pagelist_fraction)
+			setup_pagelist_highmark(pcp,
+				(zone->present_pages /
+					percpu_pagelist_fraction));
+	}
+}
+
 /*
  * Allocate per cpu pagesets and initialize them.
  * Before this call only boot pagesets were available.
- * Boot pagesets will no longer be used by this processorr
- * after setup_per_cpu_pageset().
  */
 void __init setup_per_cpu_pageset(void)
 {
 	struct zone *zone;
-	int cpu;
 
-	for_each_populated_zone(zone) {
-		zone->pageset = alloc_percpu(struct per_cpu_pageset);
-
-		for_each_possible_cpu(cpu) {
-			struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-			setup_pageset(pcp, zone_batchsize(zone));
-
-			if (percpu_pagelist_fraction)
-				setup_pagelist_highmark(pcp,
-					(zone->present_pages /
-						percpu_pagelist_fraction));
-		}
-	}
+	for_each_populated_zone(zone)
+		setup_zone_pageset(zone);
 }
 
 static noinline __init_refok
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
readaheadc-fix-comment.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch
mem-hotplug-separate-setup_per_cpu_pageset-into-separate-functions.patch
mem-hotplug-avoid-multiple-zones-sharing-same-boot-strapping-boot_pageset.patch
mem-hotplug-fix-potential-race-while-building-zonelist-for-new-populated-zone.patch
radix-tree-fix-radix_tree_prev_hole-underflow-case.patch
vfs-add-super-operation-writeback_inodes.patch

