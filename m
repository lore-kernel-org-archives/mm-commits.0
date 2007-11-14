From: akpm@linux-foundation.org
Subject: + add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch added to -mm tree
Date: Tue, 13 Nov 2007 22:40:33 -0800
Message-ID: <200711140640.lAE6eXbp025679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763239AbXKNGlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 01:41:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, benh@kernel.crashing.org, dan.j.williams@intel.com, ebony.zhu@freescale.com, galak@gate.crashing.org, paulus@samba.org, shannon.nelson@intel.com, wei.zhang@freescale.com


The patch titled
     Fix dependencies for FSL_DMA
has been added to the -mm tree.  Its filename is
     add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix dependencies for FSL_DMA
From: Olof Johansson <olof@lixom.net>

powerpc allyesconfig build:

drivers/dma/fsldma.c:504: error: implicit declaration of function 'bus_to_virt'

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Zhang Wei <wei.zhang@freescale.com>
Cc: Ebony Zhu <ebony.zhu@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/Kconfig~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix drivers/dma/Kconfig
--- a/drivers/dma/Kconfig~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix
+++ a/drivers/dma/Kconfig
@@ -36,7 +36,7 @@ config INTEL_IOP_ADMA
 
 config FSL_DMA
 	bool "Freescale MPC85xx/MPC83xx DMA support"
-	depends on PPC
+	depends on PPC && VIRT_TO_BUS
 	select DMA_ENGINE
 	---help---
 	  Enable support for the Freescale DMA engine. Now, it support
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch
