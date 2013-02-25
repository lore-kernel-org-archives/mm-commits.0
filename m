From: akpm@linux-foundation.org
Subject: [merged] mm-fold-page-_last_nid-into-page-flags-where-possible.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:46 -0800
Message-ID: <20130225205246.BE7F95A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55714 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911Ab3BYUws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:48 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so362880qaj.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mgorman@suse.de, mingo@kernel.org, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fold page->_last_nid into page->flags where possible
has been removed from the -mm tree.  Its filename was
     mm-fold-page-_last_nid-into-page-flags-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: mm: fold page->_last_nid into page->flags where possible

page->_last_nid fits into page->flags on 64-bit.  The unlikely 32-bit NUMA
configuration with NUMA Balancing will still need an extra page field.  As
Peter notes "Completely dropping 32bit support for CONFIG_NUMA_BALANCING
would simplify things, but it would also remove the warning if we grow
enough 64bit only page-flags to push the last-cpu out."

[mgorman@suse.de: minor modifications]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |   33 +++++++++++++++++++++++++++-
 include/linux/mm_types.h          |    2 -
 include/linux/page-flags-layout.h |   33 +++++++++++++++++++++-------
 mm/memory.c                       |    4 +++
 4 files changed, 62 insertions(+), 10 deletions(-)

diff -puN include/linux/mm.h~mm-fold-page-_last_nid-into-page-flags-where-possible include/linux/mm.h
--- a/include/linux/mm.h~mm-fold-page-_last_nid-into-page-flags-where-possible
+++ a/include/linux/mm.h
@@ -581,10 +581,11 @@ static inline pte_t maybe_mkwrite(pte_t 
  * sets it, so none of the operations on it need to be atomic.
  */
 
-/* Page flags: | [SECTION] | [NODE] | ZONE | ... | FLAGS | */
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
+#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
 
 /*
  * Define the bit shifts to access each section.  For non-existent
@@ -594,6 +595,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 #define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
+#define LAST_NID_PGSHIFT	(LAST_NID_PGOFF * (LAST_NID_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
 #ifdef NODE_NOT_IN_PAGE_FLAGS
@@ -615,6 +617,7 @@ static inline pte_t maybe_mkwrite(pte_t 
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
+#define LAST_NID_MASK		((1UL << LAST_NID_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(const struct page *page)
@@ -654,6 +657,7 @@ static inline int page_to_nid(const stru
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
 static inline int page_xchg_last_nid(struct page *page, int nid)
 {
 	return xchg(&page->_last_nid, nid);
@@ -668,6 +672,33 @@ static inline void reset_page_last_nid(s
 	page->_last_nid = -1;
 }
 #else
+static inline int page_last_nid(struct page *page)
+{
+	return (page->flags >> LAST_NID_PGSHIFT) & LAST_NID_MASK;
+}
+
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	unsigned long old_flags, flags;
+	int last_nid;
+
+	do {
+		old_flags = flags = page->flags;
+		last_nid = page_last_nid(page);
+
+		flags &= ~(LAST_NID_MASK << LAST_NID_PGSHIFT);
+		flags |= (nid & LAST_NID_MASK) << LAST_NID_PGSHIFT;
+	} while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
+
+	return last_nid;
+}
+
+static inline void reset_page_last_nid(struct page *page)
+{
+	page_xchg_last_nid(page, (1 << LAST_NID_SHIFT) - 1);
+}
+#endif /* LAST_NID_NOT_IN_PAGE_FLAGS */
+#else
 static inline int page_xchg_last_nid(struct page *page, int nid)
 {
 	return page_to_nid(page);
diff -puN include/linux/mm_types.h~mm-fold-page-_last_nid-into-page-flags-where-possible include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fold-page-_last_nid-into-page-flags-where-possible
+++ a/include/linux/mm_types.h
@@ -174,7 +174,7 @@ struct page {
 	void *shadow;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
 	int _last_nid;
 #endif
 }
diff -puN include/linux/page-flags-layout.h~mm-fold-page-_last_nid-into-page-flags-where-possible include/linux/page-flags-layout.h
--- a/include/linux/page-flags-layout.h~mm-fold-page-_last_nid-into-page-flags-where-possible
+++ a/include/linux/page-flags-layout.h
@@ -32,15 +32,16 @@
 /*
  * page->flags layout:
  *
- * There are three possibilities for how page->flags get
- * laid out.  The first is for the normal case, without
- * sparsemem.  The second is for sparsemem when there is
- * plenty of space for node and section.  The last is when
- * we have run out of space and have to fall back to an
- * alternate (slower) way of determining the node.
+ * There are five possibilities for how page->flags get laid out.  The first
+ * pair is for the normal case without sparsemem. The second pair is for
+ * sparsemem when there is plenty of space for node and section information.
+ * The last is when there is insufficient space in page->flags and a separate
+ * lookup is necessary.
  *
- * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
- * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE |          ... | FLAGS |
+ *         " plus space for last_nid: |       NODE     | ZONE | LAST_NID ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE |          ... | FLAGS |
+ *         " plus space for last_nid: | SECTION | NODE | ZONE | LAST_NID ... | FLAGS |
  * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
@@ -60,6 +61,18 @@
 #define NODES_WIDTH		0
 #endif
 
+#ifdef CONFIG_NUMA_BALANCING
+#define LAST_NID_SHIFT NODES_SHIFT
+#else
+#define LAST_NID_SHIFT 0
+#endif
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_NID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define LAST_NID_WIDTH LAST_NID_SHIFT
+#else
+#define LAST_NID_WIDTH 0
+#endif
+
 /*
  * We are going to use the flags for the page to node mapping if its in
  * there.  This includes the case where there is no node, so it is implicit.
@@ -68,4 +81,8 @@
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
+#if defined(CONFIG_NUMA_BALANCING) && LAST_NID_WIDTH == 0
+#define LAST_NID_NOT_IN_PAGE_FLAGS
+#endif
+
 #endif /* _LINUX_PAGE_FLAGS_LAYOUT */
diff -puN mm/memory.c~mm-fold-page-_last_nid-into-page-flags-where-possible mm/memory.c
--- a/mm/memory.c~mm-fold-page-_last_nid-into-page-flags-where-possible
+++ a/mm/memory.c
@@ -69,6 +69,10 @@
 
 #include "internal.h"
 
+#ifdef LAST_NID_NOT_IN_PAGE_FLAGS
+#warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_nid.
+#endif
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
kernel-smpc-cleanups.patch
events-convert-to-idr_alloc.patch
ipc-semc-alternatives-to-preempt_disable.patch

