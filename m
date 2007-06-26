From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-the-st-m48t59-rtc-fix-2.patch added to -mm tree
Date: Tue, 26 Jun 2007 11:53:27 -0700
Message-ID: <200706261853.l5QIrRFB032185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622AbXFZSxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 14:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rongkai.zhan@windriver.com, a.zummo@towertech.it


The patch titled
     rtc m48t59 driver leak fixup
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-the-st-m48t59-rtc-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc m48t59 driver leak fixup
From: Mark Zhan <rongkai.zhan@windriver.com>

This patch address the following problems of my previous
"rtc-add-support-for-the-st-m48t59-rtc.patch"

(1) Fixup the m48t59_private leak problem in m48t59_probe() function.

(2) Fixup the arch dependency introduced by 'NO_IRQ'.  This driver
    might be used by other architecture boards which maybe access this RTC
    chip via the I/O Space.

Signed-off-by: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-fix-2 drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-fix-2
+++ a/drivers/rtc/rtc-m48t59.c
@@ -20,6 +20,10 @@
 #include <linux/rtc/m48t59.h>
 #include <linux/bcd.h>
 
+#ifndef NO_IRQ
+#define NO_IRQ	(-1)
+#endif
+
 #define M48T59_READ(reg)	pdata->readb(dev, reg)
 #define M48T59_WRITE(val, reg)	pdata->writeb(dev, reg, val)
 
@@ -57,7 +61,7 @@ m48t59_mem_readb(struct device *dev, u32
 	return readb(m48t59->ioaddr+ofs);
 }
 
-/**
+/*
  * NOTE: M48T59 only uses BCD mode
  */
 static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -357,13 +361,13 @@ static struct bin_attribute m48t59_nvram
 static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
 {
 	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
-	struct m48t59_private *m48t59;
+	struct m48t59_private *m48t59 = NULL;
 	struct resource *res;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	/* This chip could be memory-mapped or I/O-mapped */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
+	if (!res) {
 		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 		if (!res)
 			return -EINVAL;
@@ -399,7 +403,7 @@ static int __devinit m48t59_rtc_probe(st
 	m48t59->size = res->end - res->start + 1;
 	m48t59->ioaddr = ioremap(res->start, m48t59->size);
 	if (!m48t59->ioaddr)
-		return -ENOMEM;
+		goto out;
 
 	/* Try to get irq number. We also can work in
 	 * the mode without IRQ.
@@ -437,6 +441,8 @@ out:
 		free_irq(m48t59->irq, &pdev->dev);
 	if (m48t59->ioaddr)
 		iounmap(m48t59->ioaddr);
+	if (m48t59)
+		kfree(m48t59);
 	return ret;
 }
 
_

Patches currently in -mm which might be from rongkai.zhan@windriver.com are

rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-fix-2.patch
rtc-add-support-for-the-st-m48t59-rtc-fix.patch
