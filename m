From: akpm@linux-foundation.org
Subject: - mn10300-use-bcd2bin-bin2bcd.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:54 -0700
Message-ID: <200810202037.m9KKbsmL011738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210AbYJTUqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: use bcd2bin/bin2bcd
has been removed from the -mm tree.  Its filename was
     mn10300-use-bcd2bin-bin2bcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use bcd2bin/bin2bcd
From: Adrian Bunk <bunk@kernel.org>

Change mn10300 to use the new bcd2bin/bin2bcd functions instead of the
obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/rtc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/mn10300/kernel/rtc.c~mn10300-use-bcd2bin-bin2bcd arch/mn10300/kernel/rtc.c
--- a/arch/mn10300/kernel/rtc.c~mn10300-use-bcd2bin-bin2bcd
+++ a/arch/mn10300/kernel/rtc.c
@@ -67,7 +67,7 @@ static int set_rtc_mmss(unsigned long no
 
 	cmos_minutes = CMOS_READ(RTC_MINUTES);
 	if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-		BCD_TO_BIN(cmos_minutes);
+		cmos_minutes = bcd2bin(cmos_minutes);
 
 	/*
 	 * since we're only adjusting minutes and seconds,
@@ -84,8 +84,8 @@ static int set_rtc_mmss(unsigned long no
 
 	if (abs(real_minutes - cmos_minutes) < 30) {
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 		}
 		CMOS_WRITE(real_seconds, RTC_SECONDS);
 		CMOS_WRITE(real_minutes, RTC_MINUTES);
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

