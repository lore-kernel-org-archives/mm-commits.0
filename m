From: akpm@linux-foundation.org
Subject: [merged] linux-kernelh-fix-div_round_closest-to-support-negative-dividends.patch removed from -mm tree
Date: Tue, 04 Sep 2012 12:26:31 -0700
Message-ID: <20120904192632.0BDCF5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52195 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab2IDT0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 15:26:34 -0400
Received: by lbbge1 with SMTP id ge1so310123lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 12:26:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/kernel.h: fix DIV_ROUND_CLOSEST to support negative dividends
has been removed from the -mm tree.  Its filename was
     linux-kernelh-fix-div_round_closest-to-support-negative-dividends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

