From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch removed from
 -mm tree
Date: Wed, 11 Sep 2013 14:00:24 -0700
Message-ID: <5230d9e8.Fr9R9TfCY7pDxrKy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3IKVAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, akpm@linux-foundation.org

Subject: [folded-merged] mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:00:24 -0700


The patch titled
     Subject: mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix
has been removed from the -mm tree.  Its filename was
     mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch

This patch was dropped because it was folded into mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix

clarify comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix mm/mlock.c
--- a/mm/mlock.c~mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix
+++ a/mm/mlock.c
@@ -264,7 +264,10 @@ static bool __putback_lru_fast_prepare(s
 static void __putback_lru_fast(struct pagevec *pvec, int pgrescued)
 {
 	count_vm_events(UNEVICTABLE_PGMUNLOCKED, pagevec_count(pvec));
-	/* This includes put_page so we don't call it explicitly */
+	/*
+	 *__pagevec_lru_add() calls release_pages() so we don't call
+	 * put_page() explicitly
+	 */
 	__pagevec_lru_add(pvec);
 	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 }
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
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
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

