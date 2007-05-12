From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:32 -0700
Message-ID: <200705120516.l4C5GWKF001828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbXELFQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, greg@kroah.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in Berkshire USB-PC Watchdog driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore in Berkshire USB-PC Watchdog driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The Berkshire USB-PC Watchdog driver uses a semaphore as mutex.  Use the mutex
API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/pcwd_usb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/watchdog/pcwd_usb.c~use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver drivers/char/watchdog/pcwd_usb.c
--- a/drivers/char/watchdog/pcwd_usb.c~use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver
+++ a/drivers/char/watchdog/pcwd_usb.c
@@ -34,6 +34,7 @@
 #include <linux/watchdog.h>	/* For the watchdog specific items */
 #include <linux/notifier.h>	/* For notifier support */
 #include <linux/reboot.h>	/* For reboot_notifier stuff */
+#include <linux/mutex.h>
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/fs.h>		/* For file operations */
 #include <linux/usb.h>		/* For USB functions */
@@ -146,7 +147,7 @@ struct usb_pcwd_private {
 	atomic_t		cmd_received;		/* true if we received a report after a command */
 
 	int			exists;			/* Wether or not the device exists */
-	struct semaphore	sem;			/* locks this structure */
+	struct mutex		mtx;			/* locks this structure */
 };
 static struct usb_pcwd_private *usb_pcwd_device;
 
@@ -635,7 +636,7 @@ static int usb_pcwd_probe(struct usb_int
 
 	usb_pcwd_device = usb_pcwd;
 
-	init_MUTEX (&usb_pcwd->sem);
+	mutex_init(&usb_pcwd->mtx);
 	usb_pcwd->udev = udev;
 	usb_pcwd->interface = interface;
 	usb_pcwd->interface_number = iface_desc->desc.bInterfaceNumber;
@@ -763,7 +764,7 @@ static void usb_pcwd_disconnect(struct u
 	usb_pcwd = usb_get_intfdata (interface);
 	usb_set_intfdata (interface, NULL);
 
-	down (&usb_pcwd->sem);
+	mutex_lock(&usb_pcwd->mtx);
 
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -777,7 +778,7 @@ static void usb_pcwd_disconnect(struct u
 	misc_deregister(&usb_pcwd_temperature_miscdev);
 	unregister_reboot_notifier(&usb_pcwd_notifier);
 
-	up (&usb_pcwd->sem);
+	mutex_unlock(&usb_pcwd->mtx);
 
 	/* Delete the USB PCWD device */
 	usb_pcwd_delete(usb_pcwd);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
