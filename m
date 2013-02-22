From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c313-use-pr_err-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:29 -0800
Message-ID: <20130222204429.9E08B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:51174 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab3BVUoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:30 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so104281vbb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rs5c313: use pr_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c313-use-pr_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rs5c313: use pr_err() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-rs5c313.c~rtc-rtc-rs5c313-use-pr_err-instead-of-printk drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-rtc-rs5c313-use-pr_err-instead-of-printk
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -39,6 +39,8 @@
  *	1.13	Nobuhiro Iwamatsu: Updata driver.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/rtc.h>
@@ -352,8 +354,7 @@ static void rs5c313_check_xstp_bit(void)
 		tm.tm_year 	= 2000 - 1900;
 
 		rs5c313_rtc_set_time(NULL, &tm);
-		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
-				"1 Jan 2000\n");
+		pr_err("invalid value, resetting to 1 Jan 2000\n");
 	}
 	RS5C313_CEDISABLE;
 	ndelay(700);		/* CE:L */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

