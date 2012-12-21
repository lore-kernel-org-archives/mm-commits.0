From: akpm@linux-foundation.org
Subject: [merged] linux-kernelh-fix-div_round_closest-with-unsigned-divisors.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:07 -0800
Message-ID: <20121221204007.C89DF820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49911 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LUUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:08 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so516755ggn.5
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, jbe@pengutronix.de, khali@linux-fr.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors
has been removed from the -mm tree.  Its filename was
     linux-kernelh-fix-div_round_closest-with-unsigned-divisors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors

Commit 263a523 ("linux/kernel.h: Fix warning seen with W=1 due to change
in DIV_ROUND_CLOSEST") fixes a warning seen with W=1 due to change in
DIV_ROUND_CLOSEST.

Unfortunately, the C compiler converts divide operations with unsigned
divisors to unsigned, even if the dividend is signed and negative (for
example, -10 / 5U = 858993457).  The C standard says "If one operand has
unsigned int type, the other operand is converted to unsigned int", so the
compiler is not to blame.  As a result, DIV_ROUND_CLOSEST(0, 2U) and
similar operations now return bad values, since the automatic conversion
of expressions such as "0 - 2U/2" to unsigned was not taken into account.

Fix by checking for the divisor variable type when deciding which
operation to perform.  This fixes DIV_ROUND_CLOSEST(0, 2U), but still
returns bad values for negative dividends divided by unsigned divisors. 
Mark the latter case as unsupported.

One observed effect of this problem is that the s2c_hwmon driver reports a
value of 4198403 instead of 0 if the ADC reads 0.

Other impact is unpredictable.  Problem is seen if the divisor is an
unsigned variable or constant and the dividend is less than (divisor/2).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Juergen Beisert <jbe@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: <stable@vger.kernel.org>	[3.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-div_round_closest-with-unsigned-divisors include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-div_round_closest-with-unsigned-divisors
+++ a/include/linux/kernel.h
@@ -77,13 +77,15 @@
 
 /*
  * Divide positive or negative dividend by positive divisor and round
- * to closest integer. Result is undefined for negative divisors.
+ * to closest integer. Result is undefined for negative divisors and
+ * for negative dividends if the divisor variable type is unsigned.
  */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(x) __x = x;				\
 	typeof(divisor) __d = divisor;			\
-	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
+	(((typeof(x))-1) > 0 ||				\
+	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
 		(((__x) + ((__d) / 2)) / (__d)) :	\
 		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
_

Patches currently in -mm which might be from linux@roeck-us.net are

origin.patch
linux-next.patch

