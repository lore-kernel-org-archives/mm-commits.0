From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 14:01:01 -0700
Message-ID: <5230da0d.tDVaWFovbaQtM4qd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3IKVBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangwm@marvell.com, yinghan@google.com, riel@redhat.com, npiggin@gmail.com, minchan@kernel.org, mhocko@suse.cz, mel@csn.ul.ie, lliubbo@gmail.com, linux@arm.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cldu@marvell.com, cl@linux.com, aaditya.kumar.30@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,aaditya.kumar.30@gmail.com,cl@linux.com,cldu@marvell.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,linux@arm.linux.org.uk,lliubbo@gmail.com,mel@csn.ul.ie,mhocko@suse.cz,minchan@kernel.org,npiggin@gmail.com,riel@redhat.com,yinghan@google.com,zhangwm@marvell.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:01:01 -0700


The patch titled
     Subject: mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch

This patch was dropped because it was folded into mm-vmscan-fix-do_try_to_free_pages-livelock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Neil Zhang <zhangwm@marvell.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2 mm/migrate.c
--- a/mm/migrate.c~mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2
+++ a/mm/migrate.c
@@ -1471,7 +1471,7 @@ static bool migrate_balanced_pgdat(struc
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone->all_unreclaimable)
+		if (!zone_reclaimable(zone))
 			continue;
 
 		/* Avoid waking kswapd by allocating pages_to_migrate pages. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

