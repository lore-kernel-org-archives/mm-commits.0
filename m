From: akpm@linux-foundation.org
Subject: + bay-exit-if-notify-handler-cannot-be-installed.patch added to -mm tree
Date: Thu, 22 May 2008 16:54:21 -0700
Message-ID: <200805222354.m4MNsLFf027963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402AbYEVXyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hmacht@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, trenn@suse.de


The patch titled
     bay: exit if notify handler cannot be installed
has been added to the -mm tree.  Its filename is
     bay-exit-if-notify-handler-cannot-be-installed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bay: exit if notify handler cannot be installed
From: Holger Macht <hmacht@suse.de>

If acpi_install_notify_handler() for a bay device fails, the bay driver is
superfluous.  Most likely, another driver (like libata) is already caring
about this device anyway.  Furthermore,
register_hotplug_dock_device(acpi_handle) from the dock driver must not be
called twice with the same handler.  This would result in an endless loop
consuming 100% of CPU.  So clean up and exit.

Signed-off-by: Holger Macht <hmacht@suse.de>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bay.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/acpi/bay.c~bay-exit-if-notify-handler-cannot-be-installed drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~bay-exit-if-notify-handler-cannot-be-installed
+++ a/drivers/acpi/bay.c
@@ -301,16 +301,20 @@ static int bay_add(acpi_handle handle, i
 	 */
 	pdev->dev.uevent_suppress = 0;
 
-	if (acpi_bay_add_fs(new_bay)) {
-		platform_device_unregister(new_bay->pdev);
-		goto bay_add_err;
-	}
-
 	/* register for events on this device */
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			bay_notify, new_bay);
 	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX "Error installing bay notify handler\n");
+		printk(KERN_INFO PREFIX "Error installing bay notify handler\n");
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
+	}
+
+	if (acpi_bay_add_fs(new_bay)) {
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					   bay_notify);
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
 	}
 
 	/* if we are on a dock station, we should register for dock
_

Patches currently in -mm which might be from hmacht@suse.de are

bay-exit-if-notify-handler-cannot-be-installed.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch

