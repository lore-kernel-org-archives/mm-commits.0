From: akpm@linux-foundation.org
Subject: [merged] clocksource-start-cmt-at-clocksource-resume.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:40:03 -0800
Message-ID: <201002241940.o1OJe38b016342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876Ab0BXTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: start CMT at clocksource resume
has been removed from the -mm tree.  Its filename was
     clocksource-start-cmt-at-clocksource-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: start CMT at clocksource resume
From: Magnus Damm <damm@opensource.se>

Add code to start the CMT timer on clocksource resume.  While at it handle
the suspend case as well.  Remove the platform device specific suspend
calls.

This makes sure the timer is started during sysdev_resume().  Without this
patch the clocksource may be read as suspended, this after sysdev resume
but before platform device resume.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/sh_cmt.c |   35 ++++++---------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN drivers/clocksource/sh_cmt.c~clocksource-start-cmt-at-clocksource-resume drivers/clocksource/sh_cmt.c
--- a/drivers/clocksource/sh_cmt.c~clocksource-start-cmt-at-clocksource-resume
+++ a/drivers/clocksource/sh_cmt.c
@@ -40,7 +40,6 @@ struct sh_cmt_priv {
 	struct platform_device *pdev;
 
 	unsigned long flags;
-	unsigned long flags_suspend;
 	unsigned long match_value;
 	unsigned long next_match_value;
 	unsigned long max_match_value;
@@ -432,6 +431,11 @@ static void sh_cmt_clocksource_disable(s
 	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
+static void sh_cmt_clocksource_resume(struct clocksource *cs)
+{
+	sh_cmt_start(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+}
+
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -442,6 +446,8 @@ static int sh_cmt_register_clocksource(s
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
+	cs->suspend = sh_cmt_clocksource_disable;
+	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 	pr_info("sh_cmt: %s used as clock source\n", cs->name);
@@ -668,38 +674,11 @@ static int __devexit sh_cmt_remove(struc
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
