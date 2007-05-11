From: akpm@linux-foundation.org
Subject: + powerpc-fix-kconfig-select-warning-with-ucc_fast.patch added to -mm tree
Date: Thu, 10 May 2007 20:37:25 -0700
Message-ID: <200705110337.l4B3bPu1005357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbXEKDhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timur@freescale.com


The patch titled
     powerpc: fix Kconfig 'select' warning with UCC_FAST
has been added to the -mm tree.  Its filename is
     powerpc-fix-kconfig-select-warning-with-ucc_fast.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: fix Kconfig 'select' warning with UCC_FAST
From: Timur Tabi <timur@freescale.com>

The UCC_GETH Kconfig option in drivers/net/Kconfig had a line to select the
UCC_FAST option is arch/powerpc/sysdev/qe_lib/Kconfig, which is only used
on PowerPC builds.  On other architectures, this would generated a warning.
 The fix is to have UCC_FAST depend on UCC_GETH.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/qe_lib/Kconfig |    4 +---
 drivers/net/Kconfig                |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/powerpc/sysdev/qe_lib/Kconfig~powerpc-fix-kconfig-select-warning-with-ucc_fast arch/powerpc/sysdev/qe_lib/Kconfig
--- a/arch/powerpc/sysdev/qe_lib/Kconfig~powerpc-fix-kconfig-select-warning-with-ucc_fast
+++ a/arch/powerpc/sysdev/qe_lib/Kconfig
@@ -5,15 +5,13 @@
 config UCC_SLOW
 	bool
 	default n
-	select UCC
 	help
 	  This option provides qe_lib support to UCC slow
 	  protocols: UART, BISYNC, QMC
 
 config UCC_FAST
 	bool
-	default n
-	select UCC
+	default y if UCC_GETH
 	help
 	  This option provides qe_lib support to UCC fast
 	  protocols: HDLC, Ethernet, ATM, transparent
diff -puN drivers/net/Kconfig~powerpc-fix-kconfig-select-warning-with-ucc_fast drivers/net/Kconfig
--- a/drivers/net/Kconfig~powerpc-fix-kconfig-select-warning-with-ucc_fast
+++ a/drivers/net/Kconfig
@@ -2276,7 +2276,6 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
-	select UCC_FAST
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
_

Patches currently in -mm which might be from timur@freescale.com are

origin.patch
powerpc-fix-kconfig-select-warning-with-ucc_fast.patch
