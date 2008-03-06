From: akpm@linux-foundation.org
Subject: - pageflags-get-rid-of-flags_reserved.patch removed from -mm tree
Date: Wed, 05 Mar 2008 20:08:41 -0800
Message-ID: <200803060408.m2648fmG007974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYCFEJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 23:09:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pageflags: get rid of FLAGS_RESERVED
has been removed from the -mm tree.  Its filename was
     pageflags-get-rid-of-flags_reserved.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pageflags: get rid of FLAGS_RESERVED
From: Christoph Lameter <clameter@sgi.com>

NR_PAGEFLAGS specifies the number of page flags we are using.  >From that we
can calculate the number of bits leftover that can be used for zone, node (and
maybe the sections id).  There is no need anymore for FLAGS_RESERVED if we use
NR_PAGEFLAGS.

Use the new methods to make NR_PAGEFLAGS available via the preprocessor. 
NR_PAGEFLAGS is used to calculate field boundaries in the page flags fields. 
These field widths have to be available to the preprocessor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bounds.h     |    2 ++
 include/linux/mm.h         |    6 +++---
 include/linux/mmzone.h     |   19 -------------------
 include/linux/page-flags.h |   14 +++++++-------
 kernel/bounds.c            |    1 +
 5 files changed, 13 insertions(+), 29 deletions(-)

diff -puN include/linux/bounds.h~pageflags-get-rid-of-flags_reserved include/linux/bounds.h
--- a/include/linux/bounds.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/bounds.h
@@ -7,4 +7,6 @@
  *
  */
 
+#define NR_PAGEFLAGS 32 /* __NR_PAGEFLAGS	# */
+
 #endif
diff -puN include/linux/mm.h~pageflags-get-rid-of-flags_reserved include/linux/mm.h
--- a/include/linux/mm.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/mm.h
@@ -398,7 +398,7 @@ static inline void set_compound_order(st
 
 #define ZONES_WIDTH		ZONES_SHIFT
 
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= FLAGS_RESERVED
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
 #define NODES_WIDTH		NODES_SHIFT
 #else
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
@@ -446,8 +446,8 @@ static inline void set_compound_order(st
 
 #define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
 
-#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
-#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
+#if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
+#error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
 #endif
 
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
diff -puN include/linux/mmzone.h~pageflags-get-rid-of-flags_reserved include/linux/mmzone.h
--- a/include/linux/mmzone.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/mmzone.h
@@ -839,25 +839,6 @@ static inline struct zoneref *next_zones
 #include <asm/sparsemem.h>
 #endif
 
-#if BITS_PER_LONG == 32
-/*
- * with 32 bit page->flags field, we reserve 9 bits for node/zone info.
- * there are 4 zones (3 bits) and this leaves 9-3=6 bits for nodes.
- */
-#define FLAGS_RESERVED		9
-
-#elif BITS_PER_LONG == 64
-/*
- * with 64 bit flags field, there's plenty of room.
- */
-#define FLAGS_RESERVED		32
-
-#else
-
-#error BITS_PER_LONG not defined
-
-#endif
-
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
 	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
 #define early_pfn_to_nid(nid)  (0UL)
diff -puN include/linux/page-flags.h~pageflags-get-rid-of-flags_reserved include/linux/page-flags.h
--- a/include/linux/page-flags.h~pageflags-get-rid-of-flags_reserved
+++ a/include/linux/page-flags.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/bounds.h>
 
 /*
  * Various page->flags bits:
@@ -59,13 +60,12 @@
  * extends from the high bits downwards.
  *
  *  | FIELD | ... | FLAGS |
- *  N-1     ^             0
- *          (N-FLAGS_RESERVED)
+ *  N-1           ^       0
+ *               (NR_PAGEFLAGS)
  *
- * The fields area is reserved for fields mapping zone, node and SPARSEMEM
- * section.  The boundry between these two areas is defined by
- * FLAGS_RESERVED which defines the width of the fields section
- * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
+ * The fields area is reserved for fields mapping zone, node (for NUMA) and
+ * SPARSEMEM section (for variants of SPARSEMEM that require section ids like
+ * SPARSEMEM_EXTREME with !SPARSEMEM_VMEMMAP).
  */
 enum pageflags {
 	PG_locked,		/* Page is locked. Don't touch. */
@@ -101,7 +101,7 @@ enum pageflags {
  */
 	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
-	NR_PAGEFLAGS
+	__NR_PAGEFLAGS
 };
 
 /*
diff -puN kernel/bounds.c~pageflags-get-rid-of-flags_reserved kernel/bounds.c
--- a/kernel/bounds.c~pageflags-get-rid-of-flags_reserved
+++ a/kernel/bounds.c
@@ -13,4 +13,5 @@
 
 void foo(void)
 {
+	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-mempolicy-reference-counting-bugs.patch
git-unionfs.patch
git-slub.patch
slab-pass-correct-flags-to-kmem_getpages.patch
ntfs-fix-nommu-build.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

