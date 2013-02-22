From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sun4v-use-pr_warn-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:35 -0800
Message-ID: <20130222204435.A51705A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63457 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3BVUog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:36 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so104272ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sun4v: use pr_warn() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sun4v-use-pr_warn-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sun4v: use pr_warn() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sun4v.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-pr_warn-instead-of-printk drivers/rtc/rtc-sun4v.c
--- a/drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-pr_warn-instead-of-printk
+++ a/drivers/rtc/rtc-sun4v.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -26,10 +28,10 @@ retry:
 			udelay(100);
 			goto retry;
 		}
-		printk(KERN_WARNING "SUN4V: tod_get() timed out.\n");
+		pr_warn("tod_get() timed out.\n");
 		return 0;
 	}
-	printk(KERN_WARNING "SUN4V: tod_get() not supported.\n");
+	pr_warn("tod_get() not supported.\n");
 	return 0;
 }
 
@@ -53,10 +55,10 @@ retry:
 			udelay(100);
 			goto retry;
 		}
-		printk(KERN_WARNING "SUN4V: tod_set() timed out.\n");
+		pr_warn("tod_set() timed out.\n");
 		return -EAGAIN;
 	}
-	printk(KERN_WARNING "SUN4V: tod_set() not supported.\n");
+	pr_warn("tod_set() not supported.\n");
 	return -EOPNOTSUPP;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

