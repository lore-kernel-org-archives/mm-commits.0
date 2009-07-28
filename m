From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 Jul 2009 12:26:27 -0700
Message-ID: <200907281926.n6SJQRs9019460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbZG1T03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 15:26:29 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n6SJQRYV003964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2009 12:26:28 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/b2c2/flexcop-fe-tuner.c |   64 --------------------
 drivers/usb/serial/usb-serial.c           |    4 -
 2 files changed, 68 deletions(-)

diff -puN drivers/media/dvb/b2c2/flexcop-fe-tuner.c~linux-next-git-rejects drivers/media/dvb/b2c2/flexcop-fe-tuner.c
--- a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c~linux-next-git-rejects
+++ a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
@@ -66,11 +66,7 @@ static int flexcop_sleep(struct dvb_fron
 #endif
 
 /* SkyStar2 DVB-S rev 2.3 */
-<<<<<<< HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
 #if FE_SUPPORTED(MT312)
-=======
-#if FE_SUPPORTED(MT312) && FE_SUPPORTED(PLL)
->>>>>>> FETCH_HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
 static int flexcop_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 {
 /* u16 wz_half_period_for_45_mhz[] = { 0x01ff, 0x0154, 0x00ff, 0x00cc }; */
@@ -186,11 +182,7 @@ static int skystar2_rev23_attach(struct 
 #endif
 
 /* SkyStar2 DVB-S rev 2.6 */
-<<<<<<< HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
-#if FE_SUPPORTED(STV0299)
-=======
 #if FE_SUPPORTED(STV0299) && FE_SUPPORTED(PLL)
->>>>>>> FETCH_HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
 static int samsung_tbmu24112_set_symbol_rate(struct dvb_frontend *fe,
 	u32 srate, u32 ratio)
 {
@@ -414,11 +406,7 @@ static int skystar2_rev28_attach(struct 
 #endif
 
 /* AirStar DVB-T */
-<<<<<<< HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
-#if FE_SUPPORTED(MT352)
-=======
 #if FE_SUPPORTED(MT352) && FE_SUPPORTED(PLL)
->>>>>>> FETCH_HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
 static int samsung_tdtc9251dh0_demod_init(struct dvb_frontend *fe)
 {
 	static u8 mt352_clock_config[] = { 0x89, 0x18, 0x2d };
@@ -523,58 +511,6 @@ static int airstar_atsc3_attach(struct f
 #endif
 
 /* CableStar2 DVB-C */
-<<<<<<< HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
-#if FE_SUPPORTED(STV0297)
-static int alps_tdee4_stv0297_tuner_set_params(struct dvb_frontend* fe,
-		struct dvb_frontend_parameters *fep)
-{
-	struct flexcop_device *fc = fe->dvb->priv;
-	u8 buf[4];
-	u16 div;
-	int ret;
-
-/* 62.5 kHz * 10 */
-#define REF_FREQ    625
-#define FREQ_OFFSET 36125
-
-	div = ((fep->frequency/1000 + FREQ_OFFSET) * 10) / REF_FREQ;
-/* 4 MHz = 4000 KHz */
-
-	buf[0] = (u8)( div >> 8) & 0x7f;
-	buf[1] = (u8)        div & 0xff;
-
-/* F(osc) = N * Reference Freq. (62.5 kHz)
- * byte 2 :  0 N14 N13 N12 N11 N10 N9  N8
- * byte 3 : N7 N6  N5  N4  N3  N2  N1  N0
- * byte 4 : 1  *   *   AGD R3  R2  R1  R0
- * byte 5 : C1 *   RE  RTS BS4 BS3 BS2 BS1
- * AGD = 1, R3 R2 R1 R0 = 0 1 0 1 => byte 4 = 1**10101 = 0x95 */
-	buf[2] = 0x95;
-
-/* Range(MHz)  C1 *  RE RTS BS4 BS3 BS2 BS1  Byte 5
- *  47 - 153   0  *  0   0   0   0   0   1   0x01
- * 153 - 430   0  *  0   0   0   0   1   0   0x02
- * 430 - 822   0  *  0   0   1   0   0   0   0x08
- * 822 - 862   1  *  0   0   1   0   0   0   0x88 */
-
-	     if (fep->frequency <= 153000000) buf[3] = 0x01;
-	else if (fep->frequency <= 430000000) buf[3] = 0x02;
-	else if (fep->frequency <= 822000000) buf[3] = 0x08;
-	else buf[3] = 0x88;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-	deb_tuner("tuner buffer for %d Hz: %x %x %x %x\n", fep->frequency,
-	buf[0], buf[1], buf[2], buf[3]);
-	ret = fc->i2c_request(&fc->fc_i2c_adap[2],
-			FC_WRITE, 0x61, buf[0], &buf[1], 3);
-	deb_tuner("tuner write returned: %d\n",ret);
-	return ret;
-}
-
-=======
-#if FE_SUPPORTED(STV0297) && FE_SUPPORTED(PLL)
->>>>>>> FETCH_HEAD:drivers/media/dvb/b2c2/flexcop-fe-tuner.c
 static u8 alps_tdee4_stv0297_inittab[] = {
 	0x80, 0x01,
 	0x80, 0x00,
diff -puN drivers/usb/serial/usb-serial.c~linux-next-git-rejects drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~linux-next-git-rejects
+++ a/drivers/usb/serial/usb-serial.c
@@ -347,11 +347,7 @@ static void serial_close(struct tty_stru
 	*/
 	if (tty_hung_up_p(filp)) {
 		/* serial_hangup already called serial_down at this point.
-<<<<<<< HEAD:drivers/usb/serial/usb-serial.c
-		   Another user may have already reopened the port but
-=======
 		   Another user may have already reopened the port but 
->>>>>>> FETCH_HEAD:drivers/usb/serial/usb-serial.c
 		   serial_do_free is refcounted */
 		serial_do_free(port);
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
watchdog-add-sbc-fitpc2-watchdog-driver-fix.patch
lib-flexible-array-implementation-checkpatch-fixes.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use-checkpatch-fixes.patch
fatfs-use-common-localtime-gmtime-in-fat_time_unix2fat-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

