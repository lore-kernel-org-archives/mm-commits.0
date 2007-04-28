From: akpm@linux-foundation.org
Subject: - revert-gitpowerpc-ehea-changes.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:52:33 -0700
Message-ID: <200704281052.l3SAqX4X020048@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031515AbXD1Kwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     revert-gitpowerpc-ehea-changes
has been removed from the -mm tree.  Its filename was
     revert-gitpowerpc-ehea-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert-gitpowerpc-ehea-changes
From: Andrew Morton <akpm@linux-foundation.org>

Prevent git-netdev-all from throwing a megareject

Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |    8 ++++----
 drivers/net/ucc_geth.c       |   16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~revert-gitpowerpc-ehea-changes drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~revert-gitpowerpc-ehea-changes
+++ a/drivers/net/ehea/ehea_main.c
@@ -2320,7 +2320,7 @@ static int ehea_setup_single_port(struct
 	struct net_device *dev = port->netdev;
 	struct ehea_adapter *adapter = port->adapter;
 	struct hcp_ehea_port_cb4 *cb4;
-	const u32 *dn_log_port_id;
+	u32 *dn_log_port_id;
 	int jumbo = 0;
 
 	sema_init(&port->port_lock, 1);
@@ -2336,7 +2336,7 @@ static int ehea_setup_single_port(struct
 	port->of_dev_node = dn;
 
 	/* Determine logical port id */
-	dn_log_port_id = of_get_property(dn, "ibm,hea-port-no", NULL);
+	dn_log_port_id = (u32*)get_property(dn, "ibm,hea-port-no", NULL);
 
 	if (!dn_log_port_id) {
 		ehea_error("bad device node: dn_log_port_id=%p",
@@ -2492,7 +2492,7 @@ static int __devinit ehea_probe(struct i
 				const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
-	const u64 *adapter_handle;
+	u64 *adapter_handle;
 	int ret;
 
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
@@ -2502,7 +2502,7 @@ static int __devinit ehea_probe(struct i
 		goto out;
 	}
 
-	adapter_handle = of_get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = (u64*)get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
diff -puN drivers/net/ucc_geth.c~revert-gitpowerpc-ehea-changes drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~revert-gitpowerpc-ehea-changes
+++ a/drivers/net/ucc_geth.c
@@ -4080,16 +4080,16 @@ static int ucc_geth_probe(struct of_devi
 
 	ugeth_vdbg("%s: IN", __FUNCTION__);
 
-	prop = of_get_property(np, "device-id", NULL);
+	prop = get_property(np, "device-id", NULL);
 	ucc_num = *prop - 1;
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
 	ug_info = &ugeth_info[ucc_num];
 	ug_info->uf_info.ucc_num = ucc_num;
-	prop = of_get_property(np, "rx-clock", NULL);
+	prop = get_property(np, "rx-clock", NULL);
 	ug_info->uf_info.rx_clock = *prop;
-	prop = of_get_property(np, "tx-clock", NULL);
+	prop = get_property(np, "tx-clock", NULL);
 	ug_info->uf_info.tx_clock = *prop;
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
@@ -4098,15 +4098,15 @@ static int ucc_geth_probe(struct of_devi
 	ug_info->uf_info.regs = res.start;
 	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
 
-	ph = of_get_property(np, "phy-handle", NULL);
+	ph = get_property(np, "phy-handle", NULL);
 	phy = of_find_node_by_phandle(*ph);
 
 	if (phy == NULL)
 		return -ENODEV;
 
-	prop = of_get_property(phy, "reg", NULL);
+	prop = get_property(phy, "reg", NULL);
 	ug_info->phy_address = *prop;
-	prop = of_get_property(phy, "interface", NULL);
+	prop = get_property(phy, "interface", NULL);
 	ug_info->enet_interface = *prop;
 	ug_info->phy_interrupt = irq_of_parse_and_map(phy, 0);
 	ug_info->board_flags = (ug_info->phy_interrupt == NO_IRQ)?
@@ -4127,7 +4127,7 @@ static int ucc_geth_probe(struct of_devi
 	/* timing.						*/
 	/* The following compensates by writing to the reserved */
 	/* QE Port Output Hold Registers (CPOH1?).              */
-	prop = of_get_property(phy, "interface", NULL);
+	prop = get_property(phy, "interface", NULL);
 	phy_interface = *prop;
 	if ((phy_interface == ENET_1000_RGMII) ||
 			(phy_interface == ENET_100_RGMII) ||
@@ -4140,7 +4140,7 @@ static int ucc_geth_probe(struct of_devi
 		soc = of_find_node_by_type(NULL, "soc");
 		if (soc) {
 			unsigned int size;
-			const void *prop = of_get_property(soc, "reg", &size);
+			const void *prop = get_property(soc, "reg", &size);
 			immrbase = of_translate_address(soc, prop);
 			of_node_put(soc);
 		};
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
extend-print_symbol-capability.patch
add-kvasprintf.patch
add-kvasprintf-fix.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
git-powerpc-fixup.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-fixup.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-jfs.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-netdev-all.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-kconfig-update.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
utimensat-implementation-fix.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
git-gccbug-fixup.patch
w1-build-fix.patch
