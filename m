From: akpm@linux-foundation.org
Subject: - acpi-dock-send-key=value-pair-instead-of-plain-value.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:15:04 -0700
Message-ID: <200708141915.l7EJF4ha016753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933801AbXHNTVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmacht@suse.de, gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, s.berberig@arcor.de, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: Send key=value pair instead of plain value
has been removed from the -mm tree.  Its filename was
     acpi-dock-send-key=value-pair-instead-of-plain-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: dock: Send key=value pair instead of plain value
From: Holger Macht <hmacht@suse.de>

Send key=value pair along with the uevent instead of a plain value so that
userspace (udev) can handle it like common environment variables.

Signed-off-by: Holger Macht <hmacht@suse.de>
Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Stephan Berberig <s.berberig@arcor.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-dock-send-key=value-pair-instead-of-plain-value drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-send-key=value-pair-instead-of-plain-value
+++ a/drivers/acpi/dock.c
@@ -336,13 +336,13 @@ static void hotplug_dock_devices(struct 
 static void dock_event(struct dock_station *ds, u32 event, int num)
 {
 	struct device *dev = &dock_device->dev;
-	char event_string[7];
+	char event_string[13];
 	char *envp[] = { event_string, NULL };
 
 	if (num == UNDOCK_EVENT)
-		sprintf(event_string, "UNDOCK");
+		sprintf(event_string, "EVENT=undock");
 	else
-		sprintf(event_string, "DOCK");
+		sprintf(event_string, "EVENT=dock");
 
 	/*
 	 * Indicate that the status of the dock station has
_

Patches currently in -mm which might be from hmacht@suse.de are
