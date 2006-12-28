From: akpm@osdl.org
Subject: + fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:10:20 -0800
Message-ID: <200612282310.kBSNAKQ9015717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059AbWL1XKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, greg@kroah.com


The patch titled
     usb: Fix EHCI warning
has been added to the -mm tree.  Its filename is
     fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

make-fn_keys-work-again-on-power-macbooks.patch
fix-compilation-of-via-pmu-backlight.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
fix-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
revert-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch

