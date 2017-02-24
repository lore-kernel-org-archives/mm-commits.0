From: akpm@linux-foundation.org
Subject: [patch 110/124] linux/kernel.h: fix DIV_ROUND_CLOSEST to support
 negative divisors
Date: Fri, 24 Feb 2017 15:01:01 -0800
Message-ID: <58b0bb2d.SxuhyTskniPf+0yO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdBXXBC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, niklas.soderlund+renesas@ragnatech.se, linux@roeck-us.net

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST to support negative divisors

While working on a thermal driver I encounter a scenario where the divisor
could be negative, instead of adding local code to handle this I though I
first try to add support for this in DIV_ROUND_CLOSEST.

Add support to DIV_ROUND_CLOSEST for negative divisors if both dividend
and divisor variable types are signed.  This should not alter current
behavior for users of the macro as previously negative divisors where not
supported.

Before:

DIV_ROUND_CLOSEST(  59,  4) =  15
DIV_ROUND_CLOSEST(  59, -4) = -14
DIV_ROUND_CLOSEST( -59,  4) = -15
DIV_ROUND_CLOSEST( -59, -4) =  14

After:

DIV_ROUND_CLOSEST(  59,  4) =  15
DIV_ROUND_CLOSEST(  59, -4) = -15
DIV_ROUND_CLOSEST( -59,  4) = -15
DIV_ROUND_CLOSEST( -59, -4) =  15

[akpm@linux-foundation.org: fix comment, per Guenter]
Link: http://lkml.kernel.org/r/20161222102217.29011-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-divisors include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-divisors
+++ a/include/linux/kernel.h
@@ -100,16 +100,18 @@
 )
 
 /*
- * Divide positive or negative dividend by positive divisor and round
- * to closest integer. Result is undefined for negative divisors and
- * for negative dividends if the divisor variable type is unsigned.
+ * Divide positive or negative dividend by positive or negative divisor
+ * and round to closest integer. Result is undefined for negative
+ * divisors if he dividend variable type is unsigned and for negative
+ * dividends if the divisor variable type is unsigned.
  */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(x) __x = x;				\
 	typeof(divisor) __d = divisor;			\
 	(((typeof(x))-1) > 0 ||				\
-	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
+	 ((typeof(divisor))-1) > 0 ||			\
+	 (((__x) > 0) == ((__d) > 0))) ?		\
 		(((__x) + ((__d) / 2)) / (__d)) :	\
 		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
_
