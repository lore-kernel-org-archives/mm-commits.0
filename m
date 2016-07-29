From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:57:38 -0700
Message-ID: <579ba722.Jr/s42if8nKSwroO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbcG2S5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove __GFP_NORETRY from khugepaged and madvised allocations
has been removed from the -mm tree.  Its filename was
     mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, thp: remove __GFP_NORETRY from khugepaged and madvised allocations

After the previous patch, we can distinguish costly allocations that
should be really lightweight, such as THP page faults, with __GFP_NORETRY.
This means we don't need to recognize khugepaged allocations via
PF_KTHREAD anymore.  We can also change THP page faults in areas where
madvise(MADV_HUGEPAGE) was used to try as hard as khugepaged, as the
process has indicated that it benefits from THP's and is willing to pay
some initial latency costs.

We can also make the flags handling less cryptic by distinguishing
GFP_TRANSHUGE_LIGHT (no reclaim at all, default mode in page fault) from
GFP_TRANSHUGE (only direct reclaim, khugepaged default).  Adding
__GFP_NORETRY or __GFP_KSWAPD_RECLAIM is done where needed.

The patch effectively changes the current GFP_TRANSHUGE users as follows:

* get_huge_zero_page() - the zero page lifetime should be relatively
  long and it's shared by multiple users, so it's worth spending some
  effort on it.  We use GFP_TRANSHUGE, and __GFP_NORETRY is not added. 
  This also restores direct reclaim to this allocation, which was
  unintentionally removed by commit e4a49efe4e7e ("mm: thp: set THP defrag
  by default to madvise and add a stall-free defrag option")

* alloc_hugepage_khugepaged_gfpmask() - this is khugepaged, so latency
  is not an issue.  So if khugepaged "defrag" is enabled (the default), do
  reclaim via GFP_TRANSHUGE without __GFP_NORETRY.  We can remove the
  PF_KTHREAD check from page alloc.

  As a side-effect, khugepaged will now no longer check if the initial
  compaction was deferred or contended.  This is OK, as khugepaged sleep
  times between collapsion attempts are long enough to prevent noticeable
  disruption, so we should allow it to spend some effort.

* migrate_misplaced_transhuge_page() - already was masking out
  __GFP_RECLAIM, so just convert to GFP_TRANSHUGE_LIGHT which is
  equivalent.

* alloc_hugepage_direct_gfpmask() - vma's with VM_HUGEPAGE (via madvise)
  are now allocating without __GFP_NORETRY.  Other vma's keep using
  __GFP_NORETRY if direct reclaim/compaction is at all allowed (by default
  it's allowed only for madvised vma's).  The rest is conversion to
  GFP_TRANSHUGE(_LIGHT).

[mhocko@suse.com: suggested GFP_TRANSHUGE_LIGHT]
Link: http://lkml.kernel.org/r/20160721073614.24395-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |   14 ++++++++------
 include/trace/events/mmflags.h |    1 +
 mm/huge_memory.c               |   25 ++++++++++++++-----------
 mm/khugepaged.c                |    2 +-
 mm/migrate.c                   |    2 +-
 mm/page_alloc.c                |    6 ++----
 tools/perf/builtin-kmem.c      |    1 +
 7 files changed, 28 insertions(+), 23 deletions(-)

diff -puN include/linux/gfp.h~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations include/linux/gfp.h
--- a/include/linux/gfp.h~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/include/linux/gfp.h
@@ -237,9 +237,11 @@ struct vm_area_struct;
  *   are expected to be movable via page reclaim or page migration. Typically,
  *   pages on the LRU would also be allocated with GFP_HIGHUSER_MOVABLE.
  *
- * GFP_TRANSHUGE is used for THP allocations. They are compound allocations
- *   that will fail quickly if memory is not available and will not wake
- *   kswapd on failure.
+ * GFP_TRANSHUGE and GFP_TRANSHUGE_LIGHT are used for THP allocations. They are
+ *   compound allocations that will generally fail quickly if memory is not
+ *   available and will not wake kswapd/kcompactd on failure. The _LIGHT
+ *   version does not attempt reclaim/compaction at all and is by default used
+ *   in page fault path, while the non-light is used by khugepaged.
  */
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
@@ -254,9 +256,9 @@ struct vm_area_struct;
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
-#define GFP_TRANSHUGE	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
-			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN) & \
-			 ~__GFP_RECLAIM)
+#define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
+			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
+#define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
 
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
diff -puN include/trace/events/mmflags.h~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/include/trace/events/mmflags.h
@@ -11,6 +11,7 @@
 
 #define __def_gfpflag_names						\
 	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
+	{(unsigned long)GFP_TRANSHUGE_LIGHT,	"GFP_TRANSHUGE_LIGHT"}, \
 	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
 	{(unsigned long)GFP_USER,		"GFP_USER"},		\
diff -puN mm/huge_memory.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/mm/huge_memory.c
@@ -539,23 +539,26 @@ static int __do_huge_pmd_anonymous_page(
 }
 
 /*
- * If THP is set to always then directly reclaim/compact as necessary
- * If set to defer then do no reclaim and defer to khugepaged
+ * If THP defrag is set to always then directly reclaim/compact as necessary
+ * If set to defer then do only background reclaim/compact and defer to khugepaged
  * If set to madvise and the VMA is flagged then directly reclaim/compact
+ * When direct reclaim/compact is allowed, don't retry except for flagged VMA's
  */
 static inline gfp_t alloc_hugepage_direct_gfpmask(struct vm_area_struct *vma)
 {
-	gfp_t reclaim_flags = 0;
+	bool vma_madvised = !!(vma->vm_flags & VM_HUGEPAGE);
 
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags) &&
-	    (vma->vm_flags & VM_HUGEPAGE))
-		reclaim_flags = __GFP_DIRECT_RECLAIM;
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags))
-		reclaim_flags = __GFP_KSWAPD_RECLAIM;
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
-		reclaim_flags = __GFP_DIRECT_RECLAIM;
+	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+				&transparent_hugepage_flags) && vma_madvised)
+		return GFP_TRANSHUGE;
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
+						&transparent_hugepage_flags))
+		return GFP_TRANSHUGE_LIGHT | __GFP_KSWAPD_RECLAIM;
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
+						&transparent_hugepage_flags))
+		return GFP_TRANSHUGE | (vma_madvised ? 0 : __GFP_NORETRY);
 
-	return GFP_TRANSHUGE | reclaim_flags;
+	return GFP_TRANSHUGE_LIGHT;
 }
 
 /* Caller must hold page table lock. */
diff -puN mm/khugepaged.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/mm/khugepaged.c
@@ -694,7 +694,7 @@ static bool khugepaged_scan_abort(int ni
 /* Defrag for khugepaged will enter direct reclaim/compaction if necessary */
 static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 {
-	return GFP_TRANSHUGE | (khugepaged_defrag() ? __GFP_DIRECT_RECLAIM : 0);
+	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
 #ifdef CONFIG_NUMA
diff -puN mm/migrate.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations mm/migrate.c
--- a/mm/migrate.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/mm/migrate.c
@@ -1934,7 +1934,7 @@ int migrate_misplaced_transhuge_page(str
 		goto out_dropref;
 
 	new_page = alloc_pages_node(node,
-		(GFP_TRANSHUGE | __GFP_THISNODE) & ~__GFP_RECLAIM,
+		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
 		HPAGE_PMD_ORDER);
 	if (!new_page)
 		goto out_fail;
diff -puN mm/page_alloc.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/mm/page_alloc.c
@@ -3556,11 +3556,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep
-			 * using async compaction, unless it's khugepaged
-			 * trying to collapse.
+			 * using async compaction.
 			 */
-			if (!(current->flags & PF_KTHREAD))
-				migration_mode = MIGRATE_ASYNC;
+			migration_mode = MIGRATE_ASYNC;
 		}
 	}
 
diff -puN tools/perf/builtin-kmem.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~mm-thp-remove-__gfp_noretry-from-khugepaged-and-madvised-allocations
+++ a/tools/perf/builtin-kmem.c
@@ -608,6 +608,7 @@ static const struct {
 	const char *compact;
 } gfp_compact_table[] = {
 	{ "GFP_TRANSHUGE",		"THP" },
+	{ "GFP_TRANSHUGE_LIGHT",	"THL" },
 	{ "GFP_HIGHUSER_MOVABLE",	"HUM" },
 	{ "GFP_HIGHUSER",		"HU" },
 	{ "GFP_USER",			"U" },
_

Patches currently in -mm which might be from vbabka@suse.cz are


