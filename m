From: akpm@linux-foundation.org
Subject: - ssb-compile-fix.patch removed from -mm tree
Date: Wed, 08 Aug 2007 16:54:17 -0700
Message-ID: <200708082359.l78Nx8Oi005057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55383 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761640AbXHHX77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 19:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     ssb: compile fix
has been removed from the -mm tree.  Its filename was
     ssb-compile-fix.patch

This patch was dropped because an updated version will be merged

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

git-kvm.patch
git-wireless.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
