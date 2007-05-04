From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:15:14 -0700
Message-ID: <200705040315.l443FEsp027948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbXEDDPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, greg@kroah.com, wim@iguana.be


The patch titled
     use mutex instead of semaphore in Berkshire USB-PC Watchdog driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/char/watchdog/pcwd_usb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/watchdog/pcwd_usb.c~use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver drivers/char/watchdog/pcwd_usb.c
--- a/drivers/char/watchdog/pcwd_usb.c~use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver
+++ a/drivers/char/watchdog/pcwd_usb.c
@@ -146,7 +146,7 @@ struct usb_pcwd_private {
 	atomic_t		cmd_received;		/* true if we received a report after a command */
 
 	int			exists;			/* Wether or not the device exists */
-	struct semaphore	sem;			/* locks this structure */
+	struct mutex		mtx;			/* locks this structure */
 };
 static struct usb_pcwd_private *usb_pcwd_device;
 
@@ -635,7 +635,7 @@ static int usb_pcwd_probe(struct usb_int
 
 	usb_pcwd_device = usb_pcwd;
 
-	init_MUTEX (&usb_pcwd->sem);
+	mutex_init(&usb_pcwd->mtx);
 	usb_pcwd->udev = udev;
 	usb_pcwd->interface = interface;
 	usb_pcwd->interface_number = iface_desc->desc.bInterfaceNumber;
@@ -763,7 +763,7 @@ static void usb_pcwd_disconnect(struct u
 	usb_pcwd = usb_get_intfdata (interface);
 	usb_set_intfdata (interface, NULL);
 
-	down (&usb_pcwd->sem);
+	mutex_lock(&usb_pcwd->mtx);
 
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -777,7 +777,7 @@ static void usb_pcwd_disconnect(struct u
 	misc_deregister(&usb_pcwd_temperature_miscdev);
 	unregister_reboot_notifier(&usb_pcwd_notifier);
 
-	up (&usb_pcwd->sem);
+	mutex_unlock(&usb_pcwd->mtx);
 
 	/* Delete the USB PCWD device */
 	usb_pcwd_delete(usb_pcwd);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
