From: akpm@linux-foundation.org
Subject: [merged] linux-kernelh-fix-warning-seen-with-w=1-due-to-change-in-div_round_closest.patch removed from -mm tree
Date: Thu, 20 Sep 2012 13:11:38 -0700
Message-ID: <20120920201139.BA228200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47105 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab2ITULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 16:11:42 -0400
Received: by eekd4 with SMTP id d4so170278eek.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 13:11:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, khali@linux-fr.org, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/kernel.h: fix warning seen with W=1 due to change in DIV_ROUND_CLOSEST
has been removed from the -mm tree.  Its filename was
     linux-kernelh-fix-warning-seen-with-w=1-due-to-change-in-div_round_closest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: linux/kernel.h: fix warning seen with W=1 due to change in DIV_ROUND_CLOSEST

After commit b6d86d3d ("Fix DIV_ROUND_CLOSEST to support negative
dividends"), the following warning is seen if the kernel is compiled with
W=1 (-Wextra):

warning: comparison of unsigned expression >= 0 is always true

The warning is due to the test '((typeof(x))-1) >= 0', which is used to
detect if the variable type is unsigned.  Research on the web suggests
that the warning disappears if '>' instead of '>=' is used for the
comparison.

Tests after changing the macro along that line show that the warning is gone,
and that the result is still correct:

i=-4: DIV_ROUND_CLOSEST(i, 2)=-2
i=-3: DIV_ROUND_CLOSEST(i, 2)=-2
i=-2: DIV_ROUND_CLOSEST(i, 2)=-1
i=-1: DIV_ROUND_CLOSEST(i, 2)=-1
i=0: DIV_ROUND_CLOSEST(i, 2)=0
i=1: DIV_ROUND_CLOSEST(i, 2)=1
i=2: DIV_ROUND_CLOSEST(i, 2)=1
i=3: DIV_ROUND_CLOSEST(i, 2)=2
i=4: DIV_ROUND_CLOSEST(i, 2)=2

Code size is the same as before.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~linux-kernelh-fix-warning-seen-with-w=1-due-to-change-in-div_round_closest include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-fix-warning-seen-with-w=1-due-to-change-in-div_round_closest
+++ a/include/linux/kernel.h
@@ -91,7 +91,7 @@
 {							\
 	typeof(x) __x = x;				\
 	typeof(divisor) __d = divisor;			\
-	(((typeof(x))-1) >= 0 || (__x) >= 0) ?		\
+	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
 		(((__x) + ((__d) / 2)) / (__d)) :	\
 		(((__x) - ((__d) / 2)) / (__d));	\
 }							\
_

Patches currently in -mm which might be from linux@roeck-us.net are

linux-next.patch
drm-i915-optimize-div_round_closest-call.patch

