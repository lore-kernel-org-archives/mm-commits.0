From: akpm@linux-foundation.org
Subject: [merged] viafb-add-support-for-the-vx855-chipset.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:31 -0700
Message-ID: <200909232002.n8NK2VQd017345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbZIWUDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: add support for the VX855 chipset
has been removed from the -mm tree.  Its filename was
     viafb-add-support-for-the-vx855-chipset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: add support for the VX855 chipset
From: Harald Welte <laforge@gnumonks.org>

Add support for a new VIA integrated graphics chipset, the VX855.

Signed-off-by: HaraldWelte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/chip.h     |    3 
 drivers/video/via/hw.c       |  208 ++++++++++++++++++++++-----------
 drivers/video/via/hw.h       |   14 ++
 drivers/video/via/share.h    |   98 +++++++++++++++
 drivers/video/via/viafbdev.c |    3 
 drivers/video/via/viamode.c  |   55 ++++++++
 drivers/video/via/viamode.h  |    2 
 7 files changed, 314 insertions(+), 69 deletions(-)

diff -puN drivers/video/via/chip.h~viafb-add-support-for-the-vx855-chipset drivers/video/via/chip.h
--- a/drivers/video/via/chip.h~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/chip.h
@@ -68,6 +68,9 @@
 #define     UNICHROME_VX800         11
 #define     UNICHROME_VX800_DID     0x1122
 
+#define     UNICHROME_VX855         12
+#define     UNICHROME_VX855_DID     0x5122
+
 /**************************************************/
 /* Definition TMDS Trasmitter Information         */
 /**************************************************/
diff -puN drivers/video/via/hw.c~viafb-add-support-for-the-vx855-chipset drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/hw.c
@@ -33,106 +33,147 @@ static const struct pci_device_id_info p
 	{PCI_VIA_VENDOR_ID, UNICHROME_P4M900_DID, UNICHROME_P4M900},
 	{PCI_VIA_VENDOR_ID, UNICHROME_CN750_DID, UNICHROME_CN750},
 	{PCI_VIA_VENDOR_ID, UNICHROME_VX800_DID, UNICHROME_VX800},
+	{PCI_VIA_VENDOR_ID, UNICHROME_VX855_DID, UNICHROME_VX855},
 	{0, 0, 0}
 };
 
 static struct pll_map pll_value[] = {
-	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M, CX700_25_175M},
-	{CLK_29_581M, CLE266_PLL_29_581M, K800_PLL_29_581M, CX700_29_581M},
-	{CLK_26_880M, CLE266_PLL_26_880M, K800_PLL_26_880M, CX700_26_880M},
-	{CLK_31_490M, CLE266_PLL_31_490M, K800_PLL_31_490M, CX700_31_490M},
-	{CLK_31_500M, CLE266_PLL_31_500M, K800_PLL_31_500M, CX700_31_500M},
-	{CLK_31_728M, CLE266_PLL_31_728M, K800_PLL_31_728M, CX700_31_728M},
-	{CLK_32_668M, CLE266_PLL_32_668M, K800_PLL_32_668M, CX700_32_668M},
-	{CLK_36_000M, CLE266_PLL_36_000M, K800_PLL_36_000M, CX700_36_000M},
-	{CLK_40_000M, CLE266_PLL_40_000M, K800_PLL_40_000M, CX700_40_000M},
-	{CLK_41_291M, CLE266_PLL_41_291M, K800_PLL_41_291M, CX700_41_291M},
-	{CLK_43_163M, CLE266_PLL_43_163M, K800_PLL_43_163M, CX700_43_163M},
-	{CLK_45_250M, CLE266_PLL_45_250M, K800_PLL_45_250M, CX700_45_250M},
-	{CLK_46_000M, CLE266_PLL_46_000M, K800_PLL_46_000M, CX700_46_000M},
-	{CLK_46_996M, CLE266_PLL_46_996M, K800_PLL_46_996M, CX700_46_996M},
-	{CLK_48_000M, CLE266_PLL_48_000M, K800_PLL_48_000M, CX700_48_000M},
-	{CLK_48_875M, CLE266_PLL_48_875M, K800_PLL_48_875M, CX700_48_875M},
-	{CLK_49_500M, CLE266_PLL_49_500M, K800_PLL_49_500M, CX700_49_500M},
-	{CLK_52_406M, CLE266_PLL_52_406M, K800_PLL_52_406M, CX700_52_406M},
-	{CLK_52_977M, CLE266_PLL_52_977M, K800_PLL_52_977M, CX700_52_977M},
-	{CLK_56_250M, CLE266_PLL_56_250M, K800_PLL_56_250M, CX700_56_250M},
-	{CLK_60_466M, CLE266_PLL_60_466M, K800_PLL_60_466M, CX700_60_466M},
-	{CLK_61_500M, CLE266_PLL_61_500M, K800_PLL_61_500M, CX700_61_500M},
-	{CLK_65_000M, CLE266_PLL_65_000M, K800_PLL_65_000M, CX700_65_000M},
-	{CLK_65_178M, CLE266_PLL_65_178M, K800_PLL_65_178M, CX700_65_178M},
-	{CLK_66_750M, CLE266_PLL_66_750M, K800_PLL_66_750M, CX700_66_750M},
-	{CLK_68_179M, CLE266_PLL_68_179M, K800_PLL_68_179M, CX700_68_179M},
-	{CLK_69_924M, CLE266_PLL_69_924M, K800_PLL_69_924M, CX700_69_924M},
-	{CLK_70_159M, CLE266_PLL_70_159M, K800_PLL_70_159M, CX700_70_159M},
-	{CLK_72_000M, CLE266_PLL_72_000M, K800_PLL_72_000M, CX700_72_000M},
-	{CLK_78_750M, CLE266_PLL_78_750M, K800_PLL_78_750M, CX700_78_750M},
-	{CLK_80_136M, CLE266_PLL_80_136M, K800_PLL_80_136M, CX700_80_136M},
-	{CLK_83_375M, CLE266_PLL_83_375M, K800_PLL_83_375M, CX700_83_375M},
-	{CLK_83_950M, CLE266_PLL_83_950M, K800_PLL_83_950M, CX700_83_950M},
-	{CLK_84_750M, CLE266_PLL_84_750M, K800_PLL_84_750M, CX700_84_750M},
-	{CLK_85_860M, CLE266_PLL_85_860M, K800_PLL_85_860M, CX700_85_860M},
-	{CLK_88_750M, CLE266_PLL_88_750M, K800_PLL_88_750M, CX700_88_750M},
-	{CLK_94_500M, CLE266_PLL_94_500M, K800_PLL_94_500M, CX700_94_500M},
-	{CLK_97_750M, CLE266_PLL_97_750M, K800_PLL_97_750M, CX700_97_750M},
+	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M,
+	 CX700_25_175M, VX855_25_175M},
+	{CLK_29_581M, CLE266_PLL_29_581M, K800_PLL_29_581M,
+	 CX700_29_581M, VX855_29_581M},
+	{CLK_26_880M, CLE266_PLL_26_880M, K800_PLL_26_880M,
+	 CX700_26_880M, VX855_26_880M},
+	{CLK_31_490M, CLE266_PLL_31_490M, K800_PLL_31_490M,
+	 CX700_31_490M, VX855_31_490M},
+	{CLK_31_500M, CLE266_PLL_31_500M, K800_PLL_31_500M,
+	 CX700_31_500M, VX855_31_500M},
+	{CLK_31_728M, CLE266_PLL_31_728M, K800_PLL_31_728M,
+	 CX700_31_728M, VX855_31_728M},
+	{CLK_32_668M, CLE266_PLL_32_668M, K800_PLL_32_668M,
+	 CX700_32_668M, VX855_32_668M},
+	{CLK_36_000M, CLE266_PLL_36_000M, K800_PLL_36_000M,
+	 CX700_36_000M, VX855_36_000M},
+	{CLK_40_000M, CLE266_PLL_40_000M, K800_PLL_40_000M,
+	 CX700_40_000M, VX855_40_000M},
+	{CLK_41_291M, CLE266_PLL_41_291M, K800_PLL_41_291M,
+	 CX700_41_291M, VX855_41_291M},
+	{CLK_43_163M, CLE266_PLL_43_163M, K800_PLL_43_163M,
+	 CX700_43_163M, VX855_43_163M},
+	{CLK_45_250M, CLE266_PLL_45_250M, K800_PLL_45_250M,
+	 CX700_45_250M, VX855_45_250M},
+	{CLK_46_000M, CLE266_PLL_46_000M, K800_PLL_46_000M,
+	 CX700_46_000M, VX855_46_000M},
+	{CLK_46_996M, CLE266_PLL_46_996M, K800_PLL_46_996M,
+	 CX700_46_996M, VX855_46_996M},
+	{CLK_48_000M, CLE266_PLL_48_000M, K800_PLL_48_000M,
+	 CX700_48_000M, VX855_48_000M},
+	{CLK_48_875M, CLE266_PLL_48_875M, K800_PLL_48_875M,
+	 CX700_48_875M, VX855_48_875M},
+	{CLK_49_500M, CLE266_PLL_49_500M, K800_PLL_49_500M,
+	 CX700_49_500M, VX855_49_500M},
+	{CLK_52_406M, CLE266_PLL_52_406M, K800_PLL_52_406M,
+	 CX700_52_406M, VX855_52_406M},
+	{CLK_52_977M, CLE266_PLL_52_977M, K800_PLL_52_977M,
+	 CX700_52_977M,	VX855_52_977M},
+	{CLK_56_250M, CLE266_PLL_56_250M, K800_PLL_56_250M,
+	 CX700_56_250M, VX855_56_250M},
+	{CLK_60_466M, CLE266_PLL_60_466M, K800_PLL_60_466M,
+	 CX700_60_466M, VX855_60_466M},
+	{CLK_61_500M, CLE266_PLL_61_500M, K800_PLL_61_500M,
+	 CX700_61_500M, VX855_61_500M},
+	{CLK_65_000M, CLE266_PLL_65_000M, K800_PLL_65_000M,
+	 CX700_65_000M, VX855_65_000M},
+	{CLK_65_178M, CLE266_PLL_65_178M, K800_PLL_65_178M,
+	 CX700_65_178M, VX855_65_178M},
+	{CLK_66_750M, CLE266_PLL_66_750M, K800_PLL_66_750M,
+	 CX700_66_750M, VX855_66_750M},
+	{CLK_68_179M, CLE266_PLL_68_179M, K800_PLL_68_179M,
+	 CX700_68_179M, VX855_68_179M},
+	{CLK_69_924M, CLE266_PLL_69_924M, K800_PLL_69_924M,
+	 CX700_69_924M, VX855_69_924M},
+	{CLK_70_159M, CLE266_PLL_70_159M, K800_PLL_70_159M,
+	 CX700_70_159M, VX855_70_159M},
+	{CLK_72_000M, CLE266_PLL_72_000M, K800_PLL_72_000M,
+	 CX700_72_000M, VX855_72_000M},
+	{CLK_78_750M, CLE266_PLL_78_750M, K800_PLL_78_750M,
+	 CX700_78_750M, VX855_78_750M},
+	{CLK_80_136M, CLE266_PLL_80_136M, K800_PLL_80_136M,
+	 CX700_80_136M, VX855_80_136M},
+	{CLK_83_375M, CLE266_PLL_83_375M, K800_PLL_83_375M,
+	 CX700_83_375M, VX855_83_375M},
+	{CLK_83_950M, CLE266_PLL_83_950M, K800_PLL_83_950M,
+	 CX700_83_950M, VX855_83_950M},
+	{CLK_84_750M, CLE266_PLL_84_750M, K800_PLL_84_750M,
+	 CX700_84_750M, VX855_84_750M},
+	{CLK_85_860M, CLE266_PLL_85_860M, K800_PLL_85_860M,
+	 CX700_85_860M, VX855_85_860M},
+	{CLK_88_750M, CLE266_PLL_88_750M, K800_PLL_88_750M,
+	 CX700_88_750M, VX855_88_750M},
+	{CLK_94_500M, CLE266_PLL_94_500M, K800_PLL_94_500M,
+	 CX700_94_500M, VX855_94_500M},
+	{CLK_97_750M, CLE266_PLL_97_750M, K800_PLL_97_750M,
+	 CX700_97_750M, VX855_97_750M},
 	{CLK_101_000M, CLE266_PLL_101_000M, K800_PLL_101_000M,
-	 CX700_101_000M},
+	 CX700_101_000M, VX855_101_000M},
 	{CLK_106_500M, CLE266_PLL_106_500M, K800_PLL_106_500M,
-	 CX700_106_500M},
+	 CX700_106_500M, VX855_106_500M},
 	{CLK_108_000M, CLE266_PLL_108_000M, K800_PLL_108_000M,
-	 CX700_108_000M},
+	 CX700_108_000M, VX855_108_000M},
 	{CLK_113_309M, CLE266_PLL_113_309M, K800_PLL_113_309M,
-	 CX700_113_309M},
+	 CX700_113_309M, VX855_113_309M},
 	{CLK_118_840M, CLE266_PLL_118_840M, K800_PLL_118_840M,
-	 CX700_118_840M},
+	 CX700_118_840M, VX855_118_840M},
 	{CLK_119_000M, CLE266_PLL_119_000M, K800_PLL_119_000M,
-	 CX700_119_000M},
+	 CX700_119_000M, VX855_119_000M},
 	{CLK_121_750M, CLE266_PLL_121_750M, K800_PLL_121_750M,
-	 CX700_121_750M},
+	 CX700_121_750M, 0},
 	{CLK_125_104M, CLE266_PLL_125_104M, K800_PLL_125_104M,
-	 CX700_125_104M},
+	 CX700_125_104M, 0},
 	{CLK_133_308M, CLE266_PLL_133_308M, K800_PLL_133_308M,
-	 CX700_133_308M},
+	 CX700_133_308M, 0},
 	{CLK_135_000M, CLE266_PLL_135_000M, K800_PLL_135_000M,
-	 CX700_135_000M},
+	 CX700_135_000M, VX855_135_000M},
 	{CLK_136_700M, CLE266_PLL_136_700M, K800_PLL_136_700M,
-	 CX700_136_700M},
+	 CX700_136_700M, VX855_136_700M},
 	{CLK_138_400M, CLE266_PLL_138_400M, K800_PLL_138_400M,
-	 CX700_138_400M},
+	 CX700_138_400M, VX855_138_400M},
 	{CLK_146_760M, CLE266_PLL_146_760M, K800_PLL_146_760M,
-	 CX700_146_760M},
+	 CX700_146_760M, VX855_146_760M},
 	{CLK_153_920M, CLE266_PLL_153_920M, K800_PLL_153_920M,
-	 CX700_153_920M},
+	 CX700_153_920M, VX855_153_920M},
 	{CLK_156_000M, CLE266_PLL_156_000M, K800_PLL_156_000M,
-	 CX700_156_000M},
+	 CX700_156_000M, VX855_156_000M},
 	{CLK_157_500M, CLE266_PLL_157_500M, K800_PLL_157_500M,
-	 CX700_157_500M},
+	 CX700_157_500M, VX855_157_500M},
 	{CLK_162_000M, CLE266_PLL_162_000M, K800_PLL_162_000M,
-	 CX700_162_000M},
+	 CX700_162_000M, VX855_162_000M},
 	{CLK_187_000M, CLE266_PLL_187_000M, K800_PLL_187_000M,
-	 CX700_187_000M},
+	 CX700_187_000M, VX855_187_000M},
 	{CLK_193_295M, CLE266_PLL_193_295M, K800_PLL_193_295M,
-	 CX700_193_295M},
+	 CX700_193_295M, VX855_193_295M},
 	{CLK_202_500M, CLE266_PLL_202_500M, K800_PLL_202_500M,
-	 CX700_202_500M},
+	 CX700_202_500M, VX855_202_500M},
 	{CLK_204_000M, CLE266_PLL_204_000M, K800_PLL_204_000M,
-	 CX700_204_000M},
+	 CX700_204_000M, VX855_204_000M},
 	{CLK_218_500M, CLE266_PLL_218_500M, K800_PLL_218_500M,
-	 CX700_218_500M},
+	 CX700_218_500M, VX855_218_500M},
 	{CLK_234_000M, CLE266_PLL_234_000M, K800_PLL_234_000M,
-	 CX700_234_000M},
+	 CX700_234_000M, VX855_234_000M},
 	{CLK_267_250M, CLE266_PLL_267_250M, K800_PLL_267_250M,
-	 CX700_267_250M},
+	 CX700_267_250M, VX855_267_250M},
 	{CLK_297_500M, CLE266_PLL_297_500M, K800_PLL_297_500M,
-	 CX700_297_500M},
-	{CLK_74_481M, CLE266_PLL_74_481M, K800_PLL_74_481M, CX700_74_481M},
+	 CX700_297_500M, VX855_297_500M},
+	{CLK_74_481M, CLE266_PLL_74_481M, K800_PLL_74_481M,
+	 CX700_74_481M, VX855_74_481M},
 	{CLK_172_798M, CLE266_PLL_172_798M, K800_PLL_172_798M,
-	 CX700_172_798M},
+	 CX700_172_798M, VX855_172_798M},
 	{CLK_122_614M, CLE266_PLL_122_614M, K800_PLL_122_614M,
-	 CX700_122_614M},
-	{CLK_74_270M, CLE266_PLL_74_270M, K800_PLL_74_270M, CX700_74_270M},
+	 CX700_122_614M, VX855_122_614M},
+	{CLK_74_270M, CLE266_PLL_74_270M, K800_PLL_74_270M,
+	 CX700_74_270M, 0},
 	{CLK_148_500M, CLE266_PLL_148_500M, K800_PLL_148_500M,
-	 CX700_148_500M}
+	 CX700_148_500M, VX855_148_500M}
 };
 
 static struct fifo_depth_select display_fifo_depth_reg = {
@@ -1219,6 +1260,15 @@ void viafb_load_FIFO_reg(int set_iga, in
 			    VX800_IGA1_DISPLAY_QUEUE_EXPIRE_NUM;
 		}
 
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_VX855) {
+			iga1_fifo_max_depth = VX855_IGA1_FIFO_MAX_DEPTH;
+			iga1_fifo_threshold = VX855_IGA1_FIFO_THRESHOLD;
+			iga1_fifo_high_threshold =
+			    VX855_IGA1_FIFO_HIGH_THRESHOLD;
+			iga1_display_queue_expire_num =
+			    VX855_IGA1_DISPLAY_QUEUE_EXPIRE_NUM;
+		}
+
 		/* Set Display FIFO Depath Select */
 		reg_value = IGA1_FIFO_DEPTH_SELECT_FORMULA(iga1_fifo_max_depth);
 		viafb_load_reg_num =
@@ -1350,6 +1400,15 @@ void viafb_load_FIFO_reg(int set_iga, in
 			    VX800_IGA2_DISPLAY_QUEUE_EXPIRE_NUM;
 		}
 
+		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_VX855) {
+			iga2_fifo_max_depth = VX855_IGA2_FIFO_MAX_DEPTH;
+			iga2_fifo_threshold = VX855_IGA2_FIFO_THRESHOLD;
+			iga2_fifo_high_threshold =
+			    VX855_IGA2_FIFO_HIGH_THRESHOLD;
+			iga2_display_queue_expire_num =
+			    VX855_IGA2_DISPLAY_QUEUE_EXPIRE_NUM;
+		}
+
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_K800) {
 			/* Set Display FIFO Depath Select */
 			reg_value =
@@ -1438,6 +1497,8 @@ u32 viafb_get_clk_value(int clk)
 			case UNICHROME_P4M900:
 			case UNICHROME_VX800:
 				return pll_value[i].cx700_pll;
+			case UNICHROME_VX855:
+				return pll_value[i].vx855_pll;
 			}
 		}
 	}
@@ -1471,6 +1532,7 @@ void viafb_set_vclock(u32 CLK, int set_i
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
+		case UNICHROME_VX855:
 			viafb_write_reg(SR44, VIASR, CLK / 0x10000);
 			DEBUG_MSG(KERN_INFO "\nSR44=%x", CLK / 0x10000);
 			viafb_write_reg(SR45, VIASR, (CLK & 0xFFFF) / 0x100);
@@ -1499,6 +1561,7 @@ void viafb_set_vclock(u32 CLK, int set_i
 		case UNICHROME_P4M890:
 		case UNICHROME_P4M900:
 		case UNICHROME_VX800:
+		case UNICHROME_VX855:
 			viafb_write_reg(SR4A, VIASR, CLK / 0x10000);
 			viafb_write_reg(SR4B, VIASR, (CLK & 0xFFFF) / 0x100);
 			viafb_write_reg(SR4C, VIASR, CLK % 0x100);
@@ -2215,6 +2278,10 @@ int viafb_setmode(int vmode_index, int h
 	case UNICHROME_VX800:
 		viafb_write_regx(CX700_ModeXregs, NUM_TOTAL_CX700_ModeXregs);
 		break;
+
+	case UNICHROME_VX855:
+		viafb_write_regx(VX855_ModeXregs, NUM_TOTAL_VX855_ModeXregs);
+		break;
 	}
 
 	device_off();
@@ -2597,6 +2664,7 @@ static int get_fb_size_from_pci(void)
 		case P4M890_FUNCTION3:
 		case P4M900_FUNCTION3:
 		case VX800_FUNCTION3:
+		case VX855_FUNCTION3:
 			/*case CN750_FUNCTION3: */
 			outl(configid + 0xA0, (unsigned long)0xCF8);
 			FBSize = inl((unsigned long)0xCFC);
@@ -2660,6 +2728,10 @@ static int get_fb_size_from_pci(void)
 			VideoMemSize = (256 << 20);	/*256M */
 			break;
 
+		case 0x00007000:	/* Only on VX855/875 */
+			VideoMemSize = (512 << 20);	/*512M */
+			break;
+
 		default:
 			VideoMemSize = (32 << 20);	/*32M */
 			break;
diff -puN drivers/video/via/hw.h~viafb-add-support-for-the-vx855-chipset drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/hw.h
@@ -324,6 +324,17 @@ is reserved, so it may have problem to s
 /* location: {CR94,0,6} */
 #define VX800_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     128
 
+/* For VT3409 */
+#define VX855_IGA1_FIFO_MAX_DEPTH               400
+#define VX855_IGA1_FIFO_THRESHOLD               320
+#define VX855_IGA1_FIFO_HIGH_THRESHOLD          320
+#define VX855_IGA1_DISPLAY_QUEUE_EXPIRE_NUM     160
+
+#define VX855_IGA2_FIFO_MAX_DEPTH               200
+#define VX855_IGA2_FIFO_THRESHOLD               160
+#define VX855_IGA2_FIFO_HIGH_THRESHOLD          160
+#define VX855_IGA2_DISPLAY_QUEUE_EXPIRE_NUM     320
+
 #define IGA1_FIFO_DEPTH_SELECT_REG_NUM          1
 #define IGA1_FIFO_THRESHOLD_REG_NUM             2
 #define IGA1_FIFO_HIGH_THRESHOLD_REG_NUM        2
@@ -688,6 +699,7 @@ struct pll_map {
 	u32 cle266_pll;
 	u32 k800_pll;
 	u32 cx700_pll;
+	u32 vx855_pll;
 };
 
 struct rgbLUT {
@@ -832,6 +844,8 @@ struct iga2_crtc_timing {
 #define P4M900_FUNCTION3    0x3364
 /* VT3353 chipset*/
 #define VX800_FUNCTION3     0x3353
+/* VT3409 chipset*/
+#define VX855_FUNCTION3     0x3409
 
 #define NUM_TOTAL_PLL_TABLE ARRAY_SIZE(pll_value)
 
diff -puN drivers/video/via/share.h~viafb-add-support-for-the-vx855-chipset drivers/video/via/share.h
--- a/drivers/video/via/share.h~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/share.h
@@ -167,6 +167,10 @@
 #define SR4B    0x4B
 #define SR4C    0x4C
 #define SR52    0x52
+#define SR57	0x57
+#define SR58	0x58
+#define SR59	0x59
+#define SR5D    0x5D
 #define SR5E    0x5E
 #define SR65    0x65
 
@@ -966,6 +970,100 @@
 #define CX700_297_500M    0x00CE0403
 #define CX700_122_614M    0x00870802
 
+/* PLL for VX855 */
+#define VX855_22_000M     0x007B1005
+#define VX855_25_175M     0x008D1005
+#define VX855_26_719M     0x00961005
+#define VX855_26_880M     0x00961005
+#define VX855_27_000M     0x00971005
+#define VX855_29_581M     0x00A51005
+#define VX855_29_829M     0x00641003
+#define VX855_31_490M     0x00B01005
+#define VX855_31_500M     0x00B01005
+#define VX855_31_728M     0x008E1004
+#define VX855_32_668M     0x00921004
+#define VX855_36_000M     0x00A11004
+#define VX855_40_000M     0x00700C05
+#define VX855_41_291M     0x00730C05
+#define VX855_43_163M     0x00790C05
+#define VX855_45_250M     0x007F0C05      /* 45.46MHz */
+#define VX855_46_000M     0x00670C04
+#define VX855_46_996M     0x00690C04
+#define VX855_48_000M     0x00860C05
+#define VX855_48_875M     0x00890C05
+#define VX855_49_500M     0x00530C03
+#define VX855_52_406M     0x00580C03
+#define VX855_52_977M     0x00940C05
+#define VX855_56_250M     0x009D0C05
+#define VX855_60_466M     0x00A90C05
+#define VX855_61_500M     0x00AC0C05
+#define VX855_65_000M     0x006D0C03
+#define VX855_65_178M     0x00B60C05
+#define VX855_66_750M     0x00700C03    /*67.116MHz */
+#define VX855_67_295M     0x00BC0C05
+#define VX855_68_179M     0x00BF0C05
+#define VX855_68_369M     0x00BF0C05
+#define VX855_69_924M     0x00C30C05
+#define VX855_70_159M     0x00C30C05
+#define VX855_72_000M     0x00A10C04
+#define VX855_73_023M     0x00CC0C05
+#define VX855_74_481M     0x00D10C05
+#define VX855_78_750M     0x006E0805
+#define VX855_79_466M     0x006F0805
+#define VX855_80_136M     0x00700805
+#define VX855_81_627M     0x00720805
+#define VX855_83_375M     0x00750805
+#define VX855_83_527M     0x00750805
+#define VX855_83_950M     0x00750805
+#define VX855_84_537M     0x00760805
+#define VX855_84_750M     0x00760805     /* 84.537Mhz */
+#define VX855_85_500M     0x00760805        /* 85.909080 MHz*/
+#define VX855_85_860M     0x00760805
+#define VX855_85_909M     0x00760805
+#define VX855_88_750M     0x007C0805
+#define VX855_89_489M     0x007D0805
+#define VX855_94_500M     0x00840805
+#define VX855_96_648M     0x00870805
+#define VX855_97_750M     0x00890805
+#define VX855_101_000M    0x008D0805
+#define VX855_106_500M    0x00950805
+#define VX855_108_000M    0x00970805
+#define VX855_110_125M    0x00990805
+#define VX855_112_000M    0x009D0805
+#define VX855_113_309M    0x009F0805
+#define VX855_115_000M    0x00A10805
+#define VX855_118_840M    0x00A60805
+#define VX855_119_000M    0x00A70805
+#define VX855_121_750M    0x00AA0805       /* 121.704MHz */
+#define VX855_122_614M    0x00AC0805
+#define VX855_126_266M    0x00B10805
+#define VX855_130_250M    0x00B60805      /* 130.250 */
+#define VX855_135_000M    0x00BD0805
+#define VX855_136_700M    0x00BF0805
+#define VX855_137_750M    0x00C10805
+#define VX855_138_400M    0x00C20805
+#define VX855_144_300M    0x00CA0805
+#define VX855_146_760M    0x00CE0805
+#define VX855_148_500M	  0x00D00805
+#define VX855_153_920M    0x00540402
+#define VX855_156_000M    0x006C0405
+#define VX855_156_867M    0x006E0405
+#define VX855_157_500M    0x006E0405
+#define VX855_162_000M    0x00710405
+#define VX855_172_798M    0x00790405
+#define VX855_187_000M    0x00830405
+#define VX855_193_295M    0x00870405
+#define VX855_202_500M    0x008E0405
+#define VX855_204_000M    0x008F0405
+#define VX855_218_500M    0x00990405
+#define VX855_229_500M    0x00A10405
+#define VX855_234_000M    0x00A40405
+#define VX855_267_250M    0x00BB0405
+#define VX855_297_500M    0x00D00405
+#define VX855_339_500M    0x00770005
+#define VX855_340_772M    0x00770005
+
+
 /* Definition CRTC Timing Index */
 #define H_TOTAL_INDEX               0
 #define H_ADDR_INDEX                1
diff -puN drivers/video/via/viafbdev.c~viafb-add-support-for-the-vx855-chipset drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/viafbdev.c
@@ -914,7 +914,8 @@ static int viafb_cursor(struct fb_info *
 		fg_color = cursor->image.fg_color;
 		bg_color = cursor->image.bg_color;
 		if (chip_name == UNICHROME_CX700 ||
-			chip_name == UNICHROME_VX800) {
+			chip_name == UNICHROME_VX800 ||
+			chip_name == UNICHROME_VX855) {
 			fg_color =
 				((info->cmap.red[fg_color] & 0xFFC0) << 14) |
 				((info->cmap.green[fg_color] & 0xFFC0) << 4) |
diff -puN drivers/video/via/viamode.c~viafb-add-support-for-the-vx855-chipset drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/viamode.c
@@ -312,6 +312,60 @@ struct io_reg CX700_ModeXregs[] = { {VIA
 {VIACR, CR9B, 0xFF, 0x00}
 };
 
+struct io_reg VX855_ModeXregs[] = {
+{VIASR, SR10, 0xFF, 0x01},
+{VIASR, SR15, 0x02, 0x02},
+{VIASR, SR16, 0xBF, 0x08},
+{VIASR, SR17, 0xFF, 0x1F},
+{VIASR, SR18, 0xFF, 0x4E},
+{VIASR, SR1A, 0xFB, 0x08},
+{VIASR, SR1B, 0xFF, 0xF0},
+{VIASR, SR1E, 0x07, 0x01},
+{VIASR, SR2A, 0xF0, 0x00},
+{VIASR, SR58, 0xFF, 0x00},
+{VIASR, SR59, 0xFF, 0x00},
+{VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
+{VIACR, CR09, 0xFF, 0x00},	/* Initial CR09=0*/
+{VIACR, CR11, 0x8F, 0x00},	/* IGA1 initial  Vertical end       */
+{VIACR, CR17, 0x7F, 0x00}, 	/* IGA1 CRT Mode control init   */
+{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
+{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
+{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
+{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
+{VIACR, CR32, 0xFF, 0x00},
+{VIACR, CR33, 0x7F, 0x00},
+{VIACR, CR35, 0xFF, 0x00},
+{VIACR, CR36, 0x08, 0x00},
+{VIACR, CR69, 0xFF, 0x00},
+{VIACR, CR6A, 0xFD, 0x60},
+{VIACR, CR6B, 0xFF, 0x00},
+{VIACR, CR6C, 0xFF, 0x00},
+{VIACR, CR7A, 0xFF, 0x01},          /* LCD Scaling Parameter 1             */
+{VIACR, CR7B, 0xFF, 0x02},          /* LCD Scaling Parameter 2             */
+{VIACR, CR7C, 0xFF, 0x03},          /* LCD Scaling Parameter 3             */
+{VIACR, CR7D, 0xFF, 0x04},          /* LCD Scaling Parameter 4             */
+{VIACR, CR7E, 0xFF, 0x07},          /* LCD Scaling Parameter 5             */
+{VIACR, CR7F, 0xFF, 0x0A},          /* LCD Scaling Parameter 6             */
+{VIACR, CR80, 0xFF, 0x0D},          /* LCD Scaling Parameter 7             */
+{VIACR, CR81, 0xFF, 0x13},          /* LCD Scaling Parameter 8             */
+{VIACR, CR82, 0xFF, 0x16},          /* LCD Scaling Parameter 9             */
+{VIACR, CR83, 0xFF, 0x19},          /* LCD Scaling Parameter 10            */
+{VIACR, CR84, 0xFF, 0x1C},          /* LCD Scaling Parameter 11            */
+{VIACR, CR85, 0xFF, 0x1D},          /* LCD Scaling Parameter 12            */
+{VIACR, CR86, 0xFF, 0x1E},          /* LCD Scaling Parameter 13            */
+{VIACR, CR87, 0xFF, 0x1F},          /* LCD Scaling Parameter 14            */
+{VIACR, CR88, 0xFF, 0x40},          /* LCD Panel Type                      */
+{VIACR, CR89, 0xFF, 0x00},          /* LCD Timing Control 0                */
+{VIACR, CR8A, 0xFF, 0x88},          /* LCD Timing Control 1                */
+{VIACR, CRD4, 0xFF, 0x81},          /* Second power sequence control       */
+{VIACR, CR91, 0xFF, 0x80},          /* 24/12 bit LVDS Data off             */
+{VIACR, CR96, 0xFF, 0x00},
+{VIACR, CR97, 0xFF, 0x00},
+{VIACR, CR99, 0xFF, 0x00},
+{VIACR, CR9B, 0xFF, 0x00},
+{VIACR, CRD2, 0xFF, 0xFF}           /* TMDS/LVDS control register.         */
+};
+
 /* Video Mode Table */
 /* Common Setting for Video Mode */
 struct io_reg CLE266_ModeXregs[] = { {VIASR, SR1E, 0xF0, 0x00},
@@ -1012,6 +1066,7 @@ int NUM_TOTAL_CN400_ModeXregs = ARRAY_SI
 int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
 int NUM_TOTAL_KM400_ModeXregs = ARRAY_SIZE(KM400_ModeXregs);
 int NUM_TOTAL_CX700_ModeXregs = ARRAY_SIZE(CX700_ModeXregs);
+int NUM_TOTAL_VX855_ModeXregs = ARRAY_SIZE(VX855_ModeXregs);
 int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
 int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
 int NUM_TOTAL_MODETABLE = ARRAY_SIZE(CLE266Modes);
diff -puN drivers/video/via/viamode.h~viafb-add-support-for-the-vx855-chipset drivers/video/via/viamode.h
--- a/drivers/video/via/viamode.h~viafb-add-support-for-the-vx855-chipset
+++ a/drivers/video/via/viamode.h
@@ -56,6 +56,7 @@ extern int NUM_TOTAL_CN400_ModeXregs;
 extern int NUM_TOTAL_CN700_ModeXregs;
 extern int NUM_TOTAL_KM400_ModeXregs;
 extern int NUM_TOTAL_CX700_ModeXregs;
+extern int NUM_TOTAL_VX855_ModeXregs;
 extern int NUM_TOTAL_CLE266_ModeXregs;
 extern int NUM_TOTAL_PATCH_MODE;
 extern int NUM_TOTAL_MODETABLE;
@@ -75,6 +76,7 @@ extern struct io_reg CN700_ModeXregs[];
 extern struct io_reg KM400_ModeXregs[];
 extern struct io_reg CX700_ModeXregs[];
 extern struct io_reg VX800_ModeXregs[];
+extern struct io_reg VX855_ModeXregs[];
 extern struct io_reg CLE266_ModeXregs[];
 extern struct io_reg PM1024x768[];
 extern struct patch_table res_patch_table[];
_

Patches currently in -mm which might be from laforge@gnumonks.org are

origin.patch

