From: akpm@linux-foundation.org
Subject: - mm-add-a-basic-debugging-framework-for-memory-initialisation.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:20:21 -0700
Message-ID: <200807242320.m6ONKLKA010336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbYGXXUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, cl@linux-foundation.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: add a basic debugging framework for memory initialisation
has been removed from the -mm tree.  Its filename was
     mm-add-a-basic-debugging-framework-for-memory-initialisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add a basic debugging framework for memory initialisation
From: Mel Gorman <mel@csn.ul.ie>

Boot initialisation is very complex, with significant numbers of
architecture-specific routines, hooks and code ordering.  While significant
amounts of the initialisation is architecture-independent, it trusts the data
received from the architecture layer.  This is a mistake, and has resulted in
a number of difficult-to-diagnose bugs.

This patchset adds some validation and tracing to memory initialisation.  It
also introduces a few basic defensive measures.  The validation code can be
explicitly disabled for embedded systems.



This patch:

Add additional debugging and verification code for memory initialisation.

Once enabled, the verification checks are always run and when required
additional debugging information may be outputted via a mminit_loglevel=
command-line parameter.

The verification code is placed in a new file mm/mm_init.c.  Ideally other mm
initialisation code will be moved here over time.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 +++++++
 lib/Kconfig.debug                   |   12 +++++++++++
 mm/Makefile                         |    1 
 mm/internal.h                       |   27 ++++++++++++++++++++++++++
 mm/mm_init.c                        |   18 +++++++++++++++++
 mm/page_alloc.c                     |   22 ++++++++++++---------
 6 files changed, 79 insertions(+), 9 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-add-a-basic-debugging-framework-for-memory-initialisation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/Documentation/kernel-parameters.txt
@@ -1225,6 +1225,14 @@ and is between 256 and 4096 characters. 
 
 	mga=		[HW,DRM]
 
+	mminit_loglevel=
+			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
+			parameter allows control of the logging verbosity for
+			the additional memory initialisation checks. A value
+			of 0 disables mminit logging and a level of 4 will
+			log everything. Information is printed at KERN_DEBUG
+			so loglevel=8 may also need to be specified.
+
 	mousedev.tap_time=
 			[MOUSE] Maximum time between finger touching and
 			leaving touchpad surface for touch to be considered
diff -puN lib/Kconfig.debug~mm-add-a-basic-debugging-framework-for-memory-initialisation lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/lib/Kconfig.debug
@@ -481,6 +481,18 @@ config DEBUG_WRITECOUNT
 
 	  If unsure, say N.
 
+config DEBUG_MEMORY_INIT
+	bool "Debug memory initialisation" if EMBEDDED
+	default !EMBEDDED
+	help
+	  Enable this for additional checks during memory initialisation.
+	  The sanity checks verify aspects of the VM such as the memory model
+	  and other information provided by the architecture. Verbose
+	  information will be printed at KERN_DEBUG loglevel depending
+	  on the mminit_loglevel= command-line option.
+
+	  If unsure, say Y
+
 config DEBUG_LIST
 	bool "Debug linked list manipulation"
 	depends on DEBUG_KERNEL
diff -puN mm/Makefile~mm-add-a-basic-debugging-framework-for-memory-initialisation mm/Makefile
--- a/mm/Makefile~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/mm/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_a
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
+obj-$(CONFIG_DEBUG_MEMORY_INIT) += mm_init.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
diff -puN mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation mm/internal.h
--- a/mm/internal.h~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/mm/internal.h
@@ -59,4 +59,31 @@ static inline unsigned long page_order(s
 #define __paginginit __init
 #endif
 
+/* Memory initialisation debug and verification */
+enum mminit_level {
+	MMINIT_WARNING,
+	MMINIT_VERIFY,
+	MMINIT_TRACE
+};
+
+#ifdef CONFIG_DEBUG_MEMORY_INIT
+
+extern int mminit_loglevel;
+
+#define mminit_dprintk(level, prefix, fmt, arg...) \
+do { \
+	if (level < mminit_loglevel) { \
+		printk(level <= MMINIT_WARNING ? KERN_WARNING : KERN_DEBUG); \
+		printk(KERN_CONT "mminit::" prefix " " fmt, ##arg); \
+	} \
+} while (0)
+
+#else
+
+static inline void mminit_dprintk(enum mminit_level level,
+				const char *prefix, const char *fmt, ...)
+{
+}
+
+#endif /* CONFIG_DEBUG_MEMORY_INIT */
 #endif
diff -puN mm/mm_init.c~mm-add-a-basic-debugging-framework-for-memory-initialisation mm/mm_init.c
--- a/mm/mm_init.c~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/mm/mm_init.c
@@ -0,0 +1,18 @@
+/*
+ * mm_init.c - Memory initialisation verification and debugging
+ *
+ * Copyright 2008 IBM Corporation, 2008
+ * Author Mel Gorman <mel@csn.ul.ie>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+int __meminitdata mminit_loglevel;
+
+static __init int set_mminit_loglevel(char *str)
+{
+	get_option(&str, &mminit_loglevel);
+	return 0;
+}
+early_param("mminit_loglevel", set_mminit_loglevel);
diff -puN mm/page_alloc.c~mm-add-a-basic-debugging-framework-for-memory-initialisation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-a-basic-debugging-framework-for-memory-initialisation
+++ a/mm/page_alloc.c
@@ -2975,7 +2975,8 @@ void __init sparse_memory_present_with_a
 void __init push_node_boundaries(unsigned int nid,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
-	printk(KERN_DEBUG "Entering push_node_boundaries(%u, %lu, %lu)\n",
+	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
+			"Entering push_node_boundaries(%u, %lu, %lu)\n",
 			nid, start_pfn, end_pfn);
 
 	/* Initialise the boundary for this node if necessary */
@@ -2993,7 +2994,8 @@ void __init push_node_boundaries(unsigne
 static void __meminit account_node_boundary(unsigned int nid,
 		unsigned long *start_pfn, unsigned long *end_pfn)
 {
-	printk(KERN_DEBUG "Entering account_node_boundary(%u, %lu, %lu)\n",
+	mminit_dprintk(MMINIT_TRACE, "zoneboundary",
+			"Entering account_node_boundary(%u, %lu, %lu)\n",
 			nid, *start_pfn, *end_pfn);
 
 	/* Return if boundary information has not been provided */
@@ -3368,8 +3370,8 @@ static void __paginginit free_area_init_
 			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
 		if (realsize >= memmap_pages) {
 			realsize -= memmap_pages;
-			printk(KERN_DEBUG
-				"  %s zone: %lu pages used for memmap\n",
+			mminit_dprintk(MMINIT_TRACE, "memmap_init",
+				"%s zone: %lu pages used for memmap\n",
 				zone_names[j], memmap_pages);
 		} else
 			printk(KERN_WARNING
@@ -3379,7 +3381,8 @@ static void __paginginit free_area_init_
 		/* Account for reserved pages */
 		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
+			mminit_dprintk(MMINIT_TRACE, "memmap_init",
+					"%s zone: %lu pages reserved\n",
 					zone_names[0], dma_reserve);
 		}
 
@@ -3520,10 +3523,11 @@ void __init add_active_range(unsigned in
 {
 	int i;
 
-	printk(KERN_DEBUG "Entering add_active_range(%d, %#lx, %#lx) "
-			  "%d entries of %d used\n",
-			  nid, start_pfn, end_pfn,
-			  nr_nodemap_entries, MAX_ACTIVE_REGIONS);
+	mminit_dprintk(MMINIT_TRACE, "memory_register",
+			"Entering add_active_range(%d, %#lx, %#lx) "
+			"%d entries of %d used\n",
+			nid, start_pfn, end_pfn,
+			nr_nodemap_entries, MAX_ACTIVE_REGIONS);
 
 	/* Merge with existing active regions if possible */
 	for (i = 0; i < nr_nodemap_entries; i++) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

