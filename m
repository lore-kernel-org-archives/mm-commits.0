From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-compaction-support-non-lru-movable-page-migration.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:13:45 -0700
Message-ID: <57042a89.UvTnlav2W2Ml5YnR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbcDEVNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, chan.jeong@lge.com, gurugio@hanmail.net, hughd@google.com, iamjoonsoo.kim@lge.com, koct9i@gmail.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rknize@motorola.com, sangseok.lee@lge.com, sergey.senozhatsky@gmail.com, vbabka@suse.cz, viro@ZenIV.linux.org.uk, xuyiping@hisilicon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: support non-lru movable page migration
has been removed from the -mm tree.  Its filename was
     mm-compaction-support-non-lru-movable-page-migration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/compaction: support non-lru movable page migration

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

Basically, this patch supports two page-flags and two functions related to
page migration.  The flag and page->mapping stability are protected by
PG_lock.

	PG_movable
	PG_isolated

	bool (*isolate_page) (struct page *, isolate_mode_t);
	void (*putback_page) (struct page *);

Duty of subsystem want to make their pages as migratable are
as follows:

1. It should register address_space to page->mapping then mark the
   page as PG_movable via __SetPageMovable.

2. It should mark the page as PG_isolated via SetPageIsolated if
   isolation is sucessful and return true.

3. If migration is successful, it should clear PG_isolated and
   PG_movable of the page for free preparation then release the reference
   of the page to free.

4. If migration fails, putback function of subsystem should clear
   PG_isolated via ClearPageIsolated.

5. If a subsystem want to release isolated page, it should clear
   PG_isolated but not PG_movable.  Instead, VM will do it.

Signed-off-by: Gioh Kim <gurugio@hanmail.net>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Russ Knize <rknize@motorola.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: YiPing Xu <xuyiping@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking      |    4 
 Documentation/filesystems/vfs.txt      |    5 
 fs/proc/page.c                         |    3 
 include/linux/fs.h                     |    2 
 include/linux/migrate.h                |    2 
 include/linux/page-flags.h             |   31 ++++
 include/uapi/linux/kernel-page-flags.h |    1 
 mm/compaction.c                        |   14 +
 mm/migrate.c                           |  174 ++++++++++++++++++++---
 9 files changed, 217 insertions(+), 19 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-compaction-support-non-lru-movable-page-migration Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-compaction-support-non-lru-movable-page-migration
+++ a/Documentation/filesystems/Locking
@@ -195,7 +195,9 @@ prototypes:
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
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
diff -puN Documentation/filesystems/vfs.txt~mm-compaction-support-non-lru-movable-page-migration Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mm-compaction-support-non-lru-movable-page-migration
+++ a/Documentation/filesystems/vfs.txt
@@ -592,9 +592,14 @@ struct address_space_operations {
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
+	/* isolate a page for migration */
+	bool (*isolate_page) (struct page *, isolate_mode_t);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
+	/* put the page back to right list */
+	void (*putback_page) (struct page *);
 	int (*launder_page) (struct page *);
+
 	int (*is_partially_uptodate) (struct page *, unsigned long,
 					unsigned long);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
diff -puN fs/proc/page.c~mm-compaction-support-non-lru-movable-page-migration fs/proc/page.c
--- a/fs/proc/page.c~mm-compaction-support-non-lru-movable-page-migration
+++ a/fs/proc/page.c
@@ -157,6 +157,9 @@ u64 stable_page_flags(struct page *page)
 	if (page_is_idle(page))
 		u |= 1 << KPF_IDLE;
 
+	if (PageMovable(page))
+		u |= 1 << KPF_MOVABLE;
+
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
diff -puN include/linux/fs.h~mm-compaction-support-non-lru-movable-page-migration include/linux/fs.h
--- a/include/linux/fs.h~mm-compaction-support-non-lru-movable-page-migration
+++ a/include/linux/fs.h
@@ -401,6 +401,8 @@ struct address_space_operations {
 	 */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
+	bool (*isolate_page)(struct page *, isolate_mode_t);
+	void (*putback_page)(struct page *);
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, unsigned long,
 					unsigned long);
diff -puN include/linux/migrate.h~mm-compaction-support-non-lru-movable-page-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-compaction-support-non-lru-movable-page-migration
+++ a/include/linux/migrate.h
@@ -37,6 +37,8 @@ extern int migrate_page(struct address_s
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
+extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+extern void putback_movable_page(struct page *page);
 
 extern int migrate_prep(void);
 extern int migrate_prep_local(void);
diff -puN include/linux/page-flags.h~mm-compaction-support-non-lru-movable-page-migration include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-compaction-support-non-lru-movable-page-migration
+++ a/include/linux/page-flags.h
@@ -129,6 +129,10 @@ enum pageflags {
 
 	/* Compound pages. Stored in first tail page's flags */
 	PG_double_map = PG_private_2,
+
+	/* non-lru movable pages */
+	PG_movable = PG_reclaim,
+	PG_isolated = PG_owner_priv_1,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -614,6 +618,33 @@ static inline void __ClearPageBalloon(st
 	atomic_set(&page->_mapcount, -1);
 }
 
+#define PAGE_MOVABLE_MAPCOUNT_VALUE (-255)
+
+static inline int PageMovable(struct page *page)
+{
+	return ((test_bit(PG_movable, &(page)->flags) &&
+		atomic_read(&page->_mapcount) == PAGE_MOVABLE_MAPCOUNT_VALUE)
+		|| PageBalloon(page));
+}
+
+/* Caller should hold a PG_lock */
+static inline void __SetPageMovable(struct page *page,
+				struct address_space *mapping)
+{
+	page->mapping = mapping;
+	__set_bit(PG_movable, &page->flags);
+	atomic_set(&page->_mapcount, PAGE_MOVABLE_MAPCOUNT_VALUE);
+}
+
+static inline void __ClearPageMovable(struct page *page)
+{
+	atomic_set(&page->_mapcount, -1);
+	__clear_bit(PG_movable, &(page)->flags);
+	page->mapping = NULL;
+}
+
+PAGEFLAG(Isolated, isolated, PF_ANY);
+
 /*
  * If network-based swap is enabled, sl*b must keep track of whether pages
  * were allocated from pfmemalloc reserves.
diff -puN include/uapi/linux/kernel-page-flags.h~mm-compaction-support-non-lru-movable-page-migration include/uapi/linux/kernel-page-flags.h
--- a/include/uapi/linux/kernel-page-flags.h~mm-compaction-support-non-lru-movable-page-migration
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -34,6 +34,7 @@
 #define KPF_BALLOON		23
 #define KPF_ZERO_PAGE		24
 #define KPF_IDLE		25
+#define KPF_MOVABLE		26
 
 
 #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
diff -puN mm/compaction.c~mm-compaction-support-non-lru-movable-page-migration mm/compaction.c
--- a/mm/compaction.c~mm-compaction-support-non-lru-movable-page-migration
+++ a/mm/compaction.c
@@ -703,7 +703,7 @@ isolate_migratepages_block(struct compac
 
 		/*
 		 * Check may be lockless but that's ok as we recheck later.
-		 * It's possible to migrate LRU pages and balloon pages
+		 * It's possible to migrate LRU and movable kernel pages.
 		 * Skip any other type of page
 		 */
 		is_lru = PageLRU(page);
@@ -714,6 +714,18 @@ isolate_migratepages_block(struct compac
 					goto isolate_success;
 				}
 			}
+
+			if (unlikely(PageMovable(page)) &&
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
 		}
 
 		/*
diff -puN mm/migrate.c~mm-compaction-support-non-lru-movable-page-migration mm/migrate.c
--- a/mm/migrate.c~mm-compaction-support-non-lru-movable-page-migration
+++ a/mm/migrate.c
@@ -73,6 +73,85 @@ int migrate_prep_local(void)
 	return 0;
 }
 
+bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+{
+	bool ret = false;
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
+	 * Check PG_movable before holding a PG_lock because page's owner
+	 * assumes anybody doesn't touch PG_lock of newly allocated page.
+	 */
+	if (unlikely(!PageMovable(page)))
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
+	ret = page->mapping->a_ops->isolate_page(page, mode);
+	if (!ret)
+		goto out_no_isolated;
+
+	WARN_ON_ONCE(!PageIsolated(page));
+	unlock_page(page);
+	return ret;
+
+out_no_isolated:
+	unlock_page(page);
+out_putpage:
+	put_page(page);
+out:
+	return ret;
+}
+
+/* It should be called on page which is PG_movable */
+void putback_movable_page(struct page *page)
+{
+	/*
+	 * 'lock_page()' stabilizes the page and prevents races against
+	 * concurrent isolation threads attempting to re-isolate it.
+	 */
+	VM_BUG_ON_PAGE(!PageMovable(page), page);
+
+	lock_page(page);
+	if (PageIsolated(page)) {
+		struct address_space *mapping;
+
+		mapping = page_mapping(page);
+		mapping->a_ops->putback_page(page);
+		WARN_ON_ONCE(PageIsolated(page));
+	} else {
+		__ClearPageMovable(page);
+	}
+	unlock_page(page);
+	/* drop the extra ref count taken for movable page isolation */
+	put_page(page);
+}
+
 /*
  * Put previously isolated pages back onto the appropriate lists
  * from where they were once taken off for compaction/migration.
@@ -94,10 +173,18 @@ void putback_movable_pages(struct list_h
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
-		if (unlikely(isolated_balloon_page(page)))
+		if (unlikely(isolated_balloon_page(page))) {
 			balloon_page_putback(page);
-		else
+		} else if (unlikely(PageMovable(page))) {
+			if (PageIsolated(page)) {
+				putback_movable_page(page);
+			} else {
+				__ClearPageMovable(page);
+				put_page(page);
+			}
+		} else {
 			putback_lru_page(page);
+		}
 	}
 }
 
@@ -592,7 +679,7 @@ void migrate_page_copy(struct page *newp
  ***********************************************************/
 
 /*
- * Common logic to directly migrate a single page suitable for
+ * Common logic to directly migrate a single LRU page suitable for
  * pages that do not use PagePrivate/PagePrivate2.
  *
  * Pages are locked upon entry and exit.
@@ -755,24 +842,54 @@ static int move_to_new_page(struct page
 				enum migrate_mode mode)
 {
 	struct address_space *mapping;
-	int rc;
+	int rc = -EAGAIN;
+	bool lru_movable = true;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
 	mapping = page_mapping(page);
-	if (!mapping)
-		rc = migrate_page(mapping, newpage, page, mode);
-	else if (mapping->a_ops->migratepage)
-		/*
-		 * Most pages have a mapping and most filesystems provide a
-		 * migratepage callback. Anonymous pages are part of swap
-		 * space which also has its own migratepage callback. This
-		 * is the most common path for page migration.
-		 */
-		rc = mapping->a_ops->migratepage(mapping, newpage, page, mode);
-	else
-		rc = fallback_migrate_page(mapping, newpage, page, mode);
+	/*
+	 * In case of non-lru page, it could be released after
+	 * isolation step. In that case, we shouldn't try
+	 * fallback migration which was designed for LRU pages.
+	 *
+	 * The rule for such case is that subsystem should clear
+	 * PG_isolated but remains PG_movable so VM should catch
+	 * it and clear PG_movable for it.
+	 */
+	if (unlikely(PageMovable(page))) {
+		lru_movable = false;
+		VM_BUG_ON_PAGE(!mapping, page);
+		if (!PageIsolated(page)) {
+			rc = MIGRATEPAGE_SUCCESS;
+			__ClearPageMovable(page);
+			goto out;
+		}
+	}
+
+	if (likely(lru_movable)) {
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
+		rc = mapping->a_ops->migratepage(mapping, newpage,
+						page, mode);
+		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
+			PageIsolated(page));
+	}
 
 	/*
 	 * When successful, old pagecache page->mapping must be cleared before
@@ -782,6 +899,7 @@ static int move_to_new_page(struct page
 		if (!PageAnon(page))
 			page->mapping = NULL;
 	}
+out:
 	return rc;
 }
 
@@ -960,6 +1078,8 @@ static ICE_noinline int unmap_and_move(n
 			put_new_page(newpage, private);
 		else
 			put_page(newpage);
+		if (PageMovable(page))
+			__ClearPageMovable(page);
 		goto out;
 	}
 
@@ -1000,8 +1120,26 @@ out:
 				num_poisoned_pages_inc();
 		}
 	} else {
-		if (rc != -EAGAIN)
-			putback_lru_page(page);
+		if (rc != -EAGAIN) {
+			/*
+			 * subsystem couldn't remove PG_movable since page is
+			 * isolated so PageMovable check is not racy in here.
+			 * But PageIsolated check can be racy but it's okay
+			 * because putback_movable_page checks it under PG_lock
+			 * again.
+			 */
+			if (unlikely(PageMovable(page))) {
+				if (PageIsolated(page))
+					putback_movable_page(page);
+				else {
+					__ClearPageMovable(page);
+					put_page(page);
+				}
+			} else {
+				putback_lru_page(page);
+			}
+		}
+
 		if (put_new_page)
 			put_new_page(newpage, private);
 		else
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
mm-add-non-lru-movable-page-support-document.patch
mm-balloon-use-general-movable-page-feature-into-balloon.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

