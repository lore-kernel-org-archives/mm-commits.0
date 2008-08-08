From: akpm@linux-foundation.org
Subject: + powerpc-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:40:08 -0700
Message-ID: <200808082140.m78Le84d029918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853AbYHHVkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, benh@kernel.crashing.org


The patch titled
     powerpc: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     powerpc-use-bcd2bin-bin2bcd.patch

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
Subject: powerpc: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change powerpc to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/chrp/time.c  |   24 ++++++++++++------------
 arch/powerpc/platforms/iseries/mf.c |   26 +++++++++++++-------------
 arch/powerpc/platforms/maple/time.c |   24 ++++++++++++------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff -puN arch/powerpc/platforms/chrp/time.c~powerpc-use-bcd2bin-bin2bcd arch/powerpc/platforms/chrp/time.c
--- a/arch/powerpc/platforms/chrp/time.c~powerpc-use-bcd2bin-bin2bcd
+++ a/arch/powerpc/platforms/chrp/time.c
@@ -94,12 +94,12 @@ int chrp_set_rtc_time(struct rtc_time *t
 	chrp_cmos_clock_write((save_freq_select|RTC_DIV_RESET2), RTC_FREQ_SELECT);
 
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(tm.tm_sec);
-		BIN_TO_BCD(tm.tm_min);
-		BIN_TO_BCD(tm.tm_hour);
-		BIN_TO_BCD(tm.tm_mon);
-		BIN_TO_BCD(tm.tm_mday);
-		BIN_TO_BCD(tm.tm_year);
+		tm.tm_sec = bin2bcd(tm.tm_sec);
+		tm.tm_min = bin2bcd(tm.tm_min);
+		tm.tm_hour = bin2bcd(tm.tm_hour);
+		tm.tm_mon = bin2bcd(tm.tm_mon);
+		tm.tm_mday = bin2bcd(tm.tm_mday);
+		tm.tm_year = bin2bcd(tm.tm_year);
 	}
 	chrp_cmos_clock_write(tm.tm_sec,RTC_SECONDS);
 	chrp_cmos_clock_write(tm.tm_min,RTC_MINUTES);
@@ -136,12 +136,12 @@ void chrp_get_rtc_time(struct rtc_time *
 	} while (sec != chrp_cmos_clock_read(RTC_SECONDS));
 
 	if (!(chrp_cmos_clock_read(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 	}
 	if (year < 70)
 		year += 100;
diff -puN arch/powerpc/platforms/iseries/mf.c~powerpc-use-bcd2bin-bin2bcd arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~powerpc-use-bcd2bin-bin2bcd
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -722,13 +722,13 @@ static int mf_set_rtc(struct rtc_time *t
 	day = tm->tm_mday;
 	mon = tm->tm_mon + 1;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hour);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(y1);
-	BIN_TO_BCD(y2);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hour = bin2bcd(hour);
+	mon = bin2bcd(mon);
+	day = bin2bcd(day);
+	y1 = bin2bcd(y1);
+	y2 = bin2bcd(y2);
 
 	memset(ce_time, 0, sizeof(ce_time));
 	ce_time[3] = 0x41;
@@ -777,12 +777,12 @@ static int rtc_set_tm(int rc, u8 *ce_msg
 		u8 day = ce_msg[10];
 		u8 mon = ce_msg[11];
 
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
 
 		if (year <= 69)
 			year += 100;
diff -puN arch/powerpc/platforms/maple/time.c~powerpc-use-bcd2bin-bin2bcd arch/powerpc/platforms/maple/time.c
--- a/arch/powerpc/platforms/maple/time.c~powerpc-use-bcd2bin-bin2bcd
+++ a/arch/powerpc/platforms/maple/time.c
@@ -68,12 +68,12 @@ void maple_get_rtc_time(struct rtc_time 
 
 	if (!(maple_clock_read(RTC_CONTROL) & RTC_DM_BINARY)
 	    || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(tm->tm_sec);
-		BCD_TO_BIN(tm->tm_min);
-		BCD_TO_BIN(tm->tm_hour);
-		BCD_TO_BIN(tm->tm_mday);
-		BCD_TO_BIN(tm->tm_mon);
-		BCD_TO_BIN(tm->tm_year);
+		tm->tm_sec = bcd2bin(tm->tm_sec);
+		tm->tm_min = bcd2bin(tm->tm_min);
+		tm->tm_hour = bcd2bin(tm->tm_hour);
+		tm->tm_mday = bcd2bin(tm->tm_mday);
+		tm->tm_mon = bcd2bin(tm->tm_mon);
+		tm->tm_year = bcd2bin(tm->tm_year);
 	  }
 	if ((tm->tm_year + 1900) < 1970)
 		tm->tm_year += 100;
@@ -104,12 +104,12 @@ int maple_set_rtc_time(struct rtc_time *
 	year = tm->tm_year;
 
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(sec);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(hour);
-		BIN_TO_BCD(mon);
-		BIN_TO_BCD(mday);
-		BIN_TO_BCD(year);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hour = bin2bcd(hour);
+		mon = bin2bcd(mon);
+		mday = bin2bcd(mday);
+		year = bin2bcd(year);
 	}
 	maple_clock_write(sec, RTC_SECONDS);
 	maple_clock_write(min, RTC_MINUTES);
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

