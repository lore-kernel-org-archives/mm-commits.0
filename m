From: akpm@osdl.org
Subject: - net-use-bitrev8-tidy.patch removed from -mm tree
Date: Fri, 08 Dec 2006 02:55:17 -0800
Message-ID: <200612081055.kB8AtHLa018296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425344AbWLHK5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 05:57:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, akinobu.mita@gmail.com, jgarzik@pobox.com, mlindner@syskonnect.de, paulus@samba.org, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     net-use-bitrev8-tidy
has been removed from the -mm tree.  Its filename was
     net-use-bitrev8-tidy.patch

This patch was dropped because it was folded into net-use-bitrev8.patch

------------------------------------------------------
Subject: net-use-bitrev8-tidy
From: Andrew Morton <akpm@osdl.org>

Use the API, not the array

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mirko Lindner <mlindner@syskonnect.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/skfp/drvfbi.c  |   19 +++++++++----------
 drivers/net/skfp/fplustm.c |    2 +-
 drivers/net/skfp/smt.c     |    7 +++----
 3 files changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/net/skfp/drvfbi.c~net-use-bitrev8-tidy drivers/net/skfp/drvfbi.c
--- a/drivers/net/skfp/drvfbi.c~net-use-bitrev8-tidy
+++ a/drivers/net/skfp/drvfbi.c
@@ -449,11 +449,11 @@ void read_address(struct s_smc *smc, u_c
 #if	(defined(ISA) || defined(MCA))
 	for (i = 0; i < 4 ;i++) {	/* read mac address from board */
 		smc->hw.fddi_phys_addr.a[i] =
-			byte_rev_table[(inpw(PR_A(i+SA_MAC))&0xff)] ;
+			bitrev8(inpw(PR_A(i+SA_MAC)));
 	}
 	for (i = 4; i < 6; i++) {
 		smc->hw.fddi_phys_addr.a[i] =
-			byte_rev_table[(inpw(PR_A(i+SA_MAC+PRA_OFF))&0xff)] ;
+			bitrev8(inpw(PR_A(i+SA_MAC+PRA_OFF)));
 	}
 #endif
 #ifdef	EISA
@@ -463,17 +463,17 @@ void read_address(struct s_smc *smc, u_c
 	 */
 	for (i = 0; i < 4 ;i++) {	/* read mac address from board */
 		smc->hw.fddi_phys_addr.a[i] =
-			byte_rev_table[inp(PR_A(i+SA_MAC))] ;
+			bitrev8(inp(PR_A(i+SA_MAC)));
 	}
 	for (i = 4; i < 6; i++) {
 		smc->hw.fddi_phys_addr.a[i] =
-			byte_rev_table[inp(PR_A(i+SA_MAC+PRA_OFF))] ;
+			bitrev8(inp(PR_A(i+SA_MAC+PRA_OFF)));
 	}
 #endif
 #ifdef	PCI
 	for (i = 0; i < 6; i++) {	/* read mac address from board */
 		smc->hw.fddi_phys_addr.a[i] =
-			byte_rev_table[inp(ADDR(B2_MAC_0+i))] ;
+			bitrev8(inp(ADDR(B2_MAC_0+i)));
 	}
 #endif
 #ifndef	PCI
@@ -492,7 +492,7 @@ void read_address(struct s_smc *smc, u_c
 	if (mac_addr) {
 		for (i = 0; i < 6 ;i++) {
 			smc->hw.fddi_canon_addr.a[i] = mac_addr[i] ;
-			smc->hw.fddi_home_addr.a[i] = byte_rev_table[mac_addr[i]] ;
+			smc->hw.fddi_home_addr.a[i] = bitrev8(mac_addr[i]);
 		}
 		return ;
 	}
@@ -500,7 +500,7 @@ void read_address(struct s_smc *smc, u_c
 
 	for (i = 0; i < 6 ;i++) {
 		smc->hw.fddi_canon_addr.a[i] =
-			byte_rev_table[smc->hw.fddi_phys_addr.a[i]] ;
+			bitrev8(smc->hw.fddi_phys_addr.a[i]);
 	}
 }
 
@@ -1268,9 +1268,8 @@ void driver_get_bia(struct s_smc *smc, s
 {
 	int i ;
 
-	for (i = 0 ; i < 6 ; i++) {
-		bia_addr->a[i] = byte_rev_table[smc->hw.fddi_phys_addr.a[i]] ;
-	}
+	for (i = 0 ; i < 6 ; i++)
+		bia_addr->a[i] = bitrev8(smc->hw.fddi_phys_addr.a[i]);
 }
 
 void smt_start_watchdog(struct s_smc *smc)
diff -puN drivers/net/skfp/fplustm.c~net-use-bitrev8-tidy drivers/net/skfp/fplustm.c
--- a/drivers/net/skfp/fplustm.c~net-use-bitrev8-tidy
+++ a/drivers/net/skfp/fplustm.c
@@ -1073,7 +1073,7 @@ static struct s_fpmc* mac_get_mc_table(s
 	if (can) {
 		p = own->a ;
 		for (i = 0 ; i < 6 ; i++, p++)
-			*p = byte_rev_table[*p] ;
+			*p = bitrev8(*p);
 	}
 	slot = NULL;
 	for (i = 0, tb = smc->hw.fp.mc.table ; i < FPMAX_MULTICAST ; i++, tb++){
diff -puN drivers/net/skfp/smt.c~net-use-bitrev8-tidy drivers/net/skfp/smt.c
--- a/drivers/net/skfp/smt.c~net-use-bitrev8-tidy
+++ a/drivers/net/skfp/smt.c
@@ -179,7 +179,7 @@ void smt_agent_init(struct s_smc *smc)
 	driver_get_bia(smc,&smc->mib.fddiSMTStationId.sid_node) ;
 	for (i = 0 ; i < 6 ; i ++) {
 		smc->mib.fddiSMTStationId.sid_node.a[i] =
-			byte_rev_table[smc->mib.fddiSMTStationId.sid_node.a[i]] ;
+			bitrev8(smc->mib.fddiSMTStationId.sid_node.a[i]);
 	}
 	smc->mib.fddiSMTManufacturerData[0] =
 		smc->mib.fddiSMTStationId.sid_node.a[0] ;
@@ -2048,9 +2048,8 @@ static void hwm_conv_can(struct s_smc *s
 
 	SK_UNUSED(smc) ;
 
-	for (i = len; i ; i--, data++) {
-		*data = byte_rev_table[*(u_char *)data] ;
-	}
+	for (i = len; i ; i--, data++)
+		*data = bitrev8(*data);
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
tty-signal-tty-locking.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait.patch
fsstack-introduce-fsstack_copy_attrinode_.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel.patch
add-process_session-helper-routine-deprecate-old-field.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework.patch
tty-switch-to-ktermios.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
proc_misc-build-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
pci-legacy-resource-fix-tidy.patch
git-s390.patch
s390-workqueue-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
implement-flush_work.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
bridge-avoid-using-noautorel-workqueues.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
bug-test-1.patch
net-use-bitrev8.patch
net-use-bitrev8-tidy.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
zeromap_pte_range-debug.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

