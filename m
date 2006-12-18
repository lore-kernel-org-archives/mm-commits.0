From: akpm@osdl.org
Subject: - acpi-dock-send-a-uevent-to-indicate-a-device-change.patch removed from -mm tree
Date: Mon, 18 Dec 2006 14:51:05 -0800
Message-ID: <200612182251.kBIMp54C015013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbWLRWvI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 17:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi dock: send a uevent to indicate a device change
has been removed from the -mm tree.  Its filename was
     acpi-dock-send-a-uevent-to-indicate-a-device-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: acpi dock: send a uevent to indicate a device change
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Send a uevent to indicate a device change whenever we dock or undock, so
that userspace may now check the dock status via sysfs.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/dock.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-dock-send-a-uevent-to-indicate-a-device-change drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-send-a-uevent-to-indicate-a-device-change
+++ a/drivers/acpi/dock.c
@@ -326,10 +326,12 @@ static void hotplug_dock_devices(struct 
 
 static void dock_event(struct dock_station *ds, u32 event, int num)
 {
+	struct device *dev = &dock_device.dev;
 	/*
-	 * we don't do events until someone tells me that
-	 * they would like to have them.
+	 * Indicate that the status of the dock station has
+	 * changed.
 	 */
+	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
 }
 
 /**
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
git-libata-all.patch

