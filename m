From: akpm@linux-foundation.org
Subject: - dev_dbg-check-dev_dbg-arguments.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:51:38 -0700
Message-ID: <200704281051.l3SApc2x019990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965661AbXD1Kvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     dev_dbg: check dev_dbg() arguments
has been removed from the -mm tree.  Its filename was
     dev_dbg-check-dev_dbg-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dev_dbg: check dev_dbg() arguments
From: Dan Williams <dan.j.williams@intel.com>

Duplicate what Zach Brown did for pr_debug in commit
8b2a1fd1b394c60eaa2587716102dd5e9b4e5990

[akpm@linux-foundation.org: fix a couple of things which broke]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c      |    4 +---
 drivers/usb/host/ohci-hcd.c |    6 ------
 include/linux/device.h      |    6 +++++-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/usb/core/hub.c~dev_dbg-check-dev_dbg-arguments drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~dev_dbg-check-dev_dbg-arguments
+++ a/drivers/usb/core/hub.c
@@ -119,8 +119,7 @@ MODULE_PARM_DESC(use_both_schemes,
 		"first one fails");
 
 
-#ifdef	DEBUG
-static inline char *portspeed (int portstatus)
+static inline char *portspeed(int portstatus)
 {
 	if (portstatus & (1 << USB_PORT_FEAT_HIGHSPEED))
     		return "480 Mb/s";
@@ -129,7 +128,6 @@ static inline char *portspeed (int ports
 	else
 		return "12 Mb/s";
 }
-#endif
 
 /* Note that hdev or one of its children must be locked! */
 static inline struct usb_hub *hdev_to_hub(struct usb_device *hdev)
diff -puN drivers/usb/host/ohci-hcd.c~dev_dbg-check-dev_dbg-arguments drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c~dev_dbg-check-dev_dbg-arguments
+++ a/drivers/usb/host/ohci-hcd.c
@@ -486,9 +486,6 @@ static int ohci_run (struct ohci_hcd *oh
 	 * or if bus glue did the same (e.g. for PCI add-in cards with
 	 * PCI PM support).
 	 */
-	ohci_dbg (ohci, "resetting from state '%s', control = 0x%x\n",
-			hcfs2string (ohci->hc_control & OHCI_CTRL_HCFS),
-			ohci_readl (ohci, &ohci->regs->control));
 	if ((ohci->hc_control & OHCI_CTRL_RWC) != 0
 			&& !device_may_wakeup(hcd->self.controller))
 		device_init_wakeup(hcd->self.controller, 1);
@@ -744,9 +741,6 @@ static void ohci_stop (struct usb_hcd *h
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
-	ohci_dbg (ohci, "stop %s controller (state 0x%02x)\n",
-		hcfs2string (ohci->hc_control & OHCI_CTRL_HCFS),
-		hcd->state);
 	ohci_dump (ohci, 1);
 
 	flush_scheduled_work();
diff -puN include/linux/device.h~dev_dbg-check-dev_dbg-arguments include/linux/device.h
--- a/include/linux/device.h~dev_dbg-check-dev_dbg-arguments
+++ a/include/linux/device.h
@@ -571,7 +571,11 @@ extern const char *dev_driver_string(str
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
-#define dev_dbg(dev, format, arg...) do { (void)(dev); } while (0)
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_dbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
 #endif
 
 #define dev_err(dev, format, arg...)		\
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
iop13xx-msi-support-rev6.patch
git-md-accel.patch
git-ioat-vs-git-md-accel.patch
msi-fix-arm-compile.patch
