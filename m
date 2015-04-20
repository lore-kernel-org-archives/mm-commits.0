From: akpm@linux-foundation.org
Subject: [merged] rtc-x1205-use-sign_extend32-for-sign-extension.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:37 -0700
Message-ID: <553550d1.nm1LZP7Yuo2NPI0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbDTTLQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-x1205.c: use sign_extend32() for sign extension
has been removed from the -mm tree.  Its filename was
     rtc-x1205-use-sign_extend32-for-sign-extension.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: drivers/rtc/rtc-x1205.c: use sign_extend32() for sign extension

Despite its name, sign_extend32() is safe to use for 8 bit types too. 
(See https://lkml.org/lkml/2015/1/18/289).

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~rtc-x1205-use-sign_extend32-for-sign-extension drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-x1205-use-sign_extend32-for-sign-extension
+++ a/drivers/rtc/rtc-x1205.c
@@ -22,6 +22,7 @@
 #include <linux/rtc.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/bitops.h>
 
 #define DRV_VERSION "1.0.8"
 
@@ -366,8 +367,7 @@ static int x1205_get_atrim(struct i2c_cl
 	 * perform sign extension. The formula is
 	 * Catr = (atr * 0.25pF) + 11.00pF.
 	 */
-	if (atr & 0x20)
-		atr |= 0xC0;
+	atr = sign_extend32(atr, 5);
 
 	dev_dbg(&client->dev, "%s: raw atr=%x (%d)\n", __func__, atr, atr);
 
_

Patches currently in -mm which might be from martink@posteo.de are

origin.patch
linux-next.patch

