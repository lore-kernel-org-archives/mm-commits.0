From: akpm@linux-foundation.org
Subject: + sparc64-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:40:15 -0700
Message-ID: <200808082140.m78LeF67029927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758783AbYHHVk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, davem@davemloft.net


The patch titled
     sparc64: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     sparc64-use-bcd2bin-bin2bcd.patch

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
Subject: sparc64: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change sparc64 to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/time.c |   94 +++++++++++++++++------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff -puN arch/sparc64/kernel/time.c~sparc64-use-bcd2bin-bin2bcd arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~sparc64-use-bcd2bin-bin2bcd
+++ a/arch/sparc64/kernel/time.c
@@ -582,13 +582,13 @@ static void __init set_system_time(void)
 
 		writeb(val, bregs + 0x0e);
 
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
-		BCD_TO_BIN(century);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
+		century = bcd2bin(century);
 
 		year += (century * 100);
 	} else {
@@ -604,12 +604,12 @@ static void __init set_system_time(void)
 		} while (sec != CMOS_READ(RTC_SECONDS));
 
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BCD_TO_BIN(sec);
-			BCD_TO_BIN(min);
-			BCD_TO_BIN(hour);
-			BCD_TO_BIN(day);
-			BCD_TO_BIN(mon);
-			BCD_TO_BIN(year);
+			sec = bcd2bin(sec);
+			min = bcd2bin(min);
+			hour = bcd2bin(hour);
+			day = bcd2bin(day);
+			mon = bcd2bin(mon);
+			year = bcd2bin(year);
 		}
 		if ((year += 1900) < 1970)
 			year += 100;
@@ -1146,7 +1146,7 @@ static int set_rtc_mmss(unsigned long no
 		writeb(val | 0x08, bregs + 0x0e);
 
 		chip_minutes = readb(bregs + 0x02);
-		BCD_TO_BIN(chip_minutes);
+		chip_minutes = bcd2bin(chip_minutes);
 		real_seconds = nowtime % 60;
 		real_minutes = nowtime / 60;
 		if (((abs(real_minutes - chip_minutes) + 15)/30) & 1)
@@ -1154,8 +1154,8 @@ static int set_rtc_mmss(unsigned long no
 		real_minutes %= 60;
 
 		if (abs(real_minutes - chip_minutes) < 30) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 			writeb(real_seconds, bregs + 0x00);
 			writeb(real_minutes, bregs + 0x02);
 		} else {
@@ -1184,7 +1184,7 @@ static int set_rtc_mmss(unsigned long no
 
 		chip_minutes = CMOS_READ(RTC_MINUTES);
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-			BCD_TO_BIN(chip_minutes);
+			chip_minutes = bcd2bin(chip_minutes);
 		real_seconds = nowtime % 60;
 		real_minutes = nowtime / 60;
 		if (((abs(real_minutes - chip_minutes) + 15)/30) & 1)
@@ -1193,8 +1193,8 @@ static int set_rtc_mmss(unsigned long no
 
 		if (abs(real_minutes - chip_minutes) < 30) {
 			if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-				BIN_TO_BCD(real_seconds);
-				BIN_TO_BCD(real_minutes);
+				real_seconds = bin2bcd(real_seconds);
+				real_minutes = bin2bcd(real_minutes);
 			}
 			CMOS_WRITE(real_seconds,RTC_SECONDS);
 			CMOS_WRITE(real_minutes,RTC_MINUTES);
@@ -1353,14 +1353,14 @@ static void bq4802_get_rtc_time(struct r
 
 	writeb(val, bq4802_regs + 0x0e);
 
-	BCD_TO_BIN(time->tm_sec);
-	BCD_TO_BIN(time->tm_min);
-	BCD_TO_BIN(time->tm_hour);
-	BCD_TO_BIN(time->tm_mday);
-	BCD_TO_BIN(time->tm_mon);
-	BCD_TO_BIN(time->tm_year);
-	BCD_TO_BIN(time->tm_wday);
-	BCD_TO_BIN(century);
+	time->tm_sec = bcd2bin(time->tm_sec);
+	time->tm_min = bcd2bin(time->tm_min);
+	time->tm_hour = bcd2bin(time->tm_hour);
+	time->tm_mday = bcd2bin(time->tm_mday);
+	time->tm_mon = bcd2bin(time->tm_mon);
+	time->tm_year = bcd2bin(time->tm_year);
+	time->tm_wday = bcd2bin(time->tm_wday);
+	century = bcd2bin(century);
 
 	time->tm_year += (century * 100);
 	time->tm_year -= 1900;
@@ -1384,13 +1384,13 @@ static int bq4802_set_rtc_time(struct rt
 	min = time->tm_min;
 	sec = time->tm_sec;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hrs);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(yrs);
-	BIN_TO_BCD(century);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hrs = bin2bcd(hrs);
+	day = bin2bcd(day);
+	mon = bin2bcd(mon);
+	yrs = bin2bcd(yrs);
+	century = bin2bcd(century);
 
 	writeb(val | 0x08, bq4802_regs + 0x0e);
 
@@ -1421,13 +1421,13 @@ static void cmos_get_rtc_time(struct rtc
 
 	ctrl = CMOS_READ(RTC_CONTROL);
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(rtc_tm->tm_sec);
-		BCD_TO_BIN(rtc_tm->tm_min);
-		BCD_TO_BIN(rtc_tm->tm_hour);
-		BCD_TO_BIN(rtc_tm->tm_mday);
-		BCD_TO_BIN(rtc_tm->tm_mon);
-		BCD_TO_BIN(rtc_tm->tm_year);
-		BCD_TO_BIN(rtc_tm->tm_wday);
+		rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+		rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+		rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+		rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+		rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+		rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
+		rtc_tm->tm_wday = bcd2bin(rtc_tm->tm_wday);
 	}
 
 	if (rtc_tm->tm_year <= 69)
@@ -1453,12 +1453,12 @@ static int cmos_set_rtc_time(struct rtc_
 		yrs -= 100;
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(sec);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(hrs);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(mon);
-		BIN_TO_BCD(yrs);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hrs = bin2bcd(hrs);
+		day = bin2bcd(day);
+		mon = bin2bcd(mon);
+		yrs = bin2bcd(yrs);
 	}
 
 	save_control = CMOS_READ(RTC_CONTROL);
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

