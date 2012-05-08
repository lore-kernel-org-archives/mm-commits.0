From: akpm@linux-foundation.org
Subject: + usb-musb-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:32:56 -0700
Message-ID: <20120508223256.D5F1FA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50996 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab2EHWc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:32:59 -0400
Received: by eaaq10 with SMTP id q10so344043eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:32:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.linux@gmail.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.kumar@st.com


The patch titled
     Subject: usb/musb: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     usb-musb-remove-conditional-compilation-of-clk-code.patch

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
