From: akpm@osdl.org
Subject: + pci-prevent-down_read-when-pci_devices-is-empty.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:49:51 -0800
Message-ID: <200701022149.l02Lnpme030897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915AbXABVuF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ard@telegraafnet.nl, greg@kroah.com


The patch titled
     PCI: prevent down_read when pci_devices is empty
has been added to the -mm tree.  Its filename is
     pci-prevent-down_read-when-pci_devices-is-empty.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI: prevent down_read when pci_devices is empty
From: Ard van Breemen <ard@telegraafnet.nl>

The pci_find_subsys gets called very early by obsolete ide setup parameters. 
This is a bogus call since pci is not initialized yet, so the list is empty. 
But in the mean time, interrupts get enabled by down_read.  This can result in
a kernel panic when the irq controller gets initialized.

This patch checks if the device list is empty before taking the semaphore, and
hence will not enable irq's.  Furthermore it will inform that it is called
while pci_devices is empty as a reminder that the ide code needs to be fixed.

The pci_get_subsys can get called in the same manner, and as such is patched
in the same manner.

Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+)

diff -puN drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty drivers/pci/search.c
--- a/drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty
+++ a/drivers/pci/search.c
@@ -193,6 +193,17 @@ static struct pci_dev * pci_find_subsys(
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_find_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if(unlikely(list_empty(&pci_devices))) {
+		printk(KERN_INFO "pci_find_subsys() called while pci_devices is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
@@ -259,6 +270,16 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+	/*
+	 * pci_get_subsys() can potentially be called by drivers super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if(unlikely(list_empty(&pci_devices))) {
+		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs.patch
pci-prevent-down_read-when-pci_devices-is-empty.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
