From: akpm@linux-foundation.org
Subject: [merged] rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:34:35 -0800
Message-ID: <200912162034.nBGKYZrJ013032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763214AbZLPUev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alessandro.zummo@towertech.it, andy.sharp@lsi.com, david-b@pacbell.net, thomas.hommel@gefanuc.com, mm-commits@vger.kernel.org


The patch titled
     rtc: do not use container_of macro as an argument for to_platform_device
has been removed from the -mm tree.  Its filename was
     rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/rtc/rtc-ds1553.c   |    8 ++++----
 drivers/rtc/rtc-ds1742.c   |    8 ++++----
 drivers/rtc/rtc-stk17ta8.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

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

origin.patch

