From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch removed from
 -mm tree
Date: Tue, 10 Sep 2013 15:31:26 -0700
Message-ID: <522f9dbe.g86jQRSYdj7R3Fw3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3IJWb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kees@outflux.net, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org,kees@outflux.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:31:26 -0700


The patch titled
     Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
has been removed from the -mm tree.  Its filename was
     fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch

This patch was dropped because it was folded into fs-convert-fs-shrinkers-to-new-scan-count-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2

fix shadowed local, spell "skipped" correctly

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/extents_status.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2 fs/ext4/extents_status.c
--- a/fs/ext4/extents_status.c~fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
+++ a/fs/ext4/extents_status.c
@@ -947,14 +947,14 @@ static int __ext4_es_shrink(struct ext4_
 	struct ext4_inode_info *ei;
 	struct list_head *cur, *tmp;
 	LIST_HEAD(skipped);
-	int ret, nr_shrunk = 0;
+	int nr_shrunk = 0;
 	int retried = 0, skip_precached = 1, nr_skipped = 0;
 
 	spin_lock(&sbi->s_es_lru_lock);
 
 retry:
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
-		int ret;
+		int shrunk;
 
 		/*
 		 * If we have already reclaimed all extents from extent
@@ -982,13 +982,13 @@ retry:
 			continue;
 
 		write_lock(&ei->i_es_lock);
-		ret = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
 		if (ei->i_es_lru_nr == 0)
 			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
-		nr_shrunk += ret;
-		nr_to_scan -= ret;
+		nr_shrunk += shrunk;
+		nr_to_scan -= shrunk;
 		if (nr_to_scan == 0)
 			break;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
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
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
revert-1.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
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

