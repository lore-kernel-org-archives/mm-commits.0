From: akpm@linux-foundation.org
Subject: + ssb-compile-fix.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:32:08 -0700
Message-ID: <200707310132.l6V1W8Zp008607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027AbXGaBdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, mb@bu3sch.de


The patch titled
     ssb: compile fix
has been added to the -mm tree.  Its filename is
     ssb-compile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ssb: compile fix
From: Aurelien Jarno <aurelien@aurel32.net>

The patch below against 2.6.23-rc1-mm1 fixes the definition of
pcibios_map_irq in the SSB code. The corresponding include file has been
changed in commit 19df0d1169b3ddcc84933794d1401aaafe2f0000.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_pcicore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ssb/driver_pcicore.c~ssb-compile-fix drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~ssb-compile-fix
+++ a/drivers/ssb/driver_pcicore.c
@@ -102,7 +102,7 @@ static void __init ssb_fixup_pcibridge(s
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, ssb_fixup_pcibridge);
 
-int __init pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	return ssb_mips_irq(extpci_core->dev) + 2;
 }
_

Patches currently in -mm which might be from aurelien@aurel32.net are

origin.patch
git-kvm.patch
ssb-compile-fix.patch
