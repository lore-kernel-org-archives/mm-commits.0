From: akpm@linux-foundation.org
Subject: [folded-merged]
 memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:32:21 -0800
Message-ID: <52df0385.MS70w4pCTcRz0mZo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaAUXcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com, akpm@linux-foundation.org

Subject: [folded-merged] memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,hpa@zytor.com,tangchen@cn.fujitsu.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:32:21 -0800


The patch titled
     Subject: memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch

This patch was dropped because it was folded into memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes

Cc: "H. Peter Anvin" <hpa@zytor.com>

WARNING: line over 80 characters
#83: FILE: include/linux/memblock.h:83:
+static inline bool memblock_is_hotpluggable(struct memblock_region *m){ return false; }

ERROR: space required before the open brace '{'
#83: FILE: include/linux/memblock.h:83:
+static inline bool memblock_is_hotpluggable(struct memblock_region *m){ return false; }

total: 1 errors, 1 warnings, 67 lines checked

./patches/memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/memblock.h~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes
+++ a/include/linux/memblock.h
@@ -80,8 +80,14 @@ static inline bool movable_node_is_enabl
 	return movable_node_enabled;
 }
 #else
-static inline bool memblock_is_hotpluggable(struct memblock_region *m){ return false; }
-static inline bool movable_node_is_enabled(void) { return false; }
+static inline bool memblock_is_hotpluggable(struct memblock_region *m)
+{
+	return false;
+}
+static inline bool movable_node_is_enabled(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

