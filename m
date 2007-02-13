From: akpm@linux-foundation.org
Subject: + irq-kernel-doc-fixes.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:47:49 -0800
Message-ID: <200702130547.l1D5lnB3022921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXBMFsJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     IRQ kernel-doc fixes
has been added to the -mm tree.  Its filename is
     irq-kernel-doc-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IRQ kernel-doc fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in IRQ management.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    1 +
 kernel/irq/chip.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/irq.h~irq-kernel-doc-fixes include/linux/irq.h
--- a/include/linux/irq.h~irq-kernel-doc-fixes
+++ a/include/linux/irq.h
@@ -129,6 +129,7 @@ struct irq_chip {
  *
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
  * @chip:		low level interrupt hardware access
+ * @msi_desc:		MSI descriptor
  * @handler_data:	per-IRQ data for the irq_chip methods
  * @chip_data:		platform-specific per-chip private data for the chip
  *			methods, to allow shared chip implementations
diff -puN kernel/irq/chip.c~irq-kernel-doc-fixes kernel/irq/chip.c
--- a/kernel/irq/chip.c~irq-kernel-doc-fixes
+++ a/kernel/irq/chip.c
@@ -168,7 +168,7 @@ EXPORT_SYMBOL(set_irq_data);
 /**
  *	set_irq_data - set irq type data for an irq
  *	@irq:	Interrupt number
- *	@data:	Pointer to interrupt specific data
+ *	@entry:	Pointer to MSI descriptor data
  *
  *	Set the hardware irq controller data for an irq
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-drm.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
