From: akpm@linux-foundation.org
Subject: + huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:06 -0700
Message-ID: <57044736.76fNl9qRlTWJfQ59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbcDEXQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: fix Mapped meminfo, track huge & unhuge mappings
has been added to the -mm tree.  Its filename is
     huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch

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
Subject: huge tmpfs: fix Mapped meminfo, track huge & unhuge mappings

Maintaining Mlocked was the difficult one, but now that it is correctly
tracked, without duplication between the 4kB and 2MB amounts, I think we
have to make a similar effort with Mapped.

But whereas mlock and munlock were already rare and slow operations, to
which we could fairly add a little more overhead in the huge tmpfs case,
ordinary mmap is not something we want to slow down further, relative to
hugetlbfs.

In the Mapped case, I think we can take small or misaligned mmaps of huge
tmpfs files as the exceptional operation, and add a little more overhead
to those, by maintaining another count for them in the head; and by
keeping both hugely and unhugely mapped counts in the one long, can rely
on cmpxchg to manage their racing transitions atomically.

That's good on 64-bit, but there are not enough free bits in a 32-bit
atomic_long_t team_usage to support this: I think we should continue to
permit huge tmpfs on 32-bit, but accept that Mapped may be doubly counted
there.  (A more serious problem on 32-bit is that it would, I think, be
possible to overflow the huge mapping counter: protection against that
will need to be added.)

Now that we are maintaining NR_FILE_MAPPED correctly for huge tmpfs,
adjust vmscan's zone_unmapped_file_pages() to exclude NR_SHMEM_PMDMAPPED,
which it clearly would not want included.  Whereas minimum_image_size() in
kernel/power/snapshot.c?  I have not grasped the basis for that
calculation, so leaving untouched.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +
 include/linux/pageteam.h   |  144 ++++++++++++++++++++++++++++++++---
 mm/huge_memory.c           |   34 +++++++-
 mm/rmap.c                  |   10 +-
 mm/vmscan.c                |    6 +
 5 files changed, 180 insertions(+), 19 deletions(-)

diff -puN include/linux/memcontrol.h~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings
+++ a/include/linux/memcontrol.h
@@ -675,6 +675,11 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
+static inline void mem_cgroup_update_page_stat(struct page *page,
+				enum mem_cgroup_stat_index idx, int val)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff -puN include/linux/pageteam.h~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings
+++ a/include/linux/pageteam.h
@@ -30,6 +30,30 @@ static inline struct page *team_head(str
 }
 
 /*
+ * Layout of team head's page->team_usage field, as on x86_64 and arm64_4K:
+ *
+ *  63        32 31          22 21      12     11         10    9          0
+ * +------------+--------------+----------+----------+---------+------------+
+ * | pmd_mapped & instantiated |pte_mapped| reserved | mlocked | lru_weight |
+ * |   42 bits       10 bits   |  10 bits |  1 bit   |  1 bit  |   10 bits  |
+ * +------------+--------------+----------+----------+---------+------------+
+ *
+ * TEAM_LRU_WEIGHT_ONE               1  (1<<0)
+ * TEAM_LRU_WEIGHT_MASK            3ff  (1<<10)-1
+ * TEAM_PMD_MLOCKED                400  (1<<10)
+ * TEAM_RESERVED_FLAG              800  (1<<11)
+ * TEAM_PTE_COUNTER               1000  (1<<12)
+ * TEAM_PTE_MASK                3ff000  (1<<22)-(1<<12)
+ * TEAM_PAGE_COUNTER            400000  (1<<22)
+ * TEAM_COMPLETE              80000000  (1<<31)
+ * TEAM_MAPPING_COUNTER         400000  (1<<22)
+ * TEAM_PMD_MAPPED            80400000  (1<<31)
+ *
+ * The upper bits count up to TEAM_COMPLETE as pages are instantiated,
+ * and then, above TEAM_COMPLETE, they count huge mappings of the team.
+ * Team tails have team_usage either 1 (lru_weight 1) or 0 (lru_weight 0).
+ */
+/*
  * Mask for lower bits of team_usage, giving the weight 0..HPAGE_PMD_NR of the
  * page on its LRU: normal pages have weight 1, tails held unevictable until
  * head is evicted have weight 0, and the head gathers weight 1..HPAGE_PMD_NR.
@@ -42,8 +66,22 @@ static inline struct page *team_head(str
  */
 #define TEAM_PMD_MLOCKED	(1L << (HPAGE_PMD_ORDER + 1))
 #define TEAM_RESERVED_FLAG	(1L << (HPAGE_PMD_ORDER + 2))
-
+#ifdef CONFIG_64BIT
+/*
+ * Count how many pages of team are individually mapped into userspace.
+ */
+#define TEAM_PTE_COUNTER	(1L << (HPAGE_PMD_ORDER + 3))
+#define TEAM_HIGH_COUNTER	(1L << (2*HPAGE_PMD_ORDER + 4))
+#define TEAM_PTE_MASK		(TEAM_HIGH_COUNTER - TEAM_PTE_COUNTER)
+#define team_pte_count(usage)	(((usage) & TEAM_PTE_MASK) / TEAM_PTE_COUNTER)
+#else /* 32-bit */
+/*
+ * Not enough bits in atomic_long_t: we prefer not to bloat struct page just to
+ * avoid duplication in Mapped, when a page is mapped both hugely and unhugely.
+ */
 #define TEAM_HIGH_COUNTER	(1L << (HPAGE_PMD_ORDER + 3))
+#define team_pte_count(usage)	1 /* allows for the extra page_add_file_rmap */
+#endif /* CONFIG_64BIT */
 /*
  * Count how many pages of team are instantiated, as it is built up.
  */
@@ -66,22 +104,110 @@ static inline bool team_pmd_mapped(struc
 
 /*
  * Returns true if this was the first mapping by pmd, whereupon mapped stats
- * need to be updated.
+ * need to be updated.  Together with the number of pages which then need
+ * to be accounted (can be ignored when false returned): because some team
+ * members may have been mapped unhugely by pte, so already counted as Mapped.
  */
-static inline bool inc_team_pmd_mapped(struct page *head)
+static inline bool inc_team_pmd_mapped(struct page *head, int *nr_pages)
 {
-	return atomic_long_add_return(TEAM_MAPPING_COUNTER, &head->team_usage)
-		< TEAM_PMD_MAPPED + TEAM_MAPPING_COUNTER;
+	long team_usage;
+
+	team_usage = atomic_long_add_return(TEAM_MAPPING_COUNTER,
+					    &head->team_usage);
+	*nr_pages = HPAGE_PMD_NR - team_pte_count(team_usage);
+	return team_usage < TEAM_PMD_MAPPED + TEAM_MAPPING_COUNTER;
 }
 
 /*
  * Returns true if this was the last mapping by pmd, whereupon mapped stats
- * need to be updated.
+ * need to be updated.  Together with the number of pages which then need
+ * to be accounted (can be ignored when false returned): because some team
+ * members may still be mapped unhugely by pte, so remain counted as Mapped.
+ */
+static inline bool dec_team_pmd_mapped(struct page *head, int *nr_pages)
+{
+	long team_usage;
+
+	team_usage = atomic_long_sub_return(TEAM_MAPPING_COUNTER,
+					    &head->team_usage);
+	*nr_pages = HPAGE_PMD_NR - team_pte_count(team_usage);
+	return team_usage < TEAM_PMD_MAPPED;
+}
+
+/*
+ * Returns true if this pte mapping is of a non-team page, or of a team page not
+ * covered by an existing huge pmd mapping: whereupon stats need to be updated.
+ * Only called when mapcount goes up from 0 to 1 i.e. _mapcount from -1 to 0.
+ */
+static inline bool inc_team_pte_mapped(struct page *page)
+{
+#ifdef CONFIG_64BIT
+	struct page *head;
+	long team_usage;
+	long old;
+
+	if (likely(!PageTeam(page)))
+		return true;
+	head = team_head(page);
+	team_usage = atomic_long_read(&head->team_usage);
+	for (;;) {
+		/* Is team now being disbanded? Stop once team_usage is reset */
+		if (unlikely(!PageTeam(head) ||
+			     team_usage / TEAM_PAGE_COUNTER == 0))
+			return true;
+		/*
+		 * XXX: but despite the impressive-looking cmpxchg, gthelen
+		 * points out that head might be freed and reused and assigned
+		 * a matching value in ->private now: tiny chance, must revisit.
+		 */
+		old = atomic_long_cmpxchg(&head->team_usage,
+			team_usage, team_usage + TEAM_PTE_COUNTER);
+		if (likely(old == team_usage))
+			break;
+		team_usage = old;
+	}
+	return team_usage < TEAM_PMD_MAPPED;
+#else /* 32-bit */
+	return true;
+#endif
+}
+
+/*
+ * Returns true if this pte mapping is of a non-team page, or of a team page not
+ * covered by a remaining huge pmd mapping: whereupon stats need to be updated.
+ * Only called when mapcount goes down from 1 to 0 i.e. _mapcount from 0 to -1.
  */
-static inline bool dec_team_pmd_mapped(struct page *head)
+static inline bool dec_team_pte_mapped(struct page *page)
 {
-	return atomic_long_sub_return(TEAM_MAPPING_COUNTER, &head->team_usage)
-		< TEAM_PMD_MAPPED;
+#ifdef CONFIG_64BIT
+	struct page *head;
+	long team_usage;
+	long old;
+
+	if (likely(!PageTeam(page)))
+		return true;
+	head = team_head(page);
+	team_usage = atomic_long_read(&head->team_usage);
+	for (;;) {
+		/* Is team now being disbanded? Stop once team_usage is reset */
+		if (unlikely(!PageTeam(head) ||
+			     team_usage / TEAM_PAGE_COUNTER == 0))
+			return true;
+		/*
+		 * XXX: but despite the impressive-looking cmpxchg, gthelen
+		 * points out that head might be freed and reused and assigned
+		 * a matching value in ->private now: tiny chance, must revisit.
+		 */
+		old = atomic_long_cmpxchg(&head->team_usage,
+			team_usage, team_usage - TEAM_PTE_COUNTER);
+		if (likely(old == team_usage))
+			break;
+		team_usage = old;
+	}
+	return team_usage < TEAM_PMD_MAPPED;
+#else /* 32-bit */
+	return true;
+#endif
 }
 
 static inline void inc_lru_weight(struct page *head)
diff -puN mm/huge_memory.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings
+++ a/mm/huge_memory.c
@@ -1130,9 +1130,11 @@ int copy_huge_pmd(struct mm_struct *dst_
 			pmdp_set_wrprotect(src_mm, addr, src_pmd);
 			pmd = pmd_wrprotect(pmd);
 		} else {
+			int nr_pages;	/* not interesting here */
+
 			VM_BUG_ON_PAGE(!PageTeam(src_page), src_page);
 			page_dup_rmap(src_page, false);
-			inc_team_pmd_mapped(src_page);
+			inc_team_pmd_mapped(src_page, &nr_pages);
 		}
 		add_mm_counter(dst_mm, mm_counter(src_page), HPAGE_PMD_NR);
 		atomic_long_inc(&dst_mm->nr_ptes);
@@ -3497,18 +3499,40 @@ late_initcall(split_huge_pages_debugfs);
 
 static void page_add_team_rmap(struct page *page)
 {
+	int nr_pages;
+
 	VM_BUG_ON_PAGE(PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageTeam(page), page);
-	if (inc_team_pmd_mapped(page))
-		__inc_zone_page_state(page, NR_SHMEM_PMDMAPPED);
+
+	lock_page_memcg(page);
+	if (inc_team_pmd_mapped(page, &nr_pages)) {
+		struct zone *zone = page_zone(page);
+
+		__inc_zone_state(zone, NR_SHMEM_PMDMAPPED);
+		__mod_zone_page_state(zone, NR_FILE_MAPPED, nr_pages);
+		mem_cgroup_update_page_stat(page,
+				MEM_CGROUP_STAT_FILE_MAPPED, nr_pages);
+	}
+	unlock_page_memcg(page);
 }
 
 static void page_remove_team_rmap(struct page *page)
 {
+	int nr_pages;
+
 	VM_BUG_ON_PAGE(PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageTeam(page), page);
-	if (dec_team_pmd_mapped(page))
-		__dec_zone_page_state(page, NR_SHMEM_PMDMAPPED);
+
+	lock_page_memcg(page);
+	if (dec_team_pmd_mapped(page, &nr_pages)) {
+		struct zone *zone = page_zone(page);
+
+		__dec_zone_state(zone, NR_SHMEM_PMDMAPPED);
+		__mod_zone_page_state(zone, NR_FILE_MAPPED, -nr_pages);
+		mem_cgroup_update_page_stat(page,
+				MEM_CGROUP_STAT_FILE_MAPPED, -nr_pages);
+	}
+	unlock_page_memcg(page);
 }
 
 int map_team_by_pmd(struct vm_area_struct *vma, unsigned long addr,
diff -puN mm/rmap.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings mm/rmap.c
--- a/mm/rmap.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings
+++ a/mm/rmap.c
@@ -1272,7 +1272,8 @@ void page_add_new_anon_rmap(struct page
 void page_add_file_rmap(struct page *page)
 {
 	lock_page_memcg(page);
-	if (atomic_inc_and_test(&page->_mapcount)) {
+	if (atomic_inc_and_test(&page->_mapcount) &&
+	    inc_team_pte_mapped(page)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
@@ -1299,9 +1300,10 @@ static void page_remove_file_rmap(struct
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__dec_zone_page_state(page, NR_FILE_MAPPED);
-	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
-
+	if (dec_team_pte_mapped(page)) {
+		__dec_zone_page_state(page, NR_FILE_MAPPED);
+		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	}
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
diff -puN mm/vmscan.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings mm/vmscan.c
--- a/mm/vmscan.c~huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings
+++ a/mm/vmscan.c
@@ -3665,8 +3665,12 @@ static inline unsigned long zone_unmappe
 	/*
 	 * It's possible for there to be more file mapped pages than
 	 * accounted for by the pages on the file LRU lists because
-	 * tmpfs pages accounted for as ANON can also be FILE_MAPPED
+	 * tmpfs pages accounted for as ANON can also be FILE_MAPPED.
+	 * We don't know how many, beyond the PMDMAPPED excluded below.
 	 */
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		file_mapped -= zone_page_state(zone, NR_SHMEM_PMDMAPPED) <<
+							HPAGE_PMD_ORDER;
 	return (file_lru > file_mapped) ? (file_lru - file_mapped) : 0;
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

