From: akpm@linux-foundation.org
Subject: - cris-avoid-using-arch-links-in-kconfig.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:06 -0800
Message-ID: <200802052234.m15MYlDi012557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762776AbYBEWmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     CRIS: avoid using arch links in Kconfig
has been removed from the -mm tree.  Its filename was
     cris-avoid-using-arch-links-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRIS: avoid using arch links in Kconfig
From: Jesper Nilsson <jesper.nilsson@axis.com>

Improve including of architecture dependent Kconfig files.

- Always include the architecture dependent Kconfig files.
- Wrap architecture dependent Kconfig files inside an appropriate
  "if ETRAX_ARCH_Vxx" block.

This makes it possible to run the configuration even without the arch links,
which are created later in the build process.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig                  |    5 +++--
 arch/cris/arch-v10/Kconfig         |    4 ++++
 arch/cris/arch-v10/drivers/Kconfig |    4 ++++
 arch/cris/arch-v32/Kconfig         |    4 ++++
 arch/cris/arch-v32/drivers/Kconfig |    4 ++++
 5 files changed, 19 insertions(+), 2 deletions(-)

diff -puN arch/cris/Kconfig~cris-avoid-using-arch-links-in-kconfig arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-avoid-using-arch-links-in-kconfig
+++ a/arch/cris/Kconfig
@@ -150,6 +150,7 @@ config ETRAX_FLASH_BUSWIDTH
 	  Width in bytes of the Flash bus (1, 2 or 4). Is usually 2.
 
 source arch/cris/arch-v10/Kconfig
+source arch/cris/arch-v32/Kconfig
 
 endmenu
 
@@ -157,8 +158,8 @@ source "net/Kconfig"
 
 # bring in ETRAX built-in drivers
 menu "Drivers for built-in interfaces"
-# arch/cris/arch is a symlink to correct arch (arch-v10 or arch-v32)
-source arch/cris/arch/drivers/Kconfig
+source arch/cris/arch-v10/drivers/Kconfig
+source arch/cris/arch-v32/drivers/Kconfig
 
 endmenu
 
diff -puN arch/cris/arch-v10/Kconfig~cris-avoid-using-arch-links-in-kconfig arch/cris/arch-v10/Kconfig
--- a/arch/cris/arch-v10/Kconfig~cris-avoid-using-arch-links-in-kconfig
+++ a/arch/cris/arch-v10/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V10
+
 # ETRAX 100LX v1 has a MMU "feature" requiring a low mapping
 config CRIS_LOW_MAP
 	bool
@@ -451,3 +453,5 @@ config ETRAX_POWERBUTTON_BIT
 	default "25"
 	help
 	  Configure where power button is connected.
+
+endif
diff -puN arch/cris/arch-v10/drivers/Kconfig~cris-avoid-using-arch-links-in-kconfig arch/cris/arch-v10/drivers/Kconfig
--- a/arch/cris/arch-v10/drivers/Kconfig~cris-avoid-using-arch-links-in-kconfig
+++ a/arch/cris/arch-v10/drivers/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V10
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V10
@@ -806,3 +808,5 @@ config ETRAX_DS1302_TRICKLE_CHARGE
 	  1 = 2kohm, 2 = 4kohm, 3 = 4kohm
 	  4 = 1 diode, 8 = 2 diodes
 	  Allowed values are (increasing current): 0, 11, 10, 9, 7, 6, 5
+
+endif
diff -puN arch/cris/arch-v32/Kconfig~cris-avoid-using-arch-links-in-kconfig arch/cris/arch-v32/Kconfig
--- a/arch/cris/arch-v32/Kconfig~cris-avoid-using-arch-links-in-kconfig
+++ a/arch/cris/arch-v32/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V32
+
 config ETRAX_DRAM_VIRTUAL_BASE
 	hex
 	depends on ETRAX_ARCH_V32
@@ -294,3 +296,5 @@ config ETRAX_DEF_GIO_PE_OUT
 	help
 	  Configures the initial data for the general port E bits.  Most
 	  products should use 00000 here.
+
+endif
diff -puN arch/cris/arch-v32/drivers/Kconfig~cris-avoid-using-arch-links-in-kconfig arch/cris/arch-v32/drivers/Kconfig
--- a/arch/cris/arch-v32/drivers/Kconfig~cris-avoid-using-arch-links-in-kconfig
+++ a/arch/cris/arch-v32/drivers/Kconfig
@@ -1,3 +1,5 @@
+if ETRAX_ARCH_V32
+
 config ETRAX_ETHERNET
 	bool "Ethernet support"
 	depends on ETRAX_ARCH_V32
@@ -610,3 +612,5 @@ config ETRAX_STREAMCOPROC
 	help
 	  This option enables a driver for the stream co-processor
 	  for cryptographic operations.
+
+endif
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
git-mtd.patch
procfs-constify-function-pointer-tables.patch
