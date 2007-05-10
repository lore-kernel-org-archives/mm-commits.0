From: akpm@linux-foundation.org
Subject: + acpi-dock-send-envp-with-uevent.patch added to -mm tree
Date: Wed, 09 May 2007 21:16:04 -0700
Message-ID: <200705100416.l4A4G4OQ011788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640AbXEJEQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com


The patch titled
     ACPI: dock: send envp with uevent
has been added to the -mm tree.  Its filename is
     acpi-dock-send-envp-with-uevent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: dock: send envp with uevent
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Send an env along with our KOBJ_CHANGE uevent so that user space has the
option of checking for that to see if a dock or undock has occurred.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/dock.c~acpi-dock-send-envp-with-uevent drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-send-envp-with-uevent
+++ a/drivers/acpi/dock.c
@@ -336,11 +336,19 @@ static void hotplug_dock_devices(struct 
 static void dock_event(struct dock_station *ds, u32 event, int num)
 {
 	struct device *dev = &dock_device->dev;
+	char event_string[7];
+	char *envp[] = { event_string, NULL };
+
+	if (num == UNDOCK_EVENT)
+		sprintf(event_string, "UNDOCK");
+	else
+		sprintf(event_string, "DOCK");
+
 	/*
 	 * Indicate that the status of the dock station has
 	 * changed.
 	 */
-	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
 /**
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
