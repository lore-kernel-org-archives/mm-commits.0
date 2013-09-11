From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch removed
 from -mm tree
Date: Wed, 11 Sep 2013 13:51:49 -0700
Message-ID: <5230d7e5.OP540xpZwm6nTMwJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu, shentino@gmail.com, hughd@google.com, akpm@linux-foundation.org

Subject: [folded-merged] swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,hughd@google.com,shentino@gmail.com,valdis.kletnieks@vt.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:51:49 -0700


The patch titled
     Subject: swap-warn-when-a-swap-area-overflows-the-maximum-size-fix
has been removed from the -mm tree.  Its filename was
     swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch

This patch was dropped because it was folded into swap-warn-when-a-swap-area-overflows-the-maximum-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-warn-when-a-swap-area-overflows-the-maximum-size-fix

fix warning

mm/swapfile.c: In function 'read_swap_header':
mm/swapfile.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type '__u32'

Cc: Hugh Dickins <hughd@google.com>
Cc: Raymond Jennings <shentino@gmail.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-warn-when-a-swap-area-overflows-the-maximum-size-fix
+++ a/mm/swapfile.c
@@ -1926,6 +1926,7 @@ static unsigned long read_swap_header(st
 	int i;
 	unsigned long maxpages;
 	unsigned long swapfilepages;
+	unsigned long last_page;
 
 	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		printk(KERN_ERR "Unable to find swap-space signature\n");
@@ -1968,14 +1969,15 @@ static unsigned long read_swap_header(st
 	 */
 	maxpages = swp_offset(pte_to_swp_entry(
 			swp_entry_to_pte(swp_entry(0, ~0UL)))) + 1;
-	if (swap_header->info.last_page > maxpages) {
+	last_page = swap_header->info.last_page;
+	if (last_page > maxpages) {
 		printk(KERN_WARNING
 			"Truncating oversized swap area, only using %luk out of %luk\n",
 			maxpages << (PAGE_SHIFT - 10),
-			swap_header->info.last_page << (PAGE_SHIFT - 10));
+			last_page << (PAGE_SHIFT - 10));
 	}
-	if (maxpages > swap_header->info.last_page) {
-		maxpages = swap_header->info.last_page + 1;
+	if (maxpages > last_page) {
+		maxpages = last_page + 1;
 		/* p->max is an unsigned int: don't overflow it */
 		if ((unsigned int)maxpages == 0)
 			maxpages = UINT_MAX;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
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

