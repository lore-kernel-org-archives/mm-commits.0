From: akpm@linux-foundation.org
Subject: - alpha-misc-fixes.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:12 -0700
Message-ID: <200706011748.l51HmBve015187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761506AbXFARsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jay.estabrook@hp.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ALPHA: misc fixes
has been removed from the -mm tree.  Its filename was
     alpha-misc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPHA: misc fixes
From: Jay Estabrook <jay.estabrook@hp.com>

1. arch/alpha/Kconfig

   several adjustments:
      a) additions to the systems list and cleanup of same
      b) change limits of NR_CPUS and make dep. on platform

   Note that MARVEL support is limited to 32 CPUs whan using
   42-bit KSEG - one needs 48-bit KSEG to handle up to 64, and
   we've never supported 48-bit KSEG.

2. include/asm-alpha/core_wildfire.h

   fix a typo that undoubtedly prevents WILDFIRE support
   from working

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig                |   26 ++++++++++++++------------
 include/asm-alpha/core_wildfire.h |    2 +-
 2 files changed, 15 insertions(+), 13 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-misc-fixes arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-misc-fixes
+++ a/arch/alpha/Kconfig
@@ -83,22 +83,20 @@ choice
 	  check out the Linux/Alpha FAQ, accessible on the WWW from
 	  <http://www.alphalinux.org/>. In summary:
 
-	  Alcor/Alpha-XLT     AS 600
+	  Alcor/Alpha-XLT     AS 600, AS 500, XL-300, XL-366
 	  Alpha-XL            XL-233, XL-266
 	  AlphaBook1          Alpha laptop
 	  Avanti              AS 200, AS 205, AS 250, AS 255, AS 300, AS 400
 	  Cabriolet           AlphaPC64, AlphaPCI64
-	  DP264               DP264
+	  DP264               DP264 / DS20 / ES40 / DS10 / DS10L
 	  EB164               EB164 21164 evaluation board
 	  EB64+               EB64+ 21064 evaluation board
 	  EB66                EB66 21066 evaluation board
 	  EB66+               EB66+ 21066 evaluation board
-	  Jensen              DECpc 150, DEC 2000 model 300,
-	  DEC 2000 model 500
+	  Jensen              DECpc 150, DEC 2000 models 300, 500
 	  LX164               AlphaPC164-LX
 	  Lynx                AS 2100A
-	  Miata               Personal Workstation 433a, 433au, 500a,
-	  500au, 600a, or 600au
+	  Miata               Personal Workstation 433/500/600 a/au
 	  Marvel              AlphaServer ES47 / ES80 / GS1280
 	  Mikasa              AS 1000
 	  Noname              AXPpci33, UDB (Multia)
@@ -108,9 +106,9 @@ choice
 	  Ruffian             RPX164-2, AlphaPC164-UX, AlphaPC164-BX
 	  SX164               AlphaPC164-SX
 	  Sable               AS 2000, AS 2100
-	  Shark		      DS 20L
-	  Takara              Takara
-	  Titan               AlphaServer ES45 / DS25
+	  Shark               DS 20L
+	  Takara              Takara (OEM)
+	  Titan               AlphaServer ES45 / DS25 / DS15
 	  Wildfire            AlphaServer GS 40/80/160/320
 
 	  If you don't know what to do, choose "generic".
@@ -546,10 +544,14 @@ config HAVE_DEC_LOCK
 	default y
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
-	range 2 64
+	int "Maximum number of CPUs (2-32)"
+	range 2 32
 	depends on SMP
-	default "64"
+	default "32" if ALPHA_GENERIC || ALPHA_MARVEL
+	default "4" if !ALPHA_GENERIC && !ALPHA_MARVEL
+	help
+	  MARVEL support can handle a maximum of 32 CPUs, all the others
+          with working support have a maximum of 4 CPUs.
 
 config ARCH_DISCONTIGMEM_ENABLE
 	bool "Discontiguous Memory Support (EXPERIMENTAL)"
diff -puN include/asm-alpha/core_wildfire.h~alpha-misc-fixes include/asm-alpha/core_wildfire.h
--- a/include/asm-alpha/core_wildfire.h~alpha-misc-fixes
+++ a/include/asm-alpha/core_wildfire.h
@@ -295,7 +295,7 @@ __EXTERN_INLINE int wildfire_is_ioaddr(u
 
 __EXTERN_INLINE int wildfire_is_mmio(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long)addr;
+	unsigned long addr = (unsigned long)xaddr;
 	return (addr & 0x100000000UL) == 0;
 }
 
_

Patches currently in -mm which might be from jay.estabrook@hp.com are

origin.patch
