From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-isl12022c-use-ptr_ret.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:34:56 -0700
Message-ID: <51db1460.Jn2DoUN7AKNroTgK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3GHTfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, roman.fietze@telemotive.de, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-isl12022c-use-ptr_ret.patch removed from -mm tree
To: sachin.kamat@linaro.org,roman.fietze@telemotive.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:34:56 -0700


The patch titled
     Subject: drivers/rtc/rtc-isl12022.c: use PTR_RET()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-isl12022c-use-ptr_ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-isl12022.c: use PTR_RET()

Use of PTR_RET() simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Roman Fietze <roman.fietze@telemotive.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-use-ptr_ret drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-use-ptr_ret
+++ a/drivers/rtc/rtc-isl12022.c
@@ -16,6 +16,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/err.h>
 
 #define DRV_VERSION "0.1"
 
@@ -267,10 +268,7 @@ static int isl12022_probe(struct i2c_cli
 	isl12022->rtc = devm_rtc_device_register(&client->dev,
 					isl12022_driver.driver.name,
 					&isl12022_rtc_ops, THIS_MODULE);
-	if (IS_ERR(isl12022->rtc))
-		return PTR_ERR(isl12022->rtc);
