From: akpm@linux-foundation.org
Subject: + rtc-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:39:55 -0700
Message-ID: <200808082139.m78LdtHm029807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbYHHVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     rtc-use-bcd2bin-bin2bcd.patch

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
Subject: rtc: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change various rtc related code to use the new bcd2bin/bin2bcd functions
instead of the obsolete BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/rtc.c     |   20 +++++++++---------
 drivers/char/ds1286.c     |   34 +++++++++++++++---------------
 drivers/char/ds1302.c     |   24 ++++++++++-----------
 drivers/char/ip27-rtc.c   |   24 ++++++++++-----------
 drivers/char/rtc.c        |   40 ++++++++++++++++++------------------
 include/asm-generic/rtc.h |   24 ++++++++++-----------
 6 files changed, 83 insertions(+), 83 deletions(-)

diff -puN arch/x86/kernel/rtc.c~rtc-use-bcd2bin-bin2bcd arch/x86/kernel/rtc.c
--- a/arch/x86/kernel/rtc.c~rtc-use-bcd2bin-bin2bcd
+++ a/arch/x86/kernel/rtc.c
@@ -52,7 +52,7 @@ int mach_set_rtc_mmss(unsigned long nowt
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -69,8 +69,8 @@ int mach_set_rtc_mmss(unsigned long nowt
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
@@ -124,16 +124,16 @@ unsigned long mach_get_cmos_time(void)
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
 
 	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
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
 
 	if (century) {
-		BCD_TO_BIN(century);
+		century = bcd2bin(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
diff -puN drivers/char/ds1286.c~rtc-use-bcd2bin-bin2bcd drivers/char/ds1286.c
--- a/drivers/char/ds1286.c~rtc-use-bcd2bin-bin2bcd
+++ a/drivers/char/ds1286.c
@@ -210,8 +210,8 @@ static int ds1286_ioctl(struct inode *in
 		if (sec != 0)
 			return -EINVAL;
 
-		min = BIN2BCD(min);
-		min = BIN2BCD(hrs);
+		min = bin2bcd(min);
+		min = bin2bcd(hrs);
 
 		spin_lock(&ds1286_lock);
 		rtc_write(hrs, RTC_HOURS_ALARM);
@@ -353,7 +353,7 @@ static int ds1286_proc_output(char *buf)
 
 	ds1286_get_time(&tm);
 	hundredth = rtc_read(RTC_HUNDREDTH_SECOND);
-	BCD_TO_BIN(hundredth);
+	hundredth = bcd2bin(hundredth);
 
 	p += sprintf(p,
 	             "rtc_time\t: %02d:%02d:%02d.%02d\n"
@@ -477,12 +477,12 @@ static void ds1286_get_time(struct rtc_t
 	rtc_write(save_control, RTC_CMD);
 	spin_unlock_irqrestore(&ds1286_lock, flags);
 
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
@@ -531,12 +531,12 @@ static int ds1286_set_time(struct rtc_ti
 	if (yrs >= 100)
 		yrs -= 100;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hrs);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(yrs);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hrs = bin2bcd(hrs);
+	day = bin2bcd(day);
+	mon = bin2bcd(mon);
+	yrs = bin2bcd(yrs);
 
 	spin_lock_irqsave(&ds1286_lock, flags);
 	save_control = rtc_read(RTC_CMD);
@@ -572,8 +572,8 @@ static void ds1286_get_alm_time(struct r
 	cmd = rtc_read(RTC_CMD);
 	spin_unlock_irqrestore(&ds1286_lock, flags);
 
-	BCD_TO_BIN(alm_tm->tm_min);
-	BCD_TO_BIN(alm_tm->tm_hour);
+	alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
+	alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	alm_tm->tm_sec = 0;
 }
 
diff -puN drivers/char/ds1302.c~rtc-use-bcd2bin-bin2bcd drivers/char/ds1302.c
--- a/drivers/char/ds1302.c~rtc-use-bcd2bin-bin2bcd
+++ a/drivers/char/ds1302.c
@@ -131,12 +131,12 @@ get_rtc_time(struct rtc_time *rtc_tm)
 
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
@@ -211,12 +211,12 @@ static long rtc_ioctl(struct file *file,
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
 
 			lock_kernel();
 			local_irq_save(flags);
diff -puN drivers/char/ip27-rtc.c~rtc-use-bcd2bin-bin2bcd drivers/char/ip27-rtc.c
--- a/drivers/char/ip27-rtc.c~rtc-use-bcd2bin-bin2bcd
+++ a/drivers/char/ip27-rtc.c
@@ -130,12 +130,12 @@ static long rtc_ioctl(struct file *filp,
 		if (yrs >= 100)
 			yrs -= 100;
 
-		sec = BIN2BCD(sec);
-		min = BIN2BCD(min);
-		hrs = BIN2BCD(hrs);
-		day = BIN2BCD(day);
-		mon = BIN2BCD(mon);
-		yrs = BIN2BCD(yrs);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hrs = bin2bcd(hrs);
+		day = bin2bcd(day);
+		mon = bin2bcd(mon);
+		yrs = bin2bcd(yrs);
 
 		spin_lock_irq(&rtc_lock);
 		rtc->control |= M48T35_RTC_SET;
@@ -311,12 +311,12 @@ static void get_rtc_time(struct rtc_time
 	rtc->control &= ~M48T35_RTC_READ;
 	spin_unlock_irq(&rtc_lock);
 
-	rtc_tm->tm_sec = BCD2BIN(rtc_tm->tm_sec);
-	rtc_tm->tm_min = BCD2BIN(rtc_tm->tm_min);
-	rtc_tm->tm_hour = BCD2BIN(rtc_tm->tm_hour);
-	rtc_tm->tm_mday = BCD2BIN(rtc_tm->tm_mday);
-	rtc_tm->tm_mon = BCD2BIN(rtc_tm->tm_mon);
-	rtc_tm->tm_year = BCD2BIN(rtc_tm->tm_year);
+	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+	rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+	rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	/*
 	 * Account for differences between how the RTC uses the values
diff -puN drivers/char/rtc.c~rtc-use-bcd2bin-bin2bcd drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-use-bcd2bin-bin2bcd
+++ a/drivers/char/rtc.c
@@ -519,17 +519,17 @@ static int rtc_do_ioctl(unsigned int cmd
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) ||
 							RTC_ALWAYS_BCD) {
 			if (sec < 60)
-				BIN_TO_BCD(sec);
+				sec = bin2bcd(sec);
 			else
 				sec = 0xff;
 
 			if (min < 60)
-				BIN_TO_BCD(min);
+				min = bin2bcd(min);
 			else
 				min = 0xff;
 
 			if (hrs < 24)
-				BIN_TO_BCD(hrs);
+				hrs = bin2bcd(hrs);
 			else
 				hrs = 0xff;
 		}
@@ -615,12 +615,12 @@ static int rtc_do_ioctl(unsigned int cmd
 
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
 		    || RTC_ALWAYS_BCD) {
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
 		}
 
 		save_control = CMOS_READ(RTC_CONTROL);
@@ -1096,7 +1096,7 @@ no_irq:
 	spin_unlock_irq(&rtc_lock);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(year);       /* This should never happen... */
+		year = bcd2bin(year);       /* This should never happen... */
 
 	if (year < 20) {
 		epoch = 2000;
@@ -1349,13 +1349,13 @@ static void rtc_get_rtc_time(struct rtc_
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
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
 
 #ifdef CONFIG_MACH_DECSTATION
@@ -1389,9 +1389,9 @@ static void get_rtc_alm_time(struct rtc_
 	spin_unlock_irq(&rtc_lock);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(alm_tm->tm_sec);
-		BCD_TO_BIN(alm_tm->tm_min);
-		BCD_TO_BIN(alm_tm->tm_hour);
+		alm_tm->tm_sec = bcd2bin(alm_tm->tm_sec);
+		alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
+		alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	}
 }
 
diff -puN include/asm-generic/rtc.h~rtc-use-bcd2bin-bin2bcd include/asm-generic/rtc.h
--- a/include/asm-generic/rtc.h~rtc-use-bcd2bin-bin2bcd
+++ a/include/asm-generic/rtc.h
@@ -88,12 +88,12 @@ static inline unsigned int get_rtc_time(
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
-		BCD_TO_BIN(time->tm_sec);
-		BCD_TO_BIN(time->tm_min);
-		BCD_TO_BIN(time->tm_hour);
-		BCD_TO_BIN(time->tm_mday);
-		BCD_TO_BIN(time->tm_mon);
-		BCD_TO_BIN(time->tm_year);
+		time->tm_sec = bcd2bin(time->tm_sec);
+		time->tm_min = bcd2bin(time->tm_min);
+		time->tm_hour = bcd2bin(time->tm_hour);
+		time->tm_mday = bcd2bin(time->tm_mday);
+		time->tm_mon = bcd2bin(time->tm_mon);
+		time->tm_year = bcd2bin(time->tm_year);
 	}
 
 #ifdef CONFIG_MACH_DECSTATION
@@ -163,12 +163,12 @@ static inline int set_rtc_time(struct rt
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)
 	    || RTC_ALWAYS_BCD) {
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

