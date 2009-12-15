From: akpm@linux-foundation.org
Subject: [folded] mm-simplify-try_to_unmap_one-fix-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:03:10 -0800
Message-ID: <200912150103.nBF13A8D001244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758711AbZLOBEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:04:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, macli@brc.ubc.ca, mm-commits@vger.kernel.org


The patch titled
     try_to_unmap_one() comment fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-try_to_unmap_one-fix-fix.patch

This patch was dropped because it was folded into mm-simplify-try_to_unmap_one.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: try_to_unmap_one() comment fix
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Viencent Li pointed out current comment is wrong. This patch fixes it.

Reported-by: Vincent Li <macli@brc.ubc.ca>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-simplify-try_to_unmap_one-fix-fix mm/rmap.c
--- a/mm/rmap.c~mm-simplify-try_to_unmap_one-fix-fix
+++ a/mm/rmap.c
@@ -875,8 +875,9 @@ out_mlock:
 	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
 	 * unstable result and race. Plus, We can't wait here because
 	 * we now hold anon_vma->lock or mapping->i_mmap_lock.
-	 * If trylock failed, The page remain evictable lru and
-	 * retry to more unevictable lru by later vmscan.
+	 * if trylock failed, the page remain in evictable lru and later
+	 * vmscan could retry to move the page to unevictable lru if the
+	 * page is actually mlocked.
 	 */
 	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
 		if (vma->vm_flags & VM_LOCKED) {
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

