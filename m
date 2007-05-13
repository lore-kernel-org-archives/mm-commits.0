From: akpm@linux-foundation.org
Subject: - power-management-remove-some-useless-code-from-arm.patch removed from -mm tree
Date: Sat, 12 May 2007 22:15:03 -0700
Message-ID: <200705130515.l4D5F3Cr022761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXEMFQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, greg@kroah.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     power management: remove some useless code from arm platforms
has been removed from the -mm tree.  Its filename was
     power-management-remove-some-useless-code-from-arm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: power management: remove some useless code from arm platforms
From: Johannes Berg <johannes@sipsolutions.net>

This patch kills some useless code omap1/omap2.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/pm.c |   36 +++++------------------------------
 arch/arm/mach-omap2/pm.c |   38 +++++--------------------------------
 2 files changed, 12 insertions(+), 62 deletions(-)

diff -puN arch/arm/mach-omap1/pm.c~power-management-remove-some-useless-code-from-arm arch/arm/mach-omap1/pm.c
--- a/arch/arm/mach-omap1/pm.c~power-management-remove-some-useless-code-from-arm
+++ a/arch/arm/mach-omap1/pm.c
@@ -620,26 +620,11 @@ static void (*saved_idle)(void) = NULL;
  */
 static int omap_pm_prepare(suspend_state_t state)
 {
-	int error = 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle = pm_idle;
 	pm_idle = NULL;
 
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
 
 
@@ -651,20 +636,11 @@ static int omap_pm_prepare(suspend_state
 
 static int omap_pm_enter(suspend_state_t state)
 {
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		omap_pm_suspend();
-		break;
-
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
+	/*
+	 * since we mark only "mem" as valid
+	 * there's no need to check "state" here
+	 */
+	omap_pm_suspend();
 	return 0;
 }
 
diff -puN arch/arm/mach-omap2/pm.c~power-management-remove-some-useless-code-from-arm arch/arm/mach-omap2/pm.c
--- a/arch/arm/mach-omap2/pm.c~power-management-remove-some-useless-code-from-arm
+++ a/arch/arm/mach-omap2/pm.c
@@ -73,26 +73,11 @@ void omap2_pm_idle(void)
 
 static int omap2_pm_prepare(suspend_state_t state)
 {
-	int error = 0;
-
 	/* We cannot sleep in idle until we have resumed */
 	saved_idle = pm_idle;
 	pm_idle = NULL;
 
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		break;
-
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-
-	default:
-		return -EINVAL;
-	}
-
-	return error;
+	return 0;
 }
 
 #define INT0_WAKE_MASK	(OMAP_IRQ_BIT(INT_24XX_GPIO_BANK1) |	\
@@ -345,22 +330,11 @@ static int omap2_pm_suspend(void)
 
 static int omap2_pm_enter(suspend_state_t state)
 {
-	int ret = 0;
-
-	switch (state)
-	{
-	case PM_SUSPEND_STANDBY:
-	case PM_SUSPEND_MEM:
-		ret = omap2_pm_suspend();
-		break;
-	case PM_SUSPEND_DISK:
-		ret = -ENOTSUPP;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
+	/*
+	 * since we mark only 'mem' as valid, there's
+	 * no need to check 'state' here
+	 */
+	return omap2_pm_suspend();
 }
 
 static int omap2_pm_finish(suspend_state_t state)
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
git-wireless.patch
tidy-up-usermode-helper-waiting-a-bit.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
