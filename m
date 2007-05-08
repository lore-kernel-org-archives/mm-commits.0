From: akpm@linux-foundation.org
Subject: - quicklists-for-page-table-pages.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:04 -0700
Message-ID: <200705080003.l48035OL008918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967338AbXEHADl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, davem@davemloft.net, tony.luck@intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Quicklists for page table pages
has been removed from the -mm tree.  Its filename was
     quicklists-for-page-table-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Quicklists for page table pages
From: Christoph Lameter <clameter@sgi.com>

On x86_64 this cuts allocation overhead for page table pages down to a
fraction (kernel compile / editing load.  TSC based measurement of times spend
in each function):

no quicklist

pte_alloc               1569048 4.3s(401ns/2.7us/179.7us)
pmd_alloc                780988 2.1s(337ns/2.7us/86.1us)
pud_alloc                780072 2.2s(424ns/2.8us/300.6us)
pgd_alloc                260022 1s(920ns/4us/263.1us)

quicklist:

pte_alloc                452436 573.4ms(8ns/1.3us/121.1us)
pmd_alloc                196204 174.5ms(7ns/889ns/46.1us)
pud_alloc                195688 172.4ms(7ns/881ns/151.3us)
pgd_alloc                 65228 9.8ms(8ns/150ns/6.1us)

pgd allocations are the most complex and there we see the most dramatic
improvement (may be we can cut down the amount of pgds cached somewhat?).  But
even the pte allocations still see a doubling of performance.

1. Proven code from the IA64 arch.

	The method used here has been fine tuned for years and
	is NUMA aware. It is based on the knowledge that accesses
	to page table pages are sparse in nature. Taking a page
	off the freelists instead of allocating a zeroed pages
	allows a reduction of number of cachelines touched
	in addition to getting rid of the slab overhead. So
	performance improves. This is particularly useful if pgds
	contain standard mappings. We can save on the teardown
	and setup of such a page if we have some on the quicklists.
	This includes avoiding lists operations that are otherwise
	necessary on alloc and free to track pgds.

2. Light weight alternative to use slab to manage page size pages

	Slab overhead is significant and even page allocator use
	is pretty heavy weight. The use of a per cpu quicklist
	means that we touch only two cachelines for an allocation.
	There is no need to access the page_struct (unless arch code
	needs to fiddle around with it). So the fast past just
	means bringing in one cacheline at the beginning of the
	page. That same cacheline may then be used to store the
	page table entry. Or a second cacheline may be used
	if the page table entry is not in the first cacheline of
	the page. The current code will zero the page which means
	touching 32 cachelines (assuming 128 byte). We get down
	from 32 to 2 cachelines in the fast path.

3. x86_64 gets lightweight page table page management.

	This will allow x86_64 arch code to faster repopulate pgds
	and other page table entries. The list operations for pgds
	are reduced in the same way as for i386 to the point where
	a pgd is allocated from the page allocator and when it is
	freed back to the page allocator. A pgd can pass through
	the quicklists without having to be reinitialized.

64 Consolidation of code from multiple arches

	So far arches have their own implementation of quicklist
	management. This patch moves that feature into the core allowing
	an easier maintenance and consistent management of quicklists.

Page table pages have the characteristics that they are typically zero or in a
known state when they are freed.  This is usually the exactly same state as
needed after allocation.  So it makes sense to build a list of freed page
table pages and then consume the pages already in use first.  Those pages have
already been initialized correctly (thus no need to zero them) and are likely
already cached in such a way that the MMU can use them most effectively.  Page
table pages are used in a sparse way so zeroing them on allocation is not too
useful.

Such an implementation already exits for ia64.  Howver, that implementation
did not support constructors and destructors as needed by i386 / x86_64.  It
also only supported a single quicklist.  The implementation here has
constructor and destructor support as well as the ability for an arch to
specify how many quicklists are needed.

Quicklists are defined by an arch defining CONFIG_QUICKLIST.  If more than one
quicklist is necessary then we can define NR_QUICK for additional lists.  F.e.
 i386 needs two and thus has

config NR_QUICK
	int
	default 2

If an arch has requested quicklist support then pages can be allocated
from the quicklist (or from the page allocator if the quicklist is
empty) via:

quicklist_alloc(<quicklist-nr>, <gfpflags>, <constructor>)

Page table pages can be freed using:

quicklist_free(<quicklist-nr>, <destructor>, <page>)

Pages must have a definite state after allocation and before
they are freed. If no constructor is specified then pages
will be zeroed on allocation and must be zeroed before they are
freed.

If a constructor is used then the constructor will establish
a definite page state. F.e. the i386 and x86_64 pgd constructors
establish certain mappings.

Constructors and destructors can also be used to track the pages.
i386 and x86_64 use a list of pgds in order to be able to dynamically
update standard mappings.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quicklist.h |   94 ++++++++++++++++++++++++++++++++++++
 mm/Kconfig                |    5 +
 mm/Makefile               |    2 
 mm/quicklist.c            |   88 +++++++++++++++++++++++++++++++++
 4 files changed, 189 insertions(+)

diff -puN /dev/null include/linux/quicklist.h
--- /dev/null
+++ a/include/linux/quicklist.h
@@ -0,0 +1,94 @@
+#ifndef LINUX_QUICKLIST_H
+#define LINUX_QUICKLIST_H
+/*
+ * Fast allocations and disposal of pages. Pages must be in the condition
+ * as needed after allocation when they are freed. Per cpu lists of pages
+ * are kept that only contain node local pages.
+ *
+ * (C) 2007, SGI. Christoph Lameter <clameter@sgi.com>
+ */
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/percpu.h>
+
+#ifdef CONFIG_QUICKLIST
+
+struct quicklist {
+	void *page;
+	int nr_pages;
+};
+
+DECLARE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
+
+/*
+ * The two key functions quicklist_alloc and quicklist_free are inline so
+ * that they may be custom compiled for the platform.
+ * Specifying a NULL ctor can remove constructor support. Specifying
+ * a constant quicklist allows the determination of the exact address
+ * in the per cpu area.
+ *
+ * The fast patch in quicklist_alloc touched only a per cpu cacheline and
+ * the first cacheline of the page itself. There is minmal overhead involved.
+ */
+static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
+{
+	struct quicklist *q;
+	void **p = NULL;
+
+	q =&get_cpu_var(quicklist)[nr];
+	p = q->page;
+	if (likely(p)) {
+		q->page = p[0];
+		p[0] = NULL;
+		q->nr_pages--;
+	}
+	put_cpu_var(quicklist);
+	if (likely(p))
+		return p;
+
+	p = (void *)__get_free_page(flags | __GFP_ZERO);
+	if (ctor && p)
+		ctor(p);
+	return p;
+}
+
+static inline void __quicklist_free(int nr, void (*dtor)(void *), void *p,
+	struct page *page)
+{
+	struct quicklist *q;
+	int nid = page_to_nid(page);
+
+	if (unlikely(nid != numa_node_id())) {
+		if (dtor)
+			dtor(p);
+		__free_page(page);
+		return;
+	}
+
+	q = &get_cpu_var(quicklist)[nr];
+	*(void **)p = q->page;
+	q->page = p;
+	q->nr_pages++;
+	put_cpu_var(quicklist);
+}
+
+static inline void quicklist_free(int nr, void (*dtor)(void *), void *pp)
+{
+	__quicklist_free(nr, dtor, pp, virt_to_page(pp));
+}
+
+static inline void quicklist_free_page(int nr, void (*dtor)(void *),
+							struct page *page)
+{
+	__quicklist_free(nr, dtor, page_address(page), page);
+}
+
+void quicklist_trim(int nr, void (*dtor)(void *),
+	unsigned long min_pages, unsigned long max_free);
+
+unsigned long quicklist_total_size(void);
+
+#endif
+
+#endif /* LINUX_QUICKLIST_H */
+
diff -puN mm/Kconfig~quicklists-for-page-table-pages mm/Kconfig
--- a/mm/Kconfig~quicklists-for-page-table-pages
+++ a/mm/Kconfig
@@ -163,3 +163,8 @@ config ZONE_DMA_FLAG
 	default "0" if !ZONE_DMA
 	default "1"
 
+config NR_QUICK
+	int
+	depends on QUICKLIST
+	default "1"
+
diff -puN mm/Makefile~quicklists-for-page-table-pages mm/Makefile
--- a/mm/Makefile~quicklists-for-page-table-pages
+++ a/mm/Makefile
@@ -30,3 +30,5 @@ obj-$(CONFIG_MEMORY_HOTPLUG) += memory_h
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
+obj-$(CONFIG_QUICKLIST) += quicklist.o
+
diff -puN /dev/null mm/quicklist.c
--- /dev/null
+++ a/mm/quicklist.c
@@ -0,0 +1,88 @@
+/*
+ * Quicklist support.
+ *
+ * Quicklists are light weight lists of pages that have a defined state
+ * on alloc and free. Pages must be in the quicklist specific defined state
+ * (zero by default) when the page is freed. It seems that the initial idea
+ * for such lists first came from Dave Miller and then various other people
+ * improved on it.
+ *
+ * Copyright (C) 2007 SGI,
+ * 	Christoph Lameter <clameter@sgi.com>
+ * 		Generalized, added support for multiple lists and
+ * 		constructors / destructors.
+ */
+#include <linux/kernel.h>
+
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/module.h>
+#include <linux/quicklist.h>
+
+DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
+
+#define FRACTION_OF_NODE_MEM	16
+
+static unsigned long max_pages(unsigned long min_pages)
+{
+	unsigned long node_free_pages, max;
+
+	node_free_pages = node_page_state(numa_node_id(),
+			NR_FREE_PAGES);
+	max = node_free_pages / FRACTION_OF_NODE_MEM;
+	return max(max, min_pages);
+}
+
+static long min_pages_to_free(struct quicklist *q,
+	unsigned long min_pages, long max_free)
+{
+	long pages_to_free;
+
+	pages_to_free = q->nr_pages - max_pages(min_pages);
+
+	return min(pages_to_free, max_free);
+}
+
+/*
+ * Trim down the number of pages in the quicklist
+ */
+void quicklist_trim(int nr, void (*dtor)(void *),
+	unsigned long min_pages, unsigned long max_free)
+{
+	long pages_to_free;
+	struct quicklist *q;
+
+	q = &get_cpu_var(quicklist)[nr];
+	if (q->nr_pages > min_pages) {
+		pages_to_free = min_pages_to_free(q, min_pages, max_free);
+
+		while (pages_to_free > 0) {
+			/*
+			 * We pass a gfp_t of 0 to quicklist_alloc here
+			 * because we will never call into the page allocator.
+			 */
+			void *p = quicklist_alloc(nr, 0, NULL);
+
+			if (dtor)
+				dtor(p);
+			free_page((unsigned long)p);
+			pages_to_free--;
+		}
+	}
+	put_cpu_var(quicklist);
+}
+
+unsigned long quicklist_total_size(void)
+{
+	unsigned long count = 0;
+	int cpu;
+	struct quicklist *ql, *q;
+
+	for_each_online_cpu(cpu) {
+		ql = per_cpu(quicklist, cpu);
+		for (q = ql; q < ql + CONFIG_NR_QUICK; q++)
+			count += q->nr_pages;
+	}
+	return count;
+}
+
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
