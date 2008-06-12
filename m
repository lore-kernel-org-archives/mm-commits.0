From: akpm@linux-foundation.org
Subject: - bay-exit-if-notify-handler-cannot-be-installed.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:46 -0700
Message-ID: <200806122037.m5CKbka5005460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbYFLUiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmacht@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     bay: exit if notify handler cannot be installed
has been removed from the -mm tree.  Its filename was
     bay-exit-if-notify-handler-cannot-be-installed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
