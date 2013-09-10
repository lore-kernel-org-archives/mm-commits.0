From: akpm@linux-foundation.org
Subject: + fat-additions-to-support-fat_fallocate-fix-fix.patch added to
 -mm tree
Date: Tue, 10 Sep 2013 16:34:21 -0700
Message-ID: <522fac7d.+hPIz4tSPwhlKVRQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3IJXeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 19:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, namjae.jeon@samsung.com, hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org

Subject: + fat-additions-to-support-fat_fallocate-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hirofumi@mail.parknet.co.jp,namjae.jeon@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 16:34:21 -0700


The patch titled
     Subject: fat-additions-to-support-fat_fallocate-fix-fix
has been added to the -mm tree.  Its filename is
     fat-additions-to-support-fat_fallocate-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-additions-to-support-fat_fallocate-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-additions-to-support-fat_fallocate-fix-fix.patch

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
Subject: fat-additions-to-support-fat_fallocate-fix-fix

use the new d_count()

Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate-fix-fix fs/fat/inode.c
diff -puN fs/fat/file.c~fat-additions-to-support-fat_fallocate-fix-fix fs/fat/file.c
--- a/fs/fat/file.c~fat-additions-to-support-fat_fallocate-fix-fix
+++ a/fs/fat/file.c
@@ -163,7 +163,7 @@ static int fat_file_release(struct inode
 	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
 
 	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
-	    filp->f_dentry->d_count == 1)
+	    d_count(filp->f_dentry) == 1)
 		fat_truncate_blocks(inode, inode->i_size);
 	mutex_unlock(&inode->i_mutex);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
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
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch

