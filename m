From: akpm@linux-foundation.org
Subject: - mips-remove-dead-pci-related-content-in-asm-mips-gt64240h.patch removed from -mm tree
Date: Thu, 22 Mar 2007 14:32:51 -0700
Message-ID: <200703222132.l2MLWpwr030869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965405AbXCVVcy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:32:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     MIPS: remove dead PCI-related content in <asm-mips/gt64240.h>
has been removed from the -mm tree.  Its filename was
     mips-remove-dead-pci-related-content-in-asm-mips-gt64240h.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: MIPS: remove dead PCI-related content in <asm-mips/gt64240.h>
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove clearly irrelevant PCI-related content in MIPS header file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/gt64240.h |   96 -----------------------------------
 1 file changed, 96 deletions(-)

diff -puN include/asm-mips/gt64240.h~mips-remove-dead-pci-related-content-in-asm-mips-gt64240h include/asm-mips/gt64240.h
--- a/include/asm-mips/gt64240.h~mips-remove-dead-pci-related-content-in-asm-mips-gt64240h
+++ a/include/asm-mips/gt64240.h
@@ -696,102 +696,6 @@
 #define L_SLAVE_READ_DATA_HIGH					0x1d3c
 #define L_SLAVE_READ_ID						0x1d64
 
-#if 0 /* Disabled because PCI_* namespace belongs to PCI subsystem ... */
-
-/*
- * PCI Configuration Function 0
- */
-
-#define PCI_DEVICE_AND_VENDOR_ID				0x000
-#define PCI_STATUS_AND_COMMAND					0x004
-#define PCI_CLASS_CODE_AND_REVISION_ID				0x008
-#define PCI_BIST_HEADER_TYPE_LATENCY_TIMER_CACHE_LINE		0x00C
-#define PCI_SCS_0_BASE_ADDRESS					0x010
-#define PCI_SCS_1_BASE_ADDRESS					0x014
-#define PCI_SCS_2_BASE_ADDRESS					0x018
-#define PCI_SCS_3_BASE_ADDRESS					0x01C
-#define PCI_INTERNAL_REGISTERS_MEMORY_MAPPED_BASE_ADDRESS	0x020
-#define PCI_INTERNAL_REGISTERS_I_OMAPPED_BASE_ADDRESS		0x024
-#define PCI_SUBSYSTEM_ID_AND_SUBSYSTEM_VENDOR_ID		0x02C
-#define PCI_EXPANSION_ROM_BASE_ADDRESS_REGISTER			0x030
-#define PCI_CAPABILTY_LIST_POINTER				0x034
-#define PCI_INTERRUPT_PIN_AND_LINE				0x03C
-#define PCI_POWER_MANAGEMENT_CAPABILITY				0x040
-#define PCI_POWER_MANAGEMENT_STATUS_AND_CONTROL			0x044
-#define PCI_VPD_ADDRESS						0x048
-#define PCI_VPD_DATA						0X04c
-#define PCI_MSI_MESSAGE_CONTROL					0x050
-#define PCI_MSI_MESSAGE_ADDRESS					0x054
-#define PCI_MSI_MESSAGE_UPPER_ADDRESS				0x058
-#define PCI_MSI_MESSAGE_DATA					0x05c
-#define PCI_COMPACT_PCI_HOT_SWAP_CAPABILITY			0x058
-
-/*
- * PCI Configuration Function 1
- */
-
-#define PCI_CS_0_BASE_ADDRESS					0x110
-#define PCI_CS_1_BASE_ADDRESS					0x114
-#define PCI_CS_2_BASE_ADDRESS					0x118
-#define PCI_CS_3_BASE_ADDRESS					0x11c
-#define PCI_BOOTCS_BASE_ADDRESS					0x120
-
-/*
- * PCI Configuration Function 2
- */
-
-#define PCI_P2P_MEM0_BASE_ADDRESS				0x210
-#define PCI_P2P_MEM1_BASE_ADDRESS				0x214
-#define PCI_P2P_I_O_BASE_ADDRESS				0x218
-#define PCI_CPU_BASE_ADDRESS					0x21c
-
-/*
- * PCI Configuration Function 4
- */
-
-#define PCI_DAC_SCS_0_BASE_ADDRESS_LOW				0x410
-#define PCI_DAC_SCS_0_BASE_ADDRESS_HIGH				0x414
-#define PCI_DAC_SCS_1_BASE_ADDRESS_LOW				0x418
-#define PCI_DAC_SCS_1_BASE_ADDRESS_HIGH				0x41c
-#define PCI_DAC_P2P_MEM0_BASE_ADDRESS_LOW			0x420
-#define PCI_DAC_P2P_MEM0_BASE_ADDRESS_HIGH			0x424
-
-
-/*
- * PCI Configuration Function 5
- */
-
-#define PCI_DAC_SCS_2_BASE_ADDRESS_LOW				0x510
-#define PCI_DAC_SCS_2_BASE_ADDRESS_HIGH				0x514
-#define PCI_DAC_SCS_3_BASE_ADDRESS_LOW				0x518
-#define PCI_DAC_SCS_3_BASE_ADDRESS_HIGH				0x51c
-#define PCI_DAC_P2P_MEM1_BASE_ADDRESS_LOW			0x520
-#define PCI_DAC_P2P_MEM1_BASE_ADDRESS_HIGH			0x524
-
-
-/*
- * PCI Configuration Function 6
- */
-
-#define PCI_DAC_CS_0_BASE_ADDRESS_LOW				0x610
-#define PCI_DAC_CS_0_BASE_ADDRESS_HIGH				0x614
-#define PCI_DAC_CS_1_BASE_ADDRESS_LOW				0x618
-#define PCI_DAC_CS_1_BASE_ADDRESS_HIGH				0x61c
-#define PCI_DAC_CS_2_BASE_ADDRESS_LOW				0x620
-#define PCI_DAC_CS_2_BASE_ADDRESS_HIGH				0x624
-
-/*
- * PCI Configuration Function 7
- */
-
-#define PCI_DAC_CS_3_BASE_ADDRESS_LOW				0x710
-#define PCI_DAC_CS_3_BASE_ADDRESS_HIGH				0x714
-#define PCI_DAC_BOOTCS_BASE_ADDRESS_LOW				0x718
-#define PCI_DAC_BOOTCS_BASE_ADDRESS_HIGH			0x71c
-#define PCI_DAC_CPU_BASE_ADDRESS_LOW				0x720
-#define PCI_DAC_CPU_BASE_ADDRESS_HIGH				0x724
-#endif
-
 /*
  * Interrupts
  */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
mips-remove-dead-pci-related-content-in-asm-mips-gt64240h.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
