From: akpm@linux-foundation.org
Subject: + rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch added to -mm tree
Date: Thu, 19 Jan 2012 12:31:28 -0800
Message-ID: <20120119203131.40F99200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47650 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab2ASUbd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2012 15:31:33 -0500
Received: by eaaf1 with SMTP id f1so11147eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2012 12:31:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deepak.sikri@st.com, rajeev-dlh.kumar@st.com, shiraz.hashim@st.com, viresh.kumar@st.com


The patch titled
     Subject: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
has been added to the -mm tree.  Its filename is
     rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch

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
Subject: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt

Handle the fix for unbalanced irq for the cases when enable_irq_wake
fails, and a warning related to same is displayed on the console.  The
workaround is handled at the driver level.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-spear.c~rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt
+++ a/drivers/rtc/rtc-spear.c
@@ -80,6 +80,7 @@ struct spear_rtc_config {
 	struct clk *clk;
 	spinlock_t lock;
 	void __iomem *ioaddr;
+	unsigned int irq_wake;
 };
 
 static inline void spear_rtc_clear_interrupt(struct spear_rtc_config *config)
@@ -463,9 +464,10 @@ static int spear_rtc_suspend(struct plat
 	int irq;
 
 	irq = platform_get_irq(pdev, 0);
-	if (device_may_wakeup(&pdev->dev))
-		enable_irq_wake(irq);
-	else {
+	if (device_may_wakeup(&pdev->dev)) {
+		if (!enable_irq_wake(irq))
+			config->irq_wake = 1;
+	} else {
 		spear_rtc_disable_interrupt(config);
 		clk_disable(config->clk);
 	}
@@ -481,9 +483,12 @@ static int spear_rtc_resume(struct platf
 
 	irq = platform_get_irq(pdev, 0);
 
-	if (device_may_wakeup(&pdev->dev))
-		disable_irq_wake(irq);
-	else {
+	if (device_may_wakeup(&pdev->dev)) {
+		if (config->irq_wake) {
+			disable_irq_wake(irq);
+			config->irq_wake = 0;
+		}
+	} else {
 		clk_enable(config->clk);
 		spear_rtc_enable_interrupt(config);
 	}
_
Subject: Subject: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt

Patches currently in -mm which might be from deepak.sikri@st.com are

origin.patch
rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch
rtc-spear-fix-for-rtc_aie_on-and-rtc_aie_off-ioctl-errors.patch
rtc-rtc-spear-call-platform_set_drvdata-before-registering-rtc-device.patch

