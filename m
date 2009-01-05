From: akpm@linux-foundation.org
Subject: - pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 05 Jan 2009 12:14:50 -0800
Message-ID: <200901052014.n05KEpFW015606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbZAEUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 15:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbarnes@virtuousgeek.org, mirq-linux@rere.qmqm.pl, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch

This patch was dropped because it was folded into pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#36: FILE: drivers/pci/quirks.c:2158:
+static void __devinit quirk_unhide_mch_memory_controller_dev6(struct pci_dev *dev)

WARNING: line over 80 characters
#41: FILE: drivers/pci/quirks.c:2163:
+		dev_info(&dev->dev, "Enabling MCH Memory Controller 'Overflow' Device");

total: 0 errors, 2 warnings, 27 lines checked

./patches/pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes
+++ a/drivers/pci/quirks.c
@@ -2155,12 +2155,14 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
  * the DRBs - this is where we expose device 6.
  * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
  */
-static void __devinit quirk_unhide_mch_memory_controller_dev6(struct pci_dev *dev)
+static void __devinit
+quirk_unhide_mch_memory_controller_dev6(struct pci_dev *dev)
 {
 	u8 reg;
 
 	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
-		dev_info(&dev->dev, "Enabling MCH Memory Controller 'Overflow' Device");
+		dev_info(&dev->dev,
+			"Enabling MCH Memory Controller 'Overflow' Device");
 		pci_write_config_byte(dev, 0xF4, reg | 0x02);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
mm-check-for-no-mmaps-in-exit_mmap-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
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

