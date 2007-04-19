From: akpm@linux-foundation.org
Subject: - provide-dummy-devm_ioport_-if-has_ioport.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:07 -0700
Message-ID: <200704192002.l3JK27Yx029353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766991AbXDSUCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Provide dummy devm_ioport_* if !HAS_IOPORT
has been removed from the -mm tree.  Its filename was
     provide-dummy-devm_ioport_-if-has_ioport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Provide dummy devm_ioport_* if !HAS_IOPORT
From: Russell King <rmk+lkml@arm.linux.org.uk>

Provide an dummy implementation of devm_ioport_map() and
devm_ioport_unmap() to allow drivers (eg, pata_platform) to build for
platforms where CONFIG_NO_IOPORT is selected.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/linux/io.h~provide-dummy-devm_ioport_-if-has_ioport include/linux/io.h
--- a/include/linux/io.h~provide-dummy-devm_ioport_-if-has_ioport
+++ a/include/linux/io.h
@@ -33,9 +33,22 @@ int ioremap_page_range(unsigned long add
 /*
  * Managed iomap interface
  */
+#ifdef CONFIG_HAS_IOPORT
 void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr);
 void devm_ioport_unmap(struct device *dev, void __iomem *addr);
+#else
+static inline void __iomem *devm_ioport_map(struct device *dev,
+					     unsigned long port,
+					     unsigned int nr)
+{
+	return NULL;
+}
+
+static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
+{
+}
+#endif
 
 void __iomem * devm_ioremap(struct device *dev, unsigned long offset,
 			    unsigned long size);
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

origin.patch
pata_platform-for-arm-riscpc.patch
git-kbuild.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
make-dev-port-conditional-on-config-symbol.patch
