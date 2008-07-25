From: akpm@linux-foundation.org
Subject: - drivers-power-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:59 -0700
Message-ID: <200807252255.m6PMsxtE002864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYGYWzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/power: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     drivers-power-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/power: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf ("platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:". 
Add MODULE_ALIAS() to the hotpluggable "power" drivers drivers, to
re-enable auto loading.

[dbrownell@users.sourceforge.net: one was missing]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2760_battery.c |    2 ++
 drivers/power/pda_power.c      |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/power/ds2760_battery.c~drivers-power-fix-platform-driver-hotplug-coldplug drivers/power/ds2760_battery.c
--- a/drivers/power/ds2760_battery.c~drivers-power-fix-platform-driver-hotplug-coldplug
+++ a/drivers/power/ds2760_battery.c
@@ -433,6 +433,8 @@ static int ds2760_battery_resume(struct 
 
 #endif /* CONFIG_PM */
 
+MODULE_ALIAS("platform:ds2760-battery");
+
 static struct platform_driver ds2760_battery_driver = {
 	.driver = {
 		.name = "ds2760-battery",
diff -puN drivers/power/pda_power.c~drivers-power-fix-platform-driver-hotplug-coldplug drivers/power/pda_power.c
--- a/drivers/power/pda_power.c~drivers-power-fix-platform-driver-hotplug-coldplug
+++ a/drivers/power/pda_power.c
@@ -362,6 +362,8 @@ static int pda_power_resume(struct platf
 #define pda_power_resume NULL
 #endif /* CONFIG_PM */
 
+MODULE_ALIAS("platform:pda-power");
+
 static struct platform_driver pda_power_pdrv = {
 	.driver = {
 		.name = "pda-power",
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
linux-next.patch
use-warn-in-drivers-base.patch

