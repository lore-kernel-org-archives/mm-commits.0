From: akpm@linux-foundation.org
Subject: + kernel-doc-fixes-for-pci-and-drivers-base.patch added to -mm tree
Date: Thu, 26 Jul 2007 18:32:04 -0700
Message-ID: <200707270132.l6R1W4i0031988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431AbXG0BcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 21:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     kernel-doc fixes for PCI and drivers/base/
has been added to the -mm tree.  Its filename is
     kernel-doc-fixes-for-pci-and-drivers-base.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc fixes for PCI and drivers/base/
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix undocumented function parameters in PCI and drivers/base.

Warning(linux-2.6.23-rc1//drivers/pci/pci.c:1526): No description found for parameter 'rq'
Warning(linux-2.6.23-rc1//drivers/base/firmware_class.c:245): No description found for parameter 'bin_attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    1 +
 drivers/pci/pci.c             |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/base/firmware_class.c~kernel-doc-fixes-for-pci-and-drivers-base drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~kernel-doc-fixes-for-pci-and-drivers-base
+++ a/drivers/base/firmware_class.c
@@ -232,6 +232,7 @@ fw_realloc_buffer(struct firmware_priv *
 /**
  * firmware_data_write - write method for firmware
  * @kobj: kobject for the device
+ * @bin_attr: bin_attr structure
  * @buffer: buffer being written
  * @offset: buffer offset for write in total data store area
  * @count: buffer size
diff -puN drivers/pci/pci.c~kernel-doc-fixes-for-pci-and-drivers-base drivers/pci/pci.c
--- a/drivers/pci/pci.c~kernel-doc-fixes-for-pci-and-drivers-base
+++ a/drivers/pci/pci.c
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL(pcie_get_readrq);
 /**
  * pcie_set_readrq - set PCI Express maximum memory read request
  * @dev: PCI device to query
- * @count: maximum memory read count in bytes
+ * @rq: maximum memory read count in bytes
  *    valid values are 128, 256, 512, 1024, 2048, 4096
  *
  * If possible sets maximum read byte count
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-fix-for-kmodc.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
git-acpi.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
