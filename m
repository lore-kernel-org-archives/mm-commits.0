From: akpm@linux-foundation.org
Subject: + irda-follow-lspci-device-vendor-style.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:14:56 -0700
Message-ID: <200808272314.m7RNEuou027860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbYH0XPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, samuel@sortiz.org


The patch titled
     irda: follow lspci device/vendor style
has been added to the -mm tree.  Its filename is
     irda-follow-lspci-device-vendor-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irda: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/vlsi_ir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/vlsi_ir.c~irda-follow-lspci-device-vendor-style drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~irda-follow-lspci-device-vendor-style
+++ a/drivers/net/irda/vlsi_ir.c
@@ -165,7 +165,7 @@ static void vlsi_proc_pdev(struct seq_fi
 	unsigned iobase = pci_resource_start(pdev, 0);
 	unsigned i;
 
-	seq_printf(seq, "\n%s (vid/did: %04x/%04x)\n",
+	seq_printf(seq, "\n%s (vid/did: [%04x:%04x])\n",
 		   pci_name(pdev), (int)pdev->vendor, (int)pdev->device);
 	seq_printf(seq, "pci-power-state: %u\n", (unsigned) pdev->current_state);
 	seq_printf(seq, "resources: irq=%u / io=0x%04x / dma_mask=0x%016Lx\n",
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-use-dev_printk-in-quirk-message.patch
pci-tidy-pme-support-messages.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
pnp-remove-printk-with-outdated-version.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch
x86-pci-follow-lspci-device-vendor-style.patch
agp-follow-lspci-device-vendor-style.patch
v4l-dvb-follow-lspci-device-vendor-style.patch
irda-follow-lspci-device-vendor-style.patch
pci-follow-lspci-device-vendor-style.patch

