From: akpm@linux-foundation.org
Subject: + i2c-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:40:10 -0700
Message-ID: <200808082140.m78LeA9v029921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725AbYHHVk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:40:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, khali@linux-fr.org


The patch titled
     i2c: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     i2c-use-bcd2bin-bin2bcd.patch

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
Subject: i2c: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change i2c to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/menelaus.c |   34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/i2c/chips/menelaus.c~i2c-use-bcd2bin-bin2bcd drivers/i2c/chips/menelaus.c
--- a/drivers/i2c/chips/menelaus.c~i2c-use-bcd2bin-bin2bcd
+++ a/drivers/i2c/chips/menelaus.c
@@ -833,52 +833,52 @@ static irqreturn_t menelaus_irq(int irq,
 
 static void menelaus_to_time(char *regs, struct rtc_time *t)
 {
-	t->tm_sec = BCD2BIN(regs[0]);
-	t->tm_min = BCD2BIN(regs[1]);
+	t->tm_sec = bcd2bin(regs[0]);
+	t->tm_min = bcd2bin(regs[1]);
 	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
-		t->tm_hour = BCD2BIN(regs[2] & 0x1f) - 1;
+		t->tm_hour = bcd2bin(regs[2] & 0x1f) - 1;
 		if (regs[2] & RTC_HR_PM)
 			t->tm_hour += 12;
 	} else
-		t->tm_hour = BCD2BIN(regs[2] & 0x3f);
-	t->tm_mday = BCD2BIN(regs[3]);
-	t->tm_mon = BCD2BIN(regs[4]) - 1;
-	t->tm_year = BCD2BIN(regs[5]) + 100;
+		t->tm_hour = bcd2bin(regs[2] & 0x3f);
+	t->tm_mday = bcd2bin(regs[3]);
+	t->tm_mon = bcd2bin(regs[4]) - 1;
+	t->tm_year = bcd2bin(regs[5]) + 100;
 }
 
 static int time_to_menelaus(struct rtc_time *t, int regnum)
 {
 	int	hour, status;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_sec));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_sec));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_min));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_min));
 	if (status < 0)
 		goto fail;
 
 	if (the_menelaus->rtc_control & RTC_CTRL_MODE12) {
 		hour = t->tm_hour + 1;
 		if (hour > 12)
-			hour = RTC_HR_PM | BIN2BCD(hour - 12);
+			hour = RTC_HR_PM | bin2bcd(hour - 12);
 		else
-			hour = BIN2BCD(hour);
+			hour = bin2bcd(hour);
 	} else
-		hour = BIN2BCD(t->tm_hour);
+		hour = bin2bcd(t->tm_hour);
 	status = menelaus_write_reg(regnum++, hour);
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_mday));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mday));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_mon + 1));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_mon + 1));
 	if (status < 0)
 		goto fail;
 
-	status = menelaus_write_reg(regnum++, BIN2BCD(t->tm_year - 100));
+	status = menelaus_write_reg(regnum++, bin2bcd(t->tm_year - 100));
 	if (status < 0)
 		goto fail;
 
@@ -915,7 +915,7 @@ static int menelaus_read_time(struct dev
 	}
 
 	menelaus_to_time(regs, t);
-	t->tm_wday = BCD2BIN(regs[6]);
+	t->tm_wday = bcd2bin(regs[6]);
 
 	return 0;
 }
@@ -928,7 +928,7 @@ static int menelaus_set_time(struct devi
 	status = time_to_menelaus(t, MENELAUS_RTC_SEC);
 	if (status < 0)
 		return status;
-	status = menelaus_write_reg(MENELAUS_RTC_WKDAY, BIN2BCD(t->tm_wday));
+	status = menelaus_write_reg(MENELAUS_RTC_WKDAY, bin2bcd(t->tm_wday));
 	if (status < 0) {
 		dev_err(&the_menelaus->client->dev, "rtc write reg %02x "
 				"err %d\n", MENELAUS_RTC_WKDAY, status);
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

