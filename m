From: akpm@linux-foundation.org
Subject: [folded-merged]
 initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:06:47 -0700
Message-ID: <5230db67.dBzcxeyOSe+IctCA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab3IKVGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, akpm@linux-foundation.org

Subject: [folded-merged] initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:06:47 -0700


The patch titled
     Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch

This patch was dropped because it was folded into initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#56: FILE: init/do_mounts.c:623:
+	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
+	{

total: 1 errors, 0 warnings, 36 lines checked

./patches/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes init/do_mounts.c
--- a/init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes
+++ a/init/do_mounts.c
@@ -621,12 +621,12 @@ int __init init_rootfs(void)
 		return err;
 
 	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
-		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
-	{
+		(!root_fs_names || strstr(root_fs_names, "tmpfs"))) {
 		err = shmem_init();
 		is_tmpfs = true;
-	} else
+	} else {
 		err = init_ramfs_fs();
+	}
 
 	if (err)
 		unregister_filesystem(&rootfs_fs_type);
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
mm-page-writebackc-add-strictlimit-feature.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records.patch
partitions-efi-check-pmbr-records-starting-lba.patch
partitions-efi-detect-hybrid-mbrs.patch
partitions-efi-some-style-cleanups.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

