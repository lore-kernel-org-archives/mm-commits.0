From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:25 -0700
Message-ID: <200904011842.n31IgP9T009689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933579AbZDASpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix Laguna chipset memory detection and clock setting
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix Laguna chipset memory detection and clock setting
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix memory detection and clock setting for Cirrus Laguna chipsets
(GD5464/GD5465).  The changes are done after the Xorg code.

The driver still does not display anything on the GD5465 but it switches
resolutions correctly at least.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   65 +++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting
+++ a/drivers/video/cirrusfb.c
@@ -867,19 +867,24 @@ static int cirrusfb_set_par_foo(struct f
 		}
 	}
 	if (nom) {
-		vga_wseq(regbase, CL_SEQRB, nom);
 		tmp = den << 1;
 		if (div != 0)
 			tmp |= 1;
-
 		/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
 		if ((cinfo->btype == BT_SD64) ||
 		    (cinfo->btype == BT_ALPINE) ||
 		    (cinfo->btype == BT_GD5480))
 			tmp |= 0x80;
 
-		dev_dbg(info->device, "CL_SEQR1B: %ld\n", (long) tmp);
-		vga_wseq(regbase, CL_SEQR1B, tmp);
+		dev_dbg(info->device, "CL_SEQR1B: %d\n", (int) tmp);
+		/* Laguna chipset has reversed clock registers */
+		if (cinfo->btype == BT_LAGUNA) {
+			vga_wseq(regbase, CL_SEQRE, tmp);
+			vga_wseq(regbase, CL_SEQR1E, nom);
+		} else {
+			vga_wseq(regbase, CL_SEQRB, nom);
+			vga_wseq(regbase, CL_SEQR1B, tmp);
+		}
 	}
 
 	if (yres >= 1024)
@@ -1917,31 +1922,37 @@ static unsigned int __devinit cirrusfb_g
 						   u8 __iomem *regbase)
 {
 	unsigned long mem;
-	unsigned char SRF;
+	struct cirrusfb_info *cinfo = info->par;
 
-	SRF = vga_rseq(regbase, CL_SEQRF);
-	switch ((SRF & 0x18)) {
-	case 0x08:
-		mem = 512 * 1024;
-		break;
-	case 0x10:
-		mem = 1024 * 1024;
-		break;
-	/* 64-bit DRAM data bus width; assume 2MB. Also indicates 2MB memory
-	 * on the 5430.
-	 */
-	case 0x18:
-		mem = 2048 * 1024;
-		break;
-	default:
-		dev_warn(info->device, "CLgenfb: Unknown memory size!\n");
-		mem = 1024 * 1024;
+	if (cinfo->btype == BT_LAGUNA) {
+		unsigned char SR14 = vga_rseq(regbase, CL_SEQR14);
+
+		mem = ((SR14 & 7) + 1) << 20;
+	} else {
+		unsigned char SRF = vga_rseq(regbase, CL_SEQRF);
+		switch ((SRF & 0x18)) {
+		case 0x08:
+			mem = 512 * 1024;
+			break;
+		case 0x10:
+			mem = 1024 * 1024;
+			break;
+		/* 64-bit DRAM data bus width; assume 2MB.
+		 * Also indicates 2MB memory on the 5430.
+		 */
+		case 0x18:
+			mem = 2048 * 1024;
+			break;
+		default:
+			dev_warn(info->device, "Unknown memory size!\n");
+			mem = 1024 * 1024;
+		}
+		/* If DRAM bank switching is enabled, there must be
+		 * twice as much memory installed. (4MB on the 5434)
+		 */
+		if (SRF & 0x80)
+			mem *= 2;
 	}
-	if (SRF & 0x80)
-	/* If DRAM bank switching is enabled, there must be twice as much
-	 * memory installed. (4MB on the 5434)
-	 */
-		mem *= 2;
 
 	/* TODO: Handling of GD5446/5480 (see XF86 sources ...) */
 	return mem;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

