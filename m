From: akpm@linux-foundation.org
Subject: - acpi-add-autoload-info-to-dock-driver.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:21:52 -0800
Message-ID: <200712102321.lBANLqop024297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbXLJXWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fseidel@suse.de, kasievers@novell.com, kristen.c.accardi@intel.com, lenb@kernel.org, trenn@novell.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add autoload info to dock driver
has been removed from the -mm tree.  Its filename was
     acpi-add-autoload-info-to-dock-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi: add autoload info to dock driver
From: Frank Seidel <fseidel@suse.de>

Add autoload info to dock driver

References: https://bugzilla.novell.com/show_bug.cgi?id=302482

Signed-off-by: Thomas Renninger <trenn@novell.com>
Signed-off-by: Kay Sievers <kasievers@novell.com>
Signed-off-by: Frank Seidel <fseidel@suse.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c         |    6 ++++++
 include/acpi/acpi_drivers.h |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/acpi/dock.c~acpi-add-autoload-info-to-dock-driver drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-add-autoload-info-to-dock-driver
+++ a/drivers/acpi/dock.c
@@ -51,6 +51,12 @@ static struct atomic_notifier_head dock_
 static struct platform_device *dock_device;
 static char dock_device_name[] = "dock";
 
+static const struct acpi_device_id dock_device_ids[] = {
+	{"LNXDOCK", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, dock_device_ids);
+
 struct dock_station {
 	acpi_handle handle;
 	unsigned long last_dock_time;
diff -puN include/acpi/acpi_drivers.h~acpi-add-autoload-info-to-dock-driver include/acpi/acpi_drivers.h
--- a/include/acpi/acpi_drivers.h~acpi-add-autoload-info-to-dock-driver
+++ a/include/acpi/acpi_drivers.h
@@ -48,6 +48,7 @@
 #define ACPI_BUTTON_HID_SLEEPF		"LNXSLPBN"
 #define ACPI_VIDEO_HID			"LNXVIDEO"
 #define ACPI_BAY_HID			"LNXIOBAY"
+#define ACPI_DOCK_HID			"LNXDOCK"
 
 /* --------------------------------------------------------------------------
                                        PCI
_

Patches currently in -mm which might be from fseidel@suse.de are

git-acpi.patch
