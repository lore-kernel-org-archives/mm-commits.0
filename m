From: akpm@linux-foundation.org
Subject: [merged] hp-wmi-switch-driver-to-dev_pm_ops.patch removed from -mm tree
Date: Thu, 23 Jul 2009 12:26:23 -0700
Message-ID: <200907231926.n6NJQNNU030124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbZGWT1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 15:27:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, johannes@sipsolutions.net, len.brown@intel.com, linville@tuxdriver.com, mjg@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     hp-wmi: switch driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     hp-wmi-switch-driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp-wmi: switch driver to dev_pm_ops
From: Frans Pop <elendil@planet.nl>

Gets rid of the following warning: Platform driver 'hp-wmi' needs updating
- please use dev_pm_ops

I tested that the resume handler still works on my HP 2510p notebook.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp-wmi.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/platform/x86/hp-wmi.c~hp-wmi-switch-driver-to-dev_pm_ops drivers/platform/x86/hp-wmi.c
--- a/drivers/platform/x86/hp-wmi.c~hp-wmi-switch-driver-to-dev_pm_ops
+++ a/drivers/platform/x86/hp-wmi.c
@@ -53,7 +53,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE9
 
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
-static int hp_wmi_resume_handler(struct platform_device *device);
+static int hp_wmi_resume_handler(struct device *device);
 
 struct bios_args {
 	u32 signature;
@@ -94,14 +94,18 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
+static struct dev_pm_ops hp_wmi_pm_ops = {
+	.resume  = hp_wmi_resume_handler,
+};
+
 static struct platform_driver hp_wmi_driver = {
 	.driver = {
-		   .name = "hp-wmi",
-		   .owner = THIS_MODULE,
+		.name = "hp-wmi",
+		.owner = THIS_MODULE,
+		.pm = &hp_wmi_pm_ops,
 	},
 	.probe = hp_wmi_bios_setup,
 	.remove = hp_wmi_bios_remove,
-	.resume = hp_wmi_resume_handler,
 };
 
 static int hp_wmi_perform_query(int query, int write, int value)
@@ -512,7 +516,7 @@ static int __exit hp_wmi_bios_remove(str
 	return 0;
 }
 
-static int hp_wmi_resume_handler(struct platform_device *device)
+static int hp_wmi_resume_handler(struct device *device)
 {
 	/*
 	 * Hardware state may have changed while suspended, so trigger
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch

