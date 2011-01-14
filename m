From: akpm@linux-foundation.org
Subject: [merged] thp-remove-pg_buddy.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:47 -0800
Message-ID: <201101142250.p0EMobXI005426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1ANWus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: remove PG_buddy
has been removed from the -mm tree.  Its filename was
     thp-remove-pg_buddy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: remove PG_buddy
From: Andrea Arcangeli <aarcange@redhat.com>

PG_buddy can be converted to _mapcount == -2.  So the PG_compound_lock can
be added to page->flags without overflowing (because of the sparse section
bits increasing) with CONFIG_X86_PAE=y and CONFIG_X86_PAT=y.  This also
has to move the memory hotplug code from _mapcount to lru.next to avoid
any risk of clashes.  We can't use lru.next for PG_buddy removal, but
memory hotplug can use lru.next even more easily than the mapcount
instead.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                 |   14 ++++++++------
 include/linux/memory_hotplug.h |   14 +++++++++-----
 include/linux/mm.h             |   21 +++++++++++++++++++++
 include/linux/page-flags.h     |    7 +------
 mm/memory_hotplug.c            |   14 ++++++++------
 mm/page_alloc.c                |    7 +++----
 mm/sparse.c                    |    4 ++--
 7 files changed, 52 insertions(+), 29 deletions(-)

diff -puN fs/proc/page.c~thp-remove-pg_buddy fs/proc/page.c
--- a/fs/proc/page.c~thp-remove-pg_buddy
+++ a/fs/proc/page.c
@@ -116,15 +116,17 @@ u64 stable_page_flags(struct page *page)
 	if (PageHuge(page))
 		u |= 1 << KPF_HUGE;
 
-	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
-
 	/*
-	 * Caveats on high order pages:
-	 * PG_buddy will only be set on the head page; SLUB/SLQB do the same
-	 * for PG_slab; SLOB won't set PG_slab at all on compound pages.
+	 * Caveats on high order pages: page->_count will only be set
+	 * -1 on the head page; SLUB/SLQB do the same for PG_slab;
+	 * SLOB won't set PG_slab at all on compound pages.
 	 */
+	if (PageBuddy(page))
+		u |= 1 << KPF_BUDDY;
+
+	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
+
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
-	u |= kpf_copy_bit(k, KPF_BUDDY,		PG_buddy);
 
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
diff -puN include/linux/memory_hotplug.h~thp-remove-pg_buddy include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~thp-remove-pg_buddy
+++ a/include/linux/memory_hotplug.h
@@ -13,12 +13,16 @@ struct mem_section;
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /*
- * Types for free bootmem.
- * The normal smallest mapcount is -1. Here is smaller value than it.
+ * Types for free bootmem stored in page->lru.next. These have to be in
+ * some random range in unsigned long space for debugging purposes.
  */
-#define SECTION_INFO		(-1 - 1)
-#define MIX_SECTION_INFO	(-1 - 2)
-#define NODE_INFO		(-1 - 3)
+enum {
+	MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE = 12,
+	SECTION_INFO = MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE,
+	MIX_SECTION_INFO,
+	NODE_INFO,
+	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
+};
 
 /*
  * pgdat resizing functions
diff -puN include/linux/mm.h~thp-remove-pg_buddy include/linux/mm.h
--- a/include/linux/mm.h~thp-remove-pg_buddy
+++ a/include/linux/mm.h
@@ -397,6 +397,27 @@ static inline void init_page_count(struc
 	atomic_set(&page->_count, 1);
 }
 
+/*
+ * PageBuddy() indicate that the page is free and in the buddy system
+ * (see mm/page_alloc.c).
+ */
+static inline int PageBuddy(struct page *page)
+{
+	return atomic_read(&page->_mapcount) == -2;
+}
+
+static inline void __SetPageBuddy(struct page *page)
+{
+	VM_BUG_ON(atomic_read(&page->_mapcount) != -1);
+	atomic_set(&page->_mapcount, -2);
+}
+
+static inline void __ClearPageBuddy(struct page *page)
+{
+	VM_BUG_ON(!PageBuddy(page));
+	atomic_set(&page->_mapcount, -1);
+}
+
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
diff -puN include/linux/page-flags.h~thp-remove-pg_buddy include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-remove-pg_buddy
+++ a/include/linux/page-flags.h
@@ -48,9 +48,6 @@
  * struct page (these bits with information) are always mapped into kernel
  * address space...
  *
- * PG_buddy is set to indicate that the page is free and in the buddy system
- * (see mm/page_alloc.c).
- *
  * PG_hwpoison indicates that a page got corrupted in hardware and contains
  * data with incorrect ECC bits that triggered a machine check. Accessing is
  * not safe since it may cause another machine check. Don't touch!
@@ -96,7 +93,6 @@ enum pageflags {
 	PG_swapcache,		/* Swap page: swp_entry_t in private */
 	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
-	PG_buddy,		/* Page is free, on buddy lists */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
 #ifdef CONFIG_MMU
@@ -233,7 +229,6 @@ PAGEFLAG(OwnerPriv1, owner_priv_1) TESTC
  * risky: they bypass page accounting.
  */
 TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
-__PAGEFLAG(Buddy, buddy)
 PAGEFLAG(MappedToDisk, mappedtodisk)
 
 /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
@@ -461,7 +456,7 @@ static inline int PageTransCompound(stru
 #define PAGE_FLAGS_CHECK_AT_FREE \
 	(1 << PG_lru	 | 1 << PG_locked    | \
 	 1 << PG_private | 1 << PG_private_2 | \
-	 1 << PG_buddy	 | 1 << PG_writeback | 1 << PG_reserved | \
+	 1 << PG_writeback | 1 << PG_reserved | \
 	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
 	 1 << PG_unevictable | __PG_MLOCKED | __PG_HWPOISON | \
 	 __PG_COMPOUND_LOCK)
diff -puN mm/memory_hotplug.c~thp-remove-pg_buddy mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~thp-remove-pg_buddy
+++ a/mm/memory_hotplug.c
@@ -82,9 +82,10 @@ static void release_memory_resource(stru
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void get_page_bootmem(unsigned long info,  struct page *page, int type)
+static void get_page_bootmem(unsigned long info,  struct page *page,
+			     unsigned long type)
 {
-	atomic_set(&page->_mapcount, type);
+	page->lru.next = (struct list_head *) type;
 	SetPagePrivate(page);
 	set_page_private(page, info);
 	atomic_inc(&page->_count);
@@ -94,15 +95,16 @@ static void get_page_bootmem(unsigned lo
  * so use __ref to tell modpost not to generate a warning */
 void __ref put_page_bootmem(struct page *page)
 {
-	int type;
+	unsigned long type;
 
-	type = atomic_read(&page->_mapcount);
-	BUG_ON(type >= -1);
+	type = (unsigned long) page->lru.next;
+	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
+	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (atomic_dec_return(&page->_count) == 1) {
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
-		reset_page_mapcount(page);
+		INIT_LIST_HEAD(&page->lru);
 		__free_pages_bootmem(page, 0);
 	}
 
diff -puN mm/page_alloc.c~thp-remove-pg_buddy mm/page_alloc.c
--- a/mm/page_alloc.c~thp-remove-pg_buddy
+++ a/mm/page_alloc.c
@@ -449,8 +449,8 @@ __find_combined_index(unsigned long page
  * (c) a page and its buddy have the same order &&
  * (d) a page and its buddy are in the same zone.
  *
- * For recording whether a page is in the buddy system, we use PG_buddy.
- * Setting, clearing, and testing PG_buddy is serialized by zone->lock.
+ * For recording whether a page is in the buddy system, we set ->_mapcount -2.
+ * Setting, clearing, and testing _mapcount -2 is serialized by zone->lock.
  *
  * For recording page's order, we use page_private(page).
  */
@@ -483,7 +483,7 @@ static inline int page_is_buddy(struct p
  * as necessary, plus some accounting needed to play nicely with other
  * parts of the VM system.
  * At each level, we keep a list of pages, which are heads of continuous
- * free pages of length of (1 << order) and marked with PG_buddy. Page's
+ * free pages of length of (1 << order) and marked with _mapcount -2. Page's
  * order is recorded in page_private(page) field.
  * So when we are allocating or freeing one, we can derive the state of the
  * other.  That is, if we allocate a small block, and both were   
@@ -5574,7 +5574,6 @@ static struct trace_print_flags pageflag
 	{1UL << PG_swapcache,		"swapcache"	},
 	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
 	{1UL << PG_reclaim,		"reclaim"	},
-	{1UL << PG_buddy,		"buddy"		},
 	{1UL << PG_swapbacked,		"swapbacked"	},
 	{1UL << PG_unevictable,		"unevictable"	},
 #ifdef CONFIG_MMU
diff -puN mm/sparse.c~thp-remove-pg_buddy mm/sparse.c
--- a/mm/sparse.c~thp-remove-pg_buddy
+++ a/mm/sparse.c
@@ -671,10 +671,10 @@ static void __kfree_section_memmap(struc
 static void free_map_bootmem(struct page *page, unsigned long nr_pages)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
-	int magic;
+	unsigned long magic;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		magic = atomic_read(&page->_mapcount);
+		magic = (unsigned long) page->lru.next;
 
 		BUG_ON(magic == NODE_INFO);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

