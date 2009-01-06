From: akpm@linux-foundation.org
Subject: - minix-fix-add-links-wrong-position-calculation-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:38:19 -0800
Message-ID: <200901062038.n06KcKb5031448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbZAFUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dushistov@mail.ru, nickpiggin@yahoo.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     minix-fix-add-links-wrong-position-calculation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     minix-fix-add-links-wrong-position-calculation-checkpatch-fixes.patch

This patch was dropped because it was folded into minix-fix-add-links-wrong-position-calculation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: minix-fix-add-links-wrong-position-calculation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "(foo*)" should be "(foo *)"
#23: FILE: fs/minix/dir.c:283:
+	pos = page_offset(page) + p - (char*)page_address(page);

total: 1 errors, 0 warnings, 8 lines checked

./patches/minix-fix-add-links-wrong-position-calculation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: <stable@kernel.org>		[2.6.lots]
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/dir.c~minix-fix-add-links-wrong-position-calculation-checkpatch-fixes fs/minix/dir.c
--- a/fs/minix/dir.c~minix-fix-add-links-wrong-position-calculation-checkpatch-fixes
+++ a/fs/minix/dir.c
@@ -280,7 +280,7 @@ int minix_add_link(struct dentry *dentry
 	return -EINVAL;
 
 got_it:
-	pos = page_offset(page) + p - (char*)page_address(page);
+	pos = page_offset(page) + p - (char *)page_address(page);
 	err = __minix_write_begin(NULL, page->mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
mm-mmapc-fix-coding-style.patch
mm-check-for-no-mmaps-in-exit_mmap.patch
mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch
mm-hugetlb-get-rid-of-redundant-if-operation.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module.patch
binfmtsh-include-listh.patch
spi_gpio-driver.patch
kprobes-support-probing-module-__exit-function.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
minix-fix-add-links-wrong-position-calculation.patch
minix-fix-add-links-wrong-position-calculation-checkpatch-fixes.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
fs-execc-make-do_coredump-void-checkpatch-fixes.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
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

