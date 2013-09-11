From: akpm@linux-foundation.org
Subject: [folded-merged]
 initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch removed
 from -mm tree
Date: Wed, 11 Sep 2013 14:06:22 -0700
Message-ID: <5230db4e.B/05lrAo0oAAtcyL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3IKVGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, rob@landley.net, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, akpm@linux-foundation.org

Subject: [folded-merged] initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rob@landley.net,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:06:22 -0700


The patch titled
     Subject: initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix
has been removed from the -mm tree.  Its filename was
     initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch

This patch was dropped because it was folded into initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix

using bit 1 was odd

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix
+++ a/fs/ramfs/inode.c
@@ -249,7 +249,7 @@ static struct dentry *rootfs_mount(struc
 {
 	static unsigned long once;
 
-	if (test_and_set_bit(1, &once))
+	if (test_and_set_bit(0, &once))
 		return ERR_PTR(-ENODEV);
 
 	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
@@ -278,7 +278,7 @@ static int __init init_ramfs_fs(void)
 	static unsigned long once;
 	int err;
 
-	if (test_and_set_bit(1, &once))
+	if (test_and_set_bit(0, &once))
 		return 0;
 
 	err = bdi_init(&ramfs_backing_dev_info);
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
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

