From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-introduce-common-page-state-for-ballooned-memory.patch removed from -mm
 tree
Date: Fri, 19 Sep 2014 23:26:37 -0700
Message-ID: <541d1e1d.KzKi6qGNVngGHc8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaITG0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 20 Sep 2014 02:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.khlebnikov@samsung.com, aquini@redhat.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce common page state for ballooned memory
has been removed from the -mm tree.  Its filename was
     mm-introduce-common-page-state-for-ballooned-memory.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Subject: mm: introduce common page state for ballooned memory

Add page state PageBallon() and functions __Set/ClearPageBalloon.  Like
PageBuddy() PageBalloon() looks like page-flag but actually this is
special state of page->_mapcount counter.  There is no conflict because
ballooned pages cannot be mapped and cannot be in buddy allocator.

Ballooned pages are counted in vmstat counter NR_BALLOON_PAGES, it's shown
them in /proc/meminfo and /proc/meminfo.  Also this patch it exports
PageBallon into userspace via /proc/kpageflags as KPF_BALLOON.

All this code including mm/balloon_compaction.o is under
CONFIG_MEMORY_BALLOON, it should be selected by ballooning driver which
want use this feature.

[akpm@linux-foundation.org: export __ClearPageBalloon() and __SetPageBalloon() to modules]
Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c                    |   10 ++++------
 fs/proc/page.c                         |    3 +++
 include/linux/mm.h                     |   20 ++++++++++++++++++++
 include/linux/vm_event_item.h          |    7 +++++++
 include/uapi/linux/kernel-page-flags.h |    1 +
 mm/Kconfig                             |    5 +++++
 mm/vmstat.c                            |   12 +++++++++++-
 tools/vm/page-types.c                  |    1 +
 8 files changed, 52 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-introduce-common-page-state-for-ballooned-memory Documentation/filesystems/proc.txt
diff -puN drivers/base/node.c~mm-introduce-common-page-state-for-ballooned-memory drivers/base/node.c
--- a/drivers/base/node.c~mm-introduce-common-page-state-for-ballooned-memory
+++ a/drivers/base/node.c
@@ -136,14 +136,12 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
-			, nid,
-			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR));
-#else
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       ,nid, K(node_page_state(nid,
+				NR_ANON_TRANSPARENT_HUGEPAGES) * HPAGE_PMD_NR)
 #endif
+		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
diff -puN drivers/virtio/Kconfig~mm-introduce-common-page-state-for-ballooned-memory drivers/virtio/Kconfig
diff -puN fs/proc/meminfo.c~mm-introduce-common-page-state-for-ballooned-memory fs/proc/meminfo.c
diff -puN fs/proc/page.c~mm-introduce-common-page-state-for-ballooned-memory fs/proc/page.c
--- a/fs/proc/page.c~mm-introduce-common-page-state-for-ballooned-memory
+++ a/fs/proc/page.c
@@ -133,6 +133,9 @@ u64 stable_page_flags(struct page *page)
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
 
+	if (PageBalloon(page))
+		u |= 1 << KPF_BALLOON;
+
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
diff -puN include/linux/mm.h~mm-introduce-common-page-state-for-ballooned-memory include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-common-page-state-for-ballooned-memory
+++ a/include/linux/mm.h
@@ -554,6 +554,26 @@ static inline void __ClearPageBuddy(stru
 	atomic_set(&page->_mapcount, -1);
 }
 
+#define PAGE_BALLOON_MAPCOUNT_VALUE (-256)
+
+static inline int PageBalloon(struct page *page)
+{
+	return IS_ENABLED(CONFIG_MEMORY_BALLOON) &&
+		atomic_read(&page->_mapcount) == PAGE_BALLOON_MAPCOUNT_VALUE;
+}
+
+static inline void __SetPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(atomic_read(&page->_mapcount) != -1, page);
+	atomic_set(&page->_mapcount, PAGE_BALLOON_MAPCOUNT_VALUE);
+}
+
+static inline void __ClearPageBalloon(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageBalloon(page), page);
+	atomic_set(&page->_mapcount, -1);
+}
+
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
diff -puN include/linux/mmzone.h~mm-introduce-common-page-state-for-ballooned-memory include/linux/mmzone.h
diff -puN include/uapi/linux/kernel-page-flags.h~mm-introduce-common-page-state-for-ballooned-memory include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~mm-introduce-common-page-state-for-ballooned-memory
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -31,6 +31,7 @@
 
 #define KPF_KSM			21
 #define KPF_THP			22
+#define KPF_BALLOON		23
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff -puN mm/Kconfig~mm-introduce-common-page-state-for-ballooned-memory mm/Kconfig
--- a/mm/Kconfig~mm-introduce-common-page-state-for-ballooned-memory
+++ a/mm/Kconfig
@@ -228,6 +228,11 @@ config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	boolean
 
 #
+# support for memory ballooning
+config MEMORY_BALLOON
+	boolean
+
+#
 # support for memory balloon compaction
 config BALLOON_COMPACTION
 	bool "Allow for balloon memory compaction/migration"
diff -puN mm/Makefile~mm-introduce-common-page-state-for-ballooned-memory mm/Makefile
diff -puN mm/balloon_compaction.c~mm-introduce-common-page-state-for-ballooned-memory mm/balloon_compaction.c
diff -puN mm/vmstat.c~mm-introduce-common-page-state-for-ballooned-memory mm/vmstat.c
--- a/mm/vmstat.c~mm-introduce-common-page-state-for-ballooned-memory
+++ a/mm/vmstat.c
@@ -735,7 +735,7 @@ static void walk_zones_in_node(struct se
 					TEXT_FOR_HIGHMEM(xx) xx "_movable",
 
 const char * const vmstat_text[] = {
-	/* Zoned VM counters */
+	/* enum zone_stat_item countes */
 	"nr_free_pages",
 	"nr_alloc_batch",
 	"nr_inactive_anon",
@@ -778,10 +778,13 @@ const char * const vmstat_text[] = {
 	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
 	"nr_free_cma",
+
+	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
+	/* enum vm_event_item counters */
 	"pgpgin",
 	"pgpgout",
 	"pswpin",
@@ -860,6 +863,13 @@ const char * const vmstat_text[] = {
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
diff -puN tools/vm/page-types.c~mm-introduce-common-page-state-for-ballooned-memory tools/vm/page-types.c
--- a/tools/vm/page-types.c~mm-introduce-common-page-state-for-ballooned-memory
+++ a/tools/vm/page-types.c
@@ -132,6 +132,7 @@ static const char * const page_flag_name
 	[KPF_NOPAGE]		= "n:nopage",
 	[KPF_KSM]		= "x:ksm",
 	[KPF_THP]		= "t:thp",
+	[KPF_BALLOON]		= "o:balloon",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
diff -puN include/linux/vm_event_item.h~mm-introduce-common-page-state-for-ballooned-memory include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-introduce-common-page-state-for-ballooned-memory
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
_

Patches currently in -mm which might be from k.khlebnikov@samsung.com are

include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-use-common-page-ballooning.patch
mm-balloon_compaction-general-cleanup.patch
linux-next.patch

