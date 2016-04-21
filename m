From: akpm@linux-foundation.org
Subject: [to-be-updated]
 huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch removed from -mm tree
Date: Thu, 21 Apr 2016 13:46:42 -0700
Message-ID: <57193c32.6O0BuG9/OESHYAan%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcDUUqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 16:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: /proc/<pid>/smaps show ShmemHugePages
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: /proc/<pid>/smaps show ShmemHugePages

We have been relying on the AnonHugePages line of /proc/<pid>/smaps for
informal visibility of huge tmpfs mappings by a process.  It's been good
enough, but rather tacky, and best fixed before wider use.

Now reserve AnonHugePages for anonymous THP, and use ShmemHugePages for
huge tmpfs.  There is a good argument for calling it ShmemPmdMapped
instead (pte mappings of team pages won't be included in this count), and
I wouldn't mind changing to that; but smaps is all about the mapped, and I
think ShmemHugePages is more what people would expect to see here.

Add a team_page_mapcount() function to help get the PSS accounting right,
now that compound pages are accounting correctly for ptes inside pmds; but
nothing else needs that function, so keep it out of page_mapcount().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt  |   10 +++++---
 Documentation/filesystems/tmpfs.txt |    4 +++
 fs/proc/task_mmu.c                  |   28 ++++++++++++++++--------
 include/linux/pageteam.h            |   30 ++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 13 deletions(-)

diff -puN Documentation/filesystems/proc.txt~huge-tmpfs-proc-pid-smaps-show-shmemhugepages Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~huge-tmpfs-proc-pid-smaps-show-shmemhugepages
+++ a/Documentation/filesystems/proc.txt
@@ -435,6 +435,7 @@ Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
 AnonHugePages:         0 kB
+ShmemHugePages:        0 kB
 Shared_Hugetlb:        0 kB
 Private_Hugetlb:       0 kB
 Swap:                  0 kB
@@ -462,10 +463,11 @@ accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
-"AnonHugePages" shows the ammount of memory backed by transparent hugepage.
-"Shared_Hugetlb" and "Private_Hugetlb" show the ammounts of memory backed by
-hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
-reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
+"AnonHugePages" shows how much of Anonymous is in Transparent Huge Pages, and
+"ShmemHugePages" shows how much of Rss is from huge tmpfs pages mapped by pmd.
+"Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
+hugetlbfs pages: which are not counted in "Rss" or "Pss" fields for historical
+reasons; nor are they included in the {Shared,Private}_{Clean,Dirty} fields.
 "Swap" shows how much would-be-anonymous memory is also used, but out on swap.
 For shmem mappings, "Swap" includes also the size of the mapped (and not
 replaced by copy-on-write) part of the underlying shmem object out on swap.
diff -puN Documentation/filesystems/tmpfs.txt~huge-tmpfs-proc-pid-smaps-show-shmemhugepages Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~huge-tmpfs-proc-pid-smaps-show-shmemhugepages
+++ a/Documentation/filesystems/tmpfs.txt
@@ -186,6 +186,10 @@ In addition to 0 and 1, it also accepts
 automatically on for all tmpfs mounts (intended for testing), or -1
 to force huge off for all (intended for safety if bugs appeared).
 
+/proc/<pid>/smaps shows:
+
+ShmemHugePages:    10240 kB   tmpfs hugepages mapped by pmd into this region
+
 /proc/meminfo, /sys/devices/system/node/nodeN/meminfo show:
 
 Shmem:             35016 kB   total shmem/tmpfs memory (subset of Cached)
diff -puN fs/proc/task_mmu.c~huge-tmpfs-proc-pid-smaps-show-shmemhugepages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~huge-tmpfs-proc-pid-smaps-show-shmemhugepages
+++ a/fs/proc/task_mmu.c
@@ -14,6 +14,7 @@
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
+#include <linux/pageteam.h>
 #include <linux/shmem_fs.h>
 
 #include <asm/elf.h>
@@ -448,6 +449,7 @@ struct mem_size_stats {
 	unsigned long referenced;
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
+	unsigned long shmem_huge;
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
@@ -457,13 +459,19 @@ struct mem_size_stats {
 };
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty)
+		unsigned long size, bool young, bool dirty)
 {
-	int i, nr = compound ? 1 << compound_order(page) : 1;
-	unsigned long size = nr * PAGE_SIZE;
+	int nr = size / PAGE_SIZE;
+	int i;
 
-	if (PageAnon(page))
+	if (PageAnon(page)) {
 		mss->anonymous += size;
+		if (size > PAGE_SIZE)
+			mss->anonymous_thp += size;
+	} else {
+		if (size > PAGE_SIZE)
+			mss->shmem_huge += size;
+	}
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
@@ -473,7 +481,7 @@ static void smaps_account(struct mem_siz
 	/*
 	 * page_count(page) == 1 guarantees the page is mapped exactly once.
 	 * If any subpage of the compound page mapped with PTE it would elevate
-	 * page_count().
+	 * page_count().  (This condition is never true of mapped pagecache.)
 	 */
 	if (page_count(page) == 1) {
 		if (dirty || PageDirty(page))
@@ -485,7 +493,7 @@ static void smaps_account(struct mem_siz
 	}
 
 	for (i = 0; i < nr; i++, page++) {
-		int mapcount = page_mapcount(page);
+		int mapcount = team_page_mapcount(page);
 
 		if (mapcount >= 2) {
 			if (dirty || PageDirty(page))
@@ -561,7 +569,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte));
+	smaps_account(mss, page, PAGE_SIZE, pte_young(*pte), pte_dirty(*pte));
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -576,8 +584,8 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
 	if (IS_ERR_OR_NULL(page))
 		return;
-	mss->anonymous_thp += HPAGE_PMD_SIZE;
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
+	smaps_account(mss, page, HPAGE_PMD_SIZE,
+			pmd_young(*pmd), pmd_dirty(*pmd));
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -770,6 +778,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
+		   "ShmemHugePages: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
 		   "Private_Hugetlb: %7lu kB\n"
 		   "Swap:           %8lu kB\n"
@@ -787,6 +796,7 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
 		   mss.anonymous_thp >> 10,
+		   mss.shmem_huge >> 10,
 		   mss.shared_hugetlb >> 10,
 		   mss.private_hugetlb >> 10,
 		   mss.swap >> 10,
diff -puN include/linux/pageteam.h~huge-tmpfs-proc-pid-smaps-show-shmemhugepages include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-proc-pid-smaps-show-shmemhugepages
+++ a/include/linux/pageteam.h
@@ -152,6 +152,36 @@ static inline void count_team_pmd_mapped
 }
 
 /*
+ * Slightly misnamed, team_page_mapcount() returns the number of times
+ * any page is mapped into userspace, either by pte or covered by pmd:
+ * it is a generalization of page_mapcount() to include the case of a
+ * team page.  We don't complicate page_mapcount() itself in this way,
+ * because almost nothing needs this number: only smaps accounting PSS.
+ * If something else wants it, we might have to worry more about races.
+ */
+static inline int team_page_mapcount(struct page *page)
+{
+	struct page *head;
+	long team_usage;
+	int mapcount;
+
+	mapcount = page_mapcount(page);
+	if (!PageTeam(page))
+		return mapcount;
+	head = team_head(page);
+	/* We always page_add_file_rmap to head when we page_add_team_rmap */
+	if (page == head)
+		return mapcount;
+
+	team_usage = atomic_long_read(&head->team_usage) - TEAM_COMPLETE;
+	/* Beware racing shmem_disband_hugehead() and add_to_swap_cache() */
+	smp_rmb();
+	if (PageTeam(head) && team_usage > 0)
+		mapcount += team_usage / TEAM_MAPPING_COUNTER;
+	return mapcount;
+}
+
+/*
  * Returns true if this pte mapping is of a non-team page, or of a team page not
  * covered by an existing huge pmd mapping: whereupon stats need to be updated.
  * Only called when mapcount goes up from 0 to 1 i.e. _mapcount from -1 to 0.
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
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch

