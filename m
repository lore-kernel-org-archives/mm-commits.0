From: akpm@linux-foundation.org
Subject: - e1000new-build-fix.patch removed from -mm tree
Date: Wed, 25 Jul 2007 13:49:51 -0700
Message-ID: <200707252049.l6PKnqr4021205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756927AbXGYUuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 16:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, auke-jan.h.kok@intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     e1000new build fix
has been removed from the -mm tree.  Its filename was
     e1000new-build-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: e1000new build fix
From: Andrew Morton <akpm@linux-foundation.org>

ia64 allmodconfig:

drivers/net/e1000new/82540.c: In function `e1000_reset_hw_82540':
drivers/net/e1000new/82540.c:281: error: implicit declaration of function `msleep'

And no, I refuse to partake in that include-the-whole-world-in-our-header-file
crap.

afacit this driver gets _all_ its linux includes via a single inclusion of
linux/pci.h, and sheer luck.

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000new/80003es2lan.c |    1 +
 drivers/net/e1000new/82540.c       |    1 +
 drivers/net/e1000new/82541.c       |    1 +
 drivers/net/e1000new/ethtool.c     |    1 +
 drivers/net/e1000new/ich8lan.c     |    1 +
 drivers/net/e1000new/mac.c         |    1 +
 drivers/net/e1000new/main.c        |    1 +
 drivers/net/e1000new/manage.c      |    1 +
 drivers/net/e1000new/phy.c         |    1 +
 9 files changed, 9 insertions(+)

diff -puN drivers/net/e1000new/80003es2lan.c~e1000new-build-fix drivers/net/e1000new/80003es2lan.c
--- a/drivers/net/e1000new/80003es2lan.c~e1000new-build-fix
+++ a/drivers/net/e1000new/80003es2lan.c
@@ -32,6 +32,7 @@
  */
 
 #include "80003es2lan.h"
+#include <linux/delay.h>
 
 void e1000_init_function_pointers_80003es2lan(struct e1000_hw *hw);
 
diff -puN drivers/net/e1000new/82540.c~e1000new-build-fix drivers/net/e1000new/82540.c
--- a/drivers/net/e1000new/82540.c~e1000new-build-fix
+++ a/drivers/net/e1000new/82540.c
@@ -41,6 +41,7 @@
  */
 
 #include "api.h"
+#include <linux/delay.h>
 
 void e1000_init_function_pointers_82540(struct e1000_hw *hw);
 
diff -puN drivers/net/e1000new/82541.c~e1000new-build-fix drivers/net/e1000new/82541.c
--- a/drivers/net/e1000new/82541.c~e1000new-build-fix
+++ a/drivers/net/e1000new/82541.c
@@ -36,6 +36,7 @@
  */
 
 #include "82541.h"
+#include <linux/delay.h>
 
 void e1000_init_function_pointers_82541(struct e1000_hw *hw);
 
diff -puN drivers/net/e1000new/ethtool.c~e1000new-build-fix drivers/net/e1000new/ethtool.c
--- a/drivers/net/e1000new/ethtool.c~e1000new-build-fix
+++ a/drivers/net/e1000new/ethtool.c
@@ -31,6 +31,7 @@
 #include <linux/netdevice.h>
 
 #include <linux/ethtool.h>
+#include <linux/delay.h>
 
 #include "e1000.h"
 #include "82541.h"
diff -puN drivers/net/e1000new/ich8lan.c~e1000new-build-fix drivers/net/e1000new/ich8lan.c
--- a/drivers/net/e1000new/ich8lan.c~e1000new-build-fix
+++ a/drivers/net/e1000new/ich8lan.c
@@ -41,6 +41,7 @@
  */
 
 #include "ich8lan.h"
+#include <linux/delay.h>
 
 void e1000_init_function_pointers_ich8lan(struct e1000_hw *hw);
 
diff -puN drivers/net/e1000new/mac.c~e1000new-build-fix drivers/net/e1000new/mac.c
--- a/drivers/net/e1000new/mac.c~e1000new-build-fix
+++ a/drivers/net/e1000new/mac.c
@@ -28,6 +28,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 
 #include "e1000.h"
 #include "mac.h"
diff -puN drivers/net/e1000new/main.c~e1000new-build-fix drivers/net/e1000new/main.c
--- a/drivers/net/e1000new/main.c~e1000new-build-fix
+++ a/drivers/net/e1000new/main.c
@@ -41,6 +41,7 @@
 #include <linux/if_vlan.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 
 #include "e1000.h"
 
diff -puN drivers/net/e1000new/manage.c~e1000new-build-fix drivers/net/e1000new/manage.c
--- a/drivers/net/e1000new/manage.c~e1000new-build-fix
+++ a/drivers/net/e1000new/manage.c
@@ -27,6 +27,7 @@
 *******************************************************************************/
 
 #include "manage.h"
+#include <linux/delay.h>
 
 /**
  *  e1000_calculate_checksum - Calculate checksum for buffer
diff -puN drivers/net/e1000new/phy.c~e1000new-build-fix drivers/net/e1000new/phy.c
--- a/drivers/net/e1000new/phy.c~e1000new-build-fix
+++ a/drivers/net/e1000new/phy.c
@@ -27,6 +27,7 @@
 *******************************************************************************/
 
 #include "phy.h"
+#include <linux/delay.h>
 
 static s32  e1000_get_phy_cfg_done(struct e1000_hw *hw);
 static void e1000_release_phy(struct e1000_hw *hw);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
ufs-printk-warning-fix.patch
i2c-ds1682-warning-fix.patch
edac-is-bust-on-mips.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
ia64-rename-partial_page.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-scsi-target-fixup.patch
git-unionfs.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
git-watchdog.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-list_head-in-binfmt-handling-fix.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
