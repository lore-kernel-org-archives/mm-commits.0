From: akpm@linux-foundation.org
Subject: - misc-add-sensable-phantom-driver-v3.patch removed from -mm tree
Date: Mon, 07 May 2007 22:12:16 -0700
Message-ID: <200705080512.l485CGEc014129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967870AbXEHFMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, diff to -v3
has been removed from the -mm tree.  Its filename was
     misc-add-sensable-phantom-driver-v3.patch

This patch was dropped because it was folded into misc-add-sensable-phantom-driver.patch

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

origin.patch
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
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-conditions-cleanup-fix.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-probe-cleanup-fix.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
