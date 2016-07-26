From: akpm@linux-foundation.org
Subject: [patch 043/126] mm: migrate: support non-lru movable page
 migration
Date: Tue, 26 Jul 2016 15:23:05 -0700
Message-ID: <5797e2c9.6iBLJcXvMXt9nblc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, aquini@redhat.com, corbet@lwn.net, gi-oh.kim@profitbricks.com, hughd@google.com, iamjoonsoo.kim@lge.com, john.reitan@foss.arm.com, mgorman@suse.de, opensource.ganesh@gmail.com, riel@redhat.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: migrate: support non-lru movable page migration

We have allowed migration for only LRU pages until now and it was enough
to make high-order pages.  But recently, embedded system(e.g., webOS,
android) uses lots of non-movable pages(e.g., zram, GPU memory) so we have
seen several reports about troubles of small high-order allocation.  For
fixing the problem, there were several efforts (e,g,.  enhance compaction
algorithm, SLUB fallback to 0-order page, reserved memory, vmalloc and so
on) but if there are lots of non-movable pages in system, their solutions
are void in the long run.

So, this patch is to support facility to change non-movable pages with
movable.  For the feature, this patch introduces functions related to
migration to address_space_operations as well as some page flags.

If a driver want to make own pages movable, it should define three functions
which are function pointers of struct address_space_operations.

1. bool (*isolate_page) (struct page *page, isolate_mode_t mode);

What VM expects on isolate_page function of driver is to return *true* if
driver isolates page successfully.  On returing true, VM marks the page as
PG_isolated so concurrent isolation in several CPUs skip the page for
isolation.  If a driver cannot isolate the page, it should return *false*.

Once page is successfully isolated, VM uses page.lru fields so driver
shouldn't expect to preserve values in that fields.

2. int (*migratepage) (struct address_space *mapping,
		struct page *newpage, struct page *oldpage, enum migrate_mode);

After isolation, VM calls migratepage of driver with isolated page.  The
function of migratepage is to move content of the old page to new page and
set up fields of struct page newpage.  Keep in mind that you should
indicate to the VM the oldpage is no longer movable via
__ClearPageMovable() under page_lock if you migrated the oldpage
successfully and returns 0.  If driver cannot migrate the page at the
moment, driver can return -EAGAIN.  On -EAGAIN, VM will retry page
migration in a short time because VM interprets -EAGAIN as "temporal
migration failure".  On returning any error except -EAGAIN, VM will give
up the page migration without retrying in this time.

Driver shouldn't touch page.lru field VM using in the functions.

3. void (*putback_page)(struct page *);

If migration fails on isolated page, VM should return the isolated page to
the driver so VM calls driver's putback_page with migration failed page. 
In this function, driver should put the isolated page back to the own data
structure.

4. non-lru movable page flags

There are two page flags for supporting non-lru movable page.

* PG_movable

Driver should use the below function to make page movable under page_lock.

	void __SetPageMovable(struct page *page, struct address_space *mapping)

It needs argument of address_space for registering migration family functions
which will be called by VM. Exactly speaking, PG_movable is not a real flag of
struct page. Rather than, VM reuses page->mapping's lower bits to represent it.

	#define PAGE_MAPPING_MOVABLE 0x2
	page->mapping = page->mapping | PAGE_MAPPING_MOVABLE;

so driver shouldn't access page->mapping directly. Instead, driver should
use page_mapping which mask off the low two bits of page->mapping so it can get
right struct address_space.

For testing of non-lru movable page, VM supports __PageMovable function.
However, it doesn't guarantee to identify non-lru movable page because
page->mapping field is unified with other variables in struct page.
As well, if driver releases the page after isolation by VM, page->mapping
doesn't have stable value although it has PAGE_MAPPING_MOVABLE
(Look at __ClearPageMovable). But __PageMovable is cheap to catch whether
page is LRU or non-lru movable once the page has been isolated. Because
LRU pages never can have PAGE_MAPPING_MOVABLE in page->mapping. It is also
good for just peeking to test non-lru movable pages before more expensive
checking with lock_page in pfn scanning to select victim.

For guaranteeing non-lru movable page, VM provides PageMovable function.
Unlike __PageMovable, PageMovable functions validates page->mapping and
mapping->a_ops->isolate_page under lock_page. The lock_page prevents sudden
destroying of page->mapping.

Driver using __SetPageMovable should clear the flag via __ClearMovablePage
under page_lock before the releasing the page.

* PG_isolated

To prevent concurrent isolation among several CPUs, VM marks isolated page
as PG_isolated under lock_page. So if a CPU encounters PG_isolated non-lru
movable page, it can skip it. Driver doesn't need to manipulate the flag
because VM will set/clear it automatically. Keep in mind that if driver
sees PG_isolated page, it means the page have been isolated by VM so it
shouldn't touch page.lru field.
PG_isolated is alias with PG_reclaim flag so driver shouldn't use the flag
for own purpose.

[opensource.ganesh@gmail.com: mm/compaction: remove local variable is_lru]
  Link: http://lkml.kernel.org/r/20160618014841.GA7422@leo-test
Link: http://lkml.kernel.org/r/1464736881-24886-3-git-send-email-minchan@kernel.org
Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: John Einar Reitan <john.reitan@foss.arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    4 
 Documentation/filesystems/vfs.txt |   11 +
 Documentation/vm/page_migration   |  107 +++++++++++++++
 include/linux/compaction.h        |   17 ++
 include/linux/fs.h                |    2 
 include/linux/ksm.h               |    3 
 include/linux/migrate.h           |    2 
 include/linux/mm.h                |    1 
 include/linux/page-flags.h        |   33 +++-
 mm/compaction.c                   |   85 +++++++++---
 mm/ksm.c                          |    4 
 mm/migrate.c                      |  192 +++++++++++++++++++++++++---
 mm/page_alloc.c                   |    2 
 mm/util.c                         |    6 
 14 files changed, 416 insertions(+), 53 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-migrate-support-non-lru-movable-page-migration Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-migrate-support-non-lru-movable-page-migration
+++ a/Documentation/filesystems/Locking
@@ -195,7 +195,9 @@ prototypes:
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
+	bool (*isolate_page) (struct page *, isolate_mode_t);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
+	void (*putback_page) (struct page *);
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
@@ -219,7 +221,9 @@ invalidatepage:		yes
 releasepage:		yes
 freepage:		yes
 direct_IO:
+isolate_page:		yes
 migratepage:		yes (both)
+putback_page:		yes
 launder_page:		yes
 is_partially_uptodate:	yes
 error_remove_page:	yes
diff -puN Documentation/filesystems/vfs.txt~mm-migrate-support-non-lru-movable-page-migration Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mm-migrate-support-non-lru-movable-page-migration
+++ a/Documentation/filesystems/vfs.txt
@@ -592,9 +592,14 @@ struct address_space_operations {
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
+	/* isolate a page for migration */
+	bool (*isolate_page) (struct page *, isolate_mode_t);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
+	/* put migration-failed page back to right list */
+	void (*putback_page) (struct page *);
 	int (*launder_page) (struct page *);
+
 	int (*is_partially_uptodate) (struct page *, unsigned long,
 					unsigned long);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
@@ -747,6 +752,10 @@ struct address_space_operations {
         and transfer data directly between the storage and the
         application's address space.
 
+  isolate_page: Called by the VM when isolating a movable non-lru page.
+	If page is successfully isolated, VM marks the page as PG_isolated
+	via __SetPageIsolated.
+
   migrate_page:  This is used to compact the physical memory usage.
         If the VM wants to relocate a page (maybe off a memory card
         that is signalling imminent failure) it will pass a new page
@@ -754,6 +763,8 @@ struct address_space_operations {
 	transfer any private data across and update any references
         that it has to the page.
 
+  putback_page: Called by the VM when isolated page's migration fails.
+
   launder_page: Called before freeing a page - it writes back the dirty page. To
   	prevent redirtying the page, it is kept locked during the whole
 	operation.
diff -puN Documentation/vm/page_migration~mm-migrate-support-non-lru-movable-page-migration Documentation/vm/page_migration
--- a/Documentation/vm/page_migration~mm-migrate-support-non-lru-movable-page-migration
+++ a/Documentation/vm/page_migration
@@ -142,5 +142,110 @@ Steps:
 20. The new page is moved to the LRU and can be scanned by the swapper
     etc again.
 
-Christoph Lameter, May 8, 2006.
+C. Non-LRU page migration
+-------------------------
+
+Although original migration aimed for reducing the latency of memory access
+for NUMA, compaction who want to create high-order page is also main customer.
+
+Current problem of the implementation is that it is designed to migrate only
+*LRU* pages. However, there are potential non-lru pages which can be migrated
+in drivers, for example, zsmalloc, virtio-balloon pages.
+
+For virtio-balloon pages, some parts of migration code path have been hooked
+up and added virtio-balloon specific functions to intercept migration logics.
+It's too specific to a driver so other drivers who want to make their pages
+movable would have to add own specific hooks in migration path.
+
+To overclome the problem, VM supports non-LRU page migration which provides
+generic functions for non-LRU movable pages without driver specific hooks
+migration path.
+
+If a driver want to make own pages movable, it should define three functions
+which are function pointers of struct address_space_operations.
+
+1. bool (*isolate_page) (struct page *page, isolate_mode_t mode);
+
+What VM expects on isolate_page function of driver is to return *true*
+if driver isolates page successfully. On returing true, VM marks the page
+as PG_isolated so concurrent isolation in several CPUs skip the page
+for isolation. If a driver cannot isolate the page, it should return *false*.
+
+Once page is successfully isolated, VM uses page.lru fields so driver
+shouldn't expect to preserve values in that fields.
+
+2. int (*migratepage) (struct address_space *mapping,
+		struct page *newpage, struct page *oldpage, enum migrate_mode);
+
+After isolation, VM calls migratepage of driver with isolated page.
+The function of migratepage is to move content of the old page to new page
+and set up fields of struct page newpage. Keep in mind that you should
+indicate to the VM the oldpage is no longer movable via __ClearPageMovable()
+under page_lock if you migrated the oldpage successfully and returns 0.
+If driver cannot migrate the page at the moment, driver can return -EAGAIN.
+On -EAGAIN, VM will retry page migration in a short time because VM interprets
+-EAGAIN as "temporal migration failure". On returning any error except -EAGAIN,
+VM will give up the page migration without retrying in this time.
+
+Driver shouldn't touch page.lru field VM using in the functions.
+
+3. void (*putback_page)(struct page *);
+
+If migration fails on isolated page, VM should return the isolated page
+to the driver so VM calls driver's putback_page with migration failed page.
+In this function, driver should put the isolated page back to the own data
+structure.
 
+4. non-lru movable page flags
+
+There are two page flags for supporting non-lru movable page.
+
+* PG_movable
+
+Driver should use the below function to make page movable under page_lock.
+
+	void __SetPageMovable(struct page *page, struct address_space *mapping)
+
+It needs argument of address_space for registering migration family functions
+which will be called by VM. Exactly speaking, PG_movable is not a real flag of
+struct page. Rather than, VM reuses page->mapping's lower bits to represent it.
+
+	#define PAGE_MAPPING_MOVABLE 0x2
+	page->mapping = page->mapping | PAGE_MAPPING_MOVABLE;
+
+so driver shouldn't access page->mapping directly. Instead, driver should
+use page_mapping which mask off the low two bits of page->mapping under
+page lock so it can get right struct address_space.
+
+For testing of non-lru movable page, VM supports __PageMovable function.
+However, it doesn't guarantee to identify non-lru movable page because
+page->mapping field is unified with other variables in struct page.
+As well, if driver releases the page after isolation by VM, page->mapping
+doesn't have stable value although it has PAGE_MAPPING_MOVABLE
+(Look at __ClearPageMovable). But __PageMovable is cheap to catch whether
+page is LRU or non-lru movable once the page has been isolated. Because
+LRU pages never can have PAGE_MAPPING_MOVABLE in page->mapping. It is also
+good for just peeking to test non-lru movable pages before more expensive
+checking with lock_page in pfn scanning to select victim.
+
+For guaranteeing non-lru movable page, VM provides PageMovable function.
+Unlike __PageMovable, PageMovable functions validates page->mapping and
+mapping->a_ops->isolate_page under lock_page. The lock_page prevents sudden
+destroying of page->mapping.
+
+Driver using __SetPageMovable should clear the flag via __ClearMovablePage
+under page_lock before the releasing the page.
+
+* PG_isolated
+
+To prevent concurrent isolation among several CPUs, VM marks isolated page
+as PG_isolated under lock_page. So if a CPU encounters PG_isolated non-lru
+movable page, it can skip it. Driver doesn't need to manipulate the flag
+because VM will set/clear it automatically. Keep in mind that if driver
+sees PG_isolated page, it means the page have been isolated by VM so it
+shouldn't touch page.lru field.
+PG_isolated is alias with PG_reclaim flag so driver shouldn't use the flag
+for own purpose.
+
+Christoph Lameter, May 8, 2006.
+Minchan Kim, Mar 28, 2016.
diff -puN include/linux/compaction.h~mm-migrate-support-non-lru-movable-page-migration include/linux/compaction.h
--- a/include/linux/compaction.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/compaction.h
@@ -54,6 +54,9 @@ enum compact_result {
 struct alloc_context; /* in mm/internal.h */
 
 #ifdef CONFIG_COMPACTION
+extern int PageMovable(struct page *page);
+extern void __SetPageMovable(struct page *page, struct address_space *mapping);
+extern void __ClearPageMovable(struct page *page);
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
@@ -151,6 +154,19 @@ extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
 
 #else
+static inline int PageMovable(struct page *page)
+{
+	return 0;
+}
+static inline void __SetPageMovable(struct page *page,
+			struct address_space *mapping)
+{
+}
+
+static inline void __ClearPageMovable(struct page *page)
+{
+}
+
 static inline enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 			unsigned int order, int alloc_flags,
 			const struct alloc_context *ac,
@@ -212,6 +228,7 @@ static inline void wakeup_kcompactd(pg_d
 #endif /* CONFIG_COMPACTION */
 
 #if defined(CONFIG_COMPACTION) && defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
+struct node;
 extern int compaction_register_node(struct node *node);
 extern void compaction_unregister_node(struct node *node);
 
diff -puN include/linux/fs.h~mm-migrate-support-non-lru-movable-page-migration include/linux/fs.h
--- a/include/linux/fs.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/fs.h
@@ -402,6 +402,8 @@ struct address_space_operations {
 	 */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
+	bool (*isolate_page)(struct page *, isolate_mode_t);
+	void (*putback_page)(struct page *);
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, unsigned long,
 					unsigned long);
diff -puN include/linux/ksm.h~mm-migrate-support-non-lru-movable-page-migration include/linux/ksm.h
--- a/include/linux/ksm.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/ksm.h
@@ -43,8 +43,7 @@ static inline struct stable_node *page_s
 static inline void set_page_stable_node(struct page *page,
 					struct stable_node *stable_node)
 {
-	page->mapping = (void *)stable_node +
-				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
+	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
 /*
diff -puN include/linux/migrate.h~mm-migrate-support-non-lru-movable-page-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/migrate.h
@@ -37,6 +37,8 @@ extern int migrate_page(struct address_s
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
+extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+extern void putback_movable_page(struct page *page);
 
 extern int migrate_prep(void);
 extern int migrate_prep_local(void);
diff -puN include/linux/mm.h~mm-migrate-support-non-lru-movable-page-migration include/linux/mm.h
--- a/include/linux/mm.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/mm.h
@@ -1035,6 +1035,7 @@ static inline pgoff_t page_file_index(st
 }
 
 bool page_mapped(struct page *page);
+struct address_space *page_mapping(struct page *page);
 
 /*
  * Return true only if the page has been allocated with
diff -puN include/linux/page-flags.h~mm-migrate-support-non-lru-movable-page-migration include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-migrate-support-non-lru-movable-page-migration
+++ a/include/linux/page-flags.h
@@ -129,6 +129,9 @@ enum pageflags {
 
 	/* Compound pages. Stored in first tail page's flags */
 	PG_double_map = PG_private_2,
+
+	/* non-lru isolated movable page */
+	PG_isolated = PG_reclaim,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -357,29 +360,37 @@ PAGEFLAG(Idle, idle, PF_ANY)
  * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
  *
  * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
- * the PAGE_MAPPING_KSM bit may be set along with the PAGE_MAPPING_ANON bit;
- * and then page->mapping points, not to an anon_vma, but to a private
+ * the PAGE_MAPPING_MOVABLE bit may be set along with the PAGE_MAPPING_ANON
+ * bit; and then page->mapping points, not to an anon_vma, but to a private
  * structure which KSM associates with that merged page.  See ksm.h.
  *
- * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is currently never used.
+ * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is used for non-lru movable
+ * page and then page->mapping points a struct address_space.
  *
  * Please note that, confusingly, "page_mapping" refers to the inode
  * address_space which maps the page from disk; whereas "page_mapped"
  * refers to user virtual address space into which the page is mapped.
  */
-#define PAGE_MAPPING_ANON	1
-#define PAGE_MAPPING_KSM	2
-#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
+#define PAGE_MAPPING_ANON	0x1
+#define PAGE_MAPPING_MOVABLE	0x2
+#define PAGE_MAPPING_KSM	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
+#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_MOVABLE)
 
-static __always_inline int PageAnonHead(struct page *page)
+static __always_inline int PageMappingFlags(struct page *page)
 {
-	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
+	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
 
 static __always_inline int PageAnon(struct page *page)
 {
 	page = compound_head(page);
-	return PageAnonHead(page);
+	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
+}
+
+static __always_inline int __PageMovable(struct page *page)
+{
+	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
+				PAGE_MAPPING_MOVABLE;
 }
 
 #ifdef CONFIG_KSM
@@ -393,7 +404,7 @@ static __always_inline int PageKsm(struc
 {
 	page = compound_head(page);
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
-				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
+				PAGE_MAPPING_KSM;
 }
 #else
 TESTPAGEFLAG_FALSE(Ksm)
@@ -641,6 +652,8 @@ static inline void __ClearPageBalloon(st
 	atomic_set(&page->_mapcount, -1);
 }
 
+__PAGEFLAG(Isolated, isolated, PF_ANY);
+
 /*
  * If network-based swap is enabled, sl*b must keep track of whether pages
  * were allocated from pfmemalloc reserves.
diff -puN mm/compaction.c~mm-migrate-support-non-lru-movable-page-migration mm/compaction.c
--- a/mm/compaction.c~mm-migrate-support-non-lru-movable-page-migration
+++ a/mm/compaction.c
@@ -81,6 +81,44 @@ static inline bool migrate_async_suitabl
 
 #ifdef CONFIG_COMPACTION
 
+int PageMovable(struct page *page)
+{
+	struct address_space *mapping;
+
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	if (!__PageMovable(page))
+		return 0;
+
+	mapping = page_mapping(page);
+	if (mapping && mapping->a_ops && mapping->a_ops->isolate_page)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(PageMovable);
+
+void __SetPageMovable(struct page *page, struct address_space *mapping)
+{
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE((unsigned long)mapping & PAGE_MAPPING_MOVABLE, page);
+	page->mapping = (void *)((unsigned long)mapping | PAGE_MAPPING_MOVABLE);
+}
+EXPORT_SYMBOL(__SetPageMovable);
+
+void __ClearPageMovable(struct page *page)
+{
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageMovable(page), page);
+	/*
+	 * Clear registered address_space val with keeping PAGE_MAPPING_MOVABLE
+	 * flag so that VM can catch up released page by driver after isolation.
+	 * With it, VM migration doesn't try to put it back.
+	 */
+	page->mapping = (void *)((unsigned long)page->mapping &
+				PAGE_MAPPING_MOVABLE);
+}
+EXPORT_SYMBOL(__ClearPageMovable);
+
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
 
@@ -670,7 +708,6 @@ isolate_migratepages_block(struct compac
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
-		bool is_lru;
 
 		if (skip_on_failure && low_pfn >= next_skip_pfn) {
 			/*
@@ -733,21 +770,6 @@ isolate_migratepages_block(struct compac
 		}
 
 		/*
-		 * Check may be lockless but that's ok as we recheck later.
-		 * It's possible to migrate LRU pages and balloon pages
-		 * Skip any other type of page
-		 */
-		is_lru = PageLRU(page);
-		if (!is_lru) {
-			if (unlikely(balloon_page_movable(page))) {
-				if (balloon_page_isolate(page)) {
-					/* Successfully isolated */
-					goto isolate_success;
-				}
-			}
-		}
-
-		/*
 		 * Regardless of being on LRU, compound pages such as THP and
 		 * hugetlbfs are not to be compacted. We can potentially save
 		 * a lot of iterations if we skip them at once. The check is
@@ -763,8 +785,37 @@ isolate_migratepages_block(struct compac
 			goto isolate_fail;
 		}
 
-		if (!is_lru)
+		/*
+		 * Check may be lockless but that's ok as we recheck later.
+		 * It's possible to migrate LRU and non-lru movable pages.
+		 * Skip any other type of page
+		 */
+		if (!PageLRU(page)) {
+			if (unlikely(balloon_page_movable(page))) {
+				if (balloon_page_isolate(page)) {
+					/* Successfully isolated */
+					goto isolate_success;
+				}
+			}
+
+			/*
+			 * __PageMovable can return false positive so we need
+			 * to verify it under page_lock.
+			 */
+			if (unlikely(__PageMovable(page)) &&
+					!PageIsolated(page)) {
+				if (locked) {
+					spin_unlock_irqrestore(&zone->lru_lock,
+									flags);
+					locked = false;
+				}
+
+				if (isolate_movable_page(page, isolate_mode))
+					goto isolate_success;
+			}
+
 			goto isolate_fail;
+		}
 
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
diff -puN mm/ksm.c~mm-migrate-support-non-lru-movable-page-migration mm/ksm.c
--- a/mm/ksm.c~mm-migrate-support-non-lru-movable-page-migration
+++ a/mm/ksm.c
@@ -532,8 +532,8 @@ static struct page *get_ksm_page(struct
 	void *expected_mapping;
 	unsigned long kpfn;
 
-	expected_mapping = (void *)stable_node +
-				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
+	expected_mapping = (void *)((unsigned long)stable_node |
+					PAGE_MAPPING_KSM);
 again:
 	kpfn = READ_ONCE(stable_node->kpfn);
 	page = pfn_to_page(kpfn);
diff -puN mm/migrate.c~mm-migrate-support-non-lru-movable-page-migration mm/migrate.c
--- a/mm/migrate.c~mm-migrate-support-non-lru-movable-page-migration
+++ a/mm/migrate.c
@@ -31,6 +31,7 @@
 #include <linux/vmalloc.h>
 #include <linux/security.h>
 #include <linux/backing-dev.h>
+#include <linux/compaction.h>
 #include <linux/syscalls.h>
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
@@ -73,6 +74,81 @@ int migrate_prep_local(void)
 	return 0;
 }
 
+bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+{
+	struct address_space *mapping;
+
+	/*
+	 * Avoid burning cycles with pages that are yet under __free_pages(),
+	 * or just got freed under us.
+	 *
+	 * In case we 'win' a race for a movable page being freed under us and
+	 * raise its refcount preventing __free_pages() from doing its job
+	 * the put_page() at the end of this block will take care of
+	 * release this page, thus avoiding a nasty leakage.
+	 */
+	if (unlikely(!get_page_unless_zero(page)))
+		goto out;
+
+	/*
+	 * Check PageMovable before holding a PG_lock because page's owner
+	 * assumes anybody doesn't touch PG_lock of newly allocated page
+	 * so unconditionally grapping the lock ruins page's owner side.
+	 */
+	if (unlikely(!__PageMovable(page)))
+		goto out_putpage;
+	/*
+	 * As movable pages are not isolated from LRU lists, concurrent
+	 * compaction threads can race against page migration functions
+	 * as well as race against the releasing a page.
+	 *
+	 * In order to avoid having an already isolated movable page
+	 * being (wrongly) re-isolated while it is under migration,
+	 * or to avoid attempting to isolate pages being released,
+	 * lets be sure we have the page lock
+	 * before proceeding with the movable page isolation steps.
+	 */
+	if (unlikely(!trylock_page(page)))
+		goto out_putpage;
+
+	if (!PageMovable(page) || PageIsolated(page))
+		goto out_no_isolated;
+
+	mapping = page_mapping(page);
+	VM_BUG_ON_PAGE(!mapping, page);
+
+	if (!mapping->a_ops->isolate_page(page, mode))
+		goto out_no_isolated;
+
+	/* Driver shouldn't use PG_isolated bit of page->flags */
+	WARN_ON_ONCE(PageIsolated(page));
+	__SetPageIsolated(page);
+	unlock_page(page);
+
+	return true;
+
+out_no_isolated:
+	unlock_page(page);
+out_putpage:
+	put_page(page);
+out:
+	return false;
+}
+
+/* It should be called on page which is PG_movable */
+void putback_movable_page(struct page *page)
+{
+	struct address_space *mapping;
+
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageMovable(page), page);
+	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+
+	mapping = page_mapping(page);
+	mapping->a_ops->putback_page(page);
+	__ClearPageIsolated(page);
+}
+
 /*
  * Put previously isolated pages back onto the appropriate lists
  * from where they were once taken off for compaction/migration.
@@ -94,10 +170,25 @@ void putback_movable_pages(struct list_h
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (unlikely(isolated_balloon_page(page)))
+		if (unlikely(isolated_balloon_page(page))) {
 			balloon_page_putback(page);
-		else
+		/*
+		 * We isolated non-lru movable page so here we can use
+		 * __PageMovable because LRU page's mapping cannot have
+		 * PAGE_MAPPING_MOVABLE.
+		 */
+		} else if (unlikely(__PageMovable(page))) {
+			VM_BUG_ON_PAGE(!PageIsolated(page), page);
+			lock_page(page);
+			if (PageMovable(page))
+				putback_movable_page(page);
+			else
+				__ClearPageIsolated(page);
+			unlock_page(page);
+			put_page(page);
+		} else {
 			putback_lru_page(page);
+		}
 	}
 }
 
@@ -594,7 +685,7 @@ EXPORT_SYMBOL(migrate_page_copy);
  ***********************************************************/
 
 /*
- * Common logic to directly migrate a single page suitable for
+ * Common logic to directly migrate a single LRU page suitable for
  * pages that do not use PagePrivate/PagePrivate2.
  *
  * Pages are locked upon entry and exit.
@@ -757,33 +848,72 @@ static int move_to_new_page(struct page
 				enum migrate_mode mode)
 {
 	struct address_space *mapping;
-	int rc;
+	int rc = -EAGAIN;
+	bool is_lru = !__PageMovable(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	mapping = page_mapping(page);
-	if (!mapping)
-		rc = migrate_page(mapping, newpage, page, mode);
-	else if (mapping->a_ops->migratepage)
+
+	if (likely(is_lru)) {
+		if (!mapping)
+			rc = migrate_page(mapping, newpage, page, mode);
+		else if (mapping->a_ops->migratepage)
+			/*
+			 * Most pages have a mapping and most filesystems
+			 * provide a migratepage callback. Anonymous pages
+			 * are part of swap space which also has its own
+			 * migratepage callback. This is the most common path
+			 * for page migration.
+			 */
+			rc = mapping->a_ops->migratepage(mapping, newpage,
+							page, mode);
+		else
+			rc = fallback_migrate_page(mapping, newpage,
+							page, mode);
+	} else {
 		/*
-		 * Most pages have a mapping and most filesystems provide a
-		 * migratepage callback. Anonymous pages are part of swap
-		 * space which also has its own migratepage callback. This
-		 * is the most common path for page migration.
+		 * In case of non-lru page, it could be released after
+		 * isolation step. In that case, we shouldn't try migration.
 		 */
-		rc = mapping->a_ops->migratepage(mapping, newpage, page, mode);
-	else
-		rc = fallback_migrate_page(mapping, newpage, page, mode);
+		VM_BUG_ON_PAGE(!PageIsolated(page), page);
+		if (!PageMovable(page)) {
+			rc = MIGRATEPAGE_SUCCESS;
+			__ClearPageIsolated(page);
+			goto out;
+		}
+
+		rc = mapping->a_ops->migratepage(mapping, newpage,
+						page, mode);
+		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
+			!PageIsolated(page));
+	}
 
 	/*
 	 * When successful, old pagecache page->mapping must be cleared before
 	 * page is freed; but stats require that PageAnon be left as PageAnon.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (!PageAnon(page))
+		if (__PageMovable(page)) {
+			VM_BUG_ON_PAGE(!PageIsolated(page), page);
+
+			/*
+			 * We clear PG_movable under page_lock so any compactor
+			 * cannot try to migrate this page.
+			 */
+			__ClearPageIsolated(page);
+		}
+
+		/*
+		 * Anonymous and movable page->mapping will be cleard by
+		 * free_pages_prepare so don't reset it here for keeping
+		 * the type to work PageAnon, for example.
+		 */
+		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 	}
+out:
 	return rc;
 }
 
@@ -793,6 +923,7 @@ static int __unmap_and_move(struct page
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
+	bool is_lru = !__PageMovable(page);
 
 	if (!trylock_page(page)) {
 		if (!force || mode == MIGRATE_ASYNC)
@@ -873,6 +1004,11 @@ static int __unmap_and_move(struct page
 		goto out_unlock_both;
 	}
 
+	if (unlikely(!is_lru)) {
+		rc = move_to_new_page(newpage, page, mode);
+		goto out_unlock_both;
+	}
+
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
@@ -922,7 +1058,8 @@ out:
 	 * list in here.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (unlikely(__is_movable_balloon_page(newpage)))
+		if (unlikely(__is_movable_balloon_page(newpage) ||
+				__PageMovable(newpage)))
 			put_page(newpage);
 		else
 			putback_lru_page(newpage);
@@ -963,6 +1100,12 @@ static ICE_noinline int unmap_and_move(n
 		/* page was freed from under us. So we are done. */
 		ClearPageActive(page);
 		ClearPageUnevictable(page);
+		if (unlikely(__PageMovable(page))) {
+			lock_page(page);
+			if (!PageMovable(page))
+				__ClearPageIsolated(page);
+			unlock_page(page);
+		}
 		if (put_new_page)
 			put_new_page(newpage, private);
 		else
@@ -1012,8 +1155,21 @@ out:
 				num_poisoned_pages_inc();
 		}
 	} else {
-		if (rc != -EAGAIN)
-			putback_lru_page(page);
+		if (rc != -EAGAIN) {
+			if (likely(!__PageMovable(page))) {
+				putback_lru_page(page);
+				goto put_new;
+			}
+
+			lock_page(page);
+			if (PageMovable(page))
+				putback_movable_page(page);
+			else
+				__ClearPageIsolated(page);
+			unlock_page(page);
+			put_page(page);
+		}
+put_new:
 		if (put_new_page)
 			put_new_page(newpage, private);
 		else
diff -puN mm/page_alloc.c~mm-migrate-support-non-lru-movable-page-migration mm/page_alloc.c
--- a/mm/page_alloc.c~mm-migrate-support-non-lru-movable-page-migration
+++ a/mm/page_alloc.c
@@ -1016,7 +1016,7 @@ static __always_inline bool free_pages_p
 			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
-	if (PageAnonHead(page))
+	if (PageMappingFlags(page))
 		page->mapping = NULL;
 	if (check_free)
 		bad += free_pages_check(page);
diff -puN mm/util.c~mm-migrate-support-non-lru-movable-page-migration mm/util.c
--- a/mm/util.c~mm-migrate-support-non-lru-movable-page-migration
+++ a/mm/util.c
@@ -399,10 +399,12 @@ struct address_space *page_mapping(struc
 	}
 
 	mapping = page->mapping;
-	if ((unsigned long)mapping & PAGE_MAPPING_FLAGS)
+	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		return NULL;
-	return mapping;
+
+	return (void *)((unsigned long)mapping & ~PAGE_MAPPING_FLAGS);
 }
+EXPORT_SYMBOL(page_mapping);
 
 /* Slow path of page_mapcount() for compound pages */
 int __page_mapcount(struct page *page)
_
