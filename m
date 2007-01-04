From: akpm@osdl.org
Subject: - fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:23 -0800
Message-ID: <200701042343.l04NhNB4002898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:36848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbXADXn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: Fix EHCI warning
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: Fix EHCI warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch fixes a warning introduced by the big endian MMIO EHCI support
patch on platforms that don't have readl_be/writel_be variants (though
mostly harmless as those are called in an if (0) statement, but gcc still
warns).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/ehci.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/usb/host/ehci.h~fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio drivers/usb/host/ehci.h
--- a/drivers/usb/host/ehci.h~fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio
+++ a/drivers/usb/host/ehci.h
@@ -671,17 +671,25 @@ ehci_port_speed(struct ehci_hcd *ehci, u
 static inline unsigned int ehci_readl (const struct ehci_hcd *ehci,
 				       __u32 __iomem * regs)
 {
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
 	return ehci_big_endian_mmio(ehci) ?
 		readl_be((__force u32 *)regs) :
 		readl((__force u32 *)regs);
+#else
+	return readl((__force u32 *)regs);
+#endif
 }
 
 static inline void ehci_writel (const struct ehci_hcd *ehci,
 				const unsigned int val, __u32 __iomem *regs)
 {
+#ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
 	ehci_big_endian_mmio(ehci) ?
 		writel_be(val, (__force u32 *)regs) :
 		writel(val, (__force u32 *)regs);
+#else
+	writel(val, (__force u32 *)regs);
+#endif
 }
 
 /*-------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
