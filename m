From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:28:20 -0800
Message-ID: <200712042028.lB4KSK1N003498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbXLDU25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:28:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, alessandro.zummo@towertech.it, bryan.wu@analog.com


The patch titled
     Blackfin RTC driver: use dev_dbg() rather than pr_stamp()
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin RTC driver: use dev_dbg() rather than pr_stamp()
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   48 +++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp
+++ a/drivers/rtc/rtc-bfin.c
@@ -45,8 +45,7 @@
 
 #include <asm/blackfin.h>
 
-#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
-#define stampit() stamp("here i am")
+#define dev_dbg_stamp(dev) dev_dbg(dev, "%s:%i: here i am\n", __func__, __LINE__)
 
 struct bfin_rtc {
 	struct rtc_device *rtc_dev;
@@ -120,7 +119,6 @@ static inline void rtc_bfin_to_tm(u32 rt
  */
 static void rtc_bfin_sync_pending(void)
 {
-	stampit();
 	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE)) {
 		if (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING))
 			break;
@@ -128,8 +126,9 @@ static void rtc_bfin_sync_pending(void)
 	bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
 }
 
-static void rtc_bfin_reset(struct bfin_rtc *rtc)
+static void rtc_bfin_reset(struct device *dev)
 {
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	/* Initialize the RTC. Enable pre-scaler to scale RTC clock
 	 * to 1Hz and clear interrupt/status registers. */
 	spin_lock_irq(&rtc->lock);
@@ -149,7 +148,7 @@ static irqreturn_t bfin_rtc_interrupt(in
 	unsigned long events = 0;
 	u16 rtc_istat;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 
@@ -180,10 +179,9 @@ static irqreturn_t bfin_rtc_interrupt(in
 
 static int bfin_rtc_open(struct device *dev)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	int ret;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	ret = request_irq(IRQ_RTC, bfin_rtc_interrupt, IRQF_DISABLED, "rtc-bfin", dev);
 	if (unlikely(ret)) {
@@ -191,16 +189,15 @@ static int bfin_rtc_open(struct device *
 		return ret;
 	}
 
-	rtc_bfin_reset(rtc);
+	rtc_bfin_reset(dev);
 
 	return ret;
 }
 
 static void bfin_rtc_release(struct device *dev)
 {
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
-	rtc_bfin_reset(rtc);
+	dev_dbg_stamp(dev);
+	rtc_bfin_reset(dev);
 	free_irq(IRQ_RTC, dev);
 }
 
@@ -208,11 +205,11 @@ static int bfin_rtc_ioctl(struct device 
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	switch (cmd) {
 	case RTC_PIE_ON:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ISTAT(RTC_ISTAT_STOPWATCH);
@@ -221,7 +218,7 @@ static int bfin_rtc_ioctl(struct device 
 		spin_unlock_irq(&rtc->lock);
 		return 0;
 	case RTC_PIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_SWCNT(0);
@@ -230,7 +227,7 @@ static int bfin_rtc_ioctl(struct device 
 		return 0;
 
 	case RTC_UIE_ON:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
@@ -238,7 +235,7 @@ static int bfin_rtc_ioctl(struct device 
 		spin_unlock_irq(&rtc->lock);
 		return 0;
 	case RTC_UIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~RTC_ISTAT_SEC);
@@ -250,7 +247,7 @@ static int bfin_rtc_ioctl(struct device 
 		u16 which_alarm;
 		int ret = 0;
 
-		stampit();
+		dev_dbg_stamp(dev);
 
 		spin_lock_irq(&rtc->lock);
 
@@ -278,7 +275,7 @@ static int bfin_rtc_ioctl(struct device 
 		return ret;
 	}
 	case RTC_AIE_OFF:
-		stampit();
+		dev_dbg_stamp(dev);
 		spin_lock_irq(&rtc->lock);
 		rtc_bfin_sync_pending();
 		bfin_write_RTC_ICTL(bfin_read_RTC_ICTL() & ~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
@@ -293,7 +290,7 @@ static int bfin_rtc_read_time(struct dev
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 	rtc_bfin_sync_pending();
@@ -309,7 +306,7 @@ static int bfin_rtc_set_time(struct devi
 	int ret;
 	unsigned long now;
 
-	stampit();
+	dev_dbg_stamp(dev);
 
 	spin_lock_irq(&rtc->lock);
 
@@ -327,7 +324,7 @@ static int bfin_rtc_set_time(struct devi
 static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
+	dev_dbg_stamp(dev);
 	memcpy(&alrm->time, &rtc->rtc_alarm, sizeof(struct rtc_time));
 	alrm->pending = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
 	return 0;
@@ -336,7 +333,7 @@ static int bfin_rtc_read_alarm(struct de
 static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	stampit();
+	dev_dbg_stamp(dev);
 	memcpy(&rtc->rtc_alarm, &alrm->time, sizeof(struct rtc_time));
 	return 0;
 }
@@ -345,7 +342,7 @@ static int bfin_rtc_proc(struct device *
 {
 #define yesno(x) ((x) ? "yes" : "no")
 	u16 ictl = bfin_read_RTC_ICTL();
-	stampit();
+	dev_dbg_stamp(dev);
 	seq_printf(seq,
 		"alarm_IRQ\t: %s\n"
 		"wkalarm_IRQ\t: %s\n"
@@ -369,7 +366,7 @@ static int bfin_rtc_proc(struct device *
  */
 static int bfin_irq_set_freq(struct device *dev, int freq)
 {
-	stampit();
+	dev_dbg_stamp(dev);
 	return -ENOTTY;
 }
 
@@ -390,7 +387,7 @@ static int __devinit bfin_rtc_probe(stru
 	struct bfin_rtc *rtc;
 	int ret = 0;
 
-	stampit();
+	dev_dbg_stamp(&pdev->dev);
 
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
@@ -436,7 +433,6 @@ static struct platform_driver bfin_rtc_d
 
 static int __init bfin_rtc_init(void)
 {
-	stampit();
 	return platform_driver_register(&bfin_rtc_driver);
 }
 
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
