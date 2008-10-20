From: akpm@linux-foundation.org
Subject: - alpha-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:37 -0700
Message-ID: <200810202037.m9KKbbcs011676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032AbYJTUik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     alpha-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change alpha to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_marvel.c |    4 ++--
 arch/alpha/kernel/time.c        |   18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/alpha/kernel/core_marvel.c~alpha-use-bcd2bin-bin2bcd arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~alpha-use-bcd2bin-bin2bcd
+++ a/arch/alpha/kernel/core_marvel.c
@@ -655,7 +655,7 @@ __marvel_rtc_io(u8 b, unsigned long addr
 
 	case 0x71:					/* RTC_PORT(1) */
 		rtc_access.index = index;
-		rtc_access.data = BCD_TO_BIN(b);
+		rtc_access.data = bcd2bin(b);
 		rtc_access.function = 0x48 + !write;	/* GET/PUT_TOY */
 
 #ifdef CONFIG_SMP
@@ -668,7 +668,7 @@ __marvel_rtc_io(u8 b, unsigned long addr
 #else
 		__marvel_access_rtc(&rtc_access);
 #endif
-		ret = BIN_TO_BCD(rtc_access.data);
+		ret = bin2bcd(rtc_access.data);
 		break;
 
 	default:
diff -puN arch/alpha/kernel/time.c~alpha-use-bcd2bin-bin2bcd arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~alpha-use-bcd2bin-bin2bcd
+++ a/arch/alpha/kernel/time.c
@@ -346,12 +346,12 @@ time_init(void)
 	year = CMOS_READ(RTC_YEAR);
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
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
 
 	/* PC-like is standard; used for year >= 70 */
@@ -525,7 +525,7 @@ set_rtc_mmss(unsigned long nowtime)
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -543,8 +543,8 @@ set_rtc_mmss(unsigned long nowtime)
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds,RTC_SECONDS);
 		CMOS_WRITE(real_minutes,RTC_MINUTES);
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

