From: akpm@linux-foundation.org
Subject: + pci-docbooks-add-fix-pci-kernel-doc.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:28:22 -0700
Message-ID: <200904102228.n3AMSNlV023770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZDJWaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org


The patch titled
     pci: docbooks: add/fix PCI kernel-doc
has been added to the -mm tree.  Its filename is
     pci-docbooks-add-fix-pci-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: docbooks: add/fix PCI kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add drivers/pci/*.c source files to DocBook/kernel-api.tmpl and update
those pci/*.c source files that need kernel-doc fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    6 +++++-
 drivers/pci/access.c                  |    4 ++--
 drivers/pci/htirq.c                   |    1 +
 drivers/pci/pci-sysfs.c               |   12 ++++++++----
 drivers/pci/slot.c                    |    4 ++--
 5 files changed, 18 insertions(+), 9 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~pci-docbooks-add-fix-pci-kernel-doc Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~pci-docbooks-add-fix-pci-kernel-doc
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -190,16 +190,20 @@ X!Ekernel/module.c
 !Edrivers/pci/pci.c
 !Edrivers/pci/pci-driver.c
 !Edrivers/pci/remove.c
-!Edrivers/pci/pci-acpi.c
 !Edrivers/pci/search.c
 !Edrivers/pci/msi.c
 !Edrivers/pci/bus.c
+!Edrivers/pci/access.c
+!Edrivers/pci/irq.c
+!Edrivers/pci/htirq.c
 <!-- FIXME: Removed for now since no structured comments in source
 X!Edrivers/pci/hotplug.c
 -->
 !Edrivers/pci/probe.c
+!Edrivers/pci/slot.c
 !Edrivers/pci/rom.c
 !Edrivers/pci/iov.c
+!Idrivers/pci/pci-sysfs.c
      </sect1>
      <sect1><title>PCI Hotplug Support Library</title>
 !Edrivers/pci/hotplug/pci_hotplug_core.c
diff -puN drivers/pci/access.c~pci-docbooks-add-fix-pci-kernel-doc drivers/pci/access.c
--- a/drivers/pci/access.c~pci-docbooks-add-fix-pci-kernel-doc
+++ a/drivers/pci/access.c
@@ -87,8 +87,8 @@ EXPORT_SYMBOL(pci_read_vpd);
  * pci_write_vpd - Write entry to Vital Product Data
  * @dev:	pci device struct
  * @pos:	offset in vpd space
- * @count:	number of bytes to read
- * @val:	value to write
+ * @count:	number of bytes to write
+ * @buf:	buffer containing write data
  *
  */
 ssize_t pci_write_vpd(struct pci_dev *dev, loff_t pos, size_t count, const void *buf)
diff -puN drivers/pci/htirq.c~pci-docbooks-add-fix-pci-kernel-doc drivers/pci/htirq.c
--- a/drivers/pci/htirq.c~pci-docbooks-add-fix-pci-kernel-doc
+++ a/drivers/pci/htirq.c
@@ -158,6 +158,7 @@ int ht_create_irq(struct pci_dev *dev, i
 
 /**
  * ht_destroy_irq - destroy an irq created with ht_create_irq
+ * @irq: irq to be destroyed
  *
  * This reverses ht_create_irq removing the specified irq from
  * existence.  The irq should be free before this happens.
diff -puN drivers/pci/pci-sysfs.c~pci-docbooks-add-fix-pci-kernel-doc drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~pci-docbooks-add-fix-pci-kernel-doc
+++ a/drivers/pci/pci-sysfs.c
@@ -492,6 +492,7 @@ write_vpd_attr(struct kobject *kobj, str
 /**
  * pci_read_legacy_io - read byte(s) from legacy I/O port space
  * @kobj: kobject corresponding to file to read from
+ * @bin_attr: struct bin_attribute for this file
  * @buf: buffer to store results
  * @off: offset into legacy I/O port space
  * @count: number of bytes to read
@@ -517,6 +518,7 @@ pci_read_legacy_io(struct kobject *kobj,
 /**
  * pci_write_legacy_io - write byte(s) to legacy I/O port space
  * @kobj: kobject corresponding to file to read from
+ * @bin_attr: struct bin_attribute for this file
  * @buf: buffer containing value to be written
  * @off: offset into legacy I/O port space
  * @count: number of bytes to write
@@ -733,9 +735,9 @@ pci_mmap_resource_wc(struct kobject *kob
 
 /**
  * pci_remove_resource_files - cleanup resource files
- * @dev: dev to cleanup
+ * @pdev: dev to cleanup
  *
- * If we created resource files for @dev, remove them from sysfs and
+ * If we created resource files for @pdev, remove them from sysfs and
  * free their resources.
  */
 static void
@@ -793,9 +795,9 @@ static int pci_create_attr(struct pci_de
 
 /**
  * pci_create_resource_files - create resource files in sysfs for @dev
- * @dev: dev in question
+ * @pdev: dev in question
  *
- * Walk the resources in @dev creating files for each resource available.
+ * Walk the resources in @pdev creating files for each resource available.
  */
 static int pci_create_resource_files(struct pci_dev *pdev)
 {
@@ -829,6 +831,7 @@ void __weak pci_remove_resource_files(st
 /**
  * pci_write_rom - used to enable access to the PCI ROM display
  * @kobj: kernel object handle
+ * @bin_attr: struct bin_attribute for this file
  * @buf: user input
  * @off: file offset
  * @count: number of byte in input
@@ -852,6 +855,7 @@ pci_write_rom(struct kobject *kobj, stru
 /**
  * pci_read_rom - read a PCI ROM
  * @kobj: kernel object handle
+ * @bin_attr: struct bin_attribute for this file
  * @buf: where to put the data we read from the ROM
  * @off: file offset
  * @count: number of bytes to read
diff -puN drivers/pci/slot.c~pci-docbooks-add-fix-pci-kernel-doc drivers/pci/slot.c
--- a/drivers/pci/slot.c~pci-docbooks-add-fix-pci-kernel-doc
+++ a/drivers/pci/slot.c
@@ -264,8 +264,8 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
 
 /**
  * pci_renumber_slot - update %struct pci_slot -> number
- * @slot - %struct pci_slot to update
- * @slot_nr - new number for slot
+ * @slot: &struct pci_slot to update
+ * @slot_nr: new number for slot
  *
  * The primary purpose of this interface is to allow callers who earlier
  * created a placeholder slot in pci_create_slot() by passing a -1 as
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-fix-email-address.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-docbooks-add-fix-pci-kernel-doc.patch
qla2x-fix-printk-format-warnings.patch
filemap-fix-kernel-doc-warnings.patch
shmem-respect-max_lfs_filesize-fix.patch
shmem-respect-max_lfs_filesize-fix-fix.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

