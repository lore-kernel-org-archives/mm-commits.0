From: akpm@linux-foundation.org
Subject: + acpi-bay-send-envp-with-uevent.patch added to -mm tree
Date: Sun, 20 May 2007 20:08:35 -0700
Message-ID: <200705210308.l4L38YLs001279@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbXEUDK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristen.c.accardi@intel.com, s.berberig@arcor.de


The patch titled
     ACPI: bay: send envp with uevent
has been added to the -mm tree.  Its filename is
     acpi-bay-send-envp-with-uevent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: bay: send envp with uevent
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Make the bay driver send env information on bay events.

Upon any bay event, we will send the string "BAY_EVENT=%d" along with the
KOBJ_CHANGE, and report the event number.  What the event number means will
be platform specific.  Event 3 is always an eject request, but an insert
may be either event 1, or it may be event 0.  Event 1 may also be a
remove request.  It would be best if you check the number of your event
with udevmonitor before writing any udev scripts for inserting and
removing drive bays.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Stephan Berberig <s.berberig@arcor.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bay.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/acpi/bay.c~acpi-bay-send-envp-with-uevent drivers/acpi/bay.c
--- a/drivers/acpi/bay.c~acpi-bay-send-envp-with-uevent
+++ a/drivers/acpi/bay.c
@@ -333,18 +333,12 @@ static void bay_notify(acpi_handle handl
 {
 	struct bay *bay_dev = (struct bay *)data;
 	struct device *dev = &bay_dev->pdev->dev;
+	char event_string[12];
+	char *envp[] = { event_string, NULL };
 
 	bay_dprintk(handle, "Bay event");
-
-	switch(event) {
-	case ACPI_NOTIFY_BUS_CHECK:
-	case ACPI_NOTIFY_DEVICE_CHECK:
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
-		break;
-	default:
-		printk(KERN_ERR PREFIX "Bay: unknown event %d\n", event);
-	}
+	sprintf(event_string, "BAY_EVENT=%d\n", event);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
 static acpi_status
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
acpi-bay-send-envp-with-uevent.patch
libata-check-for-an-support.patch
genhd-expose-an-to-user-space.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
genhd-send-async-notification-on-media-change.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
