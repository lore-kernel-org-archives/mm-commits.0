From: akpm@linux-foundation.org
Subject: [merged] vrtc-change-its-year-offset-from-1960-to-1972.patch removed from -mm tree
Date: Mon, 14 Nov 2011 13:26:26 -0800
Message-ID: <201111142126.pAELQQGN006393@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:51205 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1KNV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 16:26:30 -0500
Received: by ggnp4 with SMTP id p4so81946ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 13:26:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: feng.tang@intel.com, alan@linux.intel.com, hpa@zytor.com, mathias.nyman@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: vrtc: change its year offset from 1960 to 1972
has been removed from the -mm tree.  Its filename was
     vrtc-change-its-year-offset-from-1960-to-1972.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: vrtc: change its year offset from 1960 to 1972

Real world year equals the value in vrtc YEAR register plus an offset.  We
used 1960 for original developepment as the offset to make leap year
consistent, but for a device's first use, its YEAR register is 0 and the
system year will be parsed as 1960 which is not a valid UNIX time and will
cause many applications to fail mysteriously.  Devices use 1972 instead to
fix this issue.

Updated patch which adds a sanity check suggested by Mathias

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/mrst/vrtc.c |    4 ++--
 drivers/rtc/rtc-mrst.c        |   19 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN arch/x86/platform/mrst/vrtc.c~vrtc-change-its-year-offset-from-1960-to-1972 arch/x86/platform/mrst/vrtc.c
--- a/arch/x86/platform/mrst/vrtc.c~vrtc-change-its-year-offset-from-1960-to-1972
+++ a/arch/x86/platform/mrst/vrtc.c
@@ -76,8 +76,8 @@ unsigned long vrtc_get_time(void)
 
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	/* vRTC YEAR reg contains the offset to 1960 */
-	year += 1960;
+	/* vRTC YEAR reg contains the offset to 1972 */
+	year += 1972;
 
 	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
diff -puN drivers/rtc/rtc-mrst.c~vrtc-change-its-year-offset-from-1960-to-1972 drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~vrtc-change-its-year-offset-from-1960-to-1972
+++ a/drivers/rtc/rtc-mrst.c
@@ -76,12 +76,15 @@ static inline unsigned char vrtc_is_upda
 /*
  * rtc_time's year contains the increment over 1900, but vRTC's YEAR
  * register can't be programmed to value larger than 0x64, so vRTC
- * driver chose to use 1960 (1970 is UNIX time start point) as the base,
+ * driver chose to use 1972 (1970 is UNIX time start point) as the base,
  * and does the translation at read/write time.
  *
- * Why not just use 1970 as the offset? it's because using 1960 will
+ * Why not just use 1970 as the offset? it's because using 1972 will
  * make it consistent in leap year setting for both vrtc and low-level
- * physical rtc devices.
+ * physical rtc devices. Then why not use 1960 as the offset? If we use
+ * 1960, for a device's first use, its YEAR register is 0 and the system
+ * year will be parsed as 1960 which is not a valid UNIX time and will
+ * cause many applications to fail mysteriously.
  */
 static int mrst_read_time(struct device *dev, struct rtc_time *time)
 {
@@ -99,10 +102,10 @@ static int mrst_read_time(struct device 
 	time->tm_year = vrtc_cmos_read(RTC_YEAR);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 
-	/* Adjust for the 1960/1900 */
-	time->tm_year += 60;
+	/* Adjust for the 1972/1900 */
+	time->tm_year += 72;
 	time->tm_mon--;
-	return RTC_24H;
+	return rtc_valid_tm(time);
 }
 
 static int mrst_set_time(struct device *dev, struct rtc_time *time)
@@ -119,9 +122,9 @@ static int mrst_set_time(struct device *
 	min = time->tm_min;
 	sec = time->tm_sec;
 
-	if (yrs < 70 || yrs > 138)
+	if (yrs < 72 || yrs > 138)
 		return -EINVAL;
-	yrs -= 60;
+	yrs -= 72;
 
 	spin_lock_irqsave(&rtc_lock, flags);
 
_

Patches currently in -mm which might be from feng.tang@intel.com are

origin.patch
x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms.patch
mrst-battery-fixes.patch

