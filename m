From: akpm@linux-foundation.org
Subject: [merged] i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:21 -0700
Message-ID: <20120731184821.CE6491E0072@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2GaSsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:23 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.linux@gmail.com, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.kumar@st.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: i2c/i2c-pxa: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: viresh kumar <viresh.linux@gmail.com>
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
