From: akpm@linux-foundation.org
Subject: - vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:15 -0800
Message-ID: <200901072214.n07MEFt8014202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761771AbZAGWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, hannes@cmpxchg.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: shrink_active_list(): reduce lru_lock hold time
has been removed from the -mm tree.  Its filename was
     vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: shrink_active_list(): reduce lru_lock hold time
From: Andrew Morton <akpm@linux-foundation.org>

These three statements manipulate local variables and do not need the lock
coverage.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~vmscan-shrink_active_list-reduce-lru_lock-hold-time mm/vmscan.c
--- a/mm/vmscan.c~vmscan-shrink_active_list-reduce-lru_lock-hold-time
+++ a/mm/vmscan.c
@@ -1237,6 +1237,13 @@ static void shrink_active_list(unsigned 
 		list_add(&page->lru, &l_inactive);
 	}
 
+	/*
+	 * Move the pages to the [file or anon] inactive list.
+	 */
+	pagevec_init(&pvec, 1);
+	pgmoved = 0;
+	lru = LRU_BASE + file * LRU_FILE;
+
 	spin_lock_irq(&zone->lru_lock);
 	/*
 	 * Count referenced pages from currently used mappings as
@@ -1247,13 +1254,6 @@ static void shrink_active_list(unsigned 
 	if (scan_global_lru(sc))
 		zone->recent_rotated[!!file] += pgmoved;
 
-	/*
-	 * Move the pages to the [file or anon] inactive list.
-	 */
-	pagevec_init(&pvec, 1);
-
-	pgmoved = 0;
-	lru = LRU_BASE + file * LRU_FILE;
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
smp_call_function_single-be-slightly-less-stupid.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

