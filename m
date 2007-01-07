From: akpm@osdl.org
Subject: - pci-prevent-down_read-when-pci_devices-is-empty.patch removed from -mm tree
Date: Sun, 07 Jan 2007 12:59:02 -0800
Message-ID: <200701072059.l07Kx2aW025252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47925 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbXAGU7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 15:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard@telegraafnet.nl, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     PCI: prevent down_read when pci_devices is empty
has been removed from the -mm tree.  Its filename was
     pci-prevent-down_read-when-pci_devices-is-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@osdl.org: cleanups]
Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty drivers/pci/search.c
--- a/drivers/pci/search.c~pci-prevent-down_read-when-pci_devices-is-empty
+++ a/drivers/pci/search.c
@@ -193,6 +193,18 @@ static struct pci_dev * pci_find_subsys(
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_find_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_INFO "pci_find_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
@@ -259,6 +271,18 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_get_subsys() can potentially be called by drivers super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
_

Patches currently in -mm which might be from ard@telegraafnet.nl are

pci-prevent-down_read-when-pci_devices-is-empty.patch
