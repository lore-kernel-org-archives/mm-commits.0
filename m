From: akpm@linux-foundation.org
Subject: + drivers-power-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:49:10 -0700
Message-ID: <200807020849.m628nBx6008058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYGBIub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     drivers/power: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     drivers-power-fix-platform-driver-hotplug-coldplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: <stable@kernel.org>
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

linux-next.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
firmware-use-memory_read_from_buffer.patch

