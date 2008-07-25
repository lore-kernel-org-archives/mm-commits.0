From: akpm@linux-foundation.org
Subject: - mfd-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:02 -0700
Message-ID: <200807252255.m6PMt290002944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755082AbYGYXHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, rjw@sisk.pl, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     mfd: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     mfd-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:". 
Add MODULE_ALIAS() to the MFD platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: one was missing]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/htc-pasic3.c |    2 ++
 drivers/mfd/mcp-sa11x0.c |    2 ++
 drivers/mfd/sm501.c      |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/mfd/htc-pasic3.c~mfd-fix-platform-driver-hotplug-coldplug drivers/mfd/htc-pasic3.c
--- a/drivers/mfd/htc-pasic3.c~mfd-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mfd/htc-pasic3.c
@@ -238,6 +238,8 @@ static int pasic3_remove(struct platform
 	return 0;
 }
 
+MODULE_ALIAS("platform:pasic3");
+
 static struct platform_driver pasic3_driver = {
 	.driver		= {
 		.name	= "pasic3",
diff -puN drivers/mfd/mcp-sa11x0.c~mfd-fix-platform-driver-hotplug-coldplug drivers/mfd/mcp-sa11x0.c
--- a/drivers/mfd/mcp-sa11x0.c~mfd-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mfd/mcp-sa11x0.c
@@ -242,6 +242,8 @@ static int mcp_sa11x0_resume(struct plat
 /*
  * The driver for the SA11x0 MCP port.
  */
+MODULE_ALIAS("platform:sa11x0-mcp");
+
 static struct platform_driver mcp_sa11x0_driver = {
 	.probe		= mcp_sa11x0_probe,
 	.remove		= mcp_sa11x0_remove,
diff -puN drivers/mfd/sm501.c~mfd-fix-platform-driver-hotplug-coldplug drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mfd/sm501.c
@@ -1378,6 +1378,8 @@ static struct pci_driver sm501_pci_drv =
 	.remove		= sm501_pci_remove,
 };
 
+MODULE_ALIAS("platform:sm501");
+
 static struct platform_driver sm501_plat_drv = {
 	.driver		= {
 		.name	= "sm501",
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
linux-next.patch
use-warn-in-drivers-base.patch

