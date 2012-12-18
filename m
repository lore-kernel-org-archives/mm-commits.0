From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-add-clk_unprepare-support.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:55 -0800
Message-ID: <20121218200755.A32DB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58802 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:57 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so125949qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepak.sikri@st.com, a.zummo@towertech.it, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-spear: Add clk_{un}prepare() support
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-add-clk_unprepare-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -395,7 +395,7 @@ static int __devinit spear_rtc_probe(str
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
 
-	status = clk_enable(config->clk);
+	status = clk_prepare_enable(config->clk);
 	if (status < 0)
 		return status;
 
@@ -418,7 +418,7 @@ static int __devinit spear_rtc_probe(str
 
 err_disable_clock:
 	platform_set_drvdata(pdev, NULL);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 
 	return status;
 }
@@ -429,7 +429,7 @@ static int __devexit spear_rtc_remove(st
 
 	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
-	clk_disable(config->clk);
+	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
_

Patches currently in -mm which might be from deepak.sikri@st.com are

origin.patch
linux-next.patch

