From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:07:08 -0800
Message-ID: <5489eb5c.cmqnW2TcG1qfafiL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517AbaLKTHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: fix write of invalid bits to ST2 reg
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: fix write of invalid bits to ST2 reg

The NXP datasheet says:
"Bits labeled as N should always be written with logic 0."

At least one of those bits is sometime read as a 1, therfore violating
this rule.  To fix this we mask away those bits.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -28,6 +28,7 @@
 #define PCF8563_REG_ST2		0x01
 #define PCF8563_BIT_AIE		(1 << 1)
 #define PCF8563_BIT_AF		(1 << 3)
+#define PCF8563_BITS_ST2_N	(7 << 5)
 
 #define PCF8563_REG_SC		0x02 /* datetime */
 #define PCF8563_REG_MN		0x03
@@ -130,7 +131,7 @@ static int pcf8563_set_alarm_mode(struct
 	else
 		buf &= ~PCF8563_BIT_AIE;
 
-	buf &= ~PCF8563_BIT_AF;
+	buf &= ~(PCF8563_BIT_AF | PCF8563_BITS_ST2_N);
 
 	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0) {
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

