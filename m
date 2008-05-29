From: akpm@linux-foundation.org
Subject: - ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch removed from -mm tree
Date: Wed, 28 May 2008 20:46:55 -0700
Message-ID: <200805290346.m4T3ktJj014850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYE2Drk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 23:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmacht@suse.de, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, kristen.c.accardi@intel.com, mjg59@srcf.ucam.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ATA ACPI hotplug: handle bay devices in dock stations
has been removed from the -mm tree.  Its filename was
     ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ATA ACPI hotplug: handle bay devices in dock stations
From: Holger Macht <hmacht@suse.de>

* Differentiate between bay devices in dock stations and others:

 - When an ACPI_NOTIFY_EJECT_REQUEST appears, just signal uevent to
   userspace (that is when the optional eject button on a bay device is
   pressed/pulled) giving the possibility to unmount file systems and to
   clean up. Also, only send uevent in case we get an EJECT_REQUEST
   without doing anything else. In other cases, you'll get an add/remove
   event because libata attaches/detaches the device.

 - In case of a dock event, which in turn signals an
   ACPI_NOTIFY_EJECT_REQUEST, immediately detach the device, because it
   may already have been gone

* In case of an ACPI_NOTIFY_DEVICE/BUS_CHECK, evaluate _STA to check if
  the device has been plugged or unplugged. If plugged, hotplug it, if
  unplugged, just signal event to userspace
  (initial patch by Matthew Garrett <mjg59@srcf.ucam.org>)

Signed-off-by: Holger Macht <hmacht@suse.de>
Acked-by: Matthew Garrett <mjg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-acpi.c |  112 ++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 43 deletions(-)

diff -puN drivers/ata/libata-acpi.c~ata-acpi-hotplug-handle-bay-devices-in-dock-stations drivers/ata/libata-acpi.c
--- a/drivers/ata/libata-acpi.c~ata-acpi-hotplug-handle-bay-devices-in-dock-stations
+++ a/drivers/ata/libata-acpi.c
@@ -118,8 +118,25 @@ static void ata_acpi_associate_ide_port(
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
+static void ata_acpi_detach_device(struct ata_port *ap, struct ata_device *dev)
+{
+	if (dev)
+		dev->flags |= ATA_DFLAG_DETACH;
+	else {
+		struct ata_link *tlink;
+		struct ata_device *tdev;
+
+		ata_port_for_each_link(tlink, ap)
+			ata_link_for_each_dev(tdev, tlink)
+			tdev->flags |= ATA_DFLAG_DETACH;
+	}
+
+	ata_port_freeze(ap);
+	ata_port_schedule_eh(ap);
+}
+
 static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device
-				    *dev, u32 event)
+				    *dev, u32 event, int is_dock_event)
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
@@ -135,83 +152,92 @@ static void ata_acpi_handle_hotplug(stru
 		ap = dev->link->ap;
 	ehi = &ap->link.eh_info;
 
-	spin_lock_irqsave(ap->lock, flags);
-
-	if (dev)
+	if (dev) {
+		if (dev->sdev)
+			kobj = &dev->sdev->sdev_gendev.kobj;
 		handle = dev->acpi_handle;
-	else
+	} else {
+		kobj = &ap->dev->kobj;
 		handle = ap->acpi_handle;
+	}
 
 	status = acpi_get_handle(handle, "_EJ0", &tmphandle);
 	if (ACPI_FAILURE(status)) {
-		/* This device is not ejectable */
-		spin_unlock_irqrestore(ap->lock, flags);
+		/* This device does not support hotplug */
 		return;
 	}
 
-	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status)) {
-		printk ("Unable to determine bay status\n");
-		spin_unlock_irqrestore(ap->lock, flags);
-		return;
+	if (kobj && !is_dock_event) {
+		sprintf(event_string, "BAY_EVENT=%d", event);
+		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
 	}
 
+	spin_lock_irqsave(ap->lock, flags);
+
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		ata_ehi_push_desc(ehi, "ACPI event");
-		if (!sta) {
-                /* Device has been unplugged */
-			if (dev)
-				dev->flags |= ATA_DFLAG_DETACH;
-			else {
-				struct ata_link *tlink;
-				struct ata_device *tdev;
-
-				ata_port_for_each_link(tlink, ap) {
-					ata_link_for_each_dev(tdev, tlink) {
-						tdev->flags |=
-							ATA_DFLAG_DETACH;
-					}
-				}
-			}
-			ata_port_schedule_eh(ap);
-			wait = 1;
-		} else {
+
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_ERR "Unable to determine bay status\n");
+			break;
+		}
+
+		if (sta) {
 			ata_ehi_hotplugged(ehi);
 			ata_port_freeze(ap);
+		} else {
+			/* The device has gone - unplug it */
+			ata_acpi_detach_device(ap, dev);
+			wait = 1;
 		}
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ata_ehi_push_desc(ehi, "ACPI event");
+
+		if (!is_dock_event)
+			break;
+
+		/* undock event - immediate unplug */
+		ata_acpi_detach_device(ap, dev);
+		wait = 1;
+		break;
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (wait)
 		ata_port_wait_eh(ap);
+}
 
-	if (dev) {
-		if (dev->sdev)
-			kobj = &dev->sdev->sdev_gendev.kobj;
-	} else
-		kobj = &ap->dev->kobj;
+static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_device *dev = data;
 
-	if (kobj) {
-		sprintf(event_string, "BAY_EVENT=%d", event);
-		kobject_uevent_env(kobj, KOBJ_CHANGE, envp);
-	}
+	ata_acpi_handle_hotplug(NULL, dev, event, 1);
+}
+
+static void ata_acpi_ap_notify_dock(acpi_handle handle, u32 event, void *data)
+{
+	struct ata_port *ap = data;
+
+	ata_acpi_handle_hotplug(ap, NULL, event, 1);
 }
 
 static void ata_acpi_dev_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_device *dev = data;
 
-	ata_acpi_handle_hotplug(NULL, dev, event);
+	ata_acpi_handle_hotplug(NULL, dev, event, 0);
 }
 
 static void ata_acpi_ap_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ata_port *ap = data;
 
-	ata_acpi_handle_hotplug(ap, NULL, event);
+	ata_acpi_handle_hotplug(ap, NULL, event, 0);
 }
 
 /**
@@ -252,7 +278,7 @@ void ata_acpi_associate(struct ata_host 
 						    ata_acpi_ap_notify, ap);
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
-						     ata_acpi_ap_notify, ap);
+					     ata_acpi_ap_notify_dock, ap);
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -264,7 +290,7 @@ void ata_acpi_associate(struct ata_host 
 						ata_acpi_dev_notify, dev);
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
-						ata_acpi_dev_notify, dev);
+					     ata_acpi_dev_notify_dock, dev);
 			}
 		}
 	}
_

Patches currently in -mm which might be from hmacht@suse.de are

bay-exit-if-notify-handler-cannot-be-installed.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
libata-handle-bay-devices-in-dock-stations.patch

