From: akpm@linux-foundation.org
Subject: - spi_gpio-driver-cleanups.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:34:19 -0800
Message-ID: <200901062034.n06KYJ9t028153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbZAFUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, damm@igel.co.jp, dbrownell@users.sourceforge.net, torgil.svensson@gmail.com, mm-commits@vger.kernel.org


The patch titled
     spi_gpio-driver cleanups
has been removed from the -mm tree.  Its filename was
     spi_gpio-driver-cleanups.patch

This patch was dropped because it was folded into spi_gpio-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_gpio-driver cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- fix checkpatch whine.

- spi_master_put() already returns void, and that (void) thing is
  pointless and fugly.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Torgil Svensson <torgil.svensson@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_gpio.c~spi_gpio-driver-cleanups drivers/spi/spi_gpio.c
--- a/drivers/spi/spi_gpio.c~spi_gpio-driver-cleanups
+++ a/drivers/spi/spi_gpio.c
@@ -125,7 +125,7 @@ static inline int getmiso(const struct s
  * reaching even one Mbit/sec (except when we can inline bitops), so for now
  * we'll just assume we never need additional per-bit slowdowns.
  */
-#define spidelay(nsecs)	do{} while(0)
+#define spidelay(nsecs)	do {} while (0)
 
 #define	EXPAND_BITBANG_TXRX
 #include <linux/spi/spi_bitbang.h>
@@ -323,7 +323,7 @@ static int __exit spi_gpio_remove(struct
 
 	/* stop() unregisters child devices too */
 	status = spi_bitbang_stop(&spi_gpio->bitbang);
-	(void) spi_master_put(spi_gpio->bitbang.master);
+	spi_master_put(spi_gpio->bitbang.master);
 
 	platform_set_drvdata(pdev, NULL);
 
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

