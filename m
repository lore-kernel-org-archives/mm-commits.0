From: akpm@osdl.org
Subject: - remove-drivers-pci-searchcpci_find_device_reverse.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:20:50 -0800
Message-ID: <200701032220.l03MKolY000755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbXACWYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     remove drivers/pci/search.c:pci_find_device_reverse()
has been removed from the -mm tree.  Its filename was
     remove-drivers-pci-searchcpci_find_device_reverse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove drivers/pci/search.c:pci_find_device_reverse()
From: Adrian Bunk <bunk@stusta.de>

After "ide: complete switch to pci_get" we can remove the no longer used
pci_find_device_reverse().

akpm: normally we'd withdraw this after a warning period, with
EXPORT_UNUSED_SYMBOL().  But Alan says

  Normally - but for the fact pci_find_device{_reverse} is unsafe on any box
  with any kind of pci hotplug events.

  It really needs to die.  It is not hotplug safe.  The alternative would be
  to export it only with !CONFIG_HOTPLUG (which is what my test kernel does
  for both this and pci_find_device()).  If we do that then to all intents and
  purposes it vanishes from most standard builds

  The conversion is also trivial

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/search.c |   38 --------------------------------------
 include/linux/pci.h  |    1 -
 2 files changed, 39 deletions(-)

diff -puN drivers/pci/search.c~remove-drivers-pci-searchcpci_find_device_reverse drivers/pci/search.c
--- a/drivers/pci/search.c~remove-drivers-pci-searchcpci_find_device_reverse
+++ a/drivers/pci/search.c
@@ -340,43 +340,6 @@ exit:
 }
 
 /**
- * pci_find_device_reverse - begin or continue searching for a PCI device by vendor/device id
- * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
- * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
- * @from: Previous PCI device found in search, or %NULL for new search.
- *
- * Iterates through the list of known PCI devices in the reverse order of
- * pci_find_device().
- * If a PCI device is found with a matching @vendor and @device, a pointer to
- * its device structure is returned.  Otherwise, %NULL is returned.
- * A new search is initiated by passing %NULL as the @from argument.
- * Otherwise if @from is not %NULL, searches continue from previous device
- * on the global list.
- */
-struct pci_dev *
-pci_find_device_reverse(unsigned int vendor, unsigned int device, const struct pci_dev *from)
-{
-	struct list_head *n;
-	struct pci_dev *dev;
-
-	WARN_ON(in_interrupt());
-	down_read(&pci_bus_sem);
-	n = from ? from->global_list.prev : pci_devices.prev;
-
-	while (n && (n != &pci_devices)) {
-		dev = pci_dev_g(n);
-		if ((vendor == PCI_ANY_ID || dev->vendor == vendor) &&
-		    (device == PCI_ANY_ID || dev->device == device))
-			goto exit;
-		n = n->prev;
-	}
-	dev = NULL;
-exit:
-	up_read(&pci_bus_sem);
-	return dev;
-}
-
-/**
  * pci_get_class - begin or continue searching for a PCI device by class
  * @class: search for a PCI device with this class designation
  * @from: Previous PCI device found in search, or %NULL for new search.
@@ -451,7 +414,6 @@ EXPORT_SYMBOL(pci_dev_present);
 EXPORT_SYMBOL(pci_find_present);
 
 EXPORT_SYMBOL(pci_find_device);
-EXPORT_SYMBOL(pci_find_device_reverse);
 EXPORT_SYMBOL(pci_find_slot);
 /* For boot time work */
 EXPORT_SYMBOL(pci_find_bus);
diff -puN include/linux/pci.h~remove-drivers-pci-searchcpci_find_device_reverse include/linux/pci.h
--- a/include/linux/pci.h~remove-drivers-pci-searchcpci_find_device_reverse
+++ a/include/linux/pci.h
@@ -477,7 +477,6 @@ extern void pci_sort_breadthfirst(void);
 /* Generic PCI functions exported to card drivers */
 
 struct pci_dev *pci_find_device (unsigned int vendor, unsigned int device, const struct pci_dev *from);
-struct pci_dev *pci_find_device_reverse (unsigned int vendor, unsigned int device, const struct pci_dev *from);
 struct pci_dev *pci_find_slot (unsigned int bus, unsigned int devfn);
 int pci_find_capability (struct pci_dev *dev, int cap);
 int pci_find_next_capability (struct pci_dev *dev, u8 pos, int cap);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-alsa.patch
git-dvb.patch
make-usbvision_rvfree-static.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-mtd.patch
drivers-mtd-ubi-vtblc-make-2-functions-static.patch
git-netdev-all.patch
git-net.patch
net-irda-proper-prototypes.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
arch-i386-kernel-e820c-should-include-asm-setuph.patch
arch-i386-kernel-cpu-mcheck-mcec-should-include-asm-mceh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
toshiba-tc86c001-ide-driver-take-2-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i386-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
