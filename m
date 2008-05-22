From: akpm@linux-foundation.org
Subject: + pcwd-a-couple-of-watchdogs-escaped-conversion.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:08 -0700
Message-ID: <200805222316.m4MNG8Ec026586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969AbYEVXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, wim@iguana.be


The patch titled
     pcwd: a couple of watchdogs escaped conversion
has been added to the -mm tree.  Its filename is
     pcwd-a-couple-of-watchdogs-escaped-conversion.patch

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
Subject: pcwd: a couple of watchdogs escaped conversion
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix them up.  Once we know the long term plan the watchdogs can all get
shrunk massively anyway

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/pcwd_pci.c |    8 +++-----
 drivers/watchdog/pcwd_usb.c |    6 +++---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/watchdog/pcwd_pci.c~pcwd-a-couple-of-watchdogs-escaped-conversion drivers/watchdog/pcwd_pci.c
--- a/drivers/watchdog/pcwd_pci.c~pcwd-a-couple-of-watchdogs-escaped-conversion
+++ a/drivers/watchdog/pcwd_pci.c
@@ -455,8 +455,8 @@ static ssize_t pcipcwd_write(struct file
 	return len;
 }
 
-static int pcipcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -478,9 +478,7 @@ static int pcipcwd_ioctl(struct inode *i
 		case WDIOC_GETSTATUS:
 		{
 			int status;
-
 			pcipcwd_get_status(&status);
-
 			return put_user(status, p);
 		}
 
@@ -644,7 +642,7 @@ static const struct file_operations pcip
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	pcipcwd_write,
-	.ioctl =	pcipcwd_ioctl,
+	.unlocked_ioctl = pcipcwd_ioctl,
 	.open =		pcipcwd_open,
 	.release =	pcipcwd_release,
 };
diff -puN drivers/watchdog/pcwd_usb.c~pcwd-a-couple-of-watchdogs-escaped-conversion drivers/watchdog/pcwd_usb.c
--- a/drivers/watchdog/pcwd_usb.c~pcwd-a-couple-of-watchdogs-escaped-conversion
+++ a/drivers/watchdog/pcwd_usb.c
@@ -369,8 +369,8 @@ static ssize_t usb_pcwd_write(struct fil
 	return len;
 }
 
-static int usb_pcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -535,7 +535,7 @@ static const struct file_operations usb_
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	usb_pcwd_write,
-	.ioctl =	usb_pcwd_ioctl,
+	.unlocked_ioctl = usb_pcwd_ioctl,
 	.open =		usb_pcwd_open,
 	.release =	usb_pcwd_release,
 };
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl.patch
libata-sff-fix-oops-reported-in-kerneloopsorg-for-pnp-devices-with-no-ctl-fix.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations.patch
ata-acpi-hotplug-handle-bay-devices-in-dock-stations-cleanup.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
efirtc-push-down-the-bkl.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
mwave-ioctl-bkl-pushdown.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch
pcwd-a-couple-of-watchdogs-escaped-conversion.patch
dac960-push-down-bkl.patch
cm4000_cs-switch-to-unlocked_ioctl.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
snapshot-push-bkl-down-into-ioctl-handlers.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch
dsp56k-bkl-pushdown.patch
lcd-push-the-bkl-down-into-the-driver-ioctl-handler.patch

