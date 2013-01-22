From: akpm@linux-foundation.org
Subject: + mm-move-page-flags-layout-to-separate-header.patch added to -mm tree
Date: Tue, 22 Jan 2013 14:47:44 -0800
Message-ID: <20130122224745.394F331C242@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37930 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3AVWrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 17:47:46 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so29293qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 14:47:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, aarcange@redhat.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mgorman@suse.de, mingo@kernel.org, simon.jeons@gmail.com


The patch titled
     Subject: mm: move page flags layout to separate header
has been added to the -mm tree.  Its filename is
     mm-move-page-flags-layout-to-separate-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: mm: move page flags layout to separate header

This is a preparation patch for moving page->_last_nid into page->flags
that moves page flag layout information to a separate header.  This patch
is necessary because otherwise there would be a circular dependency
between mm_types.h and mm.h.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                |   40 ---------------
 include/linux/mm_types.h          |    1 
 include/linux/mmzone.h            |   22 --------
 include/linux/page-flags-layout.h |   71 ++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 61 deletions(-)

diff -puN include/linux/mm.h~mm-move-page-flags-layout-to-separate-header include/linux/mm.h
--- a/include/linux/mm.h~mm-move-page-flags-layout-to-separate-header
+++ a/include/linux/mm.h
@@ -581,52 +581,12 @@ static inline pte_t maybe_mkwrite(pte_t 
  * sets it, so none of the operations on it need to be atomic.
  */
 
-
-/*
- * page->flags layout:
- *
- * There are three possibilities for how page->flags get
- * laid out.  The first is for the normal case, without
- * sparsemem.  The second is for sparsemem when there is
- * plenty of space for node and section.  The last is when
- * we have run out of space and have to fall back to an
- * alternate (slower) way of determining the node.
- *
- * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
- * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
- * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
- */
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-#define SECTIONS_WIDTH		SECTIONS_SHIFT
-#else
-#define SECTIONS_WIDTH		0
-#endif
-
-#define ZONES_WIDTH		ZONES_SHIFT
-
-#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
-#define NODES_WIDTH		NODES_SHIFT
-#else
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-#error "Vmemmap: No space for nodes field in page flags"
-#endif
-#define NODES_WIDTH		0
-#endif
-
 /* Page flags: | [SECTION] | [NODE] | ZONE | ... | FLAGS | */
 #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
 #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
 #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
 
 /*
- * We are going to use the flags for the page to node mapping if its in
- * there.  This includes the case where there is no node, so it is implicit.
- */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
-#define NODE_NOT_IN_PAGE_FLAGS
-#endif
-
-/*
  * Define the bit shifts to access each section.  For non-existent
  * sections we define the shift as 0; that plus a 0 mask ensures
  * the compiler will optimise away reference to them.
diff -puN include/linux/mm_types.h~mm-move-page-flags-layout-to-separate-header include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-move-page-flags-layout-to-separate-header
+++ a/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
 #include <linux/uprobes.h>
+#include <linux/page-flags-layout.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
diff -puN include/linux/mmzone.h~mm-move-page-flags-layout-to-separate-header include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-page-flags-layout-to-separate-header
+++ a/include/linux/mmzone.h
@@ -15,7 +15,7 @@
 #include <linux/seqlock.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
-#include <generated/bounds.h>
+#include <linux/page-flags-layout.h>
 #include <linux/atomic.h>
 #include <asm/page.h>
 
@@ -310,24 +310,6 @@ enum zone_type {
 
 #ifndef __GENERATING_BOUNDS_H
 
-/*
- * When a memory allocation must conform to specific limitations (such
- * as being suitable for DMA) the caller will pass in hints to the
- * allocator in the gfp_mask, in the zone modifier bits.  These bits
- * are used to select a priority ordered list of memory zones which
- * match the requested limits. See gfp_zone() in include/linux/gfp.h
- */
-
-#if MAX_NR_ZONES < 2
-#define ZONES_SHIFT 0
-#elif MAX_NR_ZONES <= 2
-#define ZONES_SHIFT 1
-#elif MAX_NR_ZONES <= 4
-#define ZONES_SHIFT 2
-#else
-#error ZONES_SHIFT -- too many zones configured adjust calculation
-#endif
-
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 
@@ -1055,8 +1037,6 @@ static inline unsigned long early_pfn_to
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
-#define SECTIONS_SHIFT		(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
-
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
 #define PFN_SECTION_SHIFT	(SECTION_SIZE_BITS - PAGE_SHIFT)
 
diff -puN /dev/null include/linux/page-flags-layout.h
--- /dev/null
+++ a/include/linux/page-flags-layout.h
@@ -0,0 +1,71 @@
+#ifndef PAGE_FLAGS_LAYOUT_H
+#define PAGE_FLAGS_LAYOUT_H
+
+#include <linux/numa.h>
+#include <generated/bounds.h>
+
+/*
+ * When a memory allocation must conform to specific limitations (such
+ * as being suitable for DMA) the caller will pass in hints to the
+ * allocator in the gfp_mask, in the zone modifier bits.  These bits
+ * are used to select a priority ordered list of memory zones which
+ * match the requested limits. See gfp_zone() in include/linux/gfp.h
+ */
+#if MAX_NR_ZONES < 2
+#define ZONES_SHIFT 0
+#elif MAX_NR_ZONES <= 2
+#define ZONES_SHIFT 1
+#elif MAX_NR_ZONES <= 4
+#define ZONES_SHIFT 2
+#else
+#error ZONES_SHIFT -- too many zones configured adjust calculation
+#endif
+
+#ifdef CONFIG_SPARSEMEM
+#include <asm/sparsemem.h>
+
+/* SECTION_SHIFT	#bits space required to store a section # */
+#define SECTIONS_SHIFT	(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
+
+#endif /* CONFIG_SPARSEMEM */
+
+/*
+ * page->flags layout:
+ *
+ * There are three possibilities for how page->flags get
+ * laid out.  The first is for the normal case, without
+ * sparsemem.  The second is for sparsemem when there is
+ * plenty of space for node and section.  The last is when
+ * we have run out of space and have to fall back to an
+ * alternate (slower) way of determining the node.
+ *
+ * No sparsemem or sparsemem vmemmap: |       NODE     | ZONE | ... | FLAGS |
+ * classic sparse with space for node:| SECTION | NODE | ZONE | ... | FLAGS |
+ * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
+ */
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#define SECTIONS_WIDTH		SECTIONS_SHIFT
+#else
+#define SECTIONS_WIDTH		0
+#endif
+
+#define ZONES_WIDTH		ZONES_SHIFT
+
+#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
+#define NODES_WIDTH		NODES_SHIFT
+#else
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#error "Vmemmap: No space for nodes field in page flags"
+#endif
+#define NODES_WIDTH		0
+#endif
+
+/*
+ * We are going to use the flags for the page to node mapping if its in
+ * there.  This includes the case where there is no node, so it is implicit.
+ */
+#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#define NODE_NOT_IN_PAGE_FLAGS
+#endif
+
+#endif /* _LINUX_PAGE_FLAGS_LAYOUT */
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
smp-make-smp_call_function_many-use-logic-similar-to-smp_call_function_single.patch
kernel-smpc-cleanups.patch
ipc-semc-alternatives-to-preempt_disable.patch

