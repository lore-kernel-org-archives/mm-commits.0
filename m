From: akpm@linux-foundation.org
Subject: + ide-au1xxx-fix-use-of-mixed-declarations-and-code.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:49:54 -0800
Message-ID: <200703151849.l2FInuwd023280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35731 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbXCOSxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:53:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, bzolnier@gmail.com


The patch titled
     ide: au1xxx: fix use of mixed declarations and code
has been added to the -mm tree.  Its filename is
     ide-au1xxx-fix-use-of-mixed-declarations-and-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide: au1xxx: fix use of mixed declarations and code
From: Ralf Baechle <ralf@linux-mips.org>

drivers/ide/mips/au1xxx-ide.c:684: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/mips/au1xxx-ide.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/ide/mips/au1xxx-ide.c~ide-au1xxx-fix-use-of-mixed-declarations-and-code drivers/ide/mips/au1xxx-ide.c
--- a/drivers/ide/mips/au1xxx-ide.c~ide-au1xxx-fix-use-of-mixed-declarations-and-code
+++ a/drivers/ide/mips/au1xxx-ide.c
@@ -639,6 +639,7 @@ static int au_ide_probe(struct device *d
 	_auide_hwif *ahwif = &auide_hwif;
 	ide_hwif_t *hwif;
 	struct resource *res;
+	hw_regs_t *hw;
 	int ret = 0;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
@@ -681,7 +682,7 @@ static int au_ide_probe(struct device *d
 	/* FIXME:  This might possibly break PCMCIA IDE devices */
 
 	hwif                            = &ide_hwifs[pdev->id];
-	hw_regs_t *hw 			= &hwif->hw;
+	hw 				= &hwif->hw;
 	hwif->irq = hw->irq             = ahwif->irq;
 	hwif->chipset                   = ide_au1xxx;
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

ide-au1xxx-fix-use-of-mixed-declarations-and-code.patch
git-netdev-all.patch
netxen-fix-warnings.patch
3c59x-fix-several-modpost-warnings.patch
ibmtr-drain-rich-supply-of-modpost-warnings.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
hda_intel-build-fix.patch
ice1712-build-fixes.patch
ice1712-build-fixes-update.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
