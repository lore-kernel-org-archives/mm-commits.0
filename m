From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1742-nvram-attribute-fix.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:48:51 -0700
Message-ID: <200904091948.n39JmpID025201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbZDITzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ertbjerg@gmail.com, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net


The patch titled
     rtc: rtc-ds1742 nvram attribute fix
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1742-nvram-attribute-fix.patch

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
Subject: rtc: rtc-ds1742 nvram attribute fix
From: Torsten Ertbjerg Rasmussen <ertbjerg@gmail.com>

The RTC driver for ds1742 / ds1743 uses a static nvram attribute.  This
patch replaces this static attribute with one nvram attribute for each
ds174x registered.

The nvram size is not the same for all types of ds174x.  The nvram size is
accessible as the file size of the nvram attribute in sysfs.  With only a
single nvram attribute, this file size will be incorrect if more than one
type of ds174x is present on a system.  See the comment in the removed
code below.

This patch have been tested with linux-2.6.28 and linux-2.6.29-rc5/6 on a
custom board with one ds1743.

Signed-off-by: Torsten Ertbjerg Rasmussen <ertbjerg@gmail.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-nvram-attribute-fix drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-nvram-attribute-fix
+++ a/drivers/rtc/rtc-ds1742.c
@@ -57,6 +57,7 @@ struct rtc_plat_data {
 	size_t size;
 	resource_size_t baseaddr;
 	unsigned long last_jiffies;
+	struct bin_attribute nvram_attr;
 };
 
 static int ds1742_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -157,18 +158,6 @@ static ssize_t ds1742_nvram_write(struct
 	return count;
 }
 
-static struct bin_attribute ds1742_nvram_attr = {
-	.attr = {
-		.name = "nvram",
-		.mode = S_IRUGO | S_IWUSR,
-	},
-	.read = ds1742_nvram_read,
-	.write = ds1742_nvram_write,
-	/* REVISIT: size in sysfs won't match actual size... if it's
-	 * not a constant, each RTC should have its own attribute.
-	 */
-};
-
 static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
@@ -199,6 +188,12 @@ static int __devinit ds1742_rtc_probe(st
 	pdata->size_nvram = pdata->size - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
+	pdata->nvram_attr.attr.name = "nvram";
+	pdata->nvram_attr.attr.mode = S_IRUGO | S_IWUSR;
+	pdata->nvram_attr.read = ds1742_nvram_read;
+	pdata->nvram_attr.write = ds1742_nvram_write;
+	pdata->nvram_attr.size = pdata->size_nvram;
+
 	/* turn RTC on if it was not on */
 	ioaddr = pdata->ioaddr_rtc;
 	sec = readb(ioaddr + RTC_SECONDS);
@@ -221,11 +216,13 @@ static int __devinit ds1742_rtc_probe(st
 	pdata->rtc = rtc;
 	pdata->last_jiffies = jiffies;
 	platform_set_drvdata(pdev, pdata);
-	ds1742_nvram_attr.size = max(ds1742_nvram_attr.size,
-				     pdata->size_nvram);
-	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1742_nvram_attr);
-	if (ret)
+
+	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
+	if (ret) {
+		dev_err(&pdev->dev, "creating nvram file in sysfs failed\n");
 		goto out;
+	}
+
 	return 0;
  out:
 	if (pdata->rtc)
@@ -242,7 +239,7 @@ static int __devexit ds1742_rtc_remove(s
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1742_nvram_attr);
+	sysfs_remove_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 	rtc_device_unregister(pdata->rtc);
 	iounmap(pdata->ioaddr_nvram);
 	release_mem_region(pdata->baseaddr, pdata->size);
_

Patches currently in -mm which might be from ertbjerg@gmail.com are

rtc-rtc-ds1742-nvram-attribute-fix.patch

