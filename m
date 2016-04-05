From: akpm@linux-foundation.org
Subject: + huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:15:33 -0700
Message-ID: <57044715.kW9DFOLIe31FzUs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbcDEXPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: include shmem freeholes in available memory
has been added to the -mm tree.  Its filename is
     huge-tmpfs-include-shmem-freeholes-in-available-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-include-shmem-freeholes-in-available-memory.patch

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
Subject: huge tmpfs: include shmem freeholes in available memory

ShmemFreeHoles will be freed under memory pressure, but are not included
in MemFree: they need to be added into MemAvailable, and wherever the
kernel calculates freeable pages, rather than actually free pages.  They
must not be counted as free when considering whether to go to reclaim.

There is certainly room for debate about other places, but I think I've
got about the right list - though I'm unfamiliar with and undecided about
drivers/staging/android/lowmemorykiller.c and kernel/power/snapshot.c.

While NR_SHMEM_FREEHOLES should certainly not be counted in NR_FREE_PAGES,
there is a case for including ShmemFreeHoles in the user-visible MemFree
after all: I can see both sides of that argument, leaving it out so far.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 ++
 mm/page_alloc.c     |    6 ++++++
 mm/util.c           |    1 +
 3 files changed, 9 insertions(+)

diff -puN mm/page-writeback.c~huge-tmpfs-include-shmem-freeholes-in-available-memory mm/page-writeback.c
--- a/mm/page-writeback.c~huge-tmpfs-include-shmem-freeholes-in-available-memory
+++ a/mm/page-writeback.c
@@ -285,6 +285,7 @@ static unsigned long zone_dirtyable_memo
 	 */
 	nr_pages -= min(nr_pages, zone->totalreserve_pages);
 
+	nr_pages += zone_page_state(zone, NR_SHMEM_FREEHOLES);
 	nr_pages += zone_page_state(zone, NR_INACTIVE_FILE);
 	nr_pages += zone_page_state(zone, NR_ACTIVE_FILE);
 
@@ -348,6 +349,7 @@ static unsigned long global_dirtyable_me
 	 */
 	x -= min(x, totalreserve_pages);
 
+	x += global_page_state(NR_SHMEM_FREEHOLES);
 	x += global_page_state(NR_INACTIVE_FILE);
 	x += global_page_state(NR_ACTIVE_FILE);
 
diff -puN mm/page_alloc.c~huge-tmpfs-include-shmem-freeholes-in-available-memory mm/page_alloc.c
--- a/mm/page_alloc.c~huge-tmpfs-include-shmem-freeholes-in-available-memory
+++ a/mm/page_alloc.c
@@ -3790,6 +3790,12 @@ long si_mem_available(void)
 	available += pagecache;
 
 	/*
+	 * Shmem freeholes help to keep huge pages intact, but contain
+	 * no data, and can be shrunk whenever small pages are needed.
+	 */
+	available += global_page_state(NR_SHMEM_FREEHOLES);
+
+	/*
 	 * Part of the reclaimable slab consists of items that are in use,
 	 * and cannot be freed. Cap this estimate at the low watermark.
 	 */
diff -puN mm/util.c~huge-tmpfs-include-shmem-freeholes-in-available-memory mm/util.c
--- a/mm/util.c~huge-tmpfs-include-shmem-freeholes-in-available-memory
+++ a/mm/util.c
@@ -519,6 +519,7 @@ int __vm_enough_memory(struct mm_struct
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
 		free = global_page_state(NR_FREE_PAGES);
+		free += global_page_state(NR_SHMEM_FREEHOLES);
 		free += global_page_state(NR_FILE_PAGES);
 
 		/*
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

