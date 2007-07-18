From: akpm@linux-foundation.org
Subject: + drivers-edac-new-i82975x-driver-fix.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:32:51 -0700
Message-ID: <200707180032.l6I0WppR015661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbXGRAdo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:33:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, apw@shadowen.org, arvind@acarlab.com, dougthompson@xmission.com, greg@kroah.com, rdeskan@jetzbroadband.com


The patch titled
     drivers-edac-new-i82975x-driver-fix
has been added to the -mm tree.  Its filename is
     drivers-edac-new-i82975x-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac-new-i82975x-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

multiple coding-style bloopers, all of which checkpatch missed.

Cc: <arvind@acarlab.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ranganathan Desikan <rdeskan@jetzbroadband.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82975x_edac.c |  111 ++++++++++++++++------------------
 1 files changed, 55 insertions(+), 56 deletions(-)

diff -puN drivers/edac/i82975x_edac.c~drivers-edac-new-i82975x-driver-fix drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c~drivers-edac-new-i82975x-driver-fix
+++ a/drivers/edac/i82975x_edac.c
@@ -230,7 +230,7 @@ static const struct i82975x_dev_info i82
 	},
 };
 
-static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code has
+static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
 					 * already registered driver
 					 */
 
@@ -330,20 +330,19 @@ static int dual_channel_active(void __io
 	 * bit-0 will resolve ok in symmetric area of mixed
 	 * (symmetric/asymmetric) configurations
 	 */
-	u8	drb[ 4 ][ 2 ];
+	u8	drb[4][2];
 	int	row;
 	int    dualch;
 
-	for (dualch = 1, row = 0; dualch && ( row < 4 ); row++) {
-		drb[ row ][ 0 ] = readb( mch_window + I82975X_DRB + row);
-		drb[ row ][ 1 ] = readb( mch_window + I82975X_DRB + row + 0x80);
-		dualch = dualch && ( drb[ row ][ 0 ] == drb[ row ][ 1 ] );
+	for (dualch = 1, row = 0; dualch && (row < 4); row++) {
+		drb[row][0] = readb(mch_window + I82975X_DRB + row);
+		drb[row][1] = readb(mch_window + I82975X_DRB + row + 0x80);
+		dualch = dualch && (drb[row][0] == drb[row][1]);
 	}
 	return dualch;
 }
 
-static enum dev_type i82975x_dram_type(void __iomem *mch_window,
-	int rank)
+static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
 {
 	/*
 	 * ASUS P5W DH either does not program this register or programs
@@ -404,7 +403,7 @@ static void i82975x_init_csrows(struct m
 
 /* #define  i82975x_DEBUG_IOMEM */
 
-#ifdef  i82975x_DEBUG_IOMEM
+#ifdef i82975x_DEBUG_IOMEM
 static void i82975x_print_dram_timings(void __iomem *mch_window)
 {
 	/*
@@ -413,24 +412,24 @@ static void i82975x_print_dram_timings(v
 	 * Asus P5W Bios reports 15-5-4-4
 	 * What's your religion?
 	 */
-	static const int caslats[ 4 ] = { 5, 4, 3, 6 };
-	u32	dtreg[ 2 ];
+	static const int caslats[4] = { 5, 4, 3, 6 };
+	u32	dtreg[2];
 
-	dtreg[ 0 ] = readl( mch_window + 0x114 );
-	dtreg[ 1 ] = readl( mch_window + 0x194 );
+	dtreg[0] = readl(mch_window + 0x114);
+	dtreg[1] = readl(mch_window + 0x194);
 	i82975x_printk(KERN_INFO, "DRAM Timings :     Ch0    Ch1\n"
 		"                RAS Active Min = %d     %d\n"
 		"                CAS latency    =  %d      %d\n"
 		"                RAS to CAS     =  %d      %d\n"
 		"                RAS precharge  =  %d      %d\n",
-		( dtreg[ 0 ] >> 19 ) & 0x0f,
-			( dtreg[ 1 ] >> 19 ) & 0x0f,
-		caslats[ ( dtreg[ 0 ] >> 8 ) & 0x03 ],
-			caslats[ ( dtreg[ 1 ] >> 8 ) & 0x03 ],
-		( ( dtreg[ 0 ] >> 4 ) & 0x07 ) + 2,
-			( ( dtreg[ 1 ] >> 4 ) & 0x07 ) + 2,
-		( dtreg[ 0 ] & 0x07 ) + 2,
-			( dtreg[ 1 ] & 0x07 ) + 2
+		(dtreg[0] >> 19 ) & 0x0f,
+			(dtreg[1] >> 19) & 0x0f,
+		caslats[(dtreg[0] >> 8) & 0x03],
+			caslats[(dtreg[1] >> 8) & 0x03],
+		((dtreg[0] >> 4) & 0x07) + 2,
+			((dtreg[1] >> 4) & 0x07) + 2,
+		(dtreg[0] & 0x07) + 2,
+			(dtreg[1] & 0x07) + 2
 	);
 
 }
@@ -443,72 +442,72 @@ static int i82975x_probe1(struct pci_dev
 	struct i82975x_pvt *pvt;
 	void __iomem *mch_window;
 	u32 mchbar;
-	u32 drc[ 2 ];
+	u32 drc[2];
 	struct i82975x_error_info discard;
 	int	chans;
 #ifdef i82975x_DEBUG_IOMEM
-	u8 c0drb[ 4 ];
-	u8 c1drb[ 4 ];
+	u8 c0drb[4];
+	u8 c1drb[4];
 #endif
 
 	debugf0("%s()\n", __func__);
 
 	pci_read_config_dword(pdev, I82975X_MCHBAR, &mchbar);
-	if (!(mchbar & 1 )) {
+	if (!(mchbar & 1)) {
 		debugf3("%s(): failed, MCHBAR disabled!\n", __func__);
 		goto fail0;
 	}
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
-	mch_window = ioremap_nocache( mchbar, 0x1000 );
+	mch_window = ioremap_nocache(mchbar, 0x1000);
 
 #ifdef i82975x_DEBUG_IOMEM
 	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
 					mchbar, mch_window);
 
-	c0drb[ 0 ] = readb( mch_window + I82975X_DRB_CH0R0);
-	c0drb[ 1 ] = readb( mch_window + I82975X_DRB_CH0R1);
-	c0drb[ 2 ] = readb( mch_window + I82975X_DRB_CH0R2);
-	c0drb[ 3 ] = readb( mch_window + I82975X_DRB_CH0R3);
-	c1drb[ 0 ] = readb( mch_window + I82975X_DRB_CH1R0);
-	c1drb[ 1 ] = readb( mch_window + I82975X_DRB_CH1R1);
-	c1drb[ 2 ] = readb( mch_window + I82975X_DRB_CH1R2);
-	c1drb[ 3 ] = readb( mch_window + I82975X_DRB_CH1R3);
-	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", c0drb[ 0 ]);
-	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", c0drb[ 1 ]);
-	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", c0drb[ 2 ]);
-	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n", c0drb[ 3 ]);
-	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", c1drb[ 0 ]);
-	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", c1drb[ 1 ]);
-	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", c1drb[ 2 ]);
-	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", c1drb[ 3 ]);
+	c0drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
+	c0drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
+	c0drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
+	c0drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
+	c1drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
+	c1drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
+	c1drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
+	c1drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
+	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", c0drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", c0drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", c0drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n", c0drb[3]);
+	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", c1drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", c1drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", c1drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", c1drb[3]);
 #endif
 
-	drc[ 0 ] = readl( mch_window + I82975X_DRC_CH0M0 );
-	drc[ 1 ] = readl( mch_window + I82975X_DRC_CH1M0 );
+	drc[0] = readl(mch_window + I82975X_DRC_CH0M0);
+	drc[1] = readl(mch_window + I82975X_DRC_CH1M0);
 #ifdef i82975x_DEBUG_IOMEM
-	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[ 0 ],
-			( ( drc[ 0 ] >> 21 ) & 3 ) == 1 ?
-				"ECC enabled" : "ECC disabled" );
-	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[ 1 ],
-			( ( drc[ 1 ] >> 21 ) & 3 ) == 1 ?
-				"ECC enabled" : "ECC disabled" );
+	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
+			((drc[0] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
+			((drc[1] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
 
 	i82975x_printk(KERN_INFO, "C0 BNKARC = %0x\n",
-		readw( mch_window + I82975X_C0BNKARC ) );
+		readw(mch_window + I82975X_C0BNKARC));
 	i82975x_printk(KERN_INFO, "C1 BNKARC = %0x\n",
-		readw( mch_window + I82975X_C1BNKARC ) );
-	i82975x_print_dram_timings( mch_window );
+		readw(mch_window + I82975X_C1BNKARC));
+	i82975x_print_dram_timings(mch_window);
 	goto fail1;
 #endif
-	if (!(((drc[ 0 ] >> 21) & 3) == 1 || ((drc[ 1 ] >> 21) & 3) == 1 )) {
+	if (!(((drc[0] >> 21) & 3) == 1 || ((drc[1] >> 21) & 3) == 1)) {
 		i82975x_printk(KERN_INFO, "ECC disabled on both channels.\n");
 		goto fail1;
 	}
 
-	chans = dual_channel_active( mch_window ) + 1;
+	chans = dual_channel_active(mch_window) + 1;
 
 	/* assuming only one controller, index thus is 0 */
-	mci = edac_mc_alloc(sizeof(*pvt), I82975X_NR_CSROWS( chans ),
+	mci = edac_mc_alloc(sizeof(*pvt), I82975X_NR_CSROWS(chans),
 					chans, 0);
 	if (!mci) {
 		rc = -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-dvb-saa7134-tvaudio-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
git-watchdog.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-show-unhandled-signals.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
file-capabilities-clear-caps-cleanup-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
