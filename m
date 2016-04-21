From: akpm@linux-foundation.org
Subject: [to-be-updated] huge-tmpfs-avoid-team-pages-in-a-few-places.patch removed from -mm tree
Date: Thu, 21 Apr 2016 13:45:47 -0700
Message-ID: <57193bfb.EFW2b3CJR5/RQAHX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbcDUUps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: avoid team pages in a few places
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-avoid-team-pages-in-a-few-places.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: avoid team pages in a few places

A few functions outside of mm/shmem.c must take care not to damage a
team accidentally.  In particular, although huge tmpfs will make its
own use of page migration, we don't want compaction or other users
of page migration to stomp on teams by mistake: backstop checks in
migrate_page_move_mapping() and unmap_and_move() secure most cases,
and an earlier check in isolate_migratepages_block() saves compaction
from wasting time.

These checks are certainly too strong: we shall want NUMA mempolicy
and balancing, and memory hot-remove, and soft-offline of failing
memory, to work with team pages; but defer those to a later series.

Also send PageTeam the slow route, along with PageTransHuge, in
munlock_vma_pages_range(): because __munlock_pagevec_fill() uses
get_locked_pte(), which expects ptes not a huge pmd; and we don't
want to split up a pmd to munlock it.  This avoids a VM_BUG_ON, or
hang on the non-existent ptlock; but there's much more to do later,
to get mlock+munlock working properly.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++++
 mm/memcontrol.c |    4 ++--
 mm/migrate.c    |   15 ++++++++++++++-
 mm/mlock.c      |    2 +-
 mm/truncate.c   |    2 +-
 mm/vmscan.c     |    2 ++
 6 files changed, 25 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/compaction.c
--- a/mm/compaction.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/compaction.c
@@ -735,6 +735,11 @@ isolate_migratepages_block(struct compac
 			continue;
 		}
 
+		if (PageTeam(page)) {
+			low_pfn = round_up(low_pfn + 1, HPAGE_PMD_NR) - 1;
+			continue;
+		}
+
 		/*
 		 * Check may be lockless but that's ok as we recheck later.
 		 * It's possible to migrate LRU pages and balloon pages
diff -puN mm/memcontrol.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/memcontrol.c
--- a/mm/memcontrol.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/memcontrol.c
@@ -4563,8 +4563,8 @@ static enum mc_target_type get_mctgt_typ
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	page = pmd_page(pmd);
-	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
-	if (!(mc.flags & MOVE_ANON))
+	/* Don't attempt to move huge tmpfs pages yet: can be enabled later */
+	if (!(mc.flags & MOVE_ANON) || !PageAnon(page))
 		return ret;
 	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
diff -puN mm/migrate.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/migrate.c
--- a/mm/migrate.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/migrate.c
@@ -346,7 +346,7 @@ int migrate_page_move_mapping(struct add
  					page_index(page));
 
 	expected_count += 1 + page_has_private(page);
-	if (page_count(page) != expected_count ||
+	if (page_count(page) != expected_count || PageTeam(page) ||
 		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
@@ -944,6 +944,11 @@ static ICE_noinline int unmap_and_move(n
 	if (!newpage)
 		return -ENOMEM;
 
+	if (PageTeam(page)) {
+		rc = -EBUSY;
+		goto out;
+	}
+
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
 		goto out;
@@ -1763,6 +1768,14 @@ int migrate_misplaced_transhuge_page(str
 	pmd_t orig_entry;
 
 	/*
+	 * Leave support for NUMA balancing on huge tmpfs pages to the future.
+	 * The pmd marking up to this point should work okay, but from here on
+	 * there is work to be done: e.g. anon page->mapping assumption below.
+	 */
+	if (!PageAnon(page))
+		goto out_dropref;
+
+	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
diff -puN mm/mlock.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/mlock.c
--- a/mm/mlock.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/mlock.c
@@ -459,7 +459,7 @@ void munlock_vma_pages_range(struct vm_a
 			if (PageTransTail(page)) {
 				VM_BUG_ON_PAGE(PageMlocked(page), page);
 				put_page(page); /* follow_page_mask() */
-			} else if (PageTransHuge(page)) {
+			} else if (PageTransHuge(page) || PageTeam(page)) {
 				lock_page(page);
 				/*
 				 * Any THP page found by follow_page_mask() may
diff -puN mm/truncate.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/truncate.c
--- a/mm/truncate.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/truncate.c
@@ -528,7 +528,7 @@ invalidate_complete_page2(struct address
 		return 0;
 
 	spin_lock_irqsave(&mapping->tree_lock, flags);
-	if (PageDirty(page))
+	if (PageDirty(page) || PageTeam(page))
 		goto failed;
 
 	BUG_ON(page_has_private(page));
diff -puN mm/vmscan.c~huge-tmpfs-avoid-team-pages-in-a-few-places mm/vmscan.c
--- a/mm/vmscan.c~huge-tmpfs-avoid-team-pages-in-a-few-places
+++ a/mm/vmscan.c
@@ -638,6 +638,8 @@ static int __remove_mapping(struct addre
 	 * Note that if SetPageDirty is always performed via set_page_dirty,
 	 * and thus under tree_lock, then this ordering is not required.
 	 */
+	if (unlikely(PageTeam(page)))
+		goto cannot_free;
 	if (!page_ref_freeze(page, 2))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
_

Patches currently in -mm which might be from hughd@google.com are

huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
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

