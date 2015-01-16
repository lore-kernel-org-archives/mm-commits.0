From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
 added to -mm tree
Date: Thu, 15 Jan 2015 17:17:50 -0800
Message-ID: <54b866be.fNGMRfCLKjPrjSLE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbbAPBSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 20:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, vdavydov@parallels.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix

Move the zone_page_state_snapshot() fallback logic into
too_many_isolated(), so shrink_inactive_list() doesn't incorrectly call
congestion_wait().

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix
+++ a/mm/vmscan.c
@@ -1402,7 +1402,7 @@ int isolate_lru_page(struct page *page)
 }
 
 static int __too_many_isolated(struct zone *zone, int file,
-	struct scan_control *sc, int safe)
+			       struct scan_control *sc, int safe)
 {
 	unsigned long inactive, isolated;
 
@@ -1435,7 +1435,7 @@ static int __too_many_isolated(struct zo
  * unnecessary swapping, thrashing and OOM.
  */
 static int too_many_isolated(struct zone *zone, int file,
-		struct scan_control *sc, int safe)
+			     struct scan_control *sc)
 {
 	if (current_is_kswapd())
 		return 0;
@@ -1443,12 +1443,14 @@ static int too_many_isolated(struct zone
 	if (!global_reclaim(sc))
 		return 0;
 
-	if (unlikely(__too_many_isolated(zone, file, sc, 0))) {
-		if (safe)
-			return __too_many_isolated(zone, file, sc, safe);
-		else
-			return 1;
-	}
+	/*
+	 * __too_many_isolated(safe=0) is fast but inaccurate, because it
+	 * doesn't account for the vm_stat_diff[] counters.  So if it looks
+	 * like too_many_isolated() is about to return true, fall back to the
+	 * slower, more accurate zone_page_state_snapshot().
+	 */
+	if (unlikely(__too_many_isolated(zone, file, sc, 0)))
+		return __too_many_isolated(zone, file, sc, 1);
 
 	return 0;
 }
@@ -1540,18 +1542,15 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_immediate = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	int safe = 0;
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	while (unlikely(too_many_isolated(zone, file, sc, safe))) {
+	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
 			return SWAP_CLUSTER_MAX;
-
-		safe = 1;
 	}
 
 	lru_add_drain();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
dax-add-dax_zero_page_range-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

