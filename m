From: akpm@linux-foundation.org
Subject: + linux-kernelh-fix-div_round_closest-with-unsigned-divisors.patch added to -mm tree
Date: Wed, 19 Dec 2012 13:47:35 -0800
Message-ID: <20121219214736.18BB920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:39655 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2LSVri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 16:47:38 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so136335eaa.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 13:47:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@roeck-us.net, jbe@pengutronix.de, khali@linux-fr.org


The patch titled
     Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors
has been added to the -mm tree.  Its filename is
     linux-kernelh-fix-div_round_closest-with-unsigned-divisors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Juergen Beisert <jbe@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
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
linux-kernelh-fix-div_round_closest-with-unsigned-divisors.patch

