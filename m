From: akpm@linux-foundation.org
Subject: + rtc-rtc-spear-add-clk_unprepare-support.patch added to -mm tree
Date: Thu, 08 Nov 2012 11:36:50 -0800
Message-ID: <20121108193651.9EBCF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:59759 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2KHTgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 14:36:53 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so206712wib.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 11:36:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deepak.sikri@st.com, a.zummo@towertech.it, viresh.kumar@linaro.org


The patch titled
     Subject: rtc: rtc-spear: Add clk_{un}prepare() support
has been added to the -mm tree.  Its filename is
     rtc-rtc-spear-add-clk_unprepare-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepak Sikri <deepak.sikri@st.com>
Subject: rtc: rtc-spear: Add clk_{un}prepare() support

clk_{un}prepare is mandatory for platforms using common clock framework. 
Because for SPEAr we don't do anything in clk_{un}prepare() calls, just
call them once in probe/remove.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-add-clk_unprepare-support drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-add-clk_unprepare-support
+++ a/drivers/rtc/rtc-spear.c
@@ -401,7 +401,7 @@ static int __devinit spear_rtc_probe(str
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
 
-	status = clk_enable(config->clk);
+	status = clk_prepare_enable(config->clk);
 	if (status < 0)
 		return status;
 
@@ -424,7 +424,7 @@ static int __devinit spear_rtc_probe(str
 
 err_disable_clock:
 	platform_set_drvdata(pdev, NULL);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 
 	return status;
 }
@@ -435,7 +435,7 @@ static int __devexit spear_rtc_remove(st
 
 	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
_

Patches currently in -mm which might be from deepak.sikri@st.com are

linux-next.patch
rtc-rtc-spear-use-devm_-routines.patch
rtc-rtc-spear-add-clk_unprepare-support.patch
rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode.patch

