From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-pasemi-kconfig-depends.patch added to -mm tree
Date: Wed, 25 Jul 2007 22:25:19 -0700
Message-ID: <200707260525.l6Q5PJq0015799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761341AbXGZFZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, egor@pasemi.com


The patch titled
     drivers/edac: fix pasemi kconfig depends
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-pasemi-kconfig-depends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: fix pasemi kconfig depends
From: Doug Thompson <dougthompson@xmission.com>

Fixed 'depends on PPC_PASEMI' in EDAC Kconfig.  Module PASEMI depends ONLY on
the PASEMI on PPC.

Was previously enabled for ALL PPC

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Egor N. Martovetsky <egor@pasemi.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/Kconfig~drivers-edac-fix-pasemi-kconfig-depends drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~drivers-edac-fix-pasemi-kconfig-depends
+++ a/drivers/edac/Kconfig
@@ -126,7 +126,7 @@ config EDAC_I5000
 config EDAC_PASEMI
 	tristate "PA Semi PWRficient"
 	depends on EDAC_MM_EDAC && PCI
-	depends on PPC
+	depends on PPC_PASEMI
 	help
 	  Support for error detection and correction on PA Semi
 	  PWRficient.
_

Patches currently in -mm which might be from dougthompson@xmission.com are

edac-is-bust-on-mips.patch
drivers-edac-fix-reset-edac_mc-pollmsec.patch
drivers-edac-fix-edac_pci-sysfs.patch
include-asm-mips-add-missing-edac-h-file.patch
drivers-edac-fix-pasemi-kconfig-depends.patch
