From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8563c-use-ptr_ret.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:35:00 -0700
Message-ID: <51db1464.Rug48KYoIfmFyvdg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GHTfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-pcf8563c-use-ptr_ret.patch removed from -mm tree
To: sachin.kamat@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:00 -0700


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: use PTR_RET()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8563c-use-ptr_ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-pcf8563.c: use PTR_RET()

Use of PTR_RET() simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-use-ptr_ret drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-use-ptr_ret
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/err.h>
 
 #define DRV_VERSION "0.4.3"
 
@@ -263,10 +264,7 @@ static int pcf8563_probe(struct i2c_clie
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8563->rtc))
-		return PTR_ERR(pcf8563->rtc);
