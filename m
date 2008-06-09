From: akpm@linux-foundation.org
Subject: - net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 09 Jun 2008 16:32:55 -0700
Message-ID: <200806092332.m59NWtf5014583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492AbYFIXdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 19:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iwamatsu.nobuhiro@renesas.com, jeff@garzik.org, lethal@linux-sh.org, shimoda.yoshihiro@renesas.com, mm-commits@vger.kernel.org


The patch titled
     net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch

This patch was dropped because it was folded into net-sh_eth-add-support-for-renesas-superh-ethernet.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/cache.h> instead of <asm/cache.h>
#87: FILE: drivers/net/sh_eth.c:32:
+#include <asm/cache.h>

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#88: FILE: drivers/net/sh_eth.c:33:
+#include <asm/io.h>

ERROR: space prohibited after that open parenthesis '('
#674: FILE: drivers/net/sh_eth.c:619:
+	mod_timer( &mdp->timer, jiffies + (10 * HZ));

total: 1 errors, 2 warnings, 1663 lines checked

./patches/net-sh_eth-add-support-for-renesas-superh-ethernet.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


(akpm: also remove unused next_tick)

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sh_eth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/sh_eth.c~net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes drivers/net/sh_eth.c
--- a/drivers/net/sh_eth.c~net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes
+++ a/drivers/net/sh_eth.c
@@ -29,8 +29,9 @@
 #include <linux/mdio-bitbang.h>
 #include <linux/netdevice.h>
 #include <linux/phy.h>
-#include <asm/cache.h>
-#include <asm/io.h>
+#include <linux/cache.h>
+#include <linux/io.h>
+
 #include "sh_eth.h"
 
 /*
@@ -614,9 +615,8 @@ static void sh_eth_timer(unsigned long d
 {
 	struct net_device *ndev = (struct net_device *)data;
 	struct sh_eth_private *mdp = netdev_priv(ndev);
-	int next_tick = 10 * HZ;
 
-	mod_timer( &mdp->timer, jiffies + (10 * HZ));
+	mod_timer(&mdp->timer, jiffies + (10 * HZ));
 }
 
 /* PHY state control function */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
m68k-add-ext2_find_firstnext_bit-for-ext4-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-unbork.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
lguest-use-cpu-capability-accessors.patch
intel-agp-rewrite-gtt-on-resume.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-leds.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bluetooth-hci_bcspc-small-cleanups-api-users.patch
sundance-set-carrier-status-on-link-change-events.patch
net-sh_eth-add-support-for-renesas-superh-ethernet.patch
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
revert-revert-linux-next-changes-to-make-memstick-use-fully-asynchronous-request-processing-apply.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

