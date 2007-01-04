From: akpm@osdl.org
Subject: - fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:21 -0800
Message-ID: <200701042343.l04NhL9T002895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:36842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030277AbXADXnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: Fix OHCI warning
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: Fix OHCI warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch fixes a warning introduces by the split endian OHCI support
patch on platforms that don't have readl_be/writel_be variants (though
mostly harmless as those are called in an if (0) statement, but gcc
still warns).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/ohci.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/usb/host/ohci.h~fix-gregkh-usb-usb-implement-support-for-split-endian-ohci drivers/usb/host/ohci.h
--- a/drivers/usb/host/ohci.h~fix-gregkh-usb-usb-implement-support-for-split-endian-ohci
+++ a/drivers/usb/host/ohci.h
@@ -505,17 +505,25 @@ static inline struct usb_hcd *ohci_to_hc
 static inline unsigned int _ohci_readl (const struct ohci_hcd *ohci,
 					__hc32 __iomem * regs)
 {
+#ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
 	return big_endian_mmio(ohci) ?
 		readl_be ((__force u32 *)regs) :
 		readl ((__force u32 *)regs);
+#else
+	return readl ((__force u32 *)regs);
+#endif
 }
 
 static inline void _ohci_writel (const struct ohci_hcd *ohci,
 				 const unsigned int val, __hc32 __iomem *regs)
 {
+#ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
 	big_endian_mmio(ohci) ?
 		writel_be (val, (__force u32 *)regs) :
 		writel (val, (__force u32 *)regs);
+#else
+		writel (val, (__force u32 *)regs);
+#endif
 }
 
 #ifdef CONFIG_ARCH_LH7A404
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
