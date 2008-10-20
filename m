From: akpm@linux-foundation.org
Subject: - acpi-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:35 -0700
Message-ID: <200810202037.m9KKbZfI011665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbYJTUic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     acpi: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     acpi-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

