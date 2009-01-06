From: akpm@linux-foundation.org
Subject: - ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:26:01 -0800
Message-ID: <200901062026.n06KQ12E021406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZAFU0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bcasavan@sgi.com, bzolnier@gmail.com, mdr@sgi.com, mm-commits@vger.kernel.org


The patch titled
     ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch

This patch was dropped because it was folded into ioc4-automatically-load-sgiioc4-subordinate-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#55: FILE: drivers/misc/ioc4.c:404:
+			       __FUNCTION__);

ERROR: else should follow close brace '}'
#57: FILE: drivers/misc/ioc4.c:406:
+		}
+		else {

total: 1 errors, 1 warnings, 56 lines checked

./patches/ioc4-automatically-load-sgiioc4-subordinate-module.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Brent Casavant <bcasavan@sgi.com>
Cc: Michael Reed <mdr@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ioc4.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/misc/ioc4.c~ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c~ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes
+++ a/drivers/misc/ioc4.c
@@ -400,10 +400,8 @@ ioc4_probe(struct pci_dev *pdev, const s
 		if (!work) {
 			printk(KERN_WARNING
 			       "%s: IOC4 unable to allocate memory for "
-			       "load of sub-modules.\n",
-			       __FUNCTION__);
-		}
-		else {
+			       "load of sub-modules.\n", __func__);
+		} else {
 			/* Request the module from a work procedure as the
 			 * modprobe goes out to a userland helper and that
 			 * will hang if done directly from ioc4_probe().
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
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
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

