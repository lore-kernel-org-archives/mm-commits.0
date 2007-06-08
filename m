From: akpm@linux-foundation.org
Subject: - ide-ide-generic-add-another-device-exception.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:33 -0700
Message-ID: <200706081735.l58HZXHQ006370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938731AbXFHRpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, bzolnier@gmail.com, ml@akana.de, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     ide: ide-generic, add another device exception
has been removed from the -mm tree.  Its filename was
     ide-ide-generic-add-another-device-exception.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: ide-generic, add another device exception
From: Jiri Slaby <jirislaby@gmail.com>

This device is char device and is grabbed by generic ide driver:

00:0b.0 Class ffff: National Semiconductor Corporation 87410 IDE (rev ff) (prog-if ff)
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-

Disallow generic driver to grab it by adding next condition.  Also consolidate
exceptions to one bigger 'switch (dev->vendor)'.

Cc: Ingo Korb <ml@akana.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/generic.c |   37 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/ide/pci/generic.c~ide-ide-generic-add-another-device-exception drivers/ide/pci/generic.c
--- a/drivers/ide/pci/generic.c~ide-ide-generic-add-another-device-exception
+++ a/drivers/ide/pci/generic.c
@@ -198,32 +198,41 @@ static ide_pci_device_t generic_chipsets
 static int __devinit generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	ide_pci_device_t *d = &generic_chipsets[id->driver_data];
-	u16 command;
 	int ret = -ENODEV;
 
 	/* Don't use the generic entry unless instructed to do so */
 	if (id->driver_data == 0 && ide_generic_all == 0)
 			goto out;
 
-	if (dev->vendor == PCI_VENDOR_ID_UMC &&
-	    dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
-	    (!(PCI_FUNC(dev->devfn) & 1)))
-		goto out; /* UM8886A/BF pair */
-
-	if (dev->vendor == PCI_VENDOR_ID_OPTI &&
-	    dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
-	    (!(PCI_FUNC(dev->devfn) & 1)))
-		goto out;
-
-	if (dev->vendor == PCI_VENDOR_ID_JMICRON) {
-		if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 && PCI_FUNC(dev->devfn) != 1)
+	switch (dev->vendor) {
+	case PCI_VENDOR_ID_UMC:
+		if (dev->device == PCI_DEVICE_ID_UMC_UM8886A &&
+				!(PCI_FUNC(dev->devfn) & 1))
+			goto out; /* UM8886A/BF pair */
+		break;
+	case PCI_VENDOR_ID_OPTI:
+		if (dev->device == PCI_DEVICE_ID_OPTI_82C558 &&
+				!(PCI_FUNC(dev->devfn) & 1))
+			goto out;
+		break;
+	case PCI_VENDOR_ID_JMICRON:
+		if (dev->device != PCI_DEVICE_ID_JMICRON_JMB368 &&
+				PCI_FUNC(dev->devfn) != 1)
+			goto out;
+		break;
+	case PCI_VENDOR_ID_NS:
+		if (dev->device == PCI_DEVICE_ID_NS_87410 &&
+				(dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
 			goto out;
+		break;
 	}
 
 	if (dev->vendor != PCI_VENDOR_ID_JMICRON) {
+		u16 command;
 		pci_read_config_word(dev, PCI_COMMAND, &command);
 		if (!(command & PCI_COMMAND_IO)) {
-			printk(KERN_INFO "Skipping disabled %s IDE controller.\n", d->name);
+			printk(KERN_INFO "Skipping disabled %s IDE "
+					"controller.\n", d->name);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-stallion-dont-fail-with-less-than-max-panels.patch
char-stallion-alloc-tty-before-pci-devices-init.patch
char-stallion-proper-fail-return-values.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
shrink_slab-handle-bad-shrinkers.patch
