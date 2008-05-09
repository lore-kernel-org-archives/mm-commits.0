From: akpm@linux-foundation.org
Subject: + orion-clean-up-addr-mapc-after-window-setting-code-purge.patch added to -mm tree
Date: Fri, 09 May 2008 12:54:02 -0700
Message-ID: <200805091954.m49Js2Xo022987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbYEITyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 15:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@marvell.com, nico@marvell.com, rmk+kernel@arm.linux.org.uk, tzachi@marvell.com


The patch titled
     arm: orion: clean up addr-map.c after window setting code purge
has been added to the -mm tree.  Its filename is
     orion-clean-up-addr-mapc-after-window-setting-code-purge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: orion: clean up addr-map.c after window setting code purge
From: Lennert Buytenhek <buytenh@wantstofly.org>

Clean up Orion's addr-map.c a bit after all peripheral window programming code
has been moved out into the relevant drivers.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Reviewed-by: Tzachi Perelstein <tzachi@marvell.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-orion5x/addr-map.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN arch/arm/mach-orion5x/addr-map.c~orion-clean-up-addr-mapc-after-window-setting-code-purge arch/arm/mach-orion5x/addr-map.c
--- a/arch/arm/mach-orion5x/addr-map.c~orion-clean-up-addr-mapc-after-window-setting-code-purge
+++ a/arch/arm/mach-orion5x/addr-map.c
@@ -34,11 +34,7 @@
  * Non-CPU Masters address decoding --
  * Unlike the CPU, we setup the access from Orion's master interfaces to DDR
  * banks only (the typical use case).
- * Setup access for each master to DDR is issued by common.c.
- *
- * Note: although orion_setbits() and orion_clrbits() are not atomic
- * no locking is necessary here since code in this file is only called
- * at boot time when there is no concurrency issues.
+ * Setup access for each master to DDR is issued by platform device setup.
  */
 
 /*
@@ -48,10 +44,6 @@
 #define TARGET_DEV_BUS		1
 #define TARGET_PCI		3
 #define TARGET_PCIE		4
-#define ATTR_DDR_CS(n)		(((n) ==0) ? 0xe :	\
-				((n) == 1) ? 0xd :	\
-				((n) == 2) ? 0xb :	\
-				((n) == 3) ? 0x7 : 0xf)
 #define ATTR_PCIE_MEM		0x59
 #define ATTR_PCIE_IO		0x51
 #define ATTR_PCIE_WA		0x79
@@ -61,17 +53,12 @@
 #define ATTR_DEV_CS1		0x1d
 #define ATTR_DEV_CS2		0x1b
 #define ATTR_DEV_BOOT		0xf
-#define WIN_EN			1
 
 /*
  * Helpers to get DDR bank info
  */
-#define DDR_BASE_CS(n)		ORION5X_DDR_REG(0x1500 + ((n) * 8))
-#define DDR_SIZE_CS(n)		ORION5X_DDR_REG(0x1504 + ((n) * 8))
-#define DDR_MAX_CS		4
-#define DDR_REG_TO_SIZE(reg)	(((reg) | 0xffffff) + 1)
-#define DDR_REG_TO_BASE(reg)	((reg) & 0xff000000)
-#define DDR_BANK_EN		1
+#define DDR_BASE_CS(n)		ORION5X_DDR_REG(0x1500 + ((n) << 3))
+#define DDR_SIZE_CS(n)		ORION5X_DDR_REG(0x1504 + ((n) << 3))
 
 /*
  * CPU Address Decode Windows registers
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

orion-use-mv643xx_eth-driver-mbus-window-handling.patch
orion-pass-proper-t_clk-into-mv643xx_eth.patch
orion-clean-up-addr-mapc-after-window-setting-code-purge.patch
leds-add-pca9532-platform-data-for-thecus-n2100.patch
git-orion.patch

