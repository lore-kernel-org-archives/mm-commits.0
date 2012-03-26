From: akpm@linux-foundation.org
Subject: [merged] rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:14 -0700
Message-ID: <20120326193114.63FCAA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47661 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:15 -0400
Received: by ghbz15 with SMTP id z15so831635ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepak.sikri@st.com, rajeev-dlh.kumar@st.com, shiraz.hashim@st.com, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-spear: fix for balancing the enable_irq_wake in Power Mgmt
has been removed from the -mm tree.  Its filename was
     rtc-spear-fix-for-balancing-the-enable_irq_wake-in-power-mgmt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from deepak.sikri@st.com are

origin.patch

