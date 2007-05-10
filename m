From: akpm@linux-foundation.org
Subject: + acpi-bay-unsuppress-uevents.patch added to -mm tree
Date: Wed, 09 May 2007 21:16:05 -0700
Message-ID: <200705100416.l4A4G5Q1011791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbXEJEQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     ACPI: bay: unsuppress uevents
has been added to the -mm tree.  Its filename is
     acpi-bay-unsuppress-uevents.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: bay: unsuppress uevents
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since platform devices seem to get uevents suppressed by default, manually
unsuppress for the bay device since we want to be able to send uevents.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bay.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/acpi/bay.c~acpi-bay-unsuppress-uevents drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~acpi-bay-unsuppress-uevents
+++ a/drivers/acpi/bay.c
@@ -288,6 +288,11 @@ static int bay_add(acpi_handle handle, i
 	new_bay->pdev = pdev;
 	platform_set_drvdata(pdev, new_bay);
 
+	/*
+	 * we want the bay driver to be able to send uevents
+	 */
+	pdev->dev.uevent_suppress = 0;
+
 	if (acpi_bay_add_fs(new_bay)) {
 		platform_device_unregister(new_bay->pdev);
 		goto bay_add_err;
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
acpi-dock-cleanup-the-uid-patch.patch
acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch
acpi-dock-use-dynamically-allocated-platform-device.patch
acpi-dock-add-immediate_undock-option.patch
acpi-dock-unsuppress-uevents.patch
acpi-dock-send-envp-with-uevent.patch
acpi-bay-unsuppress-uevents.patch
acpi-fix-oops-after-dock-driver-fails-to-initialize.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
