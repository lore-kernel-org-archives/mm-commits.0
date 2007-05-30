From: akpm@linux-foundation.org
Subject: - usb-replace-flush_workqueue-with-cancel_sync_work.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:14 -0700
Message-ID: <200705302328.l4UNSDL0007738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbXE3X36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, akpm@linux-foundation.org, greg@kroah.com, mlord@pobox.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     USB: replace flush_workqueue with cancel_sync_work
has been removed from the -mm tree.  Its filename was
     usb-replace-flush_workqueue-with-cancel_sync_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: replace flush_workqueue with cancel_sync_work
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as912) replaces a couple of calls to flush_workqueue() with
cancel_sync_work() and cancel_rearming_delayed_work().  Using a more
directed approach allows us to avoid some nasty deadlocks.  The prime
example occurs when a first-level device (the parent is a root hub) is
removed while at the same time the root hub gets a remote wakeup request. 
khubd would try to flush the autosuspend workqueue while holding the
root-hub's lock, and the remote-wakeup workqueue routine would be waiting
to lock the root hub.

The patch also reorganizes the power management portion of
usb_disconnect(), separating it out into its own routine.  The autosuspend
workqueue entry is cancelled immediately instead of waiting for the
device's release routine.  In addition, synchronization with the
autosuspend thread is carried out even for root hubs (an oversight in the
original code).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Mark Lord <mlord@pobox.com>
Cc: Greg KH <greg@kroah.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    2 +-
 drivers/usb/core/hub.c |   32 +++++++++++++++++++++++++-------
 drivers/usb/core/usb.c |    4 ----
 3 files changed, 26 insertions(+), 12 deletions(-)

diff -puN drivers/usb/core/hcd.c~usb-replace-flush_workqueue-with-cancel_sync_work drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~usb-replace-flush_workqueue-with-cancel_sync_work
+++ a/drivers/usb/core/hcd.c
@@ -1681,7 +1681,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 	spin_unlock_irq (&hcd_root_hub_lock);
 
 #ifdef CONFIG_PM
-	flush_workqueue(ksuspend_usb_wq);
+	cancel_work_sync(&hcd->wakeup_work);
 #endif
 
 	mutex_lock(&usb_bus_list_lock);
diff -puN drivers/usb/core/hub.c~usb-replace-flush_workqueue-with-cancel_sync_work drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~usb-replace-flush_workqueue-with-cancel_sync_work
+++ a/drivers/usb/core/hub.c
@@ -1158,6 +1158,30 @@ static void release_address(struct usb_d
 	}
 }
 
+#ifdef	CONFIG_USB_SUSPEND
+
+static void usb_stop_pm(struct usb_device *udev)
+{
+	/* Synchronize with the ksuspend thread to prevent any more
+	 * autosuspend requests from being submitted, and decrement
+	 * the parent's count of unsuspended children.
+	 */
+	usb_pm_lock(udev);
+	if (udev->parent && !udev->discon_suspended)
+		usb_autosuspend_device(udev->parent);
+	usb_pm_unlock(udev);
+
+	/* Stop any autosuspend requests already submitted */
+	cancel_rearming_delayed_work(&udev->autosuspend);
+}
+
+#else
+
+static inline void usb_stop_pm(struct usb_device *udev)
+{ }
+
+#endif
+
 /**
  * usb_disconnect - disconnect a device (usbcore-internal)
  * @pdev: pointer to device being disconnected
@@ -1224,13 +1248,7 @@ void usb_disconnect(struct usb_device **
 	*pdev = NULL;
 	spin_unlock_irq(&device_state_lock);
 
-	/* Decrement the parent's count of unsuspended children */
-	if (udev->parent) {
-		usb_pm_lock(udev);
-		if (!udev->discon_suspended)
-			usb_autosuspend_device(udev->parent);
-		usb_pm_unlock(udev);
-	}
+	usb_stop_pm(udev);
 
 	put_device(&udev->dev);
 }
diff -puN drivers/usb/core/usb.c~usb-replace-flush_workqueue-with-cancel_sync_work drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-replace-flush_workqueue-with-cancel_sync_work
+++ a/drivers/usb/core/usb.c
@@ -184,10 +184,6 @@ static void usb_release_dev(struct devic
 
 	udev = to_usb_device(dev);
 
-#ifdef	CONFIG_USB_SUSPEND
-	cancel_delayed_work(&udev->autosuspend);
-	flush_workqueue(ksuspend_usb_wq);
-#endif
 	usb_destroy_configuration(udev);
 	usb_put_hcd(bus_to_hcd(udev->bus));
 	kfree(udev->product);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
git-hid.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
freezer-run-show_state-when-freezing-times-out.patch
