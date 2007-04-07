From: akpm@linux-foundation.org
Subject: + arm-fix-section-mismatch-warning-in-board-sam9260.patch added to -mm tree
Date: Sat, 07 Apr 2007 15:24:23 -0700
Message-ID: <200704072224.l37MON4A011265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965982AbXDGWY1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 18:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org


The patch titled
     arm: fix section mismatch warning in board-sam9260
has been added to the -mm tree.  Its filename is
     arm-fix-section-mismatch-warning-in-board-sam9260.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: fix section mismatch warning in board-sam9260
From: Sam Ravnborg <sam@ravnborg.org>

Andrew Morton found a section mismatch warning in x86_64 triggered by a
wrongly placed __initdata marker.

git grep "struct __initdata" revealed that board-sam9260.c had the same
problem.

This patch fixes this by placing the __initdata marker correct.  It was
checked with objdump that the variable was moved to .init.data by this
change.

Fixed an unrelated section mismatch warning while touching the file.

Both changes are only compile tested but obvious correct.
[Used at91sam9260ek_defconfig to get compile coverage]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/board-sam9260ek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-at91/board-sam9260ek.c~arm-fix-section-mismatch-warning-in-board-sam9260 arch/arm/mach-at91/board-sam9260ek.c
--- a/arch/arm/mach-at91/board-sam9260ek.c~arm-fix-section-mismatch-warning-in-board-sam9260
+++ a/arch/arm/mach-at91/board-sam9260ek.c
@@ -118,7 +118,7 @@ static struct spi_board_info ek_spi_devi
 /*
  * MACB Ethernet device
  */
-static struct __initdata at91_eth_data ek_macb_data = {
+static struct at91_eth_data __initdata ek_macb_data = {
 	.phy_irq_pin	= AT91_PIN_PA7,
 	.is_rmii	= 1,
 };
@@ -140,7 +140,7 @@ static struct mtd_partition __initdata e
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(ek_nand_partition);
 	return ek_nand_partition;
_

Patches currently in -mm which might be from sam@ravnborg.org are

arm-fix-section-mismatch-warning-in-board-sam9260.patch
git-kbuild.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
git-netdev-all.patch
pci-do-not-mark-exported-functions-as-__devinit.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
