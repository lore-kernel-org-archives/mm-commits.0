From: akpm@linux-foundation.org
Subject: + huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:37 -0700
Message-ID: <57044755.EWCxI83ET9glKiEY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067AbcDEXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: page migration call back into shmem
has been added to the -mm tree.  Its filename is
     huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs recovery: page migration call back into shmem

What we have works; but involves tricky "account_head" handling, and more
trips around the shmem_recovery_populate() loop than I'm comfortable with.

Tighten it all up with a MIGRATE_SHMEM_RECOVERY mode, and
shmem_recovery_migrate_page() callout from migrate_page_move_mapping(), so
that the migrated page can be made PageTeam immediately.

Which allows the SHMEM_RETRY_HUGE_PAGE hugehint to be reintroduced, for
what little that's worth.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate_mode.h   |    2 
 include/linux/shmem_fs.h       |    6 +
 include/trace/events/migrate.h |    3 
 mm/migrate.c                   |   17 ++++-
 mm/shmem.c                     |   99 ++++++++++++-------------------
 5 files changed, 62 insertions(+), 65 deletions(-)

diff -puN include/linux/migrate_mode.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem include/linux/migrate_mode.h
--- a/include/linux/migrate_mode.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem
+++ a/include/linux/migrate_mode.h
@@ -6,11 +6,13 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_SHMEM_RECOVERY is a MIGRATE_SYNC specific to huge tmpfs recovery.
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_SHMEM_RECOVERY,
 };
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff -puN include/linux/shmem_fs.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem
+++ a/include/linux/shmem_fs.h
@@ -85,6 +85,7 @@ static inline long shmem_fcntl(struct fi
 #endif /* CONFIG_TMPFS */
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
+extern bool shmem_recovery_migrate_page(struct page *new, struct page *page);
 # ifdef CONFIG_SYSCTL
 struct ctl_table;
 extern int shmem_huge, shmem_huge_min, shmem_huge_max;
@@ -92,6 +93,11 @@ extern int shmem_huge_recoveries;
 extern int shmem_huge_sysctl(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp, loff_t *ppos);
 # endif /* CONFIG_SYSCTL */
+#else
+static inline bool shmem_recovery_migrate_page(struct page *new, struct page *p)
+{
+	return true;	/* Never called: true will optimize out the fallback */
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SHMEM */
 
 #endif
diff -puN include/trace/events/migrate.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem include/trace/events/migrate.h
--- a/include/trace/events/migrate.h~huge-tmpfs-recovery-page-migration-call-back-into-shmem
+++ a/include/trace/events/migrate.h
@@ -9,7 +9,8 @@
 #define MIGRATE_MODE						\
 	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
 	EM( MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT")		\
-	EMe(MIGRATE_SYNC,	"MIGRATE_SYNC")
+	EM( MIGRATE_SYNC,	"MIGRATE_SYNC")			\
+	EMe(MIGRATE_SHMEM_RECOVERY, "MIGRATE_SHMEM_RECOVERY")
 
 
 #define MIGRATE_REASON						\
diff -puN mm/migrate.c~huge-tmpfs-recovery-page-migration-call-back-into-shmem mm/migrate.c
--- a/mm/migrate.c~huge-tmpfs-recovery-page-migration-call-back-into-shmem
+++ a/mm/migrate.c
@@ -23,6 +23,7 @@
 #include <linux/pagevec.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
+#include <linux/shmem_fs.h>
 #include <linux/topology.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
@@ -371,6 +372,15 @@ int migrate_page_move_mapping(struct add
 		return -EAGAIN;
 	}
 
+	if (mode == MIGRATE_SHMEM_RECOVERY) {
+		if (!shmem_recovery_migrate_page(newpage, page)) {
+			page_ref_unfreeze(page, expected_count);
+			spin_unlock_irq(&mapping->tree_lock);
+			return -ENOMEM;	/* quit migrate_pages() immediately */
+		}
+	} else
+		get_page(newpage);	/* add cache reference */
+
 	/*
 	 * Now we know that no one else is looking at the page:
 	 * no turning back from here.
@@ -380,7 +390,6 @@ int migrate_page_move_mapping(struct add
 	if (PageSwapBacked(page))
 		__SetPageSwapBacked(newpage);
 
-	get_page(newpage);	/* add cache reference */
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
 		set_page_private(newpage, page_private(page));
@@ -786,7 +795,7 @@ static int move_to_new_page(struct page
 }
 
 static int __unmap_and_move(struct page *page, struct page *newpage,
-		int force, enum migrate_mode mode, enum migrate_reason reason)
+				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
@@ -821,7 +830,7 @@ static int __unmap_and_move(struct page
 	 * already in use, on lru, with data newly written for that offset.
 	 * We can only be sure of this check once we have the page locked.
 	 */
-	if (reason == MR_SHMEM_RECOVERY && !page->mapping) {
+	if (mode == MIGRATE_SHMEM_RECOVERY && !page->mapping) {
 		rc = -ENOMEM;	/* quit migrate_pages() immediately */
 		goto out_unlock;
 	}
@@ -973,7 +982,7 @@ static ICE_noinline int unmap_and_move(n
 			goto out;
 	}
 
-	rc = __unmap_and_move(page, newpage, force, mode, reason);
+	rc = __unmap_and_move(page, newpage, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS) {
 		put_new_page = NULL;
 		set_page_owner_migrate_reason(newpage, reason);
diff -puN mm/shmem.c~huge-tmpfs-recovery-page-migration-call-back-into-shmem mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-recovery-page-migration-call-back-into-shmem
+++ a/mm/shmem.c
@@ -306,6 +306,7 @@ static bool shmem_confirm_swap(struct ad
 /* hugehint values: NULL to choose a small page always */
 #define SHMEM_ALLOC_SMALL_PAGE	((struct page *)1)
 #define SHMEM_ALLOC_HUGE_PAGE	((struct page *)2)
+#define SHMEM_RETRY_HUGE_PAGE	((struct page *)3)
 /* otherwise hugehint is the hugeteam page to be used */
 
 /* tag for shrinker to locate unfilled hugepages */
@@ -368,20 +369,6 @@ restart:
 			put_page(page);
 		return SHMEM_ALLOC_SMALL_PAGE;
 	}
-	if (PageSwapBacked(page)) {
-		if (speculative)
-			put_page(page);
-		/*
-		 * This is very often a case of two tasks racing to instantiate
-		 * the same hole in the huge page, and we don't particularly
-		 * want to allocate a small page.  But holepunch racing with
-		 * recovery migration, in between migrating to the page and
-		 * marking it team, can leave a PageSwapBacked NULL mapping
-		 * page here which we should avoid, and this is the easiest
-		 * way to handle all the cases correctly.
-		 */
-		return SHMEM_ALLOC_SMALL_PAGE;
-	}
 	return page;
 }
 
@@ -784,7 +771,6 @@ struct recovery {
 	struct inode *inode;
 	struct page *page;
 	pgoff_t head_index;
-	struct page *migrated_head;
 	bool exposed_team;
 };
 
@@ -988,8 +974,7 @@ static void shmem_recovery_swapin(struct
 static struct page *shmem_get_recovery_page(struct page *page,
 					unsigned long private, int **result)
 {
-	struct recovery *recovery = (struct recovery *)private;
-	struct page *head = recovery->page;
+	struct page *head = (struct page *)private;
 	struct page *newpage = head + (page->index & (HPAGE_PMD_NR-1));
 
 	/* Increment refcount to match other routes through recovery_populate */
@@ -999,19 +984,33 @@ static struct page *shmem_get_recovery_p
 		put_page(newpage);
 		return NULL;
 	}
-	/* Note when migrating to head: tricky case because already PageTeam */
-	if (newpage == head)
-		recovery->migrated_head = head;
 	return newpage;
 }
 
-static void shmem_put_recovery_page(struct page *newpage, unsigned long private)
+/*
+ * shmem_recovery_migrate_page() is called from the heart of page migration's
+ * migrate_page_move_mapping(): with interrupts disabled, mapping->tree_lock
+ * held, page's reference count frozen to 0, and no other reason to turn back.
+ */
+bool shmem_recovery_migrate_page(struct page *newpage, struct page *page)
 {
-	struct recovery *recovery = (struct recovery *)private;
+	struct page *head = newpage - (page->index & (HPAGE_PMD_NR-1));
+
+	if (!PageTeam(head))
+		return false;
+	if (newpage != head) {
+		/* Needs to be initialized before shmem_added_to_hugeteam() */
+		atomic_long_set(&newpage->team_usage, TEAM_LRU_WEIGHT_ONE);
+		SetPageTeam(newpage);
+		newpage->mapping = page->mapping;
+		newpage->index = page->index;
+	}
+	shmem_added_to_hugeteam(newpage, page_zone(newpage), NULL);
+	return true;
+}
 
-	/* Must reset migrated_head if in the end it was not used */
-	if (recovery->migrated_head == newpage)
-		recovery->migrated_head = NULL;
+static void shmem_put_recovery_page(struct page *newpage, unsigned long private)
+{
 	/* Decrement refcount again if newpage was not used */
 	put_page(newpage);
 }
@@ -1024,9 +1023,7 @@ static int shmem_recovery_populate(struc
 	struct zone *zone = page_zone(head);
 	pgoff_t index;
 	bool drained_all = false;
-	bool account_head = false;
-	int migratable;
-	int unmigratable;
+	int unmigratable = 0;
 	struct page *team;
 	struct page *endteam = head + HPAGE_PMD_NR;
 	struct page *page;
@@ -1039,12 +1036,9 @@ static int shmem_recovery_populate(struc
 
 	shmem_recovery_swapin(recovery, head);
 again:
-	migratable = 0;
-	unmigratable = 0;
 	index = recovery->head_index;
 	for (team = head; team < endteam && !error; index++, team++) {
-		if (PageTeam(team) && PageUptodate(team) && PageDirty(team) &&
-		    !account_head)
+		if (PageTeam(team) && PageUptodate(team) && PageDirty(team))
 			continue;
 
 		page = team;	/* used as hint if not yet instantiated */
@@ -1070,8 +1064,7 @@ again:
 			 */
 			if (page != team)
 				error = -ENOENT;
-			if (error || !account_head)
-				goto unlock;
+			goto unlock;
 		}
 
 		if (PageSwapBacked(team) && page != team) {
@@ -1098,8 +1091,6 @@ again:
 			SetPageTeam(head);
 			head->mapping = mapping;
 			head->index = index;
-			if (page == head)
-				account_head = true;
 		}
 
 		/* Eviction or truncation or hole-punch already disbanded? */
@@ -1132,12 +1123,9 @@ again:
 							TEAM_LRU_WEIGHT_ONE);
 					SetPageTeam(page);
 				}
-				if (page != head || account_head) {
-					shmem_added_to_hugeteam(page, zone,
-								NULL);
-					put_page(page);
-					shr_stats(page_teamed);
-				}
+				shmem_added_to_hugeteam(page, zone, NULL);
+				put_page(page);
+				shr_stats(page_teamed);
 			}
 			spin_unlock_irq(&mapping->tree_lock);
 			if (page_mapped(page)) {
@@ -1145,16 +1133,13 @@ again:
 				page_remove_rmap(page, false);
 				preempt_enable();
 			}
-			account_head = false;
 		} else {
-			VM_BUG_ON(account_head);
 			if (!PageLRU(page))
 				lru_add_drain();
 			if (isolate_lru_page(page) == 0) {
 				inc_zone_page_state(page, NR_ISOLATED_ANON);
 				list_add_tail(&page->lru, &migrate);
 				shr_stats(page_migrate);
-				migratable++;
 			} else {
 				shr_stats(page_off_lru);
 				unmigratable++;
@@ -1169,12 +1154,9 @@ unlock:
 	if (!list_empty(&migrate)) {
 		lru_add_drain(); /* not necessary but may help debugging */
 		if (!error) {
-			VM_BUG_ON(recovery->page != head);
-			recovery->migrated_head = NULL;
 			nr = migrate_pages(&migrate, shmem_get_recovery_page,
-				shmem_put_recovery_page, (unsigned long)
-				recovery, MIGRATE_SYNC, MR_SHMEM_RECOVERY);
-			account_head = !!recovery->migrated_head;
+				shmem_put_recovery_page, (unsigned long)head,
+				MIGRATE_SHMEM_RECOVERY, MR_SHMEM_RECOVERY);
 			if (nr < 0) {
 				/*
 				 * If migrate_pages() returned error (-ENOMEM)
@@ -1189,7 +1171,6 @@ unlock:
 			if (nr > 0) {
 				shr_stats_add(page_unmigrated, nr);
 				unmigratable += nr;
-				migratable -= nr;
 			}
 		}
 		putback_movable_pages(&migrate);
@@ -1208,10 +1189,6 @@ unlock:
 			shr_stats(recov_retried);
 			goto again;
 		}
-		if (migratable) {
-			/* Make another pass to SetPageTeam on them */
-			goto again;
-		}
 	}
 
 	lock_page(head);
@@ -2687,11 +2664,9 @@ static struct page *shmem_alloc_page(gfp
 			 * add_to_page_cache has the tree_lock.
 			 */
 			lock_page(page);
-			if (!PageSwapBacked(page) && PageTeam(head))
-				goto out;
-			unlock_page(page);
-			put_page(page);
-			*hugehint = SHMEM_ALLOC_SMALL_PAGE;
+			if (PageSwapBacked(page) || !PageTeam(head))
+				*hugehint = SHMEM_RETRY_HUGE_PAGE;
+			goto out;
 		}
 	}
 
@@ -2991,6 +2966,10 @@ repeat:
 			error = -ENOMEM;
 			goto decused;
 		}
+		if (hugehint == SHMEM_RETRY_HUGE_PAGE) {
+			error = -EEXIST;
+			goto decused;
+		}
 		if (sgp == SGP_WRITE)
 			__SetPageReferenced(page);
 memcg:
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

