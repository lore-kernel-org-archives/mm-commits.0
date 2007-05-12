From: akpm@linux-foundation.org
Subject: - acpi-dock-send-envp-with-uevent.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:58 -0700
Message-ID: <200705120515.l4C5FwH8001791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756501AbXELFQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: send envp with uevent
has been removed from the -mm tree.  Its filename was
     acpi-dock-send-envp-with-uevent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-acpi.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
