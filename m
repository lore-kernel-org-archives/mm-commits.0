From: akpm@linux-foundation.org
Subject: - acpi-dock-add-immediate_undock-option.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:54 -0700
Message-ID: <200705120515.l4C5Fsng001785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756444AbXELFP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: dock: add immediate_undock option
has been removed from the -mm tree.  Its filename was
     acpi-dock-add-immediate_undock-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: dock: add immediate_undock option
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Allow the driver to be loaded with an option that will allow userspace to
control whether the laptop is ejected immediately when the user presses the
button, or only when the syfs undock file is written.

if immediate_undock == 1, then when the user presses the undock button, the
laptop will send an event to userspace to notify userspace of the undock, but
then immediately undock without waiting for userspace.  This is the current
behavior, and I set this to be the default.

if immediate_undock == 0, then when the user presses the undock button, the
laptop will send an event to userspace and do nothing.  User space can query
the "flags" sysfs entry to determine if an undock request has been made by the
user (if bit 1 is set).  User space will then need to write the undock sysfs
entry to complete the undocking process.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/dock.c |   51 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/dock.c~acpi-dock-add-immediate_undock-option drivers/acpi/dock.c
--- a/drivers/acpi/dock.c~acpi-dock-add-immediate_undock-option
+++ a/drivers/acpi/dock.c
@@ -40,6 +40,13 @@ MODULE_AUTHOR("Kristen Carlson Accardi")
 MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESCRIPTION);
 MODULE_LICENSE("GPL");
 
+static int immediate_undock = 1;
+module_param(immediate_undock, bool, 0644);
+MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
+	"undock immediately when the undock button is pressed, 0 will cause"
+	" the driver to wait for userspace to write the undock sysfs file "
+	" before undocking");
+
 static struct atomic_notifier_head dock_notifier_list;
 static struct platform_device *dock_device;
 static char dock_device_name[] = "dock";
@@ -63,6 +70,7 @@ struct dock_dependent_device {
 };
 
 #define DOCK_DOCKING	0x00000001
+#define DOCK_UNDOCKING  0x00000002
 #define DOCK_EVENT	3
 #define UNDOCK_EVENT	2
 
@@ -420,6 +428,16 @@ static inline void complete_dock(struct 
 	ds->last_dock_time = jiffies;
 }
 
+static inline void begin_undock(struct dock_station *ds)
+{
+	ds->flags |= DOCK_UNDOCKING;
+}
+
+static inline void complete_undock(struct dock_station *ds)
+{
+	ds->flags &= ~(DOCK_UNDOCKING);
+}
+
 /**
  * dock_in_progress - see if we are in the middle of handling a dock event
  * @ds: the dock station
@@ -550,7 +568,7 @@ static int handle_eject_request(struct d
 		printk(KERN_ERR PREFIX "Unable to undock!\n");
 		return -EBUSY;
 	}
-
+	complete_undock(ds);
 	return 0;
 }
 
@@ -594,7 +612,11 @@ static void dock_notify(acpi_handle hand
 	 * to the driver who wish to hotplug.
          */
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		handle_eject_request(ds, event);
+		begin_undock(ds);
+		if (immediate_undock)
+			handle_eject_request(ds, event);
+		else
+			dock_event(ds, event, UNDOCK_EVENT);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown dock event %d\n", event);
@@ -653,6 +675,17 @@ static ssize_t show_docked(struct device
 DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
 /*
+ * show_flags - read method for flags file in sysfs
+ */
+static ssize_t show_flags(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
+
+}
+DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
+
+/*
  * write_undock - write method for "undock" file in sysfs
  */
 static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
@@ -717,6 +750,7 @@ static int dock_add(acpi_handle handle)
 		dock_station = NULL;
 		return PTR_ERR(dock_device);
 	}
+
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
@@ -744,6 +778,17 @@ static int dock_add(acpi_handle handle)
 		dock_station = NULL;
 		return ret;
 	}
+	ret = device_create_file(&dock_device->dev, &dev_attr_flags);
+	if (ret) {
+		printk("Error %d adding sysfs file\n", ret);
+		device_remove_file(&dock_device->dev, &dev_attr_docked);
+		device_remove_file(&dock_device->dev, &dev_attr_undock);
+		device_remove_file(&dock_device->dev, &dev_attr_uid);
+		platform_device_unregister(dock_device);
+		kfree(dock_station);
+		dock_station = NULL;
+		return ret;
+	}
 
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
@@ -781,6 +826,7 @@ dock_add_err_unregister:
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 	kfree(dock_station);
 	dock_station = NULL;
@@ -814,6 +860,7 @@ static int dock_remove(void)
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 
 	/* free dock station memory */
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
