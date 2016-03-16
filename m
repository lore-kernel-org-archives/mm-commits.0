From: akpm@linux-foundation.org
Subject: [merged] mm-tracing-make-show_gfp_flags-up-to-date.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:55:39 -0700
Message-ID: <56e9ba3b.uyy8zInbhdw5HDOn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057AbcCPTzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, acme@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, rostedt@goodmis.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, tracing: make show_gfp_flags() up to date
has been removed from the -mm tree.  Its filename was
     mm-tracing-make-show_gfp_flags-up-to-date.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, tracing: make show_gfp_flags() up to date

The show_gfp_flags() macro provides human-friendly printing of gfp flags
in tracepoints.  However, it is somewhat out of date and missing several
flags.  This patches fills in the missing flags, and distinguishes
properly between GFP_ATOMIC and __GFP_ATOMIC which were both translated to
"GFP_ATOMIC".  More generally, all __GFP_X flags which were previously
printed as GFP_X, are now printed as __GFP_X, since ommiting the
underscores results in output that doesn't actually match the source code,
and can only lead to confusion.  Where both variants are defined equal
(e.g.  _DMA and _DMA32), the variant without underscores are preferred.

Also add a note in gfp.h so hopefully future changes will be synced
better.

__GFP_MOVABLE is defined twice in include/linux/gfp.h with different
comments.  Leave just the newer one, which was intended to replace the old
one.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h             |    6 ++-
 include/trace/events/gfpflags.h |   53 +++++++++++++++++-------------
 2 files changed, 36 insertions(+), 23 deletions(-)

diff -puN include/linux/gfp.h~mm-tracing-make-show_gfp_flags-up-to-date include/linux/gfp.h
--- a/include/linux/gfp.h~mm-tracing-make-show_gfp_flags-up-to-date
+++ a/include/linux/gfp.h
@@ -9,6 +9,11 @@
 
 struct vm_area_struct;
 
+/*
+ * In case of changes, please don't forget to update
+ * include/trace/events/gfpflags.h
+ */
+
 /* Plain integer GFP bitmasks. Do not use this directly. */
 #define ___GFP_DMA		0x01u
 #define ___GFP_HIGHMEM		0x02u
@@ -48,7 +53,6 @@ struct vm_area_struct;
 #define __GFP_DMA	((__force gfp_t)___GFP_DMA)
 #define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
 #define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
-#define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* Page is movable */
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
 
diff -puN include/trace/events/gfpflags.h~mm-tracing-make-show_gfp_flags-up-to-date include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-tracing-make-show_gfp_flags-up-to-date
+++ a/include/trace/events/gfpflags.h
@@ -11,33 +11,42 @@
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
 	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
-	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
+	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
 	{(unsigned long)GFP_USER,		"GFP_USER"},		\
 	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
+	{(unsigned long)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},	\
 	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
 	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
 	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
 	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
-	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
-	{(unsigned long)__GFP_ATOMIC,		"GFP_ATOMIC"},		\
-	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
-	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
-	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
-	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
-	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
-	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
-	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
-	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
-	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
-	{(unsigned long)__GFP_MEMALLOC,		"GFP_MEMALLOC"},	\
-	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
-	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
-	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
-	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_DIRECT_RECLAIM,	"GFP_DIRECT_RECLAIM"},	\
-	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"GFP_KSWAPD_RECLAIM"},	\
-	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
-	) : "GFP_NOWAIT"
+	{(unsigned long)GFP_NOWAIT,		"GFP_NOWAIT"},		\
+	{(unsigned long)GFP_DMA,		"GFP_DMA"},		\
+	{(unsigned long)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},	\
+	{(unsigned long)GFP_DMA32,		"GFP_DMA32"},		\
+	{(unsigned long)__GFP_HIGH,		"__GFP_HIGH"},		\
+	{(unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
+	{(unsigned long)__GFP_IO,		"__GFP_IO"},		\
+	{(unsigned long)__GFP_FS,		"__GFP_FS"},		\
+	{(unsigned long)__GFP_COLD,		"__GFP_COLD"},		\
+	{(unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
+	{(unsigned long)__GFP_REPEAT,		"__GFP_REPEAT"},	\
+	{(unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
+	{(unsigned long)__GFP_NORETRY,		"__GFP_NORETRY"},	\
+	{(unsigned long)__GFP_COMP,		"__GFP_COMP"},		\
+	{(unsigned long)__GFP_ZERO,		"__GFP_ZERO"},		\
+	{(unsigned long)__GFP_NOMEMALLOC,	"__GFP_NOMEMALLOC"},	\
+	{(unsigned long)__GFP_MEMALLOC,		"__GFP_MEMALLOC"},	\
+	{(unsigned long)__GFP_HARDWALL,		"__GFP_HARDWALL"},	\
+	{(unsigned long)__GFP_THISNODE,		"__GFP_THISNODE"},	\
+	{(unsigned long)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},	\
+	{(unsigned long)__GFP_MOVABLE,		"__GFP_MOVABLE"},	\
+	{(unsigned long)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},	\
+	{(unsigned long)__GFP_NOTRACK,		"__GFP_NOTRACK"},	\
+	{(unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
+	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
+	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
+	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
+	{(unsigned long)__GFP_OTHER_NODE,	"__GFP_OTHER_NODE"}	\
+	) : "none"
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-compaction-introduce-kcompactd-fix-3.patch
mm-compaction-introduce-kcompactd-fix-4.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

