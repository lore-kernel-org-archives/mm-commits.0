From: akpm@linux-foundation.org
Subject: [folded] clocksource-start-cmt-at-clocksource-resume-v2.patch removed from -mm tree
Date: Mon, 21 Dec 2009 15:56:53 -0800
Message-ID: <200912212356.nBLNurTi003703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbZLUX5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 18:57:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource-start-cmt-at-clocksource-resume-v2
has been removed from the -mm tree.  Its filename was
     clocksource-start-cmt-at-clocksource-resume-v2.patch

This patch was dropped because it was folded into clocksource-start-cmt-at-clocksource-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource-start-cmt-at-clocksource-resume-v2
From: Magnus Damm <damm@opensource.se>

 V2 adds suspend handling.

 Depends on the clocksource resume argument patch and the
 clocksource suspend patch.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/sh_cmt.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff -puN drivers/clocksource/sh_cmt.c~clocksource-start-cmt-at-clocksource-resume-v2 drivers/clocksource/sh_cmt.c
--- a/drivers/clocksource/sh_cmt.c~clocksource-start-cmt-at-clocksource-resume-v2
+++ a/drivers/clocksource/sh_cmt.c
@@ -40,7 +40,6 @@ struct sh_cmt_priv {
 	struct platform_device *pdev;
 
 	unsigned long flags;
-	unsigned long flags_suspend;
 	unsigned long match_value;
 	unsigned long next_match_value;
 	unsigned long max_match_value;
@@ -434,9 +433,7 @@ static void sh_cmt_clocksource_disable(s
 
 static void sh_cmt_clocksource_resume(struct clocksource *cs)
 {
-	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
-
-	sh_cmt_start(p, FLAG_CLOCKSOURCE);
+	sh_cmt_start(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
@@ -449,6 +446,7 @@ static int sh_cmt_register_clocksource(s
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
+	cs->suspend = sh_cmt_clocksource_disable;
 	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
@@ -676,38 +674,11 @@ static int __devexit sh_cmt_remove(struc
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
-static int sh_cmt_suspend(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* save flag state and stop CMT channel */
-	p->flags_suspend = p->flags;
-	sh_cmt_stop(p, p->flags);
-	return 0;
-}
-
-static int sh_cmt_resume(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
-
-	/* start CMT channel from saved state */
-	sh_cmt_start(p, p->flags_suspend);
-	return 0;
-}
-
-static struct dev_pm_ops sh_cmt_dev_pm_ops = {
-	.suspend = sh_cmt_suspend,
-	.resume = sh_cmt_resume,
-};
