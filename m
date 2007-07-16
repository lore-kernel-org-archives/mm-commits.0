From: akpm@linux-foundation.org
Subject: - fix-jvc-cdrom-drive-lockup.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:54 -0700
Message-ID: <200707162052.l6GKqspD001576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761816AbXGPVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, bzolnier@gmail.com, greg@kroah.com, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix jvc cdrom drive lockup
has been removed from the -mm tree.  Its filename was
     fix-jvc-cdrom-drive-lockup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix jvc cdrom drive lockup
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

Before calling init_hwif_default, ide_unregister gets lock ide_lock and
disables irq.  init_hwif_default calls ide_default_io_base which calls
pci_get_device and later pci_get_subsys tries to apply for semaphore
pci_bus_sem and goes to sleep.

Mostly, pci_get_device should be called when irq is turned on.

ide_default_io_base just needs find if list pci_devices is empty.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c    |   12 ++++++++++++
 include/asm-i386/ide.h |    4 +---
 include/linux/pci.h    |    3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/pci/probe.c~fix-jvc-cdrom-drive-lockup drivers/pci/probe.c
--- a/drivers/pci/probe.c~fix-jvc-cdrom-drive-lockup
+++ a/drivers/pci/probe.c
@@ -22,6 +22,18 @@ EXPORT_SYMBOL(pci_root_buses);
 
 LIST_HEAD(pci_devices);
 
+/*
+ * Some device drivers need know if pci is initiated.
+ * Basically, we think pci is not initiated when there
+ * is no device in list of pci_devices.
+ */
+int no_pci_devices(void)
+{
+	return list_empty(&pci_devices);
+}
+
+EXPORT_SYMBOL(no_pci_devices);
+
 #ifdef HAVE_PCI_LEGACY
 /**
  * pci_create_legacy_files - create legacy I/O port and memory files
diff -puN include/asm-i386/ide.h~fix-jvc-cdrom-drive-lockup include/asm-i386/ide.h
--- a/include/asm-i386/ide.h~fix-jvc-cdrom-drive-lockup
+++ a/include/asm-i386/ide.h
@@ -40,14 +40,13 @@ static __inline__ int ide_default_irq(un
 
 static __inline__ unsigned long ide_default_io_base(int index)
 {
-	struct pci_dev *pdev;
 	/*
 	 *	If PCI is present then it is not safe to poke around
 	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
 	 *	defined compatibility mode ports for PCI. A user can 
 	 *	override this using ide= but we must default safe.
 	 */
-	if ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL)) == NULL) {
+	if (no_pci_devices()) {
 		switch(index) {
 			case 2: return 0x1e8;
 			case 3: return 0x168;
@@ -55,7 +54,6 @@ static __inline__ unsigned long ide_defa
 			case 5: return 0x160;
 		}
 	}
-	pci_dev_put(pdev);
 	switch (index) {
 		case 0:	return 0x1f0;
 		case 1:	return 0x170;
diff -puN include/linux/pci.h~fix-jvc-cdrom-drive-lockup include/linux/pci.h
--- a/include/linux/pci.h~fix-jvc-cdrom-drive-lockup
+++ a/include/linux/pci.h
@@ -432,6 +432,8 @@ extern struct bus_type pci_bus_type;
  * code, or pci core code. */
 extern struct list_head pci_root_buses;	/* list of all known PCI buses */
 extern struct list_head pci_devices;	/* list of all devices */
+/* Some device drivers need know if pci is initiated */
+extern int no_pci_devices(void);
 
 void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
@@ -724,6 +726,7 @@ static inline struct pci_dev *pci_get_cl
 { return NULL; }
 
 #define pci_dev_present(ids)	(0)
+#define no_pci_devices()	(1)
 #define pci_find_present(ids)	(NULL)
 #define pci_dev_put(dev)	do { } while (0)
 
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

origin.patch
