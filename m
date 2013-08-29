From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-add-strictlimit-feature-fix.patch added to
 -mm tree
Date: Thu, 29 Aug 2013 12:42:50 -0700
Message-ID: <521fa43a.gQ2l+6CwE2AnRcXB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3H2Tmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mpatlasov@parallels.com, akpm@linux-foundation.org

Subject: + mm-page-writebackc-add-strictlimit-feature-fix.patch added to -mm tree
To: akpm@linux-foundation.org,mpatlasov@parallels.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:42:50 -0700


The patch titled
     Subject: mm-page-writebackc-add-strictlimit-feature-fix
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-add-strictlimit-feature-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-add-strictlimit-feature-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-add-strictlimit-feature-fix.patch

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
Subject: mm-page-writebackc-add-strictlimit-feature-fix

fix warning in page-writeback.c

Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-add-strictlimit-feature-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-add-strictlimit-feature-fix
+++ a/mm/page-writeback.c
@@ -1366,10 +1366,8 @@ static void balance_dirty_pages(struct a
 {
 	unsigned long nr_reclaimable;	/* = file_dirty + unstable_nfs */
 	unsigned long nr_dirty;  /* = file_dirty + writeback + unstable_nfs */
-	unsigned long bdi_dirty;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
-	unsigned long bdi_thresh;
 	long period;
 	long pause;
 	long max_pause;
@@ -1385,8 +1383,10 @@ static void balance_dirty_pages(struct a
 
 	for (;;) {
 		unsigned long now = jiffies;
-		unsigned long dirty;
+		unsigned long uninitialized_var(bdi_thresh);
 		unsigned long thresh;
+		unsigned long uninitialized_var(bdi_dirty);
+		unsigned long dirty;
 		unsigned long bg_thresh;
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
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
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-checkpatch-fixes.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

