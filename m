From: akpm@linux-foundation.org
Subject: + sh-revert-dreamcast-pci-change.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:06 -0800
Message-ID: <200802230732.m1N7WtV5018106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763933AbYBWIEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, adrian@mcmen.demon.co.uk, damm@igel.co.jp, lethal@linux-sh.org


The patch titled
     sh: revert dreamcast pci change
has been added to the -mm tree.  Its filename is
     sh-revert-dreamcast-pci-change.patch

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
Subject: sh: revert dreamcast pci change
From: Magnus Damm <magnus.damm@gmail.com>

Commit e036eaa681a17f71b64f6d9040fe605555623919 broke dreamcast pci, this
patch fixes that by reverting the dreamcast specific bits.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/drivers/pci/ops-dreamcast.c |   44 +++++++++++++-------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN arch/sh/drivers/pci/ops-dreamcast.c~sh-revert-dreamcast-pci-change arch/sh/drivers/pci/ops-dreamcast.c
--- a/arch/sh/drivers/pci/ops-dreamcast.c~sh-revert-dreamcast-pci-change
+++ a/arch/sh/drivers/pci/ops-dreamcast.c
@@ -83,9 +83,9 @@ static int gapspci_read(struct pci_bus *
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch (size) {
-		case 1: *val = ctrl_inb(GAPSPCI_BBA_CONFIG+where); break;
-		case 2: *val = ctrl_inw(GAPSPCI_BBA_CONFIG+where); break;
-		case 4: *val = ctrl_inl(GAPSPCI_BBA_CONFIG+where); break;
+		case 1: *val = inb(GAPSPCI_BBA_CONFIG+where); break;
+		case 2: *val = inw(GAPSPCI_BBA_CONFIG+where); break;
+		case 4: *val = inl(GAPSPCI_BBA_CONFIG+where); break;
 	}	
 
         return PCIBIOS_SUCCESSFUL;
@@ -97,9 +97,9 @@ static int gapspci_write(struct pci_bus 
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch (size) {
-		case 1: ctrl_outb(( u8)val, GAPSPCI_BBA_CONFIG+where); break;
-		case 2: ctrl_outw((u16)val, GAPSPCI_BBA_CONFIG+where); break;
-		case 4: ctrl_outl((u32)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 1: outb(( u8)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 2: outw((u16)val, GAPSPCI_BBA_CONFIG+where); break;
+		case 4: outl((u32)val, GAPSPCI_BBA_CONFIG+where); break;
 	}
 
         return PCIBIOS_SUCCESSFUL;
@@ -127,36 +127,36 @@ int __init gapspci_init(void)
 	 */
 
 	for (i=0; i<16; i++)
-		idbuf[i] = ctrl_inb(GAPSPCI_REGS+i);
+		idbuf[i] = inb(GAPSPCI_REGS+i);
 
 	if (strncmp(idbuf, "GAPSPCI_BRIDGE_2", 16))
 		return -ENODEV;
 
-	ctrl_outl(0x5a14a501, GAPSPCI_REGS+0x18);
+	outl(0x5a14a501, GAPSPCI_REGS+0x18);
 
 	for (i=0; i<1000000; i++)
 		;
 
-	if (ctrl_inl(GAPSPCI_REGS+0x18) != 1)
+	if (inl(GAPSPCI_REGS+0x18) != 1)
 		return -EINVAL;
 
-	ctrl_outl(0x01000000, GAPSPCI_REGS+0x20);
-	ctrl_outl(0x01000000, GAPSPCI_REGS+0x24);
+	outl(0x01000000, GAPSPCI_REGS+0x20);
+	outl(0x01000000, GAPSPCI_REGS+0x24);
 
-	ctrl_outl(GAPSPCI_DMA_BASE, GAPSPCI_REGS+0x28);
-	ctrl_outl(GAPSPCI_DMA_BASE+GAPSPCI_DMA_SIZE, GAPSPCI_REGS+0x2c);
+	outl(GAPSPCI_DMA_BASE, GAPSPCI_REGS+0x28);
+	outl(GAPSPCI_DMA_BASE+GAPSPCI_DMA_SIZE, GAPSPCI_REGS+0x2c);
 
-	ctrl_outl(1, GAPSPCI_REGS+0x14);
-	ctrl_outl(1, GAPSPCI_REGS+0x34);
+	outl(1, GAPSPCI_REGS+0x14);
+	outl(1, GAPSPCI_REGS+0x34);
 
 	/* Setting Broadband Adapter */
-	ctrl_outw(0xf900, GAPSPCI_BBA_CONFIG+0x06);
-	ctrl_outl(0x00000000, GAPSPCI_BBA_CONFIG+0x30);
-	ctrl_outb(0x00, GAPSPCI_BBA_CONFIG+0x3c);
-	ctrl_outb(0xf0, GAPSPCI_BBA_CONFIG+0x0d);
-	ctrl_outw(0x0006, GAPSPCI_BBA_CONFIG+0x04);
-	ctrl_outl(0x00002001, GAPSPCI_BBA_CONFIG+0x10);
-	ctrl_outl(0x01000000, GAPSPCI_BBA_CONFIG+0x14);
+	outw(0xf900, GAPSPCI_BBA_CONFIG+0x06);
+	outl(0x00000000, GAPSPCI_BBA_CONFIG+0x30);
+	outb(0x00, GAPSPCI_BBA_CONFIG+0x3c);
+	outb(0xf0, GAPSPCI_BBA_CONFIG+0x0d);
+	outw(0x0006, GAPSPCI_BBA_CONFIG+0x04);
+	outl(0x00002001, GAPSPCI_BBA_CONFIG+0x10);
+	outl(0x01000000, GAPSPCI_BBA_CONFIG+0x14);
 
 	return 0;
 }
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

sh-revert-dreamcast-pci-change.patch
sm501-add-uart-support.patch
