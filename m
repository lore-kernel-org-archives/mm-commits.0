From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:46 -0800
Message-ID: <548d0d12.inkKvdr0E+X/oMIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaLNEHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: make debug-pagealloc boottime configurable
has been removed from the -mm tree.  Its filename was
     mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug-pagealloc: make debug-pagealloc boottime configurable

Now, we have prepared to avoid using debug-pagealloc in boottime.  So
introduce new kernel-parameter to disable debug-pagealloc in boottime, and
makes related functions to be disabled in this case.

Only non-intuitive part is change of guard page functions.  Because guard
page is effective only if debug-pagealloc is enabled, turning off
according to debug-pagealloc is reasonable thing to do.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/powerpc/mm/hash_utils_64.c     |    2 +-
 arch/powerpc/mm/pgtable_32.c        |    2 +-
 arch/s390/mm/pageattr.c             |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c              |    2 +-
 include/linux/mm.h                  |   17 ++++++++++++++++-
 mm/debug-pagealloc.c                |    8 +++++++-
 mm/page_alloc.c                     |   20 ++++++++++++++++++++
 9 files changed, 57 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/Documentation/kernel-parameters.txt
@@ -829,6 +829,15 @@ bytes respectively. Such letter suffixes
 			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
 			tracking down these problems.
 
+	debug_pagealloc=
+			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. In
+			default, it is disabled. We can avoid allocating huge
+			chunk of memory for debug pagealloc if we don't enable
+			it at boot time and the system will work mostly same
+			with the kernel built without CONFIG_DEBUG_PAGEALLOC.
+			on: enable the feature
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
diff -puN arch/powerpc/mm/hash_utils_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -1514,7 +1514,7 @@ static void kernel_unmap_linear_page(uns
 			       mmu_kernel_ssize, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long flags, vaddr, lmi;
 	int i;
diff -puN arch/powerpc/mm/pgtable_32.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/powerpc/mm/pgtable_32.c
--- a/arch/powerpc/mm/pgtable_32.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -429,7 +429,7 @@ static int change_page_attr(struct page
 }
 
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff -puN arch/s390/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/s390/mm/pageattr.c
--- a/arch/s390/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/s390/mm/pageattr.c
@@ -120,7 +120,7 @@ static void ipte_range(pte_t *pte, unsig
 	}
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long address;
 	int nr, i, j;
diff -puN arch/sparc/mm/init_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/sparc/mm/init_64.c
@@ -1621,7 +1621,7 @@ static void __init kernel_physical_mappi
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long phys_start = page_to_pfn(page) << PAGE_SHIFT;
 	unsigned long phys_end = phys_start + (numpages * PAGE_SIZE);
diff -puN arch/x86/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/arch/x86/mm/pageattr.c
@@ -1817,7 +1817,7 @@ static int __set_pages_np(struct page *p
 	return __change_page_attr_set_clr(&cpa, 0);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (PageHighMem(page))
 		return;
diff -puN include/linux/mm.h~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable include/linux/mm.h
--- a/include/linux/mm.h~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/include/linux/mm.h
@@ -2061,7 +2061,22 @@ static inline void vm_stat_account(struc
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
+extern bool _debug_pagealloc_enabled;
+extern void __kernel_map_pages(struct page *page, int numpages, int enable);
+
+static inline bool debug_pagealloc_enabled(void)
+{
+	return _debug_pagealloc_enabled;
+}
+
+static inline void
+kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	if (!debug_pagealloc_enabled())
+		return;
+
+	__kernel_map_pages(page, numpages, enable);
+}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
diff -puN mm/debug-pagealloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable mm/debug-pagealloc.c
--- a/mm/debug-pagealloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/mm/debug-pagealloc.c
@@ -10,11 +10,17 @@ static bool page_poisoning_enabled __rea
 
 static bool need_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_page_poisoning(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	page_poisoning_enabled = true;
 }
 
@@ -119,7 +125,7 @@ static void unpoison_pages(struct page *
 		unpoison_page(page + i);
 }
 
-void kernel_map_pages(struct page *page, int numpages, int enable)
+void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!page_poisoning_enabled)
 		return;
diff -puN mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable
+++ a/mm/page_alloc.c
@@ -425,15 +425,35 @@ static inline void prep_zero_page(struct
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
+bool _debug_pagealloc_enabled __read_mostly;
 bool _debug_guardpage_enabled __read_mostly;
 
+static int __init early_debug_pagealloc(char *buf)
+{
+	if (!buf)
+		return -EINVAL;
+
+	if (strcmp(buf, "on") == 0)
+		_debug_pagealloc_enabled = true;
+
+	return 0;
+}
+early_param("debug_pagealloc", early_debug_pagealloc);
+
 static bool need_debug_guardpage(void)
 {
+	/* If we don't use debug_pagealloc, we don't need guard page */
+	if (!debug_pagealloc_enabled())
+		return false;
+
 	return true;
 }
 
 static void init_debug_guardpage(void)
 {
+	if (!debug_pagealloc_enabled())
+		return;
+
 	_debug_guardpage_enabled = true;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

