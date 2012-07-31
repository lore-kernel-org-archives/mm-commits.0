From: akpm@linux-foundation.org
Subject: [merged] usb-musb-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:27 -0700
Message-ID: <20120731184828.24E92200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36646 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2GaSsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:31 -0400
Received: by lbbgp10 with SMTP id gp10so295343lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.linux@gmail.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usb/musb: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     usb-musb-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.linux@gmail.com>
Subject: usb/musb: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

musb also has these dummy macros defined locally.  Remove them as they
aren't required anymore.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_core.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/usb/musb/musb_core.h~usb-musb-remove-conditional-compilation-of-clk-code drivers/usb/musb/musb_core.h
--- a/drivers/usb/musb/musb_core.h~usb-musb-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/musb/musb_core.h
@@ -81,14 +81,6 @@ struct musb_ep;
 #define is_peripheral_active(m)		(!(m)->is_host)
 #define is_host_active(m)		((m)->is_host)
 
-#ifndef CONFIG_HAVE_CLK
-/* Dummy stub for clk framework */
-#define clk_get(dev, id)	NULL
-#define clk_put(clock)		do {} while (0)
-#define clk_enable(clock)	do {} while (0)
-#define clk_disable(clock)	do {} while (0)
-#endif
