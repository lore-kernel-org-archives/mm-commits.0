From: akpm@linux-foundation.org
Subject: + huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:15:31 -0700
Message-ID: <57044713.3n/g8qh2j1sSBDCM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcDEXPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: prepare counts in meminfo, vmstat and SysRq-m
has been added to the -mm tree.  Its filename is
     huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch

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
Subject: huge tmpfs: prepare counts in meminfo, vmstat and SysRq-m

Here is my "huge tmpfs" implementation of Transparent Huge Pagecache,
rebased to v4.6-rc2 plus the "mm: easy preliminaries to THPagecache"
series.

The design is just the same as before, when I posted against v3.19: using
a team of pagecache pages placed within a huge-order extent, instead of
using a compound page (see 04/31 for more info on that).

Patches 01-17 are much as before, but with whatever changes were needed
for the rebase, and bugfixes folded back in.  Patches 18-22 add memcg and
smaps visibility.  But the more important ones are patches 23-29, which
add recovery: reassembling a hugepage after fragmentation or swapping. 
Patches 30-31 reflect gfpmask doubts: you might prefer that I fold 31 back
in and keep 30 internal.

It was lack of recovery which stopped me from proposing inclusion of the
series a year ago: this series now is fully featured, and ready for v4.7 -
but I expect we shall want to wait a release to give time to consider the
alternatives.

I currently believe that the same functionality (including the team
implementation's support for small files, standard mlocking, and recovery)
can be achieved with compound pages, but not easily: I think the huge
tmpfs functionality should be made available soon, then converted at
leisure to compound pages, if that works out (but it's not a job I want to
do - what we have here is good enough).

Huge tmpfs has been in use within Google for about a year: it's been a
success, and gaining ever wider adoption.  Several TODOs have not yet been
toDONE, because they just haven't surfaced as real-life issues yet: that
includes NUMA migration, which is at the top of my list, but so far we've
done well enough without it.



This patch (of 31):

Abbreviate NR_ANON_TRANSPARENT_HUGEPAGES to NR_ANON_HUGEPAGES,
add NR_SHMEM_HUGEPAGES, NR_SHMEM_PMDMAPPED, NR_SHMEM_FREEHOLES:
to be accounted in later commits, when we shall need some visibility.

Shown in /proc/meminfo and /sys/devices/system/node/nodeN/meminfo
as AnonHugePages (as before), ShmemHugePages, ShmemPmdMapped,
ShmemFreeHoles; /proc/vmstat and /sys/devices/system/node/nodeN/vmstat
as nr_anon_transparent_hugepages (as before), nr_shmem_hugepages,
nr_shmem_pmdmapped, nr_shmem_freeholes.

Be upfront about this being Shmem, neither file nor anon: Shmem
is sometimes counted as file (as in Cached) and sometimes as anon
(as in Active(anon)); which is too confusing.  Shmem is already
shown in meminfo, so use that term, rather than tmpfs or shm.

ShmemHugePages will show that portion of Shmem which is allocated
on complete huge pages.  ShmemPmdMapped (named not to misalign the
%8lu) will show that portion of ShmemHugePages which is mapped into
userspace with huge pmds.  ShmemFreeHoles will show the wastage
from using huge pages for small, or sparsely occupied, or unrounded
files: wastage not included in Shmem or MemFree, but will be freed
under memory pressure.  (But no count for the partially occupied
portions of huge pages: seems less important, but could be added.)

Since shmem_freeholes are otherwise hidden, they ought to be shown by
show_free_areas(), in OOM-kill or ALT-SysRq-m or /proc/sysrq-trigger m.
shmem_hugepages is a subset of shmem, and shmem_pmdmapped a subset of
shmem_hugepages: there is not a strong argument for adding them here
(anon_hugepages is not shown), but include them anyway for reassurance.
Note that shmem_hugepages (and _pmdmapped and _freeholes) page counts
are shown in smallpage units, like other fields: not in hugepage units.

The lines get rather long: abbreviate thus
  mapped:19778 shmem:38 pagetables:1153 bounce:0
  shmem_hugepages:0 _pmdmapped:0 _freeholes:2044
  free:3261805 free_pcp:9444 free_cma:0
and
... shmem:92kB _hugepages:0kB _pmdmapped:0kB _freeholes:0kB ...

Tidy up the CONFIG_TRANSPARENT_HUGEPAGE printf blocks in
fs/proc/meminfo.c and drivers/base/node.c: the shorter names help.
Clarify a comment in page_remove_rmap() to refer to "hugetlbfs pages"
rather than hugepages generally.  I left arch/tile/mm/pgtable.c's
show_mem() unchanged: tile does not HAVE_ARCH_TRANSPARENT_HUGEPAGE.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   10 ++++++++--
 drivers/base/node.c                |   20 +++++++++++---------
 fs/proc/meminfo.c                  |   11 ++++++++---
 include/linux/mmzone.h             |    5 ++++-
 mm/huge_memory.c                   |    2 +-
 mm/page_alloc.c                    |   17 +++++++++++++++++
 mm/rmap.c                          |   14 ++++++--------
 mm/vmstat.c                        |    3 +++
 8 files changed, 58 insertions(+), 24 deletions(-)

diff -puN Documentation/filesystems/proc.txt~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/Documentation/filesystems/proc.txt
@@ -853,7 +853,7 @@ Dirty:             968 kB
 Writeback:           0 kB
 AnonPages:      861800 kB
 Mapped:         280372 kB
-Shmem:             644 kB
+Shmem:           26396 kB
 Slab:           284364 kB
 SReclaimable:   159856 kB
 SUnreclaim:     124508 kB
@@ -867,6 +867,9 @@ VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
 AnonHugePages:   49152 kB
+ShmemHugePages:  20480 kB
+ShmemPmdMapped:  12288 kB
+ShmemFreeHoles:      0 kB
 
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
@@ -908,7 +911,6 @@ MemAvailable: An estimate of how much me
        Dirty: Memory which is waiting to get written back to the disk
    Writeback: Memory which is actively being written back to the disk
    AnonPages: Non-file backed pages mapped into userspace page tables
-AnonHugePages: Non-file backed huge pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
        Shmem: Total memory used by shared memory (shmem) and tmpfs
         Slab: in-kernel data structures cache
@@ -949,6 +951,10 @@ Committed_AS: The amount of memory prese
 VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contiguous block of vmalloc area which is free
+ AnonHugePages: Non-file backed huge pages mapped into userspace page tables
+ShmemHugePages: tmpfs-file backed huge pages completed (subset of Shmem)
+ShmemPmdMapped: tmpfs-file backed huge pages with huge mappings into userspace
+ShmemFreeHoles: Space reserved for tmpfs team pages but available to shrinker
 
 ..............................................................................
 
diff -puN drivers/base/node.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m drivers/base/node.c
--- a/drivers/base/node.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/drivers/base/node.c
@@ -111,9 +111,6 @@ static ssize_t node_read_meminfo(struct
 		       "Node %d Slab:           %8lu kB\n"
 		       "Node %d SReclaimable:   %8lu kB\n"
 		       "Node %d SUnreclaim:     %8lu kB\n"
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       "Node %d AnonHugePages:  %8lu kB\n"
-#endif
 			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
@@ -130,13 +127,18 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
-			, nid,
-			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR));
-#else
 		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	n += sprintf(buf + n,
+		"Node %d AnonHugePages:  %8lu kB\n"
+		"Node %d ShmemHugePages: %8lu kB\n"
+		"Node %d ShmemPmdMapped: %8lu kB\n"
+		"Node %d ShmemFreeHoles: %8lu kB\n",
+		nid, K(node_page_state(nid, NR_ANON_HUGEPAGES)*HPAGE_PMD_NR),
+		nid, K(node_page_state(nid, NR_SHMEM_HUGEPAGES)*HPAGE_PMD_NR),
+		nid, K(node_page_state(nid, NR_SHMEM_PMDMAPPED)*HPAGE_PMD_NR),
+		nid, K(node_page_state(nid, NR_SHMEM_FREEHOLES)));
 #endif
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
diff -puN fs/proc/meminfo.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/fs/proc/meminfo.c
@@ -105,6 +105,9 @@ static int meminfo_proc_show(struct seq_
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
+		"ShmemHugePages: %8lu kB\n"
+		"ShmemPmdMapped: %8lu kB\n"
+		"ShmemFreeHoles: %8lu kB\n"
 #endif
 #ifdef CONFIG_CMA
 		"CmaTotal:       %8lu kB\n"
@@ -159,11 +162,13 @@ static int meminfo_proc_show(struct seq_
 		0ul, // used to be vmalloc 'used'
 		0ul  // used to be vmalloc 'largest_chunk'
 #ifdef CONFIG_MEMORY_FAILURE
-		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
+		, K(atomic_long_read(&num_poisoned_pages))
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		   HPAGE_PMD_NR)
+		, K(global_page_state(NR_ANON_HUGEPAGES) * HPAGE_PMD_NR)
+		, K(global_page_state(NR_SHMEM_HUGEPAGES) * HPAGE_PMD_NR)
+		, K(global_page_state(NR_SHMEM_PMDMAPPED) * HPAGE_PMD_NR)
+		, K(global_page_state(NR_SHMEM_FREEHOLES))
 #endif
 #ifdef CONFIG_CMA
 		, K(totalcma_pages)
diff -puN include/linux/mmzone.h~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m include/linux/mmzone.h
--- a/include/linux/mmzone.h~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/include/linux/mmzone.h
@@ -158,7 +158,10 @@ enum zone_stat_item {
 	WORKINGSET_REFAULT,
 	WORKINGSET_ACTIVATE,
 	WORKINGSET_NODERECLAIM,
-	NR_ANON_TRANSPARENT_HUGEPAGES,
+	NR_ANON_HUGEPAGES,	/* transparent anon huge pages */
+	NR_SHMEM_HUGEPAGES,	/* transparent shmem huge pages */
+	NR_SHMEM_PMDMAPPED,	/* shmem huge pages currently mapped hugely */
+	NR_SHMEM_FREEHOLES,	/* unused memory of high-order allocations */
 	NR_FREE_CMA_PAGES,
 	NR_VM_ZONE_STAT_ITEMS };
 
diff -puN mm/huge_memory.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/mm/huge_memory.c
@@ -2941,7 +2941,7 @@ static void __split_huge_pmd_locked(stru
 
 	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
 		/* Last compound_mapcount is gone. */
-		__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+		__dec_zone_page_state(page, NR_ANON_HUGEPAGES);
 		if (TestClearPageDoubleMap(page)) {
 			/* No need in mapcount reference anymore */
 			for (i = 0; i < HPAGE_PMD_NR; i++)
diff -puN mm/page_alloc.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m mm/page_alloc.c
--- a/mm/page_alloc.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/mm/page_alloc.c
@@ -3869,6 +3869,11 @@ out:
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define THPAGE_PMD_NR	HPAGE_PMD_NR
+#else
+#define THPAGE_PMD_NR	0	/* Avoid BUILD_BUG() */
+#endif
 
 static void show_migration_types(unsigned char type)
 {
@@ -3925,6 +3930,7 @@ void show_free_areas(unsigned int filter
 		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" shmem_hugepages:%lu _pmdmapped:%lu _freeholes:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_INACTIVE_ANON),
@@ -3942,6 +3948,9 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE),
+		global_page_state(NR_SHMEM_HUGEPAGES) * THPAGE_PMD_NR,
+		global_page_state(NR_SHMEM_PMDMAPPED) * THPAGE_PMD_NR,
+		global_page_state(NR_SHMEM_FREEHOLES),
 		global_page_state(NR_FREE_PAGES),
 		free_pcp,
 		global_page_state(NR_FREE_CMA_PAGES));
@@ -3976,6 +3985,9 @@ void show_free_areas(unsigned int filter
 			" writeback:%lukB"
 			" mapped:%lukB"
 			" shmem:%lukB"
+			" _hugepages:%lukB"
+			" _pmdmapped:%lukB"
+			" _freeholes:%lukB"
 			" slab_reclaimable:%lukB"
 			" slab_unreclaimable:%lukB"
 			" kernel_stack:%lukB"
@@ -4008,6 +4020,11 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_WRITEBACK)),
 			K(zone_page_state(zone, NR_FILE_MAPPED)),
 			K(zone_page_state(zone, NR_SHMEM)),
+			K(zone_page_state(zone, NR_SHMEM_HUGEPAGES) *
+							THPAGE_PMD_NR),
+			K(zone_page_state(zone, NR_SHMEM_PMDMAPPED) *
+							THPAGE_PMD_NR),
+			K(zone_page_state(zone, NR_SHMEM_FREEHOLES)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
 			zone_page_state(zone, NR_KERNEL_STACK) *
diff -puN mm/rmap.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m mm/rmap.c
--- a/mm/rmap.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/mm/rmap.c
@@ -1213,10 +1213,8 @@ void do_page_add_anon_rmap(struct page *
 		 * pte lock(a spinlock) is held, which implies preemption
 		 * disabled.
 		 */
-		if (compound) {
-			__inc_zone_page_state(page,
-					      NR_ANON_TRANSPARENT_HUGEPAGES);
-		}
+		if (compound)
+			__inc_zone_page_state(page, NR_ANON_HUGEPAGES);
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, nr);
 	}
 	if (unlikely(PageKsm(page)))
@@ -1254,7 +1252,7 @@ void page_add_new_anon_rmap(struct page
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/* increment count (starts at -1) */
 		atomic_set(compound_mapcount_ptr(page), 0);
-		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+		__inc_zone_page_state(page, NR_ANON_HUGEPAGES);
 	} else {
 		/* Anon THP always mapped first with PMD */
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
@@ -1285,7 +1283,7 @@ static void page_remove_file_rmap(struct
 {
 	lock_page_memcg(page);
 
-	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
+	/* hugetlbfs pages are not counted in NR_FILE_MAPPED for now. */
 	if (unlikely(PageHuge(page))) {
 		/* hugetlb pages are always mapped with pmds */
 		atomic_dec(compound_mapcount_ptr(page));
@@ -1317,14 +1315,14 @@ static void page_remove_anon_compound_rm
 	if (!atomic_add_negative(-1, compound_mapcount_ptr(page)))
 		return;
 
-	/* Hugepages are not counted in NR_ANON_PAGES for now. */
+	/* hugetlbfs pages are not counted in NR_ANON_PAGES for now. */
 	if (unlikely(PageHuge(page)))
 		return;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return;
 
-	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	__dec_zone_page_state(page, NR_ANON_HUGEPAGES);
 
 	if (TestClearPageDoubleMap(page)) {
 		/*
diff -puN mm/vmstat.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m mm/vmstat.c
--- a/mm/vmstat.c~huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m
+++ a/mm/vmstat.c
@@ -756,6 +756,9 @@ const char * const vmstat_text[] = {
 	"workingset_activate",
 	"workingset_nodereclaim",
 	"nr_anon_transparent_hugepages",
+	"nr_shmem_hugepages",
+	"nr_shmem_pmdmapped",
+	"nr_shmem_freeholes",
 	"nr_free_cma",
 
 	/* enum writeback_stat_item counters */
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

