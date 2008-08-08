From: akpm@linux-foundation.org
Subject: + acpi-use-bcd2bin-bin2bcd.patch added to -mm tree
Date: Fri, 08 Aug 2008 14:39:42 -0700
Message-ID: <200808082139.m78LdgcM029789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbYHHVjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 17:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, andi@firstfloor.org


The patch titled
     acpi: use bcd2bin/bin2bcd
has been added to the -mm tree.  Its filename is
     acpi-use-bcd2bin-bin2bcd.patch

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
Subject: acpi: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change ACPI to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/sleep/proc.c~acpi-use-bcd2bin-bin2bcd drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~acpi-use-bcd2bin-bin2bcd
+++ a/drivers/acpi/sleep/proc.c
@@ -120,13 +120,13 @@ static int acpi_system_alarm_seq_show(st
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hr);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mo);
-		BCD_TO_BIN(yr);
-		BCD_TO_BIN(cent);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hr = bcd2bin(hr);
+		day = bcd2bin(day);
+		mo = bcd2bin(mo);
+		yr = bcd2bin(yr);
+		cent = bcd2bin(cent);
 	}
 
 	/* we're trusting the FADT (see above) */
@@ -204,7 +204,7 @@ static u32 cmos_bcd_read(int offset, int
 {
 	u32 val = CMOS_READ(offset);
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(val);
+		val = bcd2bin(val);
 	return val;
 }
 
@@ -212,7 +212,7 @@ static u32 cmos_bcd_read(int offset, int
 static void cmos_bcd_write(u32 val, int offset, int rtc_control)
 {
 	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BIN_TO_BCD(val);
+		val = bin2bcd(val);
 	CMOS_WRITE(val, offset);
 }
 
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

