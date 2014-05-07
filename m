From: akpm@linux-foundation.org
Subject: + mm-migration-add-destination-page-freeing-callback.patch added
 to -mm tree
Date: Wed, 07 May 2014 14:20:45 -0700
Message-ID: <536aa3ad.KCY0iAdpuwdd7xtk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGVUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: + mm-migration-add-destination-page-freeing-callback.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:45 -0700


The patch titled
     Subject: mm, migration: add destination page freeing callback
has been added to the -mm tree.  Its filename is
     mm-migration-add-destination-page-freeing-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-add-destination-page-freeing-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-add-destination-page-freeing-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, migration: add destination page freeing callback

Memory migration uses a callback defined by the caller to determine how to
allocate destination pages.  When migration fails for a source page,
however, it frees the destination page back to the system.

This patch adds a memory migration callback defined by the caller to
determine how to free destination pages.  If a caller, such as memory
compaction, builds its own freelist for migration targets, this can reuse
already freed memory instead of scanning additional memory.

If the caller provides a function to handle freeing of destination pages,
it is called when page migration fails.  If the caller passes NULL then
freeing back to the system will be handled as usual.  This patch
introduces no functional change.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   11 ++++---
 mm/compaction.c         |    2 -
 mm/memory-failure.c     |    4 +-
 mm/memory_hotplug.c     |    2 -
 mm/mempolicy.c          |    4 +-
 mm/migrate.c            |   55 ++++++++++++++++++++++++++------------
 mm/page_alloc.c         |    2 -
 7 files changed, 53 insertions(+), 27 deletions(-)

diff -puN include/linux/migrate.h~mm-migration-add-destination-page-freeing-callback include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migration-add-destination-page-freeing-callback
+++ a/include/linux/migrate.h
@@ -5,7 +5,9 @@
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 
-typedef struct page *new_page_t(struct page *, unsigned long private, int **);
+typedef struct page *new_page_t(struct page *page, unsigned long private,
+				int **reason);
+typedef void free_page_t(struct page *page, unsigned long private);
 
 /*
  * Return values from addresss_space_operations.migratepage():
@@ -38,7 +40,7 @@ enum migrate_reason {
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
-extern int migrate_pages(struct list_head *l, new_page_t x,
+extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
 
 extern int migrate_prep(void);
@@ -56,8 +58,9 @@ extern int migrate_page_move_mapping(str
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
-static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, enum migrate_mode mode, int reason)
+static inline int migrate_pages(struct list_head *l, new_page_t new,
+		free_page_t free, unsigned long private, enum migrate_mode mode,
+		int reason)
 	{ return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-migration-add-destination-page-freeing-callback mm/compaction.c
--- a/mm/compaction.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/compaction.c
@@ -1013,7 +1013,7 @@ static int compact_zone(struct zone *zon
 		}
 
 		nr_migrate = cc->nr_migratepages;
-		err = migrate_pages(&cc->migratepages, compaction_alloc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
 				(unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
diff -puN mm/memory-failure.c~mm-migration-add-destination-page-freeing-callback mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/memory-failure.c
@@ -1500,7 +1500,7 @@ static int soft_offline_huge_page(struct
 
 	/* Keep page count to indicate a given hugepage is isolated. */
 	list_move(&hpage->lru, &pagelist);
-	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
@@ -1581,7 +1581,7 @@ static int __soft_offline_page(struct pa
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
-		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
 			if (!list_empty(&pagelist)) {
diff -puN mm/memory_hotplug.c~mm-migration-add-destination-page-freeing-callback mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/memory_hotplug.c
@@ -1394,7 +1394,7 @@ do_migrate_range(unsigned long start_pfn
 		 * alloc_migrate_target should be improooooved!!
 		 * migrate_pages returns # of failed pages.
 		 */
-		ret = migrate_pages(&source, alloc_migrate_target, 0,
+		ret = migrate_pages(&source, alloc_migrate_target, NULL, 0,
 					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
 			putback_movable_pages(&source);
diff -puN mm/mempolicy.c~mm-migration-add-destination-page-freeing-callback mm/mempolicy.c
--- a/mm/mempolicy.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/mempolicy.c
@@ -978,7 +978,7 @@ static int migrate_to_node(struct mm_str
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, dest,
+		err = migrate_pages(&pagelist, new_node_page, NULL, dest,
 					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
@@ -1227,7 +1227,7 @@ static long do_mbind(unsigned long start
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-					(unsigned long)vma,
+					NULL, (unsigned long)vma,
 					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
 				putback_movable_pages(&pagelist);
diff -puN mm/migrate.c~mm-migration-add-destination-page-freeing-callback mm/migrate.c
--- a/mm/migrate.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/migrate.c
@@ -938,8 +938,9 @@ out:
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
  */
-static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, enum migrate_mode mode)
+static int unmap_and_move(new_page_t get_new_page, free_page_t put_new_page,
+			unsigned long private, struct page *page, int force,
+			enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -983,11 +984,17 @@ out:
 				page_is_file_cache(page));
 		putback_lru_page(page);
 	}
+
 	/*
-	 * Move the new page to the LRU. If migration was not successful
-	 * then this will free the page.
+	 * If migration was not successful and there's a freeing callback, use
+	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
+	 * during isolation.
 	 */
-	putback_lru_page(newpage);
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+		put_new_page(newpage, private);
+	else
+		putback_lru_page(newpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
@@ -1016,8 +1023,9 @@ out:
  * will wait in the page fault for migration to complete.
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
-				unsigned long private, struct page *hpage,
-				int force, enum migrate_mode mode)
+				free_page_t put_new_page, unsigned long private,
+				struct page *hpage, int force,
+				enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -1056,20 +1064,30 @@ static int unmap_and_move_huge_page(new_
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, 1, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		remove_migration_ptes(hpage, hpage);
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
-	if (!rc)
+	if (rc == MIGRATEPAGE_SUCCESS)
 		hugetlb_cgroup_migrate(hpage, new_hpage);
 
 	unlock_page(hpage);
 out:
 	if (rc != -EAGAIN)
 		putback_active_hugepage(hpage);
-	put_page(new_hpage);
+
+	/*
+	 * If migration was not successful and there's a freeing callback, use
+	 * it.  Otherwise, put_page() will drop the reference grabbed during
+	 * isolation.
+	 */
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+		put_new_page(new_hpage, private);
+	else
+		put_page(new_hpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
@@ -1086,6 +1104,8 @@ out:
  * @from:		The list of pages to be migrated.
  * @get_new_page:	The function used to allocate free pages to be used
  *			as the target of the page migration.
+ * @put_new_page:	The function used to free target pages if migration
+ *			fails, or NULL if no special handling is necessary.
  * @private:		Private data to be passed on to get_new_page()
  * @mode:		The migration mode that specifies the constraints for
  *			page migration, if any.
@@ -1099,7 +1119,8 @@ out:
  * Returns the number of pages that were not migrated, or an error code.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
-		unsigned long private, enum migrate_mode mode, int reason)
+		free_page_t put_new_page, unsigned long private,
+		enum migrate_mode mode, int reason)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -1121,10 +1142,11 @@ int migrate_pages(struct list_head *from
 
 			if (PageHuge(page))
 				rc = unmap_and_move_huge_page(get_new_page,
-						private, page, pass > 2, mode);
+						put_new_page, private, page,
+						pass > 2, mode);
 			else
-				rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, mode);
+				rc = unmap_and_move(get_new_page, put_new_page,
+						private, page, pass > 2, mode);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1273,7 +1295,7 @@ set_status:
 
 	err = 0;
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_page_node,
+		err = migrate_pages(&pagelist, new_page_node, NULL,
 				(unsigned long)pm, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
@@ -1729,7 +1751,8 @@ int migrate_misplaced_page(struct page *
 
 	list_add(&page->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
-				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED);
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
diff -puN mm/page_alloc.c~mm-migration-add-destination-page-freeing-callback mm/page_alloc.c
--- a/mm/page_alloc.c~mm-migration-add-destination-page-freeing-callback
+++ a/mm/page_alloc.c
@@ -6221,7 +6221,7 @@ static int __alloc_contig_migrate_range(
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    0, MIGRATE_SYNC, MR_CMA);
+				    NULL, 0, MIGRATE_SYNC, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

