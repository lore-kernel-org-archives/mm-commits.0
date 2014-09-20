From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2.patch removed
 from -mm tree
Date: Fri, 19 Sep 2014 23:20:56 -0700
Message-ID: <541d1cc8.W98qsxYlcgesFU0D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaITGVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-common-page-state-for-ballooned-memory-fix-v2--2
has been removed from the -mm tree.  Its filename was
     mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2.patch

This patch was dropped because it was folded into mm-introduce-common-page-state-for-ballooned-memory.patch

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm-introduce-common-page-state-for-ballooned-memory-fix-v2--2

This reverts per-zone balloon counters and removes them from meminfo,
zoneinfo.  Instead of that this patch adds three /proc/vmstat counters:
"balloon_inflate", "balloon_deflate" and "balloon_migrate".  Current size
of balloon is (balloon_inflate - balloon_deflate) pages.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 --
 drivers/base/node.c                |    6 ------
 fs/proc/meminfo.c                  |    6 ------
 include/linux/mmzone.h             |    3 ---
 include/linux/vm_event_item.h      |    7 +++++++
 mm/vmstat.c                        |   10 +++++++---
 6 files changed, 14 insertions(+), 20 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/Documentation/filesystems/proc.txt
@@ -796,7 +796,6 @@ VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
 AnonHugePages:   49152 kB
-BalloonPages:        0 kB
 
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
@@ -839,7 +838,6 @@ MemAvailable: An estimate of how much me
    Writeback: Memory which is actively being written back to the disk
    AnonPages: Non-file backed pages mapped into userspace page tables
 AnonHugePages: Non-file backed huge pages mapped into userspace page tables
-BalloonPages: Memory which was ballooned, not included into MemTotal
       Mapped: files which have been mmaped, such as libraries
         Slab: in-kernel data structures cache
 SReclaimable: Part of Slab, that might be reclaimed, such as caches
diff -puN drivers/base/node.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 drivers/base/node.c
--- a/drivers/base/node.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/drivers/base/node.c
@@ -120,9 +120,6 @@ static ssize_t node_read_meminfo(struct
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       "Node %d AnonHugePages:  %8lu kB\n"
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
-		       "Node %d BalloonPages:   %8lu kB\n"
-#endif
 			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
@@ -144,9 +141,6 @@ static ssize_t node_read_meminfo(struct
 		       ,nid, K(node_page_state(nid,
 				NR_ANON_TRANSPARENT_HUGEPAGES) * HPAGE_PMD_NR)
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
-		       ,nid, K(node_page_state(nid, NR_BALLOON_PAGES))
-#endif
 		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
diff -puN fs/proc/meminfo.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/fs/proc/meminfo.c
@@ -138,9 +138,6 @@ static int meminfo_proc_show(struct seq_
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
-		"BalloonPages:   %8lu kB\n"
-#endif
 		,
 		K(i.totalram),
 		K(i.freeram),
@@ -196,9 +193,6 @@ static int meminfo_proc_show(struct seq_
 		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
 		   HPAGE_PMD_NR)
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
-		,K(global_page_state(NR_BALLOON_PAGES))
-#endif
 		);
 
 	hugetlb_report_meminfo(m);
diff -puN include/linux/mmzone.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/include/linux/mmzone.h
@@ -157,9 +157,6 @@ enum zone_stat_item {
 	WORKINGSET_NODERECLAIM,
 	NR_ANON_TRANSPARENT_HUGEPAGES,
 	NR_FREE_CMA_PAGES,
-#ifdef CONFIG_MEMORY_BALLOON
-	NR_BALLOON_PAGES,
-#endif
 	NR_VM_ZONE_STAT_ITEMS };
 
 /*
diff -puN include/linux/vm_event_item.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/include/linux/vm_event_item.h
@@ -72,6 +72,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+#ifdef CONFIG_MEMORY_BALLOON
+		BALLOON_INFLATE,
+		BALLOON_DEFLATE,
+#ifdef CONFIG_BALLOON_COMPACTION
+		BALLOON_MIGRATE,
+#endif
+#endif
 #ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
diff -puN mm/vmstat.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2 mm/vmstat.c
--- a/mm/vmstat.c~mm-introduce-common-page-state-for-ballooned-memory-fix-v2-2
+++ a/mm/vmstat.c
@@ -778,9 +778,6 @@ const char * const vmstat_text[] = {
 	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
 	"nr_free_cma",
-#ifdef CONFIG_MEMORY_BALLOON
-	"nr_balloon_pages",
-#endif
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
@@ -866,6 +863,13 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_MEMORY_BALLOON
+	"balloon_inflate",
+	"balloon_deflate",
+#ifdef CONFIG_BALLOON_COMPACTION
+	"balloon_migrate",
+#endif
+#endif /* CONFIG_MEMORY_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 #ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
_

Patches currently in -mm which might be from koct9i@gmail.com are

selftests-vm-transhuge-stress-stress-test-for-memory-compaction.patch
mm-introduce-common-page-state-for-ballooned-memory.patch
mm-balloon_compaction-use-common-page-ballooning-v2-fix-1.patch

