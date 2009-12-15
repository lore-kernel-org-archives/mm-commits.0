From: akpm@linux-foundation.org
Subject: [folded] mm-mlocking-in-try_to_unmap_one-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:01:06 -0800
Message-ID: <200912150101.nBF1166h028469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbZLOBBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, kamezawa.hiro


The patch titled
     comment adding to mlocking in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-mlocking-in-try_to_unmap_one-fix.patch

This patch was dropped because it was folded into mm-mlocking-in-try_to_unmap_one.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: comment adding to mlocking in try_to_unmap_one
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current code doesn't tell us why we don't bother to nonlinear kindly.
This patch added small adding explanation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-mlocking-in-try_to_unmap_one-fix mm/mlock.c
diff -puN mm/rmap.c~mm-mlocking-in-try_to_unmap_one-fix mm/rmap.c
--- a/mm/rmap.c~mm-mlocking-in-try_to_unmap_one-fix
+++ a/mm/rmap.c
@@ -1065,7 +1065,11 @@ static int try_to_unmap_file(struct page
 	if (list_empty(&mapping->i_mmap_nonlinear))
 		goto out;
 
-	/* We don't bother to try to find the munlocked page in nonlinears */
+	/*
+	 * We don't bother to try to find the munlocked page in nonlinears.
+	 * It's costly. Instead, later, page reclaim logic may call
+	 * try_to_unmap(TTU_MUNLOCK) and recover PG_mlocked lazily.
+	 */
 	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
 		goto out;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
mm-simplify-try_to_unmap_one-fix-fix.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan.patch
vmscan-do-not-evict-inactive-pages-when-skipping-an-active-list-scan-fix.patch
vmscan-simplify-code.patch
mlock-replace-stale-comments-in-munlock_vma_page.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-doc.patch
maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch
lib-introduce-strim.patch
lib-introduce-strim-checkpatch-fixes.patch

