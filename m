From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:26 -0700
Message-ID: <201010112259.o9BMxQtv023156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0JKXAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaos.youn@samsung.com, a.zummo@towertech.it, atul.dahiya@samsung.com, ben-linux@fluff.org, kgene.kim@samsung.com, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: fix access unit from byte to word on RTCCON
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-s3c: fix access unit from byte to word on RTCCON
From: Changhwan Youn <chaos.youn@samsung.com>

S3C2410_RTCCON of TYPE_S3C64XX RTC should be read/written by readw and
writew, because TYPE_S3C64XX RTC uses bit 8 and 9.  And TYPE_S3C2410 RTC
also can access it by readw and writew.

[atul.dahiya@samsung.com: tested on smdk2416]
Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Tested-by: Atul Dahiya <atul.dahiya@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon
+++ a/drivers/rtc/rtc-s3c.c
@@ -100,7 +100,7 @@ static int s3c_rtc_setpie(struct device 
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
+		tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
 		tmp &= ~S3C64XX_RTCCON_TICEN;
 
 		if (enabled)
@@ -318,7 +318,7 @@ static int s3c_rtc_proc(struct device *d
 	unsigned int ticnt;
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		ticnt = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt &= S3C64XX_RTCCON_TICEN;
 	} else {
 		ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
@@ -391,11 +391,11 @@ static void s3c_rtc_enable(struct platfo
 		return;
 
 	if (!en) {
-		tmp = readb(base + S3C2410_RTCCON);
+		tmp = readw(base + S3C2410_RTCCON);
 		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 			tmp &= ~S3C64XX_RTCCON_TICEN;
 		tmp &= ~S3C2410_RTCCON_RTCEN;
-		writeb(tmp, base + S3C2410_RTCCON);
+		writew(tmp, base + S3C2410_RTCCON);
 
 		if (s3c_rtc_cpu_type == TYPE_S3C2410) {
 			tmp = readb(base + S3C2410_TICNT);
@@ -405,25 +405,25 @@ static void s3c_rtc_enable(struct platfo
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((readb(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0){
+		if ((readw(base+S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0){
 			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
 
-			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp|S3C2410_RTCCON_RTCEN, base+S3C2410_RTCCON);
+			tmp = readw(base + S3C2410_RTCCON);
+			writew(tmp|S3C2410_RTCCON_RTCEN, base+S3C2410_RTCCON);
 		}
 
-		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)){
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)){
 			dev_info(&pdev->dev, "removing RTCCON_CNTSEL\n");
 
-			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);
+			tmp = readw(base + S3C2410_RTCCON);
+			writew(tmp& ~S3C2410_RTCCON_CNTSEL, base+S3C2410_RTCCON);
 		}
 
-		if ((readb(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)){
+		if ((readw(base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)){
 			dev_info(&pdev->dev, "removing RTCCON_CLKRST\n");
 
-			tmp = readb(base + S3C2410_RTCCON);
-			writeb(tmp & ~S3C2410_RTCCON_CLKRST, base+S3C2410_RTCCON);
+			tmp = readw(base + S3C2410_RTCCON);
+			writew(tmp & ~S3C2410_RTCCON_CLKRST, base+S3C2410_RTCCON);
 		}
 	}
 }
@@ -514,8 +514,8 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_enable(pdev, 1);
 
- 	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
-		 readb(s3c_rtc_base + S3C2410_RTCCON));
+	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
+		 readw(s3c_rtc_base + S3C2410_RTCCON));
 
 	device_init_wakeup(&pdev->dev, 1);
 
@@ -578,7 +578,7 @@ static int s3c_rtc_suspend(struct platfo
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		ticnt_en_save = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt_en_save = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
 	}
 	s3c_rtc_enable(pdev, 0);
@@ -596,8 +596,8 @@ static int s3c_rtc_resume(struct platfor
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
-		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
-		writeb(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
+		tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
+		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
 
 	if (device_may_wakeup(&pdev->dev))
_

Patches currently in -mm which might be from chaos.youn@samsung.com are

linux-next.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch
rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch
rtc-rtc-s3c-fix-on-support-rtc-alarm.patch
rtc-rtc-s3c-fix-rtc-initialization-method.patch

