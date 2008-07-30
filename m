From: akpm@linux-foundation.org
Subject: - usb-m66592-udc-fix-up-dev_set_name-badness.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:18 -0700
Message-ID: <200807301915.m6UJFIX3011016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbYG3TZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, gregkh@suse.de, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     USB: m66592-udc: Fix up dev_set_name() badness.
has been removed from the -mm tree.  Its filename was
     usb-m66592-udc-fix-up-dev_set_name-badness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB: m66592-udc: Fix up dev_set_name() badness.
From: Paul Mundt <lethal@linux-sh.org>

Commit 0031a06e2f07ab0d1bc98c31dbb6801f95f4bf01 converted all of the USB
drivers to use dev_set_name(), though there was a typo on the m66592-udc
conversion that handed off the wrong pointer (we want the struct device
here obviously, not the struct usb_gadget).

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/m66592-udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/gadget/m66592-udc.c~usb-m66592-udc-fix-up-dev_set_name-badness drivers/usb/gadget/m66592-udc.c
--- a/drivers/usb/gadget/m66592-udc.c~usb-m66592-udc-fix-up-dev_set_name-badness
+++ a/drivers/usb/gadget/m66592-udc.c
@@ -1593,7 +1593,7 @@ static int __init m66592_probe(struct pl
 
 	m66592->gadget.ops = &m66592_gadget_ops;
 	device_initialize(&m66592->gadget.dev);
-	dev_set_name(&m66592->gadget, "gadget");
+	dev_set_name(&m66592->gadget.dev, "gadget");
 	m66592->gadget.is_dualspeed = 1;
 	m66592->gadget.dev.parent = &pdev->dev;
 	m66592->gadget.dev.dma_mask = pdev->dev.dma_mask;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

