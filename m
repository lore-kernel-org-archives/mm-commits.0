From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:11 -0700
Message-ID: <20121005201711.B13211E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34156 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2JEURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:12 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236232ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare_enable() and clk_disable_unprepare()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare_enable() and clk_disable_unprepare()

clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare
+++ a/drivers/rtc/rtc-coh901331.c
@@ -276,8 +276,7 @@ static void coh901331_shutdown(struct pl
 
 	clk_enable(rtap->clk);
 	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
-	clk_disable(rtap->clk);
-	clk_unprepare(rtap->clk);
+	clk_disable_unprepare(rtap->clk);
 }
 
 static struct platform_driver coh901331_driver = {
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch

