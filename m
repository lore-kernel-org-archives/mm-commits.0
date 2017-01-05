From: akpm@linux-foundation.org
Subject: + mm-get-rid-of-__gfp_other_node.patch added to -mm tree
Date: Wed, 04 Jan 2017 17:04:57 -0800
Message-ID: <586d9bb9.By2TzCdF7HutFksf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdAEBDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: get rid of __GFP_OTHER_NODE
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-__gfp_other_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-get-rid-of-__gfp_other_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-get-rid-of-__gfp_other_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: get rid of __GFP_OTHER_NODE

The flag was introduced by 78afd5612deb ("mm: add __GFP_OTHER_NODE flag")
to allow proper accounting of remote node allocations done by kernel
daemons on behalf of a process - e.g.  khugepaged.

After "mm: fix remote numa hits statistics" we do not need and actually
use the flag so we can safely remove it because all allocations which are
satisfied from their "home" node are accounted properly.

Link: http://lkml.kernel.org/r/20170102153057.9451-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |   13 +++----------
 include/trace/events/mmflags.h |    1 -
 mm/huge_memory.c               |    3 +--
 mm/khugepaged.c                |    5 ++---
 mm/page_alloc.c                |    5 ++---
 tools/perf/builtin-kmem.c      |    1 -
 6 files changed, 8 insertions(+), 20 deletions(-)

diff -puN include/linux/gfp.h~mm-get-rid-of-__gfp_other_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-get-rid-of-__gfp_other_node
+++ a/include/linux/gfp.h
@@ -38,9 +38,8 @@ struct vm_area_struct;
 #define ___GFP_ACCOUNT		0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_DIRECT_RECLAIM	0x400000u
-#define ___GFP_OTHER_NODE	0x800000u
-#define ___GFP_WRITE		0x1000000u
-#define ___GFP_KSWAPD_RECLAIM	0x2000000u
+#define ___GFP_WRITE		0x800000u
+#define ___GFP_KSWAPD_RECLAIM	0x1000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -172,11 +171,6 @@ struct vm_area_struct;
  * __GFP_NOTRACK_FALSE_POSITIVE is an alias of __GFP_NOTRACK. It's a means of
  *   distinguishing in the source between false positives and allocations that
  *   cannot be supported (e.g. page tables).
- *
- * __GFP_OTHER_NODE is for allocations that are on a remote node but that
- *   should not be accounted for as a remote allocation in vmstat. A
- *   typical user would be khugepaged collapsing a huge page on a remote
- *   node.
  */
 #define __GFP_COLD	((__force gfp_t)___GFP_COLD)
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
@@ -184,10 +178,9 @@ struct vm_area_struct;
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
-#define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT 26
+#define __GFP_BITS_SHIFT 25
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /*
diff -puN include/trace/events/mmflags.h~mm-get-rid-of-__gfp_other_node include/trace/events/mmflags.h
--- a/include/trace/events/mmflags.h~mm-get-rid-of-__gfp_other_node
+++ a/include/trace/events/mmflags.h
@@ -48,7 +48,6 @@
 	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
 	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
-	{(unsigned long)__GFP_OTHER_NODE,	"__GFP_OTHER_NODE"}	\
 
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
diff -puN mm/huge_memory.c~mm-get-rid-of-__gfp_other_node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-get-rid-of-__gfp_other_node
+++ a/mm/huge_memory.c
@@ -919,8 +919,7 @@ static int do_huge_pmd_wp_page_fallback(
 	}
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE |
-					       __GFP_OTHER_NODE, vma,
+		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE, vma,
 					       vmf->address, page_to_nid(page));
 		if (unlikely(!pages[i] ||
 			     mem_cgroup_try_charge(pages[i], vma->vm_mm,
diff -puN mm/khugepaged.c~mm-get-rid-of-__gfp_other_node mm/khugepaged.c
--- a/mm/khugepaged.c~mm-get-rid-of-__gfp_other_node
+++ a/mm/khugepaged.c
@@ -943,7 +943,7 @@ static void collapse_huge_page(struct mm
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	/* Only allocate from the target node */
-	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_OTHER_NODE | __GFP_THISNODE;
+	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
 
 	/*
 	 * Before allocating the hugepage, release the mmap_sem read lock.
@@ -1309,8 +1309,7 @@ static void collapse_shmem(struct mm_str
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
 	/* Only allocate from the target node */
-	gfp = alloc_hugepage_khugepaged_gfpmask() |
-		__GFP_OTHER_NODE | __GFP_THISNODE;
+	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
 
 	new_page = khugepaged_alloc_page(hpage, gfp, node);
 	if (!new_page) {
diff -puN mm/page_alloc.c~mm-get-rid-of-__gfp_other_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-__gfp_other_node
+++ a/mm/page_alloc.c
@@ -2584,8 +2584,7 @@ int __isolate_free_page(struct page *pag
  *
  * Must be called with interrupts disabled.
  */
-static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
-								gfp_t flags)
+static inline void zone_statistics(struct zone *preferred_zone, struct zone *z)
 {
 #ifdef CONFIG_NUMA
 	enum zone_stat_item local_stat = NUMA_LOCAL;
@@ -2667,7 +2666,7 @@ struct page *buffered_rmqueue(struct zon
 	}
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
-	zone_statistics(preferred_zone, zone, gfp_flags);
+	zone_statistics(preferred_zone, zone);
 	local_irq_restore(flags);
 
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
diff -puN tools/perf/builtin-kmem.c~mm-get-rid-of-__gfp_other_node tools/perf/builtin-kmem.c
--- a/tools/perf/builtin-kmem.c~mm-get-rid-of-__gfp_other_node
+++ a/tools/perf/builtin-kmem.c
@@ -655,7 +655,6 @@ static const struct {
 	{ "__GFP_RECLAIM",		"R" },
 	{ "__GFP_DIRECT_RECLAIM",	"DR" },
 	{ "__GFP_KSWAPD_RECLAIM",	"KR" },
-	{ "__GFP_OTHER_NODE",		"ON" },
 };
 
 static size_t max_gfp_len;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-fix-remote-numa-hits-statistics.patch
mm-get-rid-of-__gfp_other_node.patch
mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch

