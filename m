From: akpm@osdl.org
Subject: - usb-fix-ohcih-over-use-warnings.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:23 -0800
Message-ID: <200612130656.kBD6uN0K030719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57951 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbWLMG4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: fix ohci.h over-use warnings
has been removed from the -mm tree.  Its filename was
     usb-fix-ohcih-over-use-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: fix ohci.h over-use warnings
From: Jeff Garzik <jeff@garzik.org>

When u132-hcd is built, it includes local header ohci.h, which appears to have
been intended only for use by ohci-hcd.

This throws warnings about functions which are defined and not used.  The
warnings thrown are because three small functions are implemented in the
header, but not declared 'inline', a rather strange affair.

Since these functions are small, let's go ahead and define them as 'inline',
just like the inline functions surrounding them.  This makes things more
consistent, and kills the warnings.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/host/ohci.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/host/ohci.h~usb-fix-ohcih-over-use-warnings drivers/usb/host/ohci.h
--- a/drivers/usb/host/ohci.h~usb-fix-ohcih-over-use-warnings
+++ a/drivers/usb/host/ohci.h
@@ -602,7 +602,7 @@ static inline void disable (struct ohci_
 #define	FIT			(1 << 31)
 #define LSTHRESH		0x628		/* lowspeed bit threshold */
 
-static void periodic_reinit (struct ohci_hcd *ohci)
+static inline void periodic_reinit (struct ohci_hcd *ohci)
 {
 	u32	fi = ohci->fminterval & 0x03fff;
 	u32	fit = ohci_readl(ohci, &ohci->regs->fminterval) & FIT;
@@ -626,11 +626,11 @@ static void periodic_reinit (struct ohci
 			temp = ohci_readl (hc, &hc->regs->roothub.register); \
 	temp; })
 
-static u32 roothub_a (struct ohci_hcd *hc)
+static inline u32 roothub_a (struct ohci_hcd *hc)
 	{ return read_roothub (hc, a, 0xfc0fe000); }
 static inline u32 roothub_b (struct ohci_hcd *hc)
 	{ return ohci_readl (hc, &hc->regs->roothub.b); }
 static inline u32 roothub_status (struct ohci_hcd *hc)
 	{ return ohci_readl (hc, &hc->regs->roothub.status); }
-static u32 roothub_portstatus (struct ohci_hcd *hc, int i)
+static inline u32 roothub_portstatus (struct ohci_hcd *hc, int i)
 	{ return read_roothub (hc, portstatus [i], 0xffe0fce0); }
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-drm.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
libata-fix-oops-with-sparsemem.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
remove-the-broken-skmc-driver.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
getting-rid-of-all-casts-of-kalloc-calls.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

