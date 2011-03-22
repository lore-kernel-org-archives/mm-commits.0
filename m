From: akpm@linux-foundation.org
Subject: [folded] mm-add-__gfp_other_node-flag-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:00:45 -0700
Message-ID: <201103222300.p2MN0jit000315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab1CVXBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mm-add-__gfp_other_node-flag-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-__gfp_other_node-flag-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-__gfp_other_node-flag.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-__gfp_other_node-flag-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#46: FILE: include/linux/gfp.h:87:
+#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */

ERROR: space required after that ',' (ctx:VxV)
#64: FILE: include/linux/vmstat.h:228:
+#define zone_statistics(_zl,_z, gfp) do { } while (0)
                            ^

ERROR: trailing whitespace
#87: FILE: mm/vmstat.c:503:
+ * $

ERROR: trailing whitespace
#102: FILE: mm/vmstat.c:516:
+^Iif (z->node == ((flags & __GFP_OTHER_NODE) ? $

total: 3 errors, 1 warnings, 58 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-add-__gfp_other_node-flag.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 mm/vmstat.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/vmstat.h~mm-add-__gfp_other_node-flag-checkpatch-fixes include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-add-__gfp_other_node-flag-checkpatch-fixes
+++ a/include/linux/vmstat.h
@@ -225,7 +225,7 @@ extern void zone_statistics(struct zone 
 #else
 
 #define node_page_state(node, item) global_page_state(item)
-#define zone_statistics(_zl,_z, gfp) do { } while (0)
+#define zone_statistics(_zl, _z, gfp) do { } while (0)
 
 #endif /* CONFIG_NUMA */
 
diff -puN mm/vmstat.c~mm-add-__gfp_other_node-flag-checkpatch-fixes mm/vmstat.c
--- a/mm/vmstat.c~mm-add-__gfp_other_node-flag-checkpatch-fixes
+++ a/mm/vmstat.c
@@ -500,7 +500,7 @@ void refresh_cpu_vm_stats(int cpu)
  * z 	    = the zone from which the allocation occurred.
  *
  * Must be called with interrupts disabled.
- * 
+ *
  * When __GFP_OTHER_NODE is set assume the node of the preferred
  * zone is the local node. This is useful for daemons who allocate
  * memory on behalf of other processes.
@@ -513,7 +513,7 @@ void zone_statistics(struct zone *prefer
 		__inc_zone_state(z, NUMA_MISS);
 		__inc_zone_state(preferred_zone, NUMA_FOREIGN);
 	}
-	if (z->node == ((flags & __GFP_OTHER_NODE) ? 
+	if (z->node == ((flags & __GFP_OTHER_NODE) ?
 			preferred_zone->node : numa_node_id()))
 		__inc_zone_state(z, NUMA_LOCAL);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

