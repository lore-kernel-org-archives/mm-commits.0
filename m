From: akpm@linux-foundation.org
Subject: + i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:32:49 -0700
Message-ID: <20120508223249.F2928A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54275 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab2EHWcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:32:51 -0400
Received: by qabg24 with SMTP id g24so179833qab.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:32:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.linux@gmail.com, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.kumar@st.com, w.sang@pengutronix.de


The patch titled
     Subject: i2c/i2c-pxa: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.linux@gmail.com>
Subject: i2c/i2c-pxa: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

pxa i2c also has these dummy macros defined locally.  Remove them as they
aren't required anymore.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pxa.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-i2c-pxa-remove-conditional-compilation-of-clk-code drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-i2c-pxa-remove-conditional-compilation-of-clk-code
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -41,13 +41,6 @@
 
 #include <asm/irq.h>
 
-#ifndef CONFIG_HAVE_CLK
-#define clk_get(dev, id)	NULL
-#define clk_put(clk)		do { } while (0)
-#define clk_disable(clk)	do { } while (0)
-#define clk_enable(clk)		do { } while (0)
-#endif
