From: akpm@linux-foundation.org
Subject: - rtc-add-rtc-rs5c313-driver-tidy.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:35:23 -0700
Message-ID: <200704301935.l3UJZOwF013043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946662AbXD3TgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, iwamatsu@nigauri.org, mm-commits@vger.kernel.org


The patch titled
     rtc-add-rtc-rs5c313-driver-tidy
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-rs5c313-driver-tidy.patch

This patch was dropped because it was folded into rtc-add-rtc-rs5c313-driver.patch

------------------------------------------------------
Subject: rtc-add-rtc-rs5c313-driver-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Zillions of coding-style fixes.  Please retest it.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |   95 +++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 49 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-rs5c313-driver-tidy drivers/rtc/Kconfig
diff -puN drivers/rtc/Makefile~rtc-add-rtc-rs5c313-driver-tidy drivers/rtc/Makefile
diff -puN drivers/rtc/rtc-rs5c313.c~rtc-add-rtc-rs5c313-driver-tidy drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-add-rtc-rs5c313-driver-tidy
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -100,14 +100,14 @@ static void rs5c313_init_port(void)
 
 static void rs5c313_write_data(unsigned char data)
 {
-	int i = 0;
+	int i;
 
-	for(i = 0; i < 8; i++){
+	for (i = 0; i < 8; i++) {
 		/* SDA:Write Data */
-		scsptr1_data = (scsptr1_data & ~SDA)
-		    | ((((0x80 >> i) & data) >> (7 - i)) << 2);
+		scsptr1_data = (scsptr1_data & ~SDA) |
+				((((0x80 >> i) & data) >> (7 - i)) << 2);
 		ctrl_outb(scsptr1_data, SCSPTR1);
-		if(i == 0){
+		if (i == 0) {
 			scsptr1_data |= SDA_OEN;	/* SDA:output enable */
 			ctrl_outb(scsptr1_data, SCSPTR1);
 		}
@@ -121,15 +121,14 @@ static void rs5c313_write_data(unsigned 
 
 	scsptr1_data &= ~SDA_OEN;	/* SDA:output disable */
 	ctrl_outb(scsptr1_data, SCSPTR1);
-
 }
 
 static unsigned char rs5c313_read_data(void)
 {
 	int i;
-	unsigned char data = 0;
+	unsigned char data;
 
-	for(i = 0; i < 8; i++){
+	for (i = 0; i < 8; i++) {
 		ndelay(700);
 		/* SDA:Read Data */
 		data |= ((ctrl_inb(SCSPTR1) & SDA) >> 2) << (7 - i);
@@ -185,7 +184,6 @@ static unsigned char rs5c313_read_reg(un
 
 	rs5c313_write_data(addr | RS5C313_CNTBIT_READ | RS5C313_CNTBIT_AD);
 	return rs5c313_read_data();
-
 }
 
 static void rs5c313_write_reg(unsigned char addr, unsigned char data)
@@ -196,23 +194,33 @@ static void rs5c313_write_reg(unsigned c
 	return;
 }
 
-#define rs5c313_read_cntreg()		rs5c313_read_reg(RS5C313_ADDR_CNTREG)
-#define rs5c313_write_cntreg(data)	rs5c313_write_reg(RS5C313_ADDR_CNTREG,data)
-#define rs5c313_write_intintvreg(data)	rs5c313_write_reg(RS5C313_ADDR_INTINTVREG,data)
+static inline unsigned char rs5c313_read_cntreg(unsigned char addr)
+{
+	return rs5c313_read_reg(RS5C313_ADDR_CNTREG);
+}
+
+static inline void rs5c313_write_cntreg(unsigned char data)
+{
+	rs5c313_write_reg(RS5C313_ADDR_CNTREG, data);
+}
+
+static inline void rs5c313_write_intintvreg(unsigned char data)
+{
+	rs5c313_write_reg(RS5C313_ADDR_INTINTVREG, data);
+}
 
 static int rs5c313_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	int data = 0;
+	int data;
 
-	while( 1 ){
+	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */
 
 		/* Initialize control reg. 24 hour */
 		rs5c313_write_cntreg(0x04);
 
-		if(!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY)){
+		if (!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY))
 			break;
-		}
 
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */
@@ -242,9 +250,9 @@ static int rs5c313_rtc_read_time(struct 
 	data = rs5c313_read_reg(RS5C313_ADDR_YEAR);
 	data |= (rs5c313_read_reg(RS5C313_ADDR_YEAR10) << 4);
 	tm->tm_year = BCD2BIN(data);
-	if(tm->tm_year < 70){
+
+	if (tm->tm_year < 70)
 		tm->tm_year += 100;
-	}
 
 	data = rs5c313_read_reg(RS5C313_ADDR_WEEK);
 	tm->tm_wday = BCD2BIN(data);
@@ -257,19 +265,17 @@ static int rs5c313_rtc_read_time(struct 
 
 static int rs5c313_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
-
-	int data = 0;
+	int data;
 
 	/* busy check. */
-	while( 1 ){
+	while (1) {
 		RS5C313_CEENABLE;	/* CE:H */
 
 		/* Initiatlize control reg. 24 hour */
 		rs5c313_write_cntreg(0x04);
 
-		if (!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY)){
+		if (!(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY))
 			break;
-		}
 		RS5C313_MISCOP;
 		RS5C313_CEDISABLE;
 		ndelay(700);	/* CE:L */
@@ -313,29 +319,26 @@ static void rs5c313_check_xstp_bit(void)
 	struct rtc_time tm;
 
 	RS5C313_CEENABLE;	/* CE:H */
-	if(rs5c313_read_cntreg() & RS5C313_CNTREG_WTEN_XSTP){
+	if (rs5c313_read_cntreg() & RS5C313_CNTREG_WTEN_XSTP) {
 		/* INT interval reg. OFF */
 		rs5c313_write_intintvreg(0x00);
 		/* Initialize control reg. 24 hour & adjust */
 		rs5c313_write_cntreg(0x07);
 
 		/* busy check. */
-		while(rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY){
+		while (rs5c313_read_cntreg() & RS5C313_CNTREG_ADJ_BSY)
 			RS5C313_MISCOP;
-		}
 
-		memset( &tm , 0 , sizeof( struct rtc_time ));
+		memset(&tm, 0, sizeof(struct rtc_time));
 		tm.tm_mday 	= 1;
 		tm.tm_mon 	= 1;
 
 		rs5c313_rtc_set_time(NULL, &tm);
-		printk(KERN_ERR
-		       "RICHO RS5C313: invalid value, resetting to 1 Jan 2000\n");
-
+		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
+				"1 Jan 2000\n");
 	}
 	RS5C313_CEDISABLE;
 	ndelay(700);		/* CE:L */
-
 }
 
 static const struct rtc_class_ops rs5c313_rtc_ops = {
@@ -345,27 +348,22 @@ static const struct rtc_class_ops rs5c31
 
 static int rs5c313_rtc_probe(struct platform_device *pdev)
 {
-	int err = 0 ;
-	struct rtc_device *rtc
-		= rtc_device_register("rs5c313",
-				&pdev->dev,
-				&rs5c313_rtc_ops,
-				THIS_MODULE);
-	if(IS_ERR( rtc )){
-		err = PTR_ERR( rtc );
-		return err;
-	}
+	struct rtc_device *rtc = rtc_device_register("rs5c313", &pdev->dev,
+				&rs5c313_rtc_ops, THIS_MODULE);
 
-	platform_set_drvdata( pdev, rtc );
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
-	return err ;
+	platform_set_drvdata(pdev, rtc);
+
+	return err;
 }
 
 static int __devexit rs5c313_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata( pdev );
 
-	rtc_device_unregister( rtc );
+	rtc_device_unregister(rtc);
 
 	return 0;
 }
@@ -381,16 +379,16 @@ static struct platform_driver rs5c313_rt
 
 static int __init rs5c313_rtc_init(void)
 {
-	int err = 0;
+	int err;
 
-	if((err = platform_driver_register( &rs5c313_rtc_platform_driver ))){
+	err = platform_driver_register(&rs5c313_rtc_platform_driver);
+	if (err)
 		return err;
-	}
 
 	rs5c313_init_port();
 	rs5c313_check_xstp_bit();
 
-	return err;
+	return 0;
 }
 
 static void __exit rs5c313_rtc_exit(void)
@@ -405,4 +403,3 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR("kogiidena , Nobuhiro Iwamatsu <iwamatsu@nigauri.org>");
 MODULE_DESCRIPTION("Ricoh RS5C313 RTC device driver");
 MODULE_LICENSE("GPL");
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zlib-backout.patch
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
i386-__inquire_remote_apic-printk-warning-fix.patch
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
mm-optimize-kill_bdev.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
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
