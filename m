From: akpm@linux-foundation.org
Subject: + rtc-driver-for-pcap2-pmic-update.patch added to -mm tree
Date: Mon, 29 Jun 2009 13:47:51 -0700
Message-ID: <200906292047.n5TKlpDT027213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZF2Us2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 16:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drwyrm@gmail.com, a.zummo@towertech.it, gmzhuo@gmail.com


The patch titled
     rtc-driver-for-pcap2-pmic-update
has been added to the -mm tree.  Its filename is
     rtc-driver-for-pcap2-pmic-update.patch

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
Subject: rtc-driver-for-pcap2-pmic-update
From: Daniel Ribeiro <drwyrm@gmail.com>

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: guiming zhuo <gmzhuo@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcap.c |   52 ++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-pcap.c~rtc-driver-for-pcap2-pmic-update drivers/rtc/rtc-pcap.c
--- a/drivers/rtc/rtc-pcap.c~rtc-driver-for-pcap2-pmic-update
+++ a/drivers/rtc/rtc-pcap.c
@@ -27,12 +27,14 @@ struct pcap_rtc {
 static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
 {
 	struct pcap_rtc *pcap_rtc = _pcap_rtc;
-	unsigned long rtc_events = 0;
+	unsigned long rtc_events;
 
 	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
-		rtc_events |= RTC_IRQF | RTC_UF;
+		rtc_events = RTC_IRQF | RTC_UF;
 	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
-		rtc_events |= RTC_IRQF | RTC_AF;
+		rtc_events = RTC_IRQF | RTC_AF;
+	else
+		rtc_events = 0;
 
 	rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
 	return IRQ_HANDLED;
@@ -44,13 +46,14 @@ static int pcap_rtc_read_alarm(struct de
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	unsigned long secs;
-	u32 tmp;
+	u32 tod;	/* time of day, seconds since midnight */
+	u32 days;	/* days since 1/1/1970 */
 
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tmp);
-	secs = tmp & PCAP_RTC_TOD_MASK;
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tod);
+	secs = tod & PCAP_RTC_TOD_MASK;
 
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &tmp);
-	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &days);
+	secs += (days & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
 
 	rtc_time_to_tm(secs, tm);
 
@@ -63,15 +66,15 @@ static int pcap_rtc_set_alarm(struct dev
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	unsigned long secs;
-	u32 tmp;
+	u32 tod, days;
 
 	rtc_tm_to_time(tm, &secs);
 
-	tmp = secs % SEC_PER_DAY;
-	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tmp);
+	tod = secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tod);
 
-	tmp = secs / SEC_PER_DAY;
-	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, tmp);
+	days = secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, days);
 
 	return 0;
 }
@@ -81,13 +84,13 @@ static int pcap_rtc_read_time(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 	unsigned long secs;
-	u32 tmp;
+	u32 tod, days;
 
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TOD, &tmp);
-	secs = tmp & PCAP_RTC_TOD_MASK;
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TOD, &tod);
+	secs = tod & PCAP_RTC_TOD_MASK;
 
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &tmp);
-	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
+	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &days);
+	secs += (days & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
 
 	rtc_time_to_tm(secs, tm);
 
@@ -98,19 +101,18 @@ static int pcap_rtc_set_mmss(struct devi
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
-	u32 tmp;
+	u32 tod, days;
 
-	tmp = secs % SEC_PER_DAY;
-	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tmp);
+	tod = secs % SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tod);
 
-	tmp = secs / SEC_PER_DAY;
-	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, tmp);
+	days = secs / SEC_PER_DAY;
+	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, days);
 
 	return 0;
 }
 
-static inline int pcap_rtc_irq_enable(struct device *dev, int pirq,
-							unsigned int en)
+static int pcap_rtc_irq_enable(struct device *dev, int pirq, unsigned int en)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
_

Patches currently in -mm which might be from drwyrm@gmail.com are

rtc-driver-for-pcap2-pmic.patch
rtc-driver-for-pcap2-pmic-update.patch

