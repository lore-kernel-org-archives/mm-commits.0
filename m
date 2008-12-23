From: akpm@linux-foundation.org
Subject: + clocksource-pass-clocksource-to-read-callback-v2-fix.patch added to -mm tree
Date: Mon, 22 Dec 2008 17:53:32 -0800
Message-ID: <200812230153.mBN1rWH9001544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYLWBxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 20:53:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, damm@igel.co.jp


The patch titled
     clocksource pass clocksource powerpc fix
has been added to the -mm tree.  Its filename is
     clocksource-pass-clocksource-to-read-callback-v2-fix.patch

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
Subject: clocksource pass clocksource powerpc fix
From: Hugh Dickins <hugh@veritas.com>

Fix powerpc build of clocksource pass clocksource mods:

arch/powerpc/kernel/time.c:88: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:99: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:770: error: conflicting types for 'rtc_read'
arch/powerpc/kernel/time.c:80: error: previous declaration of 'rtc_read' was here
arch/powerpc/kernel/time.c:775: error: conflicting types for 'timebase_read'
arch/powerpc/kernel/time.c:91: error: previous declaration of 'timebase_read' was here
make[1]: *** [arch/powerpc/kernel/time.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback-v2-fix arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~clocksource-pass-clocksource-to-read-callback-v2-fix
+++ a/arch/powerpc/kernel/time.c
@@ -77,7 +77,7 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 
-static cycle_t rtc_read(void);
+static cycle_t rtc_read(struct clocksource *);
 static struct clocksource clocksource_rtc = {
 	.name         = "rtc",
 	.rating       = 400,
@@ -88,7 +88,7 @@ static struct clocksource clocksource_rt
 	.read         = rtc_read,
 };
 
-static cycle_t timebase_read(void);
+static cycle_t timebase_read(struct clocksource *);
 static struct clocksource clocksource_timebase = {
 	.name         = "timebase",
 	.rating       = 400,
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
clocksource-pass-clocksource-to-read-callback-v2-fix.patch
bio-zero-inlined-bio_vec.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
shmem-unify-regular-and-tiny-shmem.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style.patch
mm-mmapc-fix-coding-style-fix.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-shmemc-fix-division-by-zero.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

