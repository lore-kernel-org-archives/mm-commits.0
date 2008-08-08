From: akpm@linux-foundation.org
Subject: + cris-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:39:49 -0700
Message-ID: <200808082139.m78Ldn5L029801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbYHHVkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, zankel@tensilica.com


The patch titled
     cris: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     cris-use-bcd2bin-bin2bcd.patch

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
Subject: cris: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change cris to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Chris Zankel <zankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/ds1302.c  |   24 ++++++++++++------------
 arch/cris/arch-v10/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/arch-v32/drivers/pcf8563.c |   24 ++++++++++++------------
 arch/cris/kernel/time.c              |   18 +++++++++---------
 4 files changed, 45 insertions(+), 45 deletions(-)

diff -puN arch/cris/arch-v10/drivers/ds1302.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v10/drivers/ds1302.c
--- a/arch/cris/arch-v10/drivers/ds1302.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v10/drivers/ds1302.c
@@ -215,12 +215,12 @@ get_rtc_time(struct rtc_time *rtc_tm) 
 
 	local_irq_restore(flags);
 	
-	BCD_TO_BIN(rtc_tm->tm_sec);
-	BCD_TO_BIN(rtc_tm->tm_min);
-	BCD_TO_BIN(rtc_tm->tm_hour);
-	BCD_TO_BIN(rtc_tm->tm_mday);
-	BCD_TO_BIN(rtc_tm->tm_mon);
-	BCD_TO_BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
@@ -295,12 +295,12 @@ rtc_ioctl(struct inode *inode, struct fi
 			else
 				yrs -= 1900;	/* RTC (70, 71, ... 99) */
 
-			BIN_TO_BCD(sec);
-			BIN_TO_BCD(min);
-			BIN_TO_BCD(hrs);
-			BIN_TO_BCD(day);
-			BIN_TO_BCD(mon);
-			BIN_TO_BCD(yrs);
+			sec = bin2bcd(sec);
+			min = bin2bcd(min);
+			hrs = bin2bcd(hrs);
+			day = bin2bcd(day);
+			mon = bin2bcd(mon);
+			yrs = bin2bcd(yrs);
 
 			local_irq_save(flags);
 			CMOS_WRITE(yrs, RTC_YEAR);
diff -puN arch/cris/arch-v10/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v10/drivers/pcf8563.c
--- a/arch/cris/arch-v10/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v10/drivers/pcf8563.c
@@ -122,7 +122,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -131,11 +131,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -282,12 +282,12 @@ int pcf8563_ioctl(struct inode *inode, s
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff -puN arch/cris/arch-v32/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/arch-v32/drivers/pcf8563.c
@@ -118,7 +118,7 @@ get_rtc_time(struct rtc_time *tm)
 		       "information is no longer guaranteed!\n", PCF8563_NAME);
 	}
 
-	tm->tm_year  = BCD_TO_BIN(tm->tm_year) +
+	tm->tm_year  = bcd2bin(tm->tm_year) +
 		       ((tm->tm_mon & 0x80) ? 100 : 0);
 	tm->tm_sec  &= 0x7F;
 	tm->tm_min  &= 0x7F;
@@ -127,11 +127,11 @@ get_rtc_time(struct rtc_time *tm)
 	tm->tm_wday &= 0x07; /* Not coded in BCD. */
 	tm->tm_mon  &= 0x1F;
 
-	BCD_TO_BIN(tm->tm_sec);
-	BCD_TO_BIN(tm->tm_min);
-	BCD_TO_BIN(tm->tm_hour);
-	BCD_TO_BIN(tm->tm_mday);
-	BCD_TO_BIN(tm->tm_mon);
+	tm->tm_sec = bcd2bin(tm->tm_sec);
+	tm->tm_min = bcd2bin(tm->tm_min);
+	tm->tm_hour = bcd2bin(tm->tm_hour);
+	tm->tm_mday = bcd2bin(tm->tm_mday);
+	tm->tm_mon = bcd2bin(tm->tm_mon);
 	tm->tm_mon--; /* Month is 1..12 in RTC but 0..11 in linux */
 }
 
@@ -279,12 +279,12 @@ int pcf8563_ioctl(struct inode *inode, s
 		century = (tm.tm_year >= 2000) ? 0x80 : 0;
 		tm.tm_year = tm.tm_year % 100;
 
-		BIN_TO_BCD(tm.tm_year);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_sec);
+		tm.tm_year = bin2bcd(tm.tm_year);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
 		tm.tm_mon |= century;
 
 		mutex_lock(&rtc_lock);
diff -puN arch/cris/kernel/time.c~cris-use-bcd2bin-bin2bcd arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~cris-use-bcd2bin-bin2bcd
+++ a/arch/cris/kernel/time.c
@@ -127,7 +127,7 @@ int set_rtc_mmss(unsigned long nowtime)
 		return 0;
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
-	BCD_TO_BIN(cmos_minutes);
+	cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -142,8 +142,8 @@ int set_rtc_mmss(unsigned long nowtime)
 	real_minutes %= 60;
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
-		BIN_TO_BCD(real_seconds);
-		BIN_TO_BCD(real_minutes);
+		real_seconds = bin2bcd(real_seconds);
+		real_minutes = bin2bcd(real_minutes);
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
 	} else {
@@ -170,12 +170,12 @@ get_cmos_time(void)
 	mon = CMOS_READ(RTC_MONTH);
 	year = CMOS_READ(RTC_YEAR);
 
-	BCD_TO_BIN(sec);
-	BCD_TO_BIN(min);
-	BCD_TO_BIN(hour);
-	BCD_TO_BIN(day);
-	BCD_TO_BIN(mon);
-	BCD_TO_BIN(year);
+	sec = bcd2bin(sec);
+	min = bcd2bin(min);
+	hour = bcd2bin(hour);
+	day = bcd2bin(day);
+	mon = bcd2bin(mon);
+	year = bcd2bin(year);
 
 	if ((year += 1900) < 1970)
 		year += 100;
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
ntfs-update-homepage.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
drivers-net-atl1e-atl1e_mainc-uninline-atl1e_setup_mac_ctrl.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
the-scheduled-serial_coldfire-removal.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
arm-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
ia64-use-bcd2bin-bin2bcd.patch
ide-cd-use-bcd2bin-bin2bcd.patch
m68k-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
powerpc-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
sparc64-use-bcd2bin-bin2bcd.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

