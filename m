From: akpm@linux-foundation.org
Subject: + rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:18:25 -0700
Message-ID: <200910152318.n9FNIPAp016446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763317AbZJOXTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alessandro.zummo@towertech.it, andy.sharp@lsi.com, david-b@pacbell.net, thomas.hommel@gefanuc.com


The patch titled
     rtc: do not use container_of macro as an argument for to_platform_device
has been added to the -mm tree.  Its filename is
     rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch

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
Subject: rtc: do not use container_of macro as an argument for to_platform_device
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The to_platform_device macro itself uses container_of macro.  Nested use
of container_of macro causes following sparse warnings:

rtc-ds1553.c:259:3: warning: symbol '__mptr' shadows an earlier one
rtc-ds1553.c:259:3: originally declared here

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Andrew Sharp <andy.sharp@lsi.com>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-ds1553.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device
+++ a/drivers/rtc/rtc-ds1553.c
@@ -255,8 +255,8 @@ static ssize_t ds1553_nvram_read(struct 
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
@@ -270,8 +270,8 @@ static ssize_t ds1553_nvram_write(struct
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
diff -puN drivers/rtc/rtc-ds1742.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device
+++ a/drivers/rtc/rtc-ds1742.c
@@ -131,8 +131,8 @@ static ssize_t ds1742_nvram_read(struct 
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
@@ -146,8 +146,8 @@ static ssize_t ds1742_nvram_write(struct
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr_nvram;
 	ssize_t count;
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -247,8 +247,8 @@ static ssize_t stk17ta8_nvram_read(struc
 				 struct bin_attribute *attr, char *buf,
 				 loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
@@ -262,8 +262,8 @@ static ssize_t stk17ta8_nvram_write(stru
 				  struct bin_attribute *attr, char *buf,
 				  loff_t pos, size_t size)
 {
-	struct platform_device *pdev =
-		to_platform_device(container_of(kobj, struct device, kobj));
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 	ssize_t count;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

rtc-fix-driver-data-issues-in-several-rtc-drivers.patch
rtc-ds1511-fix-races-around-device-registration.patch
rtc-tx4939-fix-races-around-device-registration.patch
rtc-ds1553-fix-races-around-device-registration.patch
rtc-ds1742-fix-races-around-device-registration.patch
rtc-stk17ta8-fix-races-around-device-registration.patch
rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch

