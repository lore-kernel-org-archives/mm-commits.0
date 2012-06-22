From: akpm@linux-foundation.org
Subject: + arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n.patch added to -mm tree
Date: Fri, 22 Jun 2012 13:06:37 -0700
Message-ID: <20120622200637.BAAFFA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60305 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab2FVUOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 16:14:48 -0400
Received: by vbnl22 with SMTP id l22so229341vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 13:14:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar2@arm.com, paul.gortmaker@gmail.com, s.hauer@pengutronix.de


The patch titled
     Subject: arch/arm/mach-netx/fb.c: reuse dummy clk routines for CONFIG_HAVE_CLK=n
has been added to the -mm tree.  Its filename is
     arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar2@arm.com>
Subject: arch/arm/mach-netx/fb.c: reuse dummy clk routines for CONFIG_HAVE_CLK=n

mach-netx had its own implementation of clk routines like, clk_get{put},
clk_enable{disable}, etc.  And with introduction of following patchset:

https://lkml.org/lkml/2012/4/24/154

we get compilation error for multiple definition of these routines.

Sascha had following suggestion to deal with it:

http://www.spinics.net/lists/arm-kernel/msg179369.html

So, remove this code completely.

Signed-off-by: Viresh Kumar <viresh.kumar2@arm.com>
Reported-by: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-netx/fb.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN arch/arm/mach-netx/fb.c~arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n arch/arm/mach-netx/fb.c
--- a/arch/arm/mach-netx/fb.c~arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n
+++ a/arch/arm/mach-netx/fb.c
@@ -69,29 +69,6 @@ void netx_clcd_remove(struct clcd_fb *fb
 			      fb->fb.screen_base, fb->fb.fix.smem_start);
 }
 
-void clk_disable(struct clk *clk)
-{
-}
-
-int clk_set_rate(struct clk *clk, unsigned long rate)
-{
-	return 0;
-}
-
-int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-
-struct clk *clk_get(struct device *dev, const char *id)
-{
-	return dev && strcmp(dev_name(dev), "fb") == 0 ? NULL : ERR_PTR(-ENOENT);
-}
-
-void clk_put(struct clk *clk)
-{
-}
