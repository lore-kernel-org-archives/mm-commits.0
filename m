From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:15 -0800
Message-ID: <58b5e2c3.6uPYL2Ea6i1lWy7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdB1Uvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "partiton" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "partiton" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  partiton||partition

Link: http://lkml.kernel.org/r/1481573103-11329-7-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/mach/flash.h                   |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c                 |    2 +-
 arch/powerpc/boot/dts/fsl/mpc8569mds.dts            |    2 +-
 arch/powerpc/include/asm/book3s/64/mmu.h            |    2 +-
 arch/powerpc/include/asm/fsl_hcalls.h               |    2 +-
 arch/powerpc/platforms/pseries/iommu.c              |    2 +-
 arch/sparc/kernel/visemul.c                         |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |    2 +-
 drivers/watchdog/bcm2835_wdt.c                      |    6 +++---
 include/linux/mtd/qinfo.h                           |    2 +-
 include/linux/spi/flash.h                           |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/arm/include/asm/mach/flash.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/arm/include/asm/mach/flash.h
--- a/arch/arm/include/asm/mach/flash.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/arm/include/asm/mach/flash.h
@@ -22,7 +22,7 @@ struct mtd_info;
  * set_vpp:	method called to enable or disable VPP
  * mmcontrol:	method called to enable or disable Sync. Burst Read in OneNAND
  * parts:	optional array of mtd_partitions for static partitioning
- * nr_parts:	number of mtd_partitions for static partitoning
+ * nr_parts:	number of mtd_partitions for static partitioning
  */
 struct flash_platform_data {
 	const char	*map_name;
diff -puN arch/ia64/sn/kernel/sn2/sn_hwperf.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -525,7 +525,7 @@ static int sn_topology_show(struct seq_f
 				/* both ends local to this partition */
 				seq_puts(s, " local");
 			else if (SN_HWPERF_FOREIGN(p))
-				/* both ends of the link in foreign partiton */
+				/* both ends of the link in foreign partition */
 				seq_puts(s, " foreign");
 			else
 				/* link straddles a partition */
diff -puN arch/powerpc/boot/dts/fsl/mpc8569mds.dts~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/powerpc/boot/dts/fsl/mpc8569mds.dts
--- a/arch/powerpc/boot/dts/fsl/mpc8569mds.dts~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/powerpc/boot/dts/fsl/mpc8569mds.dts
@@ -55,7 +55,7 @@
 				label = "kernel";
 				reg = <0x01c00000 0x002e0000>;
 			};
-			partiton@1ee0000 {
+			partition@1ee0000 {
 				label = "dtb";
 				reg = <0x01ee0000 0x00020000>;
 			};
diff -puN arch/powerpc/include/asm/book3s/64/mmu.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/powerpc/include/asm/book3s/64/mmu.h
--- a/arch/powerpc/include/asm/book3s/64/mmu.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -30,7 +30,7 @@ extern struct mmu_psize_def mmu_psize_de
 
 #ifndef __ASSEMBLY__
 /*
- * ISA 3.0 partiton and process table entry format
+ * ISA 3.0 partition and process table entry format
  */
 struct prtb_entry {
 	__be64 prtb0;
diff -puN arch/powerpc/include/asm/fsl_hcalls.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/powerpc/include/asm/fsl_hcalls.h
--- a/arch/powerpc/include/asm/fsl_hcalls.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/powerpc/include/asm/fsl_hcalls.h
@@ -109,7 +109,7 @@ static inline unsigned int fh_send_nmi(u
 #define FH_DTPROP_MAX_PROPLEN 32768
 
 /**
- * fh_partiton_get_dtprop - get a property from a guest device tree.
+ * fh_partition_get_dtprop - get a property from a guest device tree.
  * @handle: handle of partition whose device tree is to be accessed
  * @dtpath_addr: physical address of device tree path to access
  * @propname_addr: physical address of name of property
diff -puN arch/powerpc/platforms/pseries/iommu.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/powerpc/platforms/pseries/iommu.c
--- a/arch/powerpc/platforms/pseries/iommu.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/powerpc/platforms/pseries/iommu.c
@@ -1020,7 +1020,7 @@ static u64 enable_ddw(struct pci_dev *de
 	/* check largest block * page size > max memory hotplug addr */
 	max_addr = memory_hotplug_max();
 	if (query.largest_available_block < (max_addr >> page_shift)) {
-		dev_dbg(&dev->dev, "can't map partiton max 0x%llx with %u "
+		dev_dbg(&dev->dev, "can't map partition max 0x%llx with %u "
 			  "%llu-sized pages\n", max_addr,  query.largest_available_block,
 			  1ULL << page_shift);
 		goto out_failed;
diff -puN arch/sparc/kernel/visemul.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances arch/sparc/kernel/visemul.c
--- a/arch/sparc/kernel/visemul.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/arch/sparc/kernel/visemul.c
@@ -30,7 +30,7 @@
 /* 001001011 - two 32-bit merges */
 #define FPMERGE_OPF	0x04b
 
-/* 000110001 - 8-by-16-bit partitoned product  */
+/* 000110001 - 8-by-16-bit partitioned product  */
 #define FMUL8x16_OPF	0x031
 
 /* 000110011 - 8-by-16-bit upper alpha partitioned product  */
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -178,7 +178,7 @@ const u32 qlcnic_83xx_reg_tbl[] = {
 	0x3540,		/* Device state, DRV_REG1 */
 	0x3544,		/* Driver state, DRV_REG2 */
 	0x3548,		/* Driver scratch, DRV_REG3 */
-	0x354C,		/* Device partiton info, DRV_REG4 */
+	0x354C,		/* Device partition info, DRV_REG4 */
 	0x3524,		/* Driver IDC ver, DRV_REG5 */
 	0x3550,		/* FW_VER_MAJOR */
 	0x3554,		/* FW_VER_MINOR */
diff -puN drivers/watchdog/bcm2835_wdt.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances drivers/watchdog/bcm2835_wdt.c
--- a/drivers/watchdog/bcm2835_wdt.c~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/drivers/watchdog/bcm2835_wdt.c
@@ -36,9 +36,9 @@
 #define PM_RSTC_RESET			0x00000102
 
 /*
- * The Raspberry Pi firmware uses the RSTS register to know which partiton
- * to boot from. The partiton value is spread into bits 0, 2, 4, 6, 8, 10.
- * Partiton 63 is a special partition used by the firmware to indicate halt.
+ * The Raspberry Pi firmware uses the RSTS register to know which partition
+ * to boot from. The partition value is spread into bits 0, 2, 4, 6, 8, 10.
+ * Partition 63 is a special partition used by the firmware to indicate halt.
  */
 #define PM_RSTS_RASPBERRYPI_HALT	0x555
 
diff -puN include/linux/mtd/qinfo.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances include/linux/mtd/qinfo.h
--- a/include/linux/mtd/qinfo.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/include/linux/mtd/qinfo.h
@@ -14,7 +14,7 @@
  * @DevId - Chip Device ID
  * @qinfo - pointer to qinfo records describing the chip
  * @numchips - number of chips including virual RWW partitions
- * @chipshift - Chip/partiton size 2^chipshift
+ * @chipshift - Chip/partition size 2^chipshift
  * @chips - per-chip data structure
  */
 struct lpddr_private {
diff -puN include/linux/spi/flash.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances include/linux/spi/flash.h
--- a/include/linux/spi/flash.h~scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances
+++ a/include/linux/spi/flash.h
@@ -7,7 +7,7 @@ struct mtd_partition;
  * struct flash_platform_data: board-specific flash data
  * @name: optional flash device name (eg, as used with mtdparts=)
  * @parts: optional array of mtd_partitions for static partitioning
- * @nr_parts: number of mtd_partitions for static partitoning
+ * @nr_parts: number of mtd_partitions for static partitioning
  * @type: optional flash device type (e.g. m25p80 vs m25p64), for use
  *	with chips that can't be queried for JEDEC or other IDs
  *
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

