From: akpm@linux-foundation.org
Subject: [merged] edac-amd8111-amd8131-kconfig-fixup.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:27 -0700
Message-ID: <200905291843.n4TIhRfn011673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853AbZE2Snz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8111 & AMD8131 Kconfig fixup
has been removed from the -mm tree.  Its filename was
     edac-amd8111-amd8131-kconfig-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8111 & AMD8131 Kconfig fixup
From: Harry Ciao <qingtao.cao@windriver.com>

The amd8111_edac.c driver will fail allmodconfig on architectures other
than PPC, introduce Kconfig dependency to avoid this, since both AMD8111
and AMD8131 chips are only adopted on Maple so far.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig  |    8 ++++++--
 drivers/edac/Makefile |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/edac/Kconfig~edac-amd8111-amd8131-kconfig-fixup drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-amd8111-amd8131-kconfig-fixup
+++ a/drivers/edac/Kconfig
@@ -192,16 +192,20 @@ config EDAC_PPC4XX
 
 config EDAC_AMD8131
 	tristate "AMD8131 HyperTransport PCI-X Tunnel"
-	depends on EDAC_MM_EDAC && PCI
+	depends on EDAC_MM_EDAC && PCI && PPC_MAPLE
 	help
 	  Support for error detection and correction on the
 	  AMD8131 HyperTransport PCI-X Tunnel chip.
+	  Note, add more Kconfig dependency if it's adopted
+	  on some machine other than Maple.
 
 config EDAC_AMD8111
 	tristate "AMD8111 HyperTransport I/O Hub"
-	depends on EDAC_MM_EDAC && PCI
+	depends on EDAC_MM_EDAC && PCI && PPC_MAPLE
 	help
 	  Support for error detection and correction on the
 	  AMD8111 HyperTransport I/O Hub chip.
+	  Note, add more Kconfig dependency if it's adopted
+	  on some machine other than Maple.
 
 endif # EDAC
diff -puN drivers/edac/Makefile~edac-amd8111-amd8131-kconfig-fixup drivers/edac/Makefile
--- a/drivers/edac/Makefile~edac-amd8111-amd8131-kconfig-fixup
+++ a/drivers/edac/Makefile
@@ -35,3 +35,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_e
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
+obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
+obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

origin.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-cpc925-memory-controller-driver-mc-check-fixup.patch
edac-add-edac_device_alloc_index.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-cpc925-mc-platform-device-setup.patch
edac-cpc925-mc-platform-device-setup-v3.patch

