From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:58 -0800
Message-ID: <20121218200759.4DB81200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:50790 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:01 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so63381eek.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepak.sikri@st.com, a.zummo@towertech.it, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-spear: Provide flag for no support of UIE mode
has been removed from the -mm tree.  Its filename was
     rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepak Sikri <deepak.sikri@st.com>
Subject: rtc: rtc-spear: Provide flag for no support of UIE mode

The applications can set the RTC hardware to trigger interrupts in one
of three modes:
    * AIE: Alarm interrupt
    * UIE: Update interrupt (ie: once per second)
    * PIE: Periodic interrupt (sub-second irqs)

The above defined 3 modes are to be supported in the RTC HW in form of
interrupts. The SPEAr RTC hardware does not support the later two modes.

There have been refinements in the RTC core in mainline related to
use of timer queue infrastructure to manage events in RTC. Please refer
the below mentioned patch for details:
	* RTC: Rework RTC code to use timerqueue for events
	* SHA ID: 6610e0893b8bc6f59b14fed7f089c5997f035f88

There have been provisions added to support hardware that do not have
support the UIE mode. Please refer the following patch.
	* rtc: Provide flag for rtc devices that don't support UIE
	* SHA ID: 4a649903f91232d02284d53724b0a45728111767

The patch makes use of the provision defined in the above patch to
update the hardware status of UIE mode.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-spear.c~rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-rtc-spear-provide-flag-for-no-support-of-uie-mode
+++ a/drivers/rtc/rtc-spear.c
@@ -411,6 +411,8 @@ static int __devinit spear_rtc_probe(str
 		goto err_disable_clock;
 	}
 
+	config->rtc->uie_unsupported = 1;
+
 	if (!device_can_wakeup(&pdev->dev))
 		device_init_wakeup(&pdev->dev, 1);
 
_

Patches currently in -mm which might be from deepak.sikri@st.com are

origin.patch
linux-next.patch

