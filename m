From: akpm@linux-foundation.org
Subject: + linux-kernelh-fix-div_round_closest-to-support-negative-dividends.patch added to -mm tree
Date: Fri, 31 Aug 2012 12:38:19 -0700
Message-ID: <20120831193820.12DF720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:46450 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755Ab2HaTiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2012 15:38:22 -0400
Received: by lagw12 with SMTP id w12so171487lag.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 12:38:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@roeck-us.net


The patch titled
     Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST to support negative dividends
has been added to the -mm tree.  Its filename is
     linux-kernelh-fix-div_round_closest-to-support-negative-dividends.patch

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
Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST to support negative dividends

DIV_ROUND_CLOSEST returns a bad result for negative dividends:
	DIV_ROUND_CLOSEST(-2, 2) = 0

Most of the time this does not matter. However, in the hardware monitoring
subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
negative (such as temperatures).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-dividends include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-div_round_closest-to-support-negative-dividends
+++ a/include/linux/kernel.h
@@ -82,10 +82,18 @@
 	__x - (__x % (y));				\
 }							\
 )
+
+/*
+ * Divide positive or negative dividend by positive divisor and round
+ * to closest integer. Result is undefined for negative divisors.
+ */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
-	typeof(divisor) __divisor = divisor;		\
-	(((x) + ((__divisor) / 2)) / (__divisor));	\
+	typeof(x) __x = x;				\
+	typeof(divisor) __d = divisor;			\
+	(((typeof(x))-1) >= 0 || (__x) >= 0) ?		\
+		(((__x) + ((__d) / 2)) / (__d)) :	\
+		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
 )
 
_

Patches currently in -mm which might be from linux@roeck-us.net are

origin.patch
linux-next.patch
linux-kernelh-fix-div_round_closest-to-support-negative-dividends.patch

