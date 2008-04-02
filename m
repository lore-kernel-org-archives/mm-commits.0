From: akpm@linux-foundation.org
Subject: + e1000-use-netdev_alloc_skb_nowarn.patch added to -mm tree
Date: Wed, 02 Apr 2008 01:41:31 -0700
Message-ID: <200804020841.m328fVYv005351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYDBImI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 04:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, auke-jan.h.kok@intel.com, davem@davemloft.net, jeff@garzik.org, jesse.brandeburg@intel.com


The patch titled
     e1000: use netdev_alloc_skb_nowarn()
has been added to the -mm tree.  Its filename is
     e1000-use-netdev_alloc_skb_nowarn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000: use netdev_alloc_skb_nowarn()
From: Andrew Morton <akpm@linux-foundation.org>

We get rather a lot of reports of page allocation failure warnings coming out
of e1000.  But this driver is know to handle them properly so let's suppress
them.

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-use-netdev_alloc_skb_nowarn drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-use-netdev_alloc_skb_nowarn
+++ a/drivers/net/e1000/e1000_main.c
@@ -4281,7 +4281,8 @@ e1000_clean_rx_irq(struct e1000_adapter 
 		 * of reassembly being done in the stack */
 		if (length < copybreak) {
 			struct sk_buff *new_skb =
-			    netdev_alloc_skb(netdev, length + NET_IP_ALIGN);
+			    netdev_alloc_skb_nowarn(netdev,
+						length + NET_IP_ALIGN);
 			if (new_skb) {
 				skb_reserve(new_skb, NET_IP_ALIGN);
 				skb_copy_to_linear_data_offset(new_skb,
@@ -4570,7 +4571,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
 			goto map_skb;
 		}
 
-		skb = netdev_alloc_skb(netdev, bufsz);
+		skb = netdev_alloc_skb_nowarn(netdev, bufsz);
 		if (unlikely(!skb)) {
 			/* Better luck next round */
 			adapter->alloc_rx_buff_failed++;
@@ -4583,7 +4584,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
 			DPRINTK(RX_ERR, ERR, "skb align check failed: %u bytes "
 					     "at %p\n", bufsz, skb->data);
 			/* Try again, without freeing the previous */
-			skb = netdev_alloc_skb(netdev, bufsz);
+			skb = netdev_alloc_skb_nowarn(netdev, bufsz);
 			/* Failed allocation, critical failure */
 			if (!skb) {
 				dev_kfree_skb(oldskb);
@@ -4705,8 +4706,8 @@ e1000_alloc_rx_buffers_ps(struct e1000_a
 				rx_desc->read.buffer_addr[j+1] = ~cpu_to_le64(0);
 		}
 
-		skb = netdev_alloc_skb(netdev,
-		                       adapter->rx_ps_bsize0 + NET_IP_ALIGN);
+		skb = netdev_alloc_skb_nowarn(netdev,
+					adapter->rx_ps_bsize0 + NET_IP_ALIGN);
 
 		if (unlikely(!skb)) {
 			adapter->alloc_rx_buff_failed++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
git-x86-fix-printk-warning.patch
i386-arch-x86-math-emu-fpu_entryc-warning-fix.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
pm-remove-destroy_suspended_device.patch
scsi-add-iscsi-ibft-support.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
arch-ia64-kernel-use-time_-macros.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-kvm.patch
git-kvm-fixup.patch
git-kvm-vs-git-s390.patch
git-leds.patch
git-libata-fix-config_pci=n-build.patch
git-async-tx.patch
git-mips.patch
git-net.patch
net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
tulip-tulip_read_eeprom-fixes-for-bug-4420.patch
net-add-netdev_alloc_skb_nowarn.patch
e1000-use-netdev_alloc_skb_nowarn.patch
e1000e-use-netdev_alloc_skb_nowarn.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-s390-git-rejects.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-sparc64.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-fixup.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-slub-git-rejects.patch
git-semaphore-git-rejects.patch
r8169-fix-irqx-nobody-cared-for-shared-irq-with-intx-checkpatch-fixes.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-allocate-section_map-for-sparse_init-update-fix.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
arch-um-os-linux-mainc-fix-memory-leaks-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
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
clocksource-introduce-clock_monotonic_raw-fix-checkpatch-fixes.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
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
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

