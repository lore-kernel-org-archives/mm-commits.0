From: akpm@linux-foundation.org
Subject: [merged] add-explanation-of-udelay-inaccuracy.patch removed from
 -mm tree
Date: Tue, 31 Jan 2017 12:28:34 -0800
Message-ID: <5890f372.V7rR8h26+uoUqepM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdAaU2f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 15:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@armlinux.org.uk, davidriley@chromium.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/delay.h: add explanation of udelay() inaccuracy
has been removed from the -mm tree.  Its filename was
     add-explanation-of-udelay-inaccuracy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: include/linux/delay.h: add explanation of udelay() inaccuracy

There seems to be some misunderstanding that udelay() and friends will
always guarantee the specified delay.  This is a false understanding. 
When udelay() is based on CPU cycles, it can return early for many reasons
which are detailed by Linus' reply to me in a thread in 2011:

  http://lists.openwall.net/linux-kernel/2011/01/12/372

However, a udelay test module was created in 2014 which allows udelay() to
only be 0.5% fast, which is outside of the CPU-cycles udelay() results I
measured back in 2011, which were deemed to be in the "we don't care"
region.

test_udelay() should be fixed to reflect the real allowable tolerance
on udelay(), rather than 0.5%.

Link: http://lkml.kernel.org/r/E1cUAQz-0002HC-EX@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: David Riley <davidriley@chromium.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/delay.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/delay.h~add-explanation-of-udelay-inaccuracy include/linux/delay.h
--- a/include/linux/delay.h~add-explanation-of-udelay-inaccuracy
+++ a/include/linux/delay.h
@@ -5,6 +5,17 @@
  * Copyright (C) 1993 Linus Torvalds
  *
  * Delay routines, using a pre-computed "loops_per_jiffy" value.
+ *
+ * Please note that ndelay(), udelay() and mdelay() may return early for
+ * several reasons:
+ *  1. computed loops_per_jiffy too low (due to the time taken to
+ *     execute the timer interrupt.)
+ *  2. cache behaviour affecting the time it takes to execute the
+ *     loop function.
+ *  3. CPU clock rate changes.
+ *
+ * Please see this thread:
+ *   http://lists.openwall.net/linux-kernel/2011/01/09/56
  */
 
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from rmk+kernel@armlinux.org.uk are


