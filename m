From: akpm@linux-foundation.org
Subject: [merged] arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:55 -0700
Message-ID: <20120731184855.C0D671E007C@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaSs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:56 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar2@arm.com, paul.gortmaker@gmail.com, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-netx/fb.c: reuse dummy clk routines for CONFIG_HAVE_CLK=n
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-netx-fbc-reuse-dummy-clk-routines-for-config_have_clk=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
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
