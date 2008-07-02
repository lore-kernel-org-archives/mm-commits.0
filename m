From: akpm@linux-foundation.org
Subject: - usb-handle-pci_name-being-const.patch removed from -mm tree
Date: Wed, 02 Jul 2008 16:26:51 -0700
Message-ID: <200807022326.m62NQpD4009183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYGBX04 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:26:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     USB: handle pci_name() being const
has been removed from the -mm tree.  Its filename was
     usb-handle-pci_name-being-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: handle pci_name() being const
From: Greg Kroah-Hartman <gregkh@suse.de>

This changes usb_create_hcd() to be able to handle the fact that
pci_name() has changed to a constant string.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    2 +-
 drivers/usb/core/hcd.h |    2 +-
 include/linux/usb.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/core/hcd.c~usb-handle-pci_name-being-const drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~usb-handle-pci_name-being-const
+++ a/drivers/usb/core/hcd.c
@@ -1744,7 +1744,7 @@ EXPORT_SYMBOL_GPL (usb_hc_died);
  * If memory is unavailable, returns NULL.
  */
 struct usb_hcd *usb_create_hcd (const struct hc_driver *driver,
-		struct device *dev, char *bus_name)
+		struct device *dev, const char *bus_name)
 {
 	struct usb_hcd *hcd;
 
diff -puN drivers/usb/core/hcd.h~usb-handle-pci_name-being-const drivers/usb/core/hcd.h
--- a/drivers/usb/core/hcd.h~usb-handle-pci_name-being-const
+++ a/drivers/usb/core/hcd.h
@@ -233,7 +233,7 @@ extern void usb_hcd_disable_endpoint(str
 extern int usb_hcd_get_frame_number(struct usb_device *udev);
 
 extern struct usb_hcd *usb_create_hcd(const struct hc_driver *driver,
-		struct device *dev, char *bus_name);
+		struct device *dev, const char *bus_name);
 extern struct usb_hcd *usb_get_hcd(struct usb_hcd *hcd);
 extern void usb_put_hcd(struct usb_hcd *hcd);
 extern int usb_add_hcd(struct usb_hcd *hcd,
diff -puN include/linux/usb.h~usb-handle-pci_name-being-const include/linux/usb.h
--- a/include/linux/usb.h~usb-handle-pci_name-being-const
+++ a/include/linux/usb.h
@@ -293,7 +293,7 @@ struct usb_devmap {
 struct usb_bus {
 	struct device *controller;	/* host/master side hardware */
 	int busnum;			/* Bus number (in order of reg) */
-	char *bus_name;			/* stable id (PCI slot_name etc) */
+	const char *bus_name;		/* stable id (PCI slot_name etc) */
 	u8 uses_dma;			/* Does the host controller use DMA? */
 	u8 otg_port;			/* 0, or number of OTG/HNP port */
 	unsigned is_b_host:1;		/* true during some HNP roleswitches */
_

Patches currently in -mm which might be from gregkh@suse.de are

sisusbvga-fix-oops-on-disconnect.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
mtd-handle-pci_name-being-const.patch
3c59x-handle-pci_name-being-const.patch
pci-handle-pci_name-being-const.patch
usb-handle-pci_name-being-const.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
hugetlb-new-sysfs-interface.patch
checkpatch-usb_free_urb-can-take-null.patch
firmware-use-memory_read_from_buffer.patch
edac-core-fix-to-use-dynamic-kobject.patch

