From: akpm@linux-foundation.org
Subject: + revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:05:09 -0800
Message-ID: <20111216230509.B3C46100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:44081 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1LPXFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, adi@hexapodia.org, alan@lxorguk.ukuu.org.uk, hannes@cmpxchg.org, mgorman@suse.de, minchan.kim@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: revert mm-do-not-stall-in-synchronous-compaction-for-thp-allocations
has been added to the -mm tree.  Its filename is
     revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert mm-do-not-stall-in-synchronous-compaction-for-thp-allocations

Take this away again to amke way for "Reduce compaction-related stalls and
improve asynchronous migration of dirty pages v6".

But mm-do-not-stall-in-synchronous-compaction-for-thp-allocations migth
still be appl;icable for earlier kernel versions.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@vger.kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   11 -----------
 mm/page_alloc.c     |    9 +--------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff -puN include/linux/gfp.h~revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations include/linux/gfp.h
--- a/include/linux/gfp.h~revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations
+++ a/include/linux/gfp.h
@@ -84,18 +84,7 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
-/*
- * __GFP_NO_KSWAPD indicates that the VM should favour failing the allocation
- * over excessive disruption of the system. Currently this means
- * 1. Do not wake kswapd (hence the flag name)
- * 2. Do not use stall in synchronous compaction for high-order allocations
- *    as this may cause the caller to stall writing out pages
- *
- * This flag it primarily intended for use with transparent hugepage support.
- * If the flag is used outside the VM, linux-mm should be cc'd for review.
- */
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
-
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
diff -puN mm/page_alloc.c~revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations
+++ a/mm/page_alloc.c
@@ -2285,14 +2285,7 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-
-	/*
-	 * Do not use sync migration if __GFP_NO_KSWAPD is used to indicate
-	 * the system should not be heavily disrupted. In practice, this is
-	 * to avoid THP callers being stalled in writeback during migration
-	 * as it's preferable for the the allocations to fail than to stall
-	 */
-	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
+	sync_migration = true;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
_
Subject: Subject: revert mm-do-not-stall-in-synchronous-compaction-for-thp-allocations

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sound-soc-mid-x86-sst_platformc-fix-build.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-fix.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

