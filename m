From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:23:28 -0700
Message-ID: <20120904222328.ACB611E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41629 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IDWX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:23:29 -0400
Received: by yenq6 with SMTP id q6so787458yen.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:23:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, linus.walleij@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-coh901331.c: use clk_prepare_enable() and clk_disable_unprepare()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch

