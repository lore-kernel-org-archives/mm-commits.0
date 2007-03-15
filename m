From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-rs5c313-driver-tidy.patch added to -mm tree
Date: Thu, 15 Mar 2007 13:53:35 -0700
Message-ID: <200703152053.l2FKrZO5026228@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbXCOUxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 16:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, iwamatsu@nigauri.org


The patch titled
     rtc-add-rtc-rs5c313-driver-tidy
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-rs5c313-driver-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
software-suspend-fix-suspend-when-console-is-in-tidy.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-tidy.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
