From: akpm@linux-foundation.org
Subject: + misc-add-sensable-phantom-driver-v3.patch added to -mm tree
Date: Thu, 03 May 2007 13:25:18 -0700
Message-ID: <200705032025.l43KPISA018907@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031288AbXECU1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 16:27:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Misc: phantom, diff to -v3
has been added to the -mm tree.  Its filename is
     misc-add-sensable-phantom-driver-v3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Misc: phantom, diff to -v3
From: Jiri Slaby <jirislaby@gmail.com>

phantom, diff to -v3

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   24 ++++++++++++++----------
 include/linux/Kbuild   |    1 +
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN drivers/misc/phantom.c~misc-add-sensable-phantom-driver-v3 drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-add-sensable-phantom-driver-v3
+++ a/drivers/misc/phantom.c
@@ -21,6 +21,7 @@
 #include <linux/cdev.h>
 #include <linux/phantom.h>
 
+#include <asm/atomic.h>
 #include <asm/io.h>
 
 #define PHANTOM_VERSION		"n0.9.5"
@@ -40,7 +41,7 @@ struct phantom_device {
 	u32 __iomem *iaddr;
 	u32 __iomem *oaddr;
 	unsigned long status;
-	unsigned int counter;
+	atomic_t counter;
 
 	wait_queue_head_t wait;
 	struct cdev cdev;
@@ -55,6 +56,7 @@ static int phantom_status(struct phantom
 	pr_debug("phantom_status %lx %lx\n", dev->status, newstat);
 
 	if (!(dev->status & PHB_RUNNING) && (newstat & PHB_RUNNING)) {
+		atomic_set(&dev->counter, 0);
 		iowrite32(PHN_CTL_IRQ, dev->iaddr + PHN_CONTROL);
 		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
 	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
@@ -145,6 +147,8 @@ static int phantom_open(struct inode *in
 	struct phantom_device *dev = container_of(inode->i_cdev,
 			struct phantom_device, cdev);
 
+	nonseekable_open(inode, file);
+
 	if (mutex_lock_interruptible(&dev->open_lock))
 		return -ERESTARTSYS;
 
@@ -165,8 +169,7 @@ static int phantom_release(struct inode 
 {
 	struct phantom_device *dev = file->private_data;
 
-	if (mutex_lock_interruptible(&dev->open_lock))
-		return -ERESTARTSYS;
+	mutex_lock(&dev->open_lock);
 
 	dev->opened = 0;
 	phantom_status(dev, dev->status & ~PHB_RUNNING);
@@ -181,14 +184,14 @@ static unsigned int phantom_poll(struct 
 	struct phantom_device *dev = file->private_data;
 	unsigned int mask = 0;
 
-	pr_debug("phantom_poll: %u\n", dev->counter);
+	pr_debug("phantom_poll: %d\n", atomic_read(&dev->counter));
 	poll_wait(file, &dev->wait, wait);
-	if (dev->counter) {
+	if (atomic_read(&dev->counter)) {
 		mask = POLLIN | POLLRDNORM;
-		dev->counter--;
+		atomic_dec(&dev->counter);
 	} else if ((dev->status & PHB_RUNNING) == 0)
 		mask = POLLIN | POLLRDNORM | POLLERR;
-	pr_debug("phantom_poll end: %x/%u\n", mask, dev->counter);
+	pr_debug("phantom_poll end: %x/%d\n", mask, atomic_read(&dev->counter));
 
 	return mask;
 }
@@ -210,7 +213,7 @@ static irqreturn_t phantom_isr(int irq, 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
 
-	dev->counter++;
+	atomic_inc(&dev->counter);
 	wake_up_interruptible(&dev->wait);
 
 	return IRQ_HANDLED;
@@ -367,6 +370,9 @@ static int phantom_resume(struct pci_dev
 
 	return 0;
 }
+#else
+#define phantom_suspend	NULL
+#define phantom_resume	NULL
 #endif
 
 static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
@@ -381,10 +387,8 @@ static struct pci_driver phantom_pci_dri
 	.id_table = phantom_pci_tbl,
 	.probe = phantom_probe,
 	.remove = __devexit_p(phantom_remove),
-#ifdef CONFIG_PM
 	.suspend = phantom_suspend,
 	.resume = phantom_resume
-#endif
 };
 
 static ssize_t phantom_show_version(struct class *cls, char *buf)
diff -puN include/linux/Kbuild~misc-add-sensable-phantom-driver-v3 include/linux/Kbuild
--- a/include/linux/Kbuild~misc-add-sensable-phantom-driver-v3
+++ a/include/linux/Kbuild
@@ -121,6 +121,7 @@ header-y += pci_regs.h
 header-y += personality.h
 header-y += pfkeyv2.h
 header-y += pg.h
+header-y += phantom.h
 header-y += pkt_cls.h
 header-y += pkt_sched.h
 header-y += posix_types.h
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
