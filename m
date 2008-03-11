From: akpm@linux-foundation.org
Subject: - pageflags-get-rid-of-flags_reserved.patch removed from -mm tree
Date: Mon, 10 Mar 2008 21:41:23 -0700
Message-ID: <200803110450.m2B4ouwW022952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755955AbYCKEvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 00:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     pageflags: get rid of FLAGS_RESERVED
has been removed from the -mm tree.  Its filename was
     pageflags-get-rid-of-flags_reserved.patch

This patch was dropped because it had testing failures

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    6 +++---
 include/linux/mmzone.h     |   19 -------------------
 include/linux/page-flags.h |   20 +++++++++++++-------
 kernel/bounds.c            |    1 +
 4 files changed, 17 insertions(+), 29 deletions(-)

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
@@ -59,13 +59,12 @@
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
@@ -101,9 +100,16 @@ enum pageflags {
  */
 	PG_uncached = 31,		/* Page has been mapped as uncached */
 #endif
-	NR_PAGEFLAGS
+	__NR_PAGEFLAGS
 };
 
+#ifndef __GENERATING_BOUNDS_H
+#include <linux/bounds.h>
+#else
+/* Dummy for use during bounds.h generation */
+#define NR_PAGEFLAGS 1
+#endif
+
 /*
  * Manipulation of page state flags
  */
diff -puN kernel/bounds.c~pageflags-get-rid-of-flags_reserved kernel/bounds.c
--- a/kernel/bounds.c~pageflags-get-rid-of-flags_reserved
+++ a/kernel/bounds.c
@@ -15,5 +15,6 @@
 void foo(void)
 {
 	/* The enum constants to put into include/linux/bounds.h */
+	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
 	/* End of constants */
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ntfs-fix-nommu-build.patch
git-net.patch
git-unionfs.patch
git-slub.patch
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
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-move-cache_line_size-to-linux-cacheh.patch
mempolicy-convert-mpol-constants-to-enum.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-add-mpol_f_static_nodes-flag.patch
mempolicy-add-bitmap_onto-and-bitmap_fold-operations.patch
mempolicy-add-mpol_f_relative_nodes-flag.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-move-rebind-functions.patch
mempolicy-create-mempolicy_operations-structure.patch
mempolicy-create-mempolicy_operations-structure-fix.patch
mempolicy-small-header-file-cleanup.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
get-rid-of-__zone_count.patch
dmapool-enable-debugging-for-config_slub_debug_on-too.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

