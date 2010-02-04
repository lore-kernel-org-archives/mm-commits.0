From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-mask-ecc-syndrome-correctly.patch added to -mm tree
Date: Thu, 04 Feb 2010 10:43:48 -0800
Message-ID: <201002041843.o14Ihm83014783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757441Ab0BDSnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 13:43:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ptyser@xes-inc.com, djiang@mvista.com, dougthompson@xmission.com, galak@gate.crashing.org


The patch titled
     edac: mpc85xx mask ecc syndrome correctly
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-mask-ecc-syndrome-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx mask ecc syndrome correctly
From: Peter Tyser <ptyser@xes-inc.com>

With a 64-bit wide data bus only the lowest 8-bits of the ECC syndrome are
relevant.  With a 32-bit wide data bus only the lowest 16-bits are
relevant on most architectures.

Without this change, the ECC syndrome displayed can be mildly confusing,
eg:

  EDAC MPC85xx MC1: syndrome: 0x25252525

When in reality the ECC syndrome is 0x25.

A variety of Freescale manuals say a variety of different things about how
to decode the CAPTURE_ECC (syndrome) register.  I don't have a system with
a 32-bit bus to test on, but I believe the change is correct.  It'd be
good to get an ACK from someone at Freescale about this change though.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |   12 +++++++++++-
 drivers/edac/mpc85xx_edac.h |    3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-mask-ecc-syndrome-correctly drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-mask-ecc-syndrome-correctly
+++ a/drivers/edac/mpc85xx_edac.c
@@ -672,6 +672,7 @@ static void mpc85xx_mc_check(struct mem_
 {
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
 	struct csrow_info *csrow;
+	u32 bus_width;
 	u32 err_detect;
 	u32 syndrome;
 	u32 err_addr;
@@ -692,6 +693,15 @@ static void mpc85xx_mc_check(struct mem_
 	}
 
 	syndrome = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ECC);
+
+	/* Mask off appropriate bits of syndrome based on bus width */
+	bus_width = (in_be32(pdata->mc_vbase + MPC85XX_MC_DDR_SDRAM_CFG) &
+			DSC_DBW_MASK) ? 32 : 64;
+	if (bus_width == 64)
+		syndrome &= 0xff;
+	else
+		syndrome &= 0xffff;
+
 	err_addr = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_ADDRESS);
 	pfn = err_addr >> PAGE_SHIFT;
 
@@ -707,7 +717,7 @@ static void mpc85xx_mc_check(struct mem_
 	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data Low: %#8.8x\n",
 			  in_be32(pdata->mc_vbase +
 				  MPC85XX_MC_CAPTURE_DATA_LO));
-	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#8.8x\n", syndrome);
+	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#2.2x\n", syndrome);
 	mpc85xx_mc_printk(mci, KERN_ERR, "err addr: %#8.8x\n", err_addr);
 	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
 
diff -puN drivers/edac/mpc85xx_edac.h~edac-mpc85xx-mask-ecc-syndrome-correctly drivers/edac/mpc85xx_edac.h
--- a/drivers/edac/mpc85xx_edac.h~edac-mpc85xx-mask-ecc-syndrome-correctly
+++ a/drivers/edac/mpc85xx_edac.h
@@ -48,6 +48,9 @@
 #define DSC_MEM_EN	0x80000000
 #define DSC_ECC_EN	0x20000000
 #define DSC_RD_EN	0x10000000
+#define DSC_DBW_MASK	0x00180000
+#define DSC_DBW_32	0x00080000
+#define DSC_DBW_64	0x00000000
 
 #define DSC_SDTYPE_MASK		0x07000000
 
_

Patches currently in -mm which might be from ptyser@xes-inc.com are

edac-mpc85xx-fix-bad-page-calculation.patch
edac-mpc85xx-fix-build-regression-by-removing-unused-debug-code.patch
linux-next.patch
edac-mpc85xx-mask-ecc-syndrome-correctly.patch
edac-mpc85xx-improve-sdram-error-reporting.patch
edac-mpc85xx-use-resource_size-instead-of-raw-math.patch
edac-e752x-fsb-ecc.patch
edac-e752x-add-dram-scrubbing-support.patch

