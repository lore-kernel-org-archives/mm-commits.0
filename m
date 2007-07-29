From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-pasemi-kconfig-depends.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:23 -0700
Message-ID: <200707290612.l6T6CN2Z011121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236AbXG2GXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, egor@pasemi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix pasemi kconfig depends
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-pasemi-kconfig-depends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
