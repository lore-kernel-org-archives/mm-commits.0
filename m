From: akpm@linux-foundation.org
Subject: [merged] proc-add-kpageidle-file.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:22 -0700
Message-ID: <55f3194a.fq5r6lVjcsg3E/K6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbIKSLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add kpageidle file
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc: add kpageidle file

Knowing the portion of memory that is not used by a certain application or
memory cgroup (idle memory) can be useful for partitioning the system
efficiently, e.g.  by setting memory cgroup limits appropriately. 
Currently, the only means to estimate the amount of idle memory provided
by the kernel is /proc/PID/{clear_refs,smaps}: the user can clear the
access bit for all pages mapped to a particular process by writing 1 to
clear_refs, wait for some time, and then count smaps:Referenced.  However,
this method has two serious shortcomings:

 - it does not count unmapped file pages
 - it affects the reclaimer logic

To overcome these drawbacks, this patch introduces two new page flags,
Idle and Young, and a new proc file, /proc/kpageidle.  A page's Idle flag
can only be set from userspace by setting bit in /proc/kpageidle at the
offset corresponding to the page, and it is cleared whenever the page is
accessed either through page tables (it is cleared in page_referenced() in
this case) or using the read(2) system call (mark_page_accessed()).  Thus
by setting the Idle flag for pages of a particular workload, which can be
found e.g.  by reading /proc/PID/pagemap, waiting for some time to let the
workload access its working set, and then reading the kpageidle file, one
can estimate the amount of pages that are not used by the workload.

The Young page flag is used to avoid interference with the memory
reclaimer.  A page's Young flag is set whenever the Access bit of a page
table entry pointing to the page is cleared by writing to kpageidle.  If
page_referenced() is called on a Young page, it will add 1 to its return
value, therefore concealing the fact that the Access bit was cleared.

Note, since there is no room for extra page flags on 32 bit, this feature
uses extended page flags when compiled on 32 bit.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: kpageidle requires an MMU]
[akpm@linux-foundation.org: decouple from page-flags rework]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX               |    2 
 Documentation/vm/idle_page_tracking.txt |   98 +++++++++
 fs/proc/page.c                          |    3 
 fs/proc/task_mmu.c                      |    5 
 include/linux/mmu_notifier.h            |    2 
 include/linux/page-flags.h              |   11 +
 include/linux/page_ext.h                |    4 
 include/linux/page_idle.h               |  110 ++++++++++
 mm/Kconfig                              |   12 +
 mm/Makefile                             |    1 
 mm/debug.c                              |    4 
 mm/huge_memory.c                        |   12 -
 mm/migrate.c                            |    6 
 mm/page_ext.c                           |    4 
 mm/page_idle.c                          |  232 ++++++++++++++++++++++
 mm/rmap.c                               |    6 
 mm/swap.c                               |    3 
 17 files changed, 512 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/00-INDEX~proc-add-kpageidle-file Documentation/vm/00-INDEX
--- a/Documentation/vm/00-INDEX~proc-add-kpageidle-file
+++ a/Documentation/vm/00-INDEX
@@ -14,6 +14,8 @@ hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
 hwpoison.txt
 	- explains what hwpoison is
+idle_page_tracking.txt
+	- description of the idle page tracking feature.
 ksm.txt
 	- how to use the Kernel Samepage Merging feature.
 numa
diff -puN /dev/null Documentation/vm/idle_page_tracking.txt
--- /dev/null
+++ a/Documentation/vm/idle_page_tracking.txt
@@ -0,0 +1,98 @@
+MOTIVATION
+
+The idle page tracking feature allows to track which memory pages are being
+accessed by a workload and which are idle. This information can be useful for
+estimating the workload's working set size, which, in turn, can be taken into
+account when configuring the workload parameters, setting memory cgroup limits,
+or deciding where to place the workload within a compute cluster.
+
+It is enabled by CONFIG_IDLE_PAGE_TRACKING=y.
+
+USER API
+
+The idle page tracking API is located at /sys/kernel/mm/page_idle. Currently,
+it consists of the only read-write file, /sys/kernel/mm/page_idle/bitmap.
+
+The file implements a bitmap where each bit corresponds to a memory page. The
+bitmap is represented by an array of 8-byte integers, and the page at PFN #i is
+mapped to bit #i%64 of array element #i/64, byte order is native. When a bit is
+set, the corresponding page is idle.
+
+A page is considered idle if it has not been accessed since it was marked idle
+(for more details on what "accessed" actually means see the IMPLEMENTATION
+DETAILS section). To mark a page idle one has to set the bit corresponding to
+the page by writing to the file. A value written to the file is OR-ed with the
+current bitmap value.
+
+Only accesses to user memory pages are tracked. These are pages mapped to a
+process address space, page cache and buffer pages, swap cache pages. For other
+page types (e.g. SLAB pages) an attempt to mark a page idle is silently ignored,
+and hence such pages are never reported idle.
+
+For huge pages the idle flag is set only on the head page, so one has to read
+/proc/kpageflags in order to correctly count idle huge pages.
+
+Reading from or writing to /sys/kernel/mm/page_idle/bitmap will return
+-EINVAL if you are not starting the read/write on an 8-byte boundary, or
+if the size of the read/write is not a multiple of 8 bytes. Writing to
+this file beyond max PFN will return -ENXIO.
+
+That said, in order to estimate the amount of pages that are not used by a
+workload one should:
+
+ 1. Mark all the workload's pages as idle by setting corresponding bits in
+    /sys/kernel/mm/page_idle/bitmap. The pages can be found by reading
+    /proc/pid/pagemap if the workload is represented by a process, or by
+    filtering out alien pages using /proc/kpagecgroup in case the workload is
+    placed in a memory cgroup.
+
+ 2. Wait until the workload accesses its working set.
+
+ 3. Read /sys/kernel/mm/page_idle/bitmap and count the number of bits set. If
+    one wants to ignore certain types of pages, e.g. mlocked pages since they
+    are not reclaimable, he or she can filter them out using /proc/kpageflags.
+
+See Documentation/vm/pagemap.txt for more information about /proc/pid/pagemap,
+/proc/kpageflags, and /proc/kpagecgroup.
+
+IMPLEMENTATION DETAILS
+
+The kernel internally keeps track of accesses to user memory pages in order to
+reclaim unreferenced pages first on memory shortage conditions. A page is
+considered referenced if it has been recently accessed via a process address
+space, in which case one or more PTEs it is mapped to will have the Accessed bit
+set, or marked accessed explicitly by the kernel (see mark_page_accessed()). The
+latter happens when:
+
+ - a userspace process reads or writes a page using a system call (e.g. read(2)
+   or write(2))
+
+ - a page that is used for storing filesystem buffers is read or written,
+   because a process needs filesystem metadata stored in it (e.g. lists a
+   directory tree)
+
+ - a page is accessed by a device driver using get_user_pages()
+
+When a dirty page is written to swap or disk as a result of memory reclaim or
+exceeding the dirty memory limit, it is not marked referenced.
+
+The idle memory tracking feature adds a new page flag, the Idle flag. This flag
+is set manually, by writing to /sys/kernel/mm/page_idle/bitmap (see the USER API
+section), and cleared automatically whenever a page is referenced as defined
+above.
+
+When a page is marked idle, the Accessed bit must be cleared in all PTEs it is
+mapped to, otherwise we will not be able to detect accesses to the page coming
+from a process address space. To avoid interference with the reclaimer, which,
+as noted above, uses the Accessed bit to promote actively referenced pages, one
+more page flag is introduced, the Young flag. When the PTE Accessed bit is
+cleared as a result of setting or updating a page's Idle flag, the Young flag
+is set on the page. The reclaimer treats the Young flag as an extra PTE
+Accessed bit and therefore will consider such a page as referenced.
+
+Since the idle memory tracking feature is based on the memory reclaimer logic,
+it only works with pages that are on an LRU list, other pages are silently
+ignored. That means it will ignore a user memory page if it is isolated, but
+since there are usually not many of them, it should not affect the overall
+result noticeably. In order not to stall scanning of the idle page bitmap,
+locked pages may be skipped too.
diff -puN fs/proc/page.c~proc-add-kpageidle-file fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file
+++ a/fs/proc/page.c
@@ -10,12 +10,15 @@
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
+#include <linux/mmu_notifier.h>
+#include <linux/page_idle.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
+#define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
 /* /proc/kpagecount - an array exposing page counts
  *
diff -puN fs/proc/task_mmu.c~proc-add-kpageidle-file fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-add-kpageidle-file
+++ a/fs/proc/task_mmu.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
+#include <linux/page_idle.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
@@ -459,7 +460,7 @@ static void smaps_account(struct mem_siz
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || PageReferenced(page))
+	if (young || page_is_young(page) || PageReferenced(page))
 		mss->referenced += size;
 	mapcount = page_mapcount(page);
 	if (mapcount >= 2) {
@@ -807,6 +808,7 @@ static int clear_refs_pte_range(pmd_t *p
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
+		test_and_clear_page_young(page);
 		ClearPageReferenced(page);
 out:
 		spin_unlock(ptl);
@@ -834,6 +836,7 @@ out:
 
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
+		test_and_clear_page_young(page);
 		ClearPageReferenced(page);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
diff -puN include/linux/mmu_notifier.h~proc-add-kpageidle-file include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~proc-add-kpageidle-file
+++ a/include/linux/mmu_notifier.h
@@ -471,6 +471,8 @@ static inline void mmu_notifier_mm_destr
 
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
+#define ptep_clear_young_notify ptep_test_and_clear_young
+#define pmdp_clear_young_notify pmdp_test_and_clear_young
 #define	ptep_clear_flush_notify ptep_clear_flush
 #define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
 #define pmdp_huge_get_and_clear_notify pmdp_huge_get_and_clear
diff -puN include/linux/page-flags.h~proc-add-kpageidle-file include/linux/page-flags.h
--- a/include/linux/page-flags.h~proc-add-kpageidle-file
+++ a/include/linux/page-flags.h
@@ -109,6 +109,10 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+	PG_young,
+	PG_idle,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -289,6 +293,13 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+TESTPAGEFLAG(Young, young)
+SETPAGEFLAG(Young, young)
+TESTCLEARFLAG(Young, young)
+PAGEFLAG(Idle, idle)
+#endif
+
 /*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
diff -puN include/linux/page_ext.h~proc-add-kpageidle-file include/linux/page_ext.h
--- a/include/linux/page_ext.h~proc-add-kpageidle-file
+++ a/include/linux/page_ext.h
@@ -26,6 +26,10 @@ enum page_ext_flags {
 	PAGE_EXT_DEBUG_POISON,		/* Page is poisoned */
 	PAGE_EXT_DEBUG_GUARD,
 	PAGE_EXT_OWNER,
+#if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
+	PAGE_EXT_YOUNG,
+	PAGE_EXT_IDLE,
+#endif
 };
 
 /*
diff -puN /dev/null include/linux/page_idle.h
--- /dev/null
+++ a/include/linux/page_idle.h
@@ -0,0 +1,110 @@
+#ifndef _LINUX_MM_PAGE_IDLE_H
+#define _LINUX_MM_PAGE_IDLE_H
+
+#include <linux/bitops.h>
+#include <linux/page-flags.h>
+#include <linux/page_ext.h>
+
+#ifdef CONFIG_IDLE_PAGE_TRACKING
+
+#ifdef CONFIG_64BIT
+static inline bool page_is_young(struct page *page)
+{
+	return PageYoung(page);
+}
+
+static inline void set_page_young(struct page *page)
+{
+	SetPageYoung(page);
+}
+
+static inline bool test_and_clear_page_young(struct page *page)
+{
+	return TestClearPageYoung(page);
+}
+
+static inline bool page_is_idle(struct page *page)
+{
+	return PageIdle(page);
+}
+
+static inline void set_page_idle(struct page *page)
+{
+	SetPageIdle(page);
+}
+
+static inline void clear_page_idle(struct page *page)
+{
+	ClearPageIdle(page);
+}
+#else /* !CONFIG_64BIT */
+/*
+ * If there is not enough space to store Idle and Young bits in page flags, use
+ * page ext flags instead.
+ */
+extern struct page_ext_operations page_idle_ops;
+
+static inline bool page_is_young(struct page *page)
+{
+	return test_bit(PAGE_EXT_YOUNG, &lookup_page_ext(page)->flags);
+}
+
+static inline void set_page_young(struct page *page)
+{
+	set_bit(PAGE_EXT_YOUNG, &lookup_page_ext(page)->flags);
+}
+
+static inline bool test_and_clear_page_young(struct page *page)
+{
+	return test_and_clear_bit(PAGE_EXT_YOUNG,
+				  &lookup_page_ext(page)->flags);
+}
+
+static inline bool page_is_idle(struct page *page)
+{
+	return test_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+}
+
+static inline void set_page_idle(struct page *page)
+{
+	set_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+}
+
+static inline void clear_page_idle(struct page *page)
+{
+	clear_bit(PAGE_EXT_IDLE, &lookup_page_ext(page)->flags);
+}
+#endif /* CONFIG_64BIT */
+
+#else /* !CONFIG_IDLE_PAGE_TRACKING */
+
+static inline bool page_is_young(struct page *page)
+{
+	return false;
+}
+
+static inline void set_page_young(struct page *page)
+{
+}
+
+static inline bool test_and_clear_page_young(struct page *page)
+{
+	return false;
+}
+
+static inline bool page_is_idle(struct page *page)
+{
+	return false;
+}
+
+static inline void set_page_idle(struct page *page)
+{
+}
+
+static inline void clear_page_idle(struct page *page)
+{
+}
+
+#endif /* CONFIG_IDLE_PAGE_TRACKING */
+
+#endif /* _LINUX_MM_PAGE_IDLE_H */
diff -puN mm/Kconfig~proc-add-kpageidle-file mm/Kconfig
--- a/mm/Kconfig~proc-add-kpageidle-file
+++ a/mm/Kconfig
@@ -649,6 +649,18 @@ config DEFERRED_STRUCT_PAGE_INIT
 	  processes running early in the lifetime of the systemm until kswapd
 	  finishes the initialisation.
 
+config IDLE_PAGE_TRACKING
+	bool "Enable idle page tracking"
+	depends on SYSFS && MMU
+	select PAGE_EXTENSION if !64BIT
+	help
+	  This feature allows to estimate the amount of user pages that have
+	  not been touched during a given period of time. This information can
+	  be useful to tune memory cgroup limits and/or for job placement
+	  within a compute cluster.
+
+	  See Documentation/vm/idle_page_tracking.txt for more details.
+
 config ZONE_DEVICE
 	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
 	default !ZONE_DMA
diff -puN mm/Makefile~proc-add-kpageidle-file mm/Makefile
--- a/mm/Makefile~proc-add-kpageidle-file
+++ a/mm/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_MEMORY_BALLOON) += balloon_
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
+obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
diff -puN mm/debug.c~proc-add-kpageidle-file mm/debug.c
--- a/mm/debug.c~proc-add-kpageidle-file
+++ a/mm/debug.c
@@ -48,6 +48,10 @@ static const struct trace_print_flags pa
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+#if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
+	{1UL << PG_young,		"young"		},
+	{1UL << PG_idle,		"idle"		},
+#endif
 };
 
 static void dump_flags(unsigned long flags,
diff -puN mm/huge_memory.c~proc-add-kpageidle-file mm/huge_memory.c
--- a/mm/huge_memory.c~proc-add-kpageidle-file
+++ a/mm/huge_memory.c
@@ -25,6 +25,7 @@
 #include <linux/migrate.h>
 #include <linux/hashtable.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/page_idle.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -1757,6 +1758,11 @@ static void __split_huge_page_refcount(s
 		/* clear PageTail before overwriting first_page */
 		smp_wmb();
 
+		if (page_is_young(page))
+			set_page_young(page_tail);
+		if (page_is_idle(page))
+			set_page_idle(page_tail);
+
 		/*
 		 * __split_huge_page_splitting() already set the
 		 * splitting bit in all pmd that could map this
@@ -2262,7 +2268,8 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 
 		/* If there is no mapped pte young don't collapse the page */
-		if (pte_young(pteval) || PageReferenced(page) ||
+		if (pte_young(pteval) ||
+		    page_is_young(page) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = true;
 	}
@@ -2693,7 +2700,8 @@ static int khugepaged_scan_pmd(struct mm
 		 */
 		if (page_count(page) != 1 + !!PageSwapCache(page))
 			goto out_unmap;
-		if (pte_young(pteval) || PageReferenced(page) ||
+		if (pte_young(pteval) ||
+		    page_is_young(page) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = true;
 	}
diff -puN mm/migrate.c~proc-add-kpageidle-file mm/migrate.c
--- a/mm/migrate.c~proc-add-kpageidle-file
+++ a/mm/migrate.c
@@ -37,6 +37,7 @@
 #include <linux/gfp.h>
 #include <linux/balloon_compaction.h>
 #include <linux/mmu_notifier.h>
+#include <linux/page_idle.h>
 
 #include <asm/tlbflush.h>
 
@@ -524,6 +525,11 @@ void migrate_page_copy(struct page *newp
 			__set_page_dirty_nobuffers(newpage);
  	}
 
+	if (page_is_young(page))
+		set_page_young(newpage);
+	if (page_is_idle(page))
+		set_page_idle(newpage);
+
 	/*
 	 * Copy NUMA information to the new page, to prevent over-eager
 	 * future migrations of this same page.
diff -puN mm/page_ext.c~proc-add-kpageidle-file mm/page_ext.c
--- a/mm/page_ext.c~proc-add-kpageidle-file
+++ a/mm/page_ext.c
@@ -6,6 +6,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 #include <linux/page_owner.h>
+#include <linux/page_idle.h>
 
 /*
  * struct page extension
@@ -59,6 +60,9 @@ static struct page_ext_operations *page_
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
 #endif
+#if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
+	&page_idle_ops,
+#endif
 };
 
 static unsigned long total_usage;
diff -puN /dev/null mm/page_idle.c
--- /dev/null
+++ a/mm/page_idle.c
@@ -0,0 +1,232 @@
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/fs.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/pagemap.h>
+#include <linux/rmap.h>
+#include <linux/mmu_notifier.h>
+#include <linux/page_ext.h>
+#include <linux/page_idle.h>
+
+#define BITMAP_CHUNK_SIZE	sizeof(u64)
+#define BITMAP_CHUNK_BITS	(BITMAP_CHUNK_SIZE * BITS_PER_BYTE)
+
+/*
+ * Idle page tracking only considers user memory pages, for other types of
+ * pages the idle flag is always unset and an attempt to set it is silently
+ * ignored.
+ *
+ * We treat a page as a user memory page if it is on an LRU list, because it is
+ * always safe to pass such a page to rmap_walk(), which is essential for idle
+ * page tracking. With such an indicator of user pages we can skip isolated
+ * pages, but since there are not usually many of them, it will hardly affect
+ * the overall result.
+ *
+ * This function tries to get a user memory page by pfn as described above.
+ */
+static struct page *page_idle_get_page(unsigned long pfn)
+{
+	struct page *page;
+	struct zone *zone;
+
+	if (!pfn_valid(pfn))
+		return NULL;
+
+	page = pfn_to_page(pfn);
+	if (!page || !PageLRU(page) ||
+	    !get_page_unless_zero(page))
+		return NULL;
+
+	zone = page_zone(page);
+	spin_lock_irq(&zone->lru_lock);
+	if (unlikely(!PageLRU(page))) {
+		put_page(page);
+		page = NULL;
+	}
+	spin_unlock_irq(&zone->lru_lock);
+	return page;
+}
+
+static int page_idle_clear_pte_refs_one(struct page *page,
+					struct vm_area_struct *vma,
+					unsigned long addr, void *arg)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pmd_t *pmd;
+	pte_t *pte;
+	bool referenced = false;
+
+	if (unlikely(PageTransHuge(page))) {
+		pmd = page_check_address_pmd(page, mm, addr,
+					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
+		if (pmd) {
+			referenced = pmdp_clear_young_notify(vma, addr, pmd);
+			spin_unlock(ptl);
+		}
+	} else {
+		pte = page_check_address(page, mm, addr, &ptl, 0);
+		if (pte) {
+			referenced = ptep_clear_young_notify(vma, addr, pte);
+			pte_unmap_unlock(pte, ptl);
+		}
+	}
+	if (referenced) {
+		clear_page_idle(page);
+		/*
+		 * We cleared the referenced bit in a mapping to this page. To
+		 * avoid interference with page reclaim, mark it young so that
+		 * page_referenced() will return > 0.
+		 */
+		set_page_young(page);
+	}
+	return SWAP_AGAIN;
+}
+
+static void page_idle_clear_pte_refs(struct page *page)
+{
+	/*
+	 * Since rwc.arg is unused, rwc is effectively immutable, so we
+	 * can make it static const to save some cycles and stack.
+	 */
+	static const struct rmap_walk_control rwc = {
+		.rmap_one = page_idle_clear_pte_refs_one,
+		.anon_lock = page_lock_anon_vma_read,
+	};
+	bool need_lock;
+
+	if (!page_mapped(page) ||
+	    !page_rmapping(page))
+		return;
+
+	need_lock = !PageAnon(page) || PageKsm(page);
+	if (need_lock && !trylock_page(page))
+		return;
+
+	rmap_walk(page, (struct rmap_walk_control *)&rwc);
+
+	if (need_lock)
+		unlock_page(page);
+}
+
+static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
+				     struct bin_attribute *attr, char *buf,
+				     loff_t pos, size_t count)
+{
+	u64 *out = (u64 *)buf;
+	struct page *page;
+	unsigned long pfn, end_pfn;
+	int bit;
+
+	if (pos % BITMAP_CHUNK_SIZE || count % BITMAP_CHUNK_SIZE)
+		return -EINVAL;
+
+	pfn = pos * BITS_PER_BYTE;
+	if (pfn >= max_pfn)
+		return 0;
+
+	end_pfn = pfn + count * BITS_PER_BYTE;
+	if (end_pfn > max_pfn)
+		end_pfn = ALIGN(max_pfn, BITMAP_CHUNK_BITS);
+
+	for (; pfn < end_pfn; pfn++) {
+		bit = pfn % BITMAP_CHUNK_BITS;
+		if (!bit)
+			*out = 0ULL;
+		page = page_idle_get_page(pfn);
+		if (page) {
+			if (page_is_idle(page)) {
+				/*
+				 * The page might have been referenced via a
+				 * pte, in which case it is not idle. Clear
+				 * refs and recheck.
+				 */
+				page_idle_clear_pte_refs(page);
+				if (page_is_idle(page))
+					*out |= 1ULL << bit;
+			}
+			put_page(page);
+		}
+		if (bit == BITMAP_CHUNK_BITS - 1)
+			out++;
+		cond_resched();
+	}
+	return (char *)out - buf;
+}
+
+static ssize_t page_idle_bitmap_write(struct file *file, struct kobject *kobj,
+				      struct bin_attribute *attr, char *buf,
+				      loff_t pos, size_t count)
+{
+	const u64 *in = (u64 *)buf;
+	struct page *page;
+	unsigned long pfn, end_pfn;
+	int bit;
+
+	if (pos % BITMAP_CHUNK_SIZE || count % BITMAP_CHUNK_SIZE)
+		return -EINVAL;
+
+	pfn = pos * BITS_PER_BYTE;
+	if (pfn >= max_pfn)
+		return -ENXIO;
+
+	end_pfn = pfn + count * BITS_PER_BYTE;
+	if (end_pfn > max_pfn)
+		end_pfn = ALIGN(max_pfn, BITMAP_CHUNK_BITS);
+
+	for (; pfn < end_pfn; pfn++) {
+		bit = pfn % BITMAP_CHUNK_BITS;
+		if ((*in >> bit) & 1) {
+			page = page_idle_get_page(pfn);
+			if (page) {
+				page_idle_clear_pte_refs(page);
+				set_page_idle(page);
+				put_page(page);
+			}
+		}
+		if (bit == BITMAP_CHUNK_BITS - 1)
+			in++;
+		cond_resched();
+	}
+	return (char *)in - buf;
+}
+
+static struct bin_attribute page_idle_bitmap_attr =
+		__BIN_ATTR(bitmap, S_IRUSR | S_IWUSR,
+			   page_idle_bitmap_read, page_idle_bitmap_write, 0);
+
+static struct bin_attribute *page_idle_bin_attrs[] = {
+	&page_idle_bitmap_attr,
+	NULL,
+};
+
+static struct attribute_group page_idle_attr_group = {
+	.bin_attrs = page_idle_bin_attrs,
+	.name = "page_idle",
+};
+
+#ifndef CONFIG_64BIT
+static bool need_page_idle(void)
+{
+	return true;
+}
+struct page_ext_operations page_idle_ops = {
+	.need = need_page_idle,
+};
+#endif
+
+static int __init page_idle_init(void)
+{
+	int err;
+
+	err = sysfs_create_group(mm_kobj, &page_idle_attr_group);
+	if (err) {
+		pr_err("page_idle: register sysfs failed\n");
+		return err;
+	}
+	return 0;
+}
+subsys_initcall(page_idle_init);
diff -puN mm/rmap.c~proc-add-kpageidle-file mm/rmap.c
--- a/mm/rmap.c~proc-add-kpageidle-file
+++ a/mm/rmap.c
@@ -59,6 +59,7 @@
 #include <linux/migrate.h>
 #include <linux/hugetlb.h>
 #include <linux/backing-dev.h>
+#include <linux/page_idle.h>
 
 #include <asm/tlbflush.h>
 
@@ -886,6 +887,11 @@ static int page_referenced_one(struct pa
 		pte_unmap_unlock(pte, ptl);
 	}
 
+	if (referenced)
+		clear_page_idle(page);
+	if (test_and_clear_page_young(page))
+		referenced++;
+
 	if (referenced) {
 		pra->referenced++;
 		pra->vm_flags |= vma->vm_flags;
diff -puN mm/swap.c~proc-add-kpageidle-file mm/swap.c
--- a/mm/swap.c~proc-add-kpageidle-file
+++ a/mm/swap.c
@@ -32,6 +32,7 @@
 #include <linux/gfp.h>
 #include <linux/uio.h>
 #include <linux/hugetlb.h>
+#include <linux/page_idle.h>
 
 #include "internal.h"
 
@@ -622,6 +623,8 @@ void mark_page_accessed(struct page *pag
 	} else if (!PageReferenced(page)) {
 		SetPageReferenced(page);
 	}
+	if (page_is_idle(page))
+		clear_page_idle(page);
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are


