From: akpm@linux-foundation.org
Subject: - acpi-bay-unsuppress-uevents.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:00 -0700
Message-ID: <200705120516.l4C5G033001794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756503AbXELFQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: bay: unsuppress uevents
has been removed from the -mm tree.  Its filename was
     acpi-bay-unsuppress-uevents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
