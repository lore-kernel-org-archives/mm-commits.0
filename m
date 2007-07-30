From: akpm@linux-foundation.org
Subject: + acpi-dock-send-key=value-pair-instead-of-plain-value.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:05:57 -0700
Message-ID: <200707302105.l6UL5vHR030399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938200AbXG3VGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hmacht@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, s.berberig@arcor.de


The patch titled
     ACPI: dock: Send key=value pair instead of plain value
has been added to the -mm tree.  Its filename is
     acpi-dock-send-key=value-pair-instead-of-plain-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

acpi-dock-send-key=value-pair-instead-of-plain-value.patch
