From: akpm@linux-foundation.org
Subject: - pci-hotplug-introduce-pci_slot-fix.patch removed from -mm tree
Date: Wed, 16 Apr 2008 12:49:49 -0700
Message-ID: <200804161949.m3GJnou1003747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbYDPTuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 15:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, achiang@hp.com, greg@kroah.com, kaneshige.kenji@jp.fujitsu.com, kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     pci-hotplug-introduce-pci_slot-fix
has been removed from the -mm tree.  Its filename was
     pci-hotplug-introduce-pci_slot-fix.patch

This patch was dropped because it was folded into pci-hotplug-introduce-pci_slot.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-hotplug-introduce-pci_slot-fix
From: Andrew Morton <akpm@linux-foundation.org>

Please, see Documentation/SubmitChecklist?

In file included from arch/x86/kernel/quirks.c:4:
include/linux/pci.h:28: error: field 'list' has incomplete type
include/linux/pci.h:31: error: field 'kobj' has incomplete type

Cc: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
DESC
pci-hotplug-introduce-pci_slot-fix-fix
EDESC

make headers_check happy.

Cc: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
DESC
pci-hotplug-introduce-pci_slot-fix-2
EDESC

drivers/pci/slot.c: In function 'pci_create_slot':
drivers/pci/slot.c:90: error: implicit declaration of function 'ERR_PTR'
drivers/pci/slot.c:90: warning: assignment makes pointer from integer without a cast
drivers/pci/slot.c:116: warning: assignment makes pointer from integer without a cast

Cc: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
DESC
pci-hotplug-introduce-pci_slot-fix-99
EDESC

this patch was a bit of a fiasco.

Cc: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
DESC
remove rpaphp 'address_read_file'
EDESC

Physical pci_slot removed ->get_address methods from individual
PCI hotplug drivers, but overlooked rpaphp, causing build errors.

Remove rpaphp's 'address_read_file' as well.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpadlpar_sysfs.c |    2 -
 drivers/pci/hotplug/rpaphp_slot.c    |   37 -------------------------
 drivers/pci/slot.c                   |    1 
 include/linux/pci.h                  |   22 +++++++-------
 4 files changed, 13 insertions(+), 49 deletions(-)

diff -puN include/linux/pci.h~pci-hotplug-introduce-pci_slot-fix include/linux/pci.h
--- a/include/linux/pci.h~pci-hotplug-introduce-pci_slot-fix
+++ a/include/linux/pci.h
@@ -17,20 +17,10 @@
 #ifndef LINUX_PCI_H
 #define LINUX_PCI_H
 
-/* Include the pci register defines */
-#include <linux/pci_regs.h>
+#include <linux/pci_regs.h>	/* The pci register defines */
 
 struct pci_vpd;
 
-/* pci_slot represents a physical slot */
-struct pci_slot {
-	struct pci_bus *bus;		/* The bus this slot is on */
-	struct list_head list;		/* node in list of slots on this bus */
-	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
-	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
-	struct kobject kobj;
-};
-
 /*
  * The PCI interface treats multi-function devices as independent
  * devices.  The slot/function address of each device is encoded
@@ -59,12 +49,22 @@ struct pci_slot {
 #include <linux/list.h>
 #include <linux/compiler.h>
 #include <linux/errno.h>
+#include <linux/kobject.h>
 #include <asm/atomic.h>
 #include <linux/device.h>
 
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+/* pci_slot represents a physical slot */
+struct pci_slot {
+	struct pci_bus *bus;		/* The bus this slot is on */
+	struct list_head list;		/* node in list of slots on this bus */
+	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
+	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
+	struct kobject kobj;
+};
+
 /* File state for mmap()s on /proc/bus/pci/X/Y */
 enum pci_mmap_state {
 	pci_mmap_io,
diff -puN drivers/pci/slot.c~pci-hotplug-introduce-pci_slot-fix drivers/pci/slot.c
--- a/drivers/pci/slot.c~pci-hotplug-introduce-pci_slot-fix
+++ a/drivers/pci/slot.c
@@ -7,6 +7,7 @@
 
 #include <linux/kobject.h>
 #include <linux/pci.h>
+#include <linux/err.h>
 #include "pci.h"
 
 struct kset *pci_slots_kset;
diff -puN drivers/pci/hotplug/rpadlpar_sysfs.c~pci-hotplug-introduce-pci_slot-fix drivers/pci/hotplug/rpadlpar_sysfs.c
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~pci-hotplug-introduce-pci_slot-fix
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -17,7 +17,7 @@
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include "rpadlpar.h"
-#include "../pcih."
+#include "../pci.h"
 
 #define DLPAR_KOBJ_NAME       "control"
 #define ADD_SLOT_ATTR_NAME    "add_slot"
diff -puN drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-fix drivers/pci/hotplug/rpaphp_slot.c
--- a/drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-fix
+++ a/drivers/pci/hotplug/rpaphp_slot.c
@@ -33,33 +33,6 @@
 #include <asm/rtas.h>
 #include "rpaphp.h"
 
-static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
-{
-	int retval;
-	struct slot *slot = (struct slot *)php_slot->private;
-	struct pci_bus *bus;
-
-	if (!slot)
-		return -ENOENT;
-
-	bus = slot->bus;
-	if (!bus)
-		return -ENOENT;
-
-	if (bus->self)
-		retval = sprintf(buf, pci_name(bus->self));
-	else
-		retval = sprintf(buf, "%04x:%02x:00.0",
-		        pci_domain_nr(bus), bus->number);
-
-	return retval;
-}
-
-static struct hotplug_slot_attribute php_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 /* free up the memory used by a slot */
 static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 {
@@ -135,9 +108,6 @@ int rpaphp_deregister_slot(struct slot *
 
 	list_del(&slot->rpaphp_slot_list);
 	
-	/* remove "address" file */
-	sysfs_remove_file(&php_slot->kobj, &php_attr_address.attr);
-
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
 		err("Problem unregistering a slot %s\n", slot->name);
@@ -169,13 +139,6 @@ int rpaphp_register_slot(struct slot *sl
 		return retval;
 	}
 
-	/* create "address" file */
-	retval = sysfs_create_file(&php_slot->kobj, &php_attr_address.attr);
-	if (retval) {
-		err("sysfs_create_file failed with error %d\n", retval);
-		goto sysfs_fail;
-	}
-
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
 	info("Slot [%s] registered\n", slot->name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
disable-the-memory-controller-by-default-v3-fix.patch
hotplug-memory-make-online_page-common-fix.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
arch-x86-video-fbdevc-add-module_license.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
git-input.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-leds.patch
git-libata-all.patch
pata_atiixp-simplex-clear-fix.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
smc911x-test-after-postfix-decrement-fails-in-smc911x_resetdrop_pkt-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sched-git-rejects.patch
add-rcu_assign_index-if-ever-needed.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
topologyc-revert-git-s390-changes.patch
topologyc-revert-git-s390-changes-fix.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

