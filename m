From: akpm@linux-foundation.org
Subject: - reapply-gitpowerpc-ehea-changes.patch removed from -mm tree
Date: Sat, 28 Apr 2007 02:46:10 -0700
Message-ID: <200704280946.l3S9kAAQ019112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbXD1JqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 05:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     reapply-gitpowerpc-ehea-changes
has been removed from the -mm tree.  Its filename was
     reapply-gitpowerpc-ehea-changes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: reapply-gitpowerpc-ehea-changes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |    9 ++++-----
 drivers/net/ucc_geth.c       |   18 +++++++++---------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~reapply-gitpowerpc-ehea-changes drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~reapply-gitpowerpc-ehea-changes
+++ a/drivers/net/ehea/ehea_main.c
@@ -2518,15 +2518,14 @@ static int ehea_setup_ports(struct ehea_
 {
 	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
-
-	u32 *dn_log_port_id;
+	const u32 *dn_log_port_id;
 	int port_setup_ok = 0;
 	int i = 0;
 
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = of_get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (!dn_log_port_id) {
 			ehea_error("bad device node: eth_dn name=%s",
@@ -2680,7 +2679,7 @@ static int __devinit ehea_probe_adapter(
 					const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
-	u64 *adapter_handle;
+	const u64 *adapter_handle;
 	int ret;
 
 	if (!dev || !dev->ofdev.node) {
@@ -2697,7 +2696,7 @@ static int __devinit ehea_probe_adapter(
 
 	adapter->ebus_dev = dev;
 
-	adapter_handle = (u64*)get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = of_get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
diff -puN drivers/net/ucc_geth.c~reapply-gitpowerpc-ehea-changes drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~reapply-gitpowerpc-ehea-changes
+++ a/drivers/net/ucc_geth.c
@@ -3787,7 +3787,7 @@ static int ucc_geth_probe(struct of_devi
 
 	ugeth_vdbg("%s: IN", __FUNCTION__);
 
-	prop = get_property(np, "device-id", NULL);
+	prop = of_get_property(np, "device-id", NULL);
 	ucc_num = *prop - 1;
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
@@ -3795,9 +3795,9 @@ static int ucc_geth_probe(struct of_devi
 	ug_info = &ugeth_info[ucc_num];
 	ug_info->uf_info.ucc_num = ucc_num;
 
-	prop = get_property(np, "rx-clock", NULL);
+	prop = of_get_property(np, "rx-clock", NULL);
 	ug_info->uf_info.rx_clock = *prop;
-	prop = get_property(np, "tx-clock", NULL);
+	prop = of_get_property(np, "tx-clock", NULL);
 	ug_info->uf_info.tx_clock = *prop;
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
@@ -3806,23 +3806,23 @@ static int ucc_geth_probe(struct of_devi
 	ug_info->uf_info.regs = res.start;
 	ug_info->uf_info.irq = irq_of_parse_and_map(np, 0);
 
-	ph = get_property(np, "phy-handle", NULL);
+	ph = of_get_property(np, "phy-handle", NULL);
 	phy = of_find_node_by_phandle(*ph);
 
 	if (phy == NULL)
 		return -ENODEV;
 
 	/* set the PHY address */
-	prop = get_property(phy, "reg", NULL);
+	prop = of_get_property(phy, "reg", NULL);
 	if (prop == NULL)
 		return -1;
 	ug_info->phy_address = *prop;
 
 	/* get the phy interface type, or default to MII */
-	prop = get_property(np, "interface-type", NULL);
+	prop = of_get_property(np, "interface-type", NULL);
 	if (!prop) {
 		/* handle interface property present in old trees */
-		prop = get_property(phy, "interface", NULL);
+		prop = of_get_property(phy, "interface", NULL);
 		if (prop != NULL)
 			phy_interface = enet_to_phy_interface[*prop];
 		else
@@ -3832,10 +3832,10 @@ static int ucc_geth_probe(struct of_devi
 	}
 
 	/* get speed, or derive from interface */
-	prop = get_property(np, "max-speed", NULL);
+	prop = of_get_property(np, "max-speed", NULL);
 	if (!prop) {
 		/* handle interface property present in old trees */
-		prop = get_property(phy, "interface", NULL);
+		prop = of_get_property(phy, "interface", NULL);
 		if (prop != NULL)
 			max_speed = enet_to_speed[*prop];
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
extend-print_symbol-capability.patch
add-kvasprintf.patch
add-kvasprintf-fix.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
ida-implement-idr-based-id-allocator-fix.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-gfs2-nmw.patch
git-ieee1394.patch
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
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-export-ieee80211_debug_level.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
git-net-fix-yamc.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
git-r8169.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
git-wireless.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
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
w1-build-fix.patch
