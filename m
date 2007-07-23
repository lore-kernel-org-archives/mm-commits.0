From: akpm@linux-foundation.org
Subject: - document-pci_iomap.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:36:01 -0700
Message-ID: <200707230936.l6N9a1De016536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759252AbXGWJp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, greg@kroah.com, htejun@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Document pci_iomap()
has been removed from the -mm tree.  Its filename was
     document-pci_iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Document pci_iomap()
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This useful interface is hardly mentioned anywhere in the in-tree
documentation.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/deviceiobook.tmpl |    3 ++-
 include/asm-i386/io.h                   |    3 +++
 lib/iomap.c                             |   15 ++++++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/deviceiobook.tmpl~document-pci_iomap Documentation/DocBook/deviceiobook.tmpl
--- a/Documentation/DocBook/deviceiobook.tmpl~document-pci_iomap
+++ a/Documentation/DocBook/deviceiobook.tmpl
@@ -316,7 +316,8 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Einclude/asm-i386/io.h
+!Iinclude/asm-i386/io.h
+!Elib/iomap.c
   </chapter>
 
 </book>
diff -puN include/asm-i386/io.h~document-pci_iomap include/asm-i386/io.h
--- a/include/asm-i386/io.h~document-pci_iomap
+++ a/include/asm-i386/io.h
@@ -112,6 +112,9 @@ extern void __iomem * __ioremap(unsigned
  * writew/writel functions and the other mmio helpers. The returned
  * address is not guaranteed to be usable directly as a virtual
  * address. 
+ *
+ * If the area you are trying to map is a PCI BAR you should have a
+ * look at pci_iomap().
  */
 
 static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
diff -puN lib/iomap.c~document-pci_iomap lib/iomap.c
--- a/lib/iomap.c~document-pci_iomap
+++ a/lib/iomap.c
@@ -240,7 +240,20 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide
+ * the details if this is a MMIO or PIO address space and will just do what
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
 	unsigned long start = pci_resource_start(dev, bar);
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

fix-typos-in-fs-sysfs-filec.patch
initialize-filp-private_data-only-once-in-em28xx_v4l2_open.patch
git-r8169.patch
