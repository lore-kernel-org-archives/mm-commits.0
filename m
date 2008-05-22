From: akpm@linux-foundation.org
Subject: + rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch added to -mm tree
Date: Thu, 22 May 2008 16:16:02 -0700
Message-ID: <200805222316.m4MNG2D3026574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517AbYEVXQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     rio: push down the BKL into the firmware ioctl handler
has been added to the -mm tree.  Its filename is
     rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch

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
Subject: rio: push down the BKL into the firmware ioctl handler
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

TTY side is already done.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/rio_linux.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/rio/rio_linux.c~rio-push-down-the-bkl-into-the-firmware-ioctl-handler drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~rio-push-down-the-bkl-into-the-firmware-ioctl-handler
+++ a/drivers/char/rio/rio_linux.c
@@ -184,7 +184,7 @@ static int rio_set_real_termios(void *pt
 static void rio_hungup(void *ptr);
 static void rio_close(void *ptr);
 static int rio_chars_in_buffer(void *ptr);
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 static int rio_init_drivers(void);
 
 static void my_hd(void *addr, int len);
@@ -245,7 +245,7 @@ static struct real_driver rio_real_drive
 
 static const struct file_operations rio_fw_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = rio_fw_ioctl,
+	.unlocked_ioctl = rio_fw_ioctl,
 };
 
 static struct miscdevice rio_fw_device = {
@@ -565,13 +565,15 @@ static void rio_close(void *ptr)
 
 
 
-static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
+static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int rc = 0;
 	func_enter();
 
 	/* The "dev" argument isn't used. */
+	lock_kernel();
 	rc = riocontrol(p, 0, cmd, arg, capable(CAP_SYS_ADMIN));
+	unlock_kernel();
 
 	func_exit();
 	return rc;
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

