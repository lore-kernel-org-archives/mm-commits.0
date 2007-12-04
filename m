From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:28:18 -0800
Message-ID: <200712042028.lB4KSI1k003493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbXLDU2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:28:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com


The patch titled
     Blackfin RTC driver: cleanup proc handler (we dont need RTC reg dump now that we have MMR filesystem in sysfs)
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin RTC driver: cleanup proc handler (we dont need RTC reg dump now that we have MMR filesystem in sysfs)
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs
+++ a/drivers/rtc/rtc-bfin.c
@@ -45,7 +45,7 @@
 
 #include <asm/blackfin.h>
 
-#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __FUNCTION__, __LINE__, ## args)
+#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
 
 struct bfin_rtc {
@@ -343,22 +343,20 @@ static int bfin_rtc_set_alarm(struct dev
 
 static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-#define yesno(x) (x ? "yes" : "no")
+#define yesno(x) ((x) ? "yes" : "no")
 	u16 ictl = bfin_read_RTC_ICTL();
 	stampit();
-	seq_printf(seq, "alarm_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_ALARM));
-	seq_printf(seq, "wkalarm_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_ALARM_DAY));
-	seq_printf(seq, "seconds_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_SEC));
-	seq_printf(seq, "periodic_IRQ\t: %s\n", yesno(ictl & RTC_ISTAT_STOPWATCH));
-#ifdef DEBUG
-	seq_printf(seq, "RTC_STAT\t: 0x%08X\n", bfin_read_RTC_STAT());
-	seq_printf(seq, "RTC_ICTL\t: 0x%04X\n", bfin_read_RTC_ICTL());
-	seq_printf(seq, "RTC_ISTAT\t: 0x%04X\n", bfin_read_RTC_ISTAT());
-	seq_printf(seq, "RTC_SWCNT\t: 0x%04X\n", bfin_read_RTC_SWCNT());
-	seq_printf(seq, "RTC_ALARM\t: 0x%08X\n", bfin_read_RTC_ALARM());
-	seq_printf(seq, "RTC_PREN\t: 0x%04X\n", bfin_read_RTC_PREN());
-#endif
+	seq_printf(seq,
+		"alarm_IRQ\t: %s\n"
+		"wkalarm_IRQ\t: %s\n"
+		"seconds_IRQ\t: %s\n"
+		"periodic_IRQ\t: %s\n",
+		yesno(ictl & RTC_ISTAT_ALARM),
+		yesno(ictl & RTC_ISTAT_ALARM_DAY),
+		yesno(ictl & RTC_ISTAT_SEC),
+		yesno(ictl & RTC_ISTAT_STOPWATCH));
 	return 0;
+#undef yesno
 }
 
 /**
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

spi-spi_bfin-dont-bypass-spi-framework.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
