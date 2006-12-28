From: akpm@osdl.org
Subject: + fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:09:31 -0800
Message-ID: <200612282309.kBSN9V7s015689@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40403 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965058AbWL1XJg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:09:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, greg@kroah.com


The patch titled
     usb: Fix OHCI warning
has been added to the -mm tree.  Its filename is
     fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

make-fn_keys-work-again-on-power-macbooks.patch
fix-compilation-of-via-pmu-backlight.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
fix-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
revert-gregkh-usb-usb-implement-support-for-split-endian-ohci.patch
revert-gregkh-usb-usb-implement-support-for-ehci-with-big-endian-mmio.patch
revert-gregkh-usb-ohci-add-support-for-ohci-controller-on-the-of_platform-bus.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch

