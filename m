From: akpm@linux-foundation.org
Subject: + huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:33 -0700
Message-ID: <57044751.B9sqAPxRVyQZWaNR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbcDEXQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: tweak shmem_getpage_gfp to fill team
has been added to the -mm tree.  Its filename is
     huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch

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
Subject: huge tmpfs recovery: tweak shmem_getpage_gfp to fill team

shmem_recovery_swapin() took the trouble to arrange for pages to be
swapped in to their final destinations without needing page migration. 
It's daft not to do the same for pages being newly instantiated (when a
huge page has been allocated after transient fragmentation, too late to
satisfy the initial fault).

Let SGP_TEAM convey the intended destination down to shmem_getpage_gfp(). 
And make sure that SGP_TEAM cannot instantiate pages beyond the last huge
page: although shmem_recovery_populate() has a PageTeam check against
truncation, that's insufficient, and only shmem_getpage_gfp() knows what
adjustments to make when we have allocated too far.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   56 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team
+++ a/mm/shmem.c
@@ -464,6 +464,7 @@ static int shmem_populate_hugeteam(struc
 		/* Mark all pages dirty even when map is readonly, for now */
 		if (PageUptodate(head + i) && PageDirty(head + i))
 			continue;
+		page = NULL;
 		error = shmem_getpage_gfp(inode, index, &page, SGP_TEAM,
 					  gfp, vma->vm_mm, NULL);
 		if (error)
@@ -965,6 +966,7 @@ again:
 		    !account_head)
 			continue;
 
+		page = team;	/* used as hint if not yet instantiated */
 		error = shmem_getpage_gfp(recovery->inode, index, &page,
 					  SGP_TEAM, gfp, recovery->mm, NULL);
 		if (error)
@@ -2708,6 +2710,7 @@ static int shmem_replace_page(struct pag
 
 /*
  * shmem_getpage_gfp - find page in cache, or get from swap, or allocate
+ *                     (or use page indicated by shmem_recovery_populate)
  *
  * If we allocate a new one we do not mark it dirty. That's up to the
  * vm. If we swap it in we mark it dirty since we also free the swap
@@ -2727,14 +2730,20 @@ static int shmem_getpage_gfp(struct inod
 	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
+	loff_t offset;
 	int error;
 	int once = 0;
-	int alloced = 0;
+	bool alloced = false;
+	bool exposed_swapbacked = false;
 	struct page *hugehint;
 	struct page *alloced_huge = NULL;
 
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
+
+	offset = (loff_t)index << PAGE_SHIFT;
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && sgp == SGP_TEAM)
+		offset &= ~((loff_t)HPAGE_PMD_SIZE-1);
 repeat:
 	swap.val = 0;
 	page = find_lock_entry(mapping, index);
@@ -2743,8 +2752,7 @@ repeat:
 		page = NULL;
 	}
 
-	if (sgp <= SGP_CACHE &&
-	    ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
+	if (sgp <= SGP_TEAM && offset >= i_size_read(inode)) {
 		error = -EINVAL;
 		goto unlock;
 	}
@@ -2863,8 +2871,34 @@ repeat:
 			percpu_counter_inc(&sbinfo->used_blocks);
 		}
 
-		/* Take huge hint from super, except for shmem_symlink() */
 		hugehint = NULL;
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    sgp == SGP_TEAM && *pagep) {
+			struct page *head;
+
+			if (!get_page_unless_zero(*pagep)) {
+				error = -ENOENT;
+				goto decused;
+			}
+			page = *pagep;
+			lock_page(page);
+			head = page - (index & (HPAGE_PMD_NR-1));
+			if (!PageTeam(head)) {
+				error = -ENOENT;
+				goto decused;
+			}
+			if (PageSwapBacked(page)) {
+				shr_stats(page_raced);
+				/* maybe already created; or swapin truncated */
+				error = page->mapping ? -EEXIST : -ENOENT;
+				goto decused;
+			}
+			SetPageSwapBacked(page);
+			exposed_swapbacked = true;
+			goto memcg;
+		}
+
+		/* Take huge hint from super, except for shmem_symlink() */
 		if (mapping->a_ops == &shmem_aops &&
 		    (shmem_huge == SHMEM_HUGE_FORCE ||
 		     (sbinfo->huge && shmem_huge != SHMEM_HUGE_DENY)))
@@ -2878,7 +2912,7 @@ repeat:
 		}
 		if (sgp == SGP_WRITE)
 			__SetPageReferenced(page);
-
+memcg:
 		error = mem_cgroup_try_charge(page, charge_mm, gfp, &memcg,
 				false);
 		if (error)
@@ -2894,6 +2928,11 @@ repeat:
 			goto decused;
 		}
 		mem_cgroup_commit_charge(page, memcg, false, false);
+		if (exposed_swapbacked) {
+			shr_stats(page_created);
+			/* cannot clear swapbacked once sent to lru */
+			exposed_swapbacked = false;
+		}
 		lru_cache_add_anon(page);
 
 		spin_lock(&info->lock);
@@ -2937,8 +2976,7 @@ clear:
 	}
 
 	/* Perhaps the file has been truncated since we checked */
-	if (sgp <= SGP_CACHE &&
-	    ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
+	if (sgp <= SGP_TEAM && offset >= i_size_read(inode)) {
 		if (alloced && !PageTeam(page)) {
 			ClearPageDirty(page);
 			delete_from_page_cache(page);
@@ -2966,6 +3004,10 @@ failed:
 		error = -EEXIST;
 unlock:
 	if (page) {
+		if (exposed_swapbacked) {
+			ClearPageSwapBacked(page);
+			exposed_swapbacked = false;
+		}
 		unlock_page(page);
 		put_page(page);
 	}
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

