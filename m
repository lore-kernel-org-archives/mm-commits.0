From: akpm@linux-foundation.org
Subject: [merged] mm-fix-memmap-init-for-handling-memory-hole.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:05 -0800
Message-ID: <200902191917.n1JJH5AR016335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282AbZBSTR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, davem@davemlloft.net, heiko.carstens@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix memmap init for handling memory hole
has been removed from the -mm tree.  Its filename was
     mm-fix-memmap-init-for-handling-memory-hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix memmap init for handling memory hole
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, early_pfn_in_nid(PFN, NID) may returns false if PFN is a hole.
and memmap initialization was not done. This was a trouble for
sparc boot.

To fix this, the PFN should be initialized and marked as PG_reserved.
This patch changes early_pfn_in_nid() return true if PFN is a hole.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: David Miller <davem@davemlloft.net>
Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/numa.c    |    2 +-
 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   23 ++++++++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

diff -puN arch/ia64/mm/numa.c~mm-fix-memmap-init-for-handling-memory-hole arch/ia64/mm/numa.c
--- a/arch/ia64/mm/numa.c~mm-fix-memmap-init-for-handling-memory-hole
+++ a/arch/ia64/mm/numa.c
@@ -70,7 +70,7 @@ int __meminit __early_pfn_to_nid(unsigne
 			return node_memblk[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff -puN include/linux/mmzone.h~mm-fix-memmap-init-for-handling-memory-hole include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-memmap-init-for-handling-memory-hole
+++ a/include/linux/mmzone.h
@@ -1071,7 +1071,7 @@ void sparse_init(void);
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
+bool early_pfn_in_nid(unsigned long pfn, int nid);
 #else
 #define early_pfn_in_nid(pfn, nid)	(1)
 #endif
diff -puN mm/page_alloc.c~mm-fix-memmap-init-for-handling-memory-hole mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-memmap-init-for-handling-memory-hole
+++ a/mm/page_alloc.c
@@ -3000,16 +3000,33 @@ int __meminit __early_pfn_to_nid(unsigne
 		if (start_pfn <= pfn && pfn < end_pfn)
 			return early_node_map[i].nid;
 	}
-
-	return 0;
+	/* This is a memory hole */
+	return -1;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
-	return __early_pfn_to_nid(pfn);
+	int nid;
+
+	nid = __early_pfn_to_nid(pfn);
+	if (nid >= 0)
+		return nid;
+	/* just returns 0 */
+	return 0;
 }
 
+#ifdef CONFIG_NODES_SPAN_OTHER_NODES
+bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
+{
+	int nid;
+
+	nid = __early_pfn_to_nid(pfn);
+	if (nid >= 0 && nid != node)
+		return false;
+	return true;
+}
+#endif
 
 /* Basic iterator support to walk early_node_map[] */
 #define for_each_active_range_index_in_nid(i, nid) \
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch

