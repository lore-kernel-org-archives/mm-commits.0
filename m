From: akpm@linux-foundation.org
Subject: - usb-fix-interface-deregistration-during-unbind-operations.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:17 -0700
Message-ID: <200804130240.m3D2eHfB032488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbYDMCk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     usb: fix interface deregistration during unbind operations
has been removed from the -mm tree.  Its filename was
     usb-fix-interface-deregistration-during-unbind-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fix interface deregistration during unbind operations
From: Alan Stern <stern@rowland.harvard.edu>

Removing an interface's sysfs files before unregistering the interface doesn't
work properly, because usb_unbind_interface() will reinstall altsetting 0 and
thereby create new sysfs files.  This patch (as1074) removes the files after
the unregistration is finished.  It's not quite as clean, but at least it
works.

Also, there's no need to check if an interface has been registered before
removing its sysfs files.  If it hasn't been registered then the files won't
have been created, so usb_remove_sysfs_intf_files() will simply do nothing.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/message.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/usb/core/message.c~usb-fix-interface-deregistration-during-unbind-operations drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~usb-fix-interface-deregistration-during-unbind-operations
+++ a/drivers/usb/core/message.c
@@ -1089,8 +1089,8 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				interface->dev.bus_id);
-			usb_remove_sysfs_intf_files(interface);
 			device_del(&interface->dev);
+			usb_remove_sysfs_intf_files(interface);
 		}
 
 		/* Now that the interfaces are unbound, nobody should
@@ -1231,7 +1231,7 @@ int usb_set_interface(struct usb_device 
 	 */
 
 	/* prevent submissions using previous endpoint settings */
-	if (iface->cur_altsetting != alt && device_is_registered(&iface->dev))
+	if (iface->cur_altsetting != alt)
 		usb_remove_sysfs_intf_files(iface);
 	usb_disable_interface(dev, iface);
 
@@ -1330,8 +1330,7 @@ int usb_reset_configuration(struct usb_d
 		struct usb_interface *intf = config->interface[i];
 		struct usb_host_interface *alt;
 
-		if (device_is_registered(&intf->dev))
-			usb_remove_sysfs_intf_files(intf);
+		usb_remove_sysfs_intf_files(intf);
 		alt = usb_altnum_to_altsetting(intf, 0);
 
 		/* No altsetting 0?  We'll assume the first altsetting.
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch

